// Package app 组装链、存储、盘口、名单、价格、评分和只读 HTTP，并管理生命周期。
package app

import (
	"context"
	"errors"
	"fmt"
	"sync"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/chain"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/config"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/contracts"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/httpsvc"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/logx"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/price"
	scorecalc "github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/score"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/store"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/venue"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/wallets"
)

// App 是进程级编排器；业务解析仍由 venue，持久化仍由 store 负责。
type App struct {
	config       config.Config
	logger       *logx.Logger
	store        *store.Store
	client       *chain.Client
	traceClient  nativeTraceClient
	catalog      *contracts.Catalog
	router       *venue.Router
	wallets      *wallets.Snapshot
	feed         *price.BinanceFeed
	converter    *price.Converter
	dirty        *price.DirtySet
	scorer       *scorecalc.Recalculator
	poller       *chain.Poller
	http         *httpsvc.Server
	scoreTrigger chan struct{}
	closeOnce    sync.Once
	signalMu     sync.Mutex
	signalSeen   map[string]time.Time
	sellSince    int
}

// New 按文档顺序完成迁移、目录、链校验、登记重建、名单加载和服务组装。
func New(ctx context.Context, cfg config.Config, logger *logx.Logger) (*App, error) {
	if logger == nil {
		return nil, fmt.Errorf("日志器不能为空")
	}
	data, err := store.Open(ctx, cfg.SQLitePath)
	if err != nil {
		return nil, err
	}
	fail := func(err error) (*App, error) {
		_ = data.Close()
		return nil, err
	}
	if err = data.Migrate(ctx, "migrations"); err != nil {
		return fail(err)
	}
	catalog, err := contracts.NewCatalog()
	if err != nil {
		return fail(err)
	}
	client, err := connectChain(ctx, cfg)
	if err != nil {
		return fail(err)
	}
	for _, skipped := range client.SkippedEndpoints() {
		logger.Error(map[string]any{"类型": "RPC跳过", "RPC": skipped.RPC, "错误": skipped.Reason})
	}
	var traceClient *chain.Client
	if cfg.TraceRPCURL != "" {
		traceClient, err = chain.NewClient(ctx, cfg.TraceRPCURL, cfg.HTTPUserAgent,
			time.Duration(cfg.TraceTimeoutMS)*time.Millisecond, cfg.ChainID)
		if err != nil {
			return fail(fmt.Errorf("连接 trace RPC: %w", err))
		}
	}
	pools, curves, err := data.LoadRegistrations(ctx)
	if err != nil {
		return fail(err)
	}
	if err = enrichRegistrationDecimals(ctx, client, pools, curves); err != nil {
		return fail(err)
	}
	if err = catalog.RebuildRegistrations(pools, curves); err != nil {
		return fail(err)
	}
	snapshot, err := wallets.New(data, logger)
	if err != nil {
		return fail(err)
	}
	if err = snapshot.Load(ctx); err != nil {
		return fail(fmt.Errorf("启动加载名单: %w", err))
	}
	feed, err := price.NewBinanceFeed(price.BinanceConfig{
		BaseURL: cfg.BinanceBaseURL, Symbol: cfg.BinanceETHSymbol,
		PollInterval:  time.Duration(cfg.ETHUSDPollSec) * time.Second,
		TTL:           time.Duration(cfg.ETHUSDTTLSec) * time.Second,
		Stale:         time.Duration(cfg.ETHUSDStaleSec) * time.Second,
		RequestTimout: time.Duration(cfg.BinanceTimeoutMS) * time.Millisecond,
	}, logger)
	if err != nil {
		return fail(err)
	}
	converter, err := price.NewConverter(data, feed)
	if err != nil {
		return fail(err)
	}
	dirty, err := price.NewDirtySet(data, cfg.DirtyTokenCap, logger)
	if err != nil {
		return fail(err)
	}
	scorer, err := scorecalc.New(data, logger)
	if err != nil {
		return fail(err)
	}
	a := &App{
		config: cfg, logger: logger, store: data, client: client, traceClient: traceClient, catalog: catalog,
		router: venue.NewRouter(catalog), wallets: snapshot, feed: feed, converter: converter,
		dirty: dirty, scorer: scorer, scoreTrigger: make(chan struct{}, 1),
		signalSeen: make(map[string]time.Time),
	}
	poller, err := chain.NewPoller(client, data, a.ProcessBlock, logger, chain.PollerConfig{
		FromBlock: cfg.FromBlock, MaxBlocksPerTick: uint64(cfg.MaxBlocksPerTick),
		LagWarn: uint64(cfg.HealthLagWarn), SkipHistoryLag: uint64(cfg.SkipHistoryLag),
		PollInterval: time.Duration(cfg.PollMS) * time.Millisecond,
		FetchMode:    cfg.BlockFetchMode, ReceiptMethod: cfg.ReceiptMethod,
	})
	if err != nil {
		return fail(err)
	}
	a.poller = poller
	a.http, err = httpsvc.New(httpsvc.Config{
		Rest: cfg.Rest, ChainID: cfg.ChainID, QueryTimeout: time.Duration(cfg.HTTPQueryMS) * time.Millisecond,
		HealthLagWarn: uint64(cfg.HealthLagWarn),
	}, data, poller, logger)
	if err != nil {
		return fail(err)
	}
	return a, nil
}

// Run 启动 HTTP、行情和定时任务，并以前台扫块结果决定进程退出。
func (a *App) Run(ctx context.Context) error {
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()
	var workers sync.WaitGroup
	workers.Add(3)
	go func() {
		defer workers.Done()
		a.http.Start()
	}()
	go func() {
		defer workers.Done()
		_ = a.feed.Run(ctx)
	}()
	go func() {
		defer workers.Done()
		a.runTicks(ctx)
	}()
	err := a.poller.Run(ctx)
	cancel()
	a.http.Stop()
	workers.Wait()
	if errors.Is(err, context.Canceled) {
		return nil
	}
	return err
}

// Close 在所有工作协程退出后关闭 writer，再关闭 SQLite 连接。
func (a *App) Close() error {
	var err error
	a.closeOnce.Do(func() { err = a.store.Close() })
	return err
}

// RPCCount 返回启动成功连上的扫块节点数。
func (a *App) RPCCount() int {
	if a == nil || a.client == nil {
		return 0
	}
	return a.client.EndpointCount()
}

// RPCLabels 返回脱敏后的扫块节点标签，供启动日志使用。
func (a *App) RPCLabels() []string {
	if a == nil || a.client == nil {
		return nil
	}
	return a.client.EndpointLabels()
}

func connectChain(ctx context.Context, cfg config.Config) (*chain.Client, error) {
	timeout := time.Duration(cfg.RPCTimeoutMS) * time.Millisecond
	endpoints := make([]chain.RPCEndpoint, len(cfg.RPCEndpoints))
	for i, item := range cfg.RPCEndpoints {
		endpoints[i] = chain.RPCEndpoint{URL: item.URL, QPS: item.QPS}
	}
	var client *chain.Client
	var err error
	for attempt := 0; attempt < 3; attempt++ {
		client, err = chain.NewPoolClient(ctx, endpoints, cfg.HTTPUserAgent, timeout, cfg.ChainID)
		if err == nil {
			return client, nil
		}
		if attempt < 2 {
			timer := time.NewTimer(time.Duration(attempt+1) * 200 * time.Millisecond)
			select {
			case <-timer.C:
			case <-ctx.Done():
				timer.Stop()
				return nil, ctx.Err()
			}
		}
	}
	return nil, fmt.Errorf("连接 RPC 三次失败: %w", err)
}

func enrichRegistrationDecimals(ctx context.Context, client *chain.Client, pools []domain.PoolRegistration, curves []domain.CurveRegistration) error {
	head, err := client.BlockNumber(ctx)
	if err != nil {
		return err
	}
	cache := make(map[string]uint8)
	get := func(token string) (uint8, error) {
		if decimals, ok := cache[token]; ok {
			return decimals, nil
		}
		metadata, metadataErr := client.TokenMetadata(ctx, token, head)
		if metadataErr != nil {
			return 0, metadataErr
		}
		cache[token] = metadata.Decimals
		return metadata.Decimals, nil
	}
	for i := range pools {
		if pools[i].TokenDecimals, err = get(pools[i].Token); err != nil {
			return fmt.Errorf("重建池 %s 的代币精度: %w", pools[i].PoolID, err)
		}
	}
	for i := range curves {
		if curves[i].TokenDecimals, err = get(curves[i].Token); err != nil {
			return fmt.Errorf("重建曲线 %s 的代币精度: %w", curves[i].Curve, err)
		}
	}
	return nil
}
