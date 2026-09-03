// Package config 负责从环境变量加载进程配置并在启动前完成边界校验。
package config

import (
	"fmt"
	"net"
	"os"
	"path/filepath"
	"strconv"
	"strings"

	"github.com/zeromicro/go-zero/core/service"
	"github.com/zeromicro/go-zero/rest"
)

// Config 汇总 v0 进程全部环境变量；业务公式不属于配置。
type Config struct {
	RPCURL, TraceRPCURL, HTTPUserAgent, SQLitePath, LogLevel, LogDir string
	RPCEndpointsFile, BlockFetchMode, ReceiptMethod                  string
	RPCEndpoints                                                     []RPCEndpoint
	BinanceBaseURL, BinanceETHSymbol                                 string
	FromBlock, ChainID                                               uint64
	PollMS, MaxBlocksPerTick, RPCTimeoutMS, TraceTimeoutMS           int
	PriceFlushSec, WalletReloadMS, ScoreIntervalSec                  int
	SignalIntervalSec, HealthLagWarn, HTTPQueryMS                    int
	DirtyTokenCap, ETHUSDPollSec, BinanceTimeoutMS                   int
	ETHUSDTTLSec, ETHUSDStaleSec                                     int
	EventRetentionDays, EventPurgeIntervalSec, EventPurgeBatch       int
	EventPurgeSleepMS, EventPurgeMaxPerRun, SkipHistoryLag           int
	Rest                                                             rest.RestConf
}

// Load 从环境变量加载配置，应用文档默认值并拒绝无效配置。
func Load() (Config, error) {
	var c Config
	c.RPCURL = strings.TrimSpace(os.Getenv("RH_RPC_URL"))
	c.RPCEndpointsFile = strings.TrimSpace(os.Getenv("RH_RPC_ENDPOINTS_FILE"))
	c.TraceRPCURL = strings.TrimSpace(os.Getenv("RH_TRACE_RPC_URL"))
	c.HTTPUserAgent = envString("RH_HTTP_UA", "go-robinhood-meme/v0")
	c.SQLitePath = envString("RH_SQLITE_PATH", "/data/robinhood_meme.sqlite3")
	c.LogLevel = strings.ToLower(envString("LOG_LEVEL", "info"))
	c.LogDir = strings.TrimSpace(os.Getenv("RH_LOG_DIR"))
	c.BlockFetchMode = strings.ToLower(envString("RH_BLOCK_FETCH_MODE", "batch"))
	c.ReceiptMethod = envString("RH_RECEIPT_METHOD", "eth_getBlockReceipts")
	c.BinanceBaseURL = envString("RH_BINANCE_BASE_URL", "https://api.binance.com")
	c.BinanceETHSymbol = envString("RH_BINANCE_ETH_SYMBOL", "ETHUSDT")
	var err error
	if c.FromBlock, err = envUint("RH_FROM_BLOCK", 0); err != nil {
		return c, err
	}
	if c.ChainID, err = envUint("RH_CHAIN_ID", 4663); err != nil {
		return c, err
	}
	values := []struct {
		key string
		def int
		dst *int
	}{
		{"RH_POLL_MS", 80, &c.PollMS}, {"RH_MAX_BLOCKS_PER_TICK", 10, &c.MaxBlocksPerTick},
		{"RH_RPC_TIMEOUT_MS", 8000, &c.RPCTimeoutMS}, {"RH_TRACE_TIMEOUT_MS", 8000, &c.TraceTimeoutMS},
		{"RH_PRICE_FLUSH_SEC", 3, &c.PriceFlushSec},
		{"RH_WALLET_RELOAD_MS", 1000, &c.WalletReloadMS}, {"RH_SCORE_INTERVAL_SEC", 3600, &c.ScoreIntervalSec},
		{"RH_SIGNAL_INTERVAL_SEC", 3600, &c.SignalIntervalSec}, {"RH_HEALTH_LAG_WARN", 50, &c.HealthLagWarn},
		{"RH_HTTP_QUERY_MS", 3000, &c.HTTPQueryMS}, {"RH_DIRTY_TOKEN_CAP", 5000, &c.DirtyTokenCap},
		{"RH_ETHUSD_POLL_SEC", 10, &c.ETHUSDPollSec}, {"RH_BINANCE_TIMEOUT_MS", 3000, &c.BinanceTimeoutMS},
		{"RH_ETHUSD_TTL_SEC", 30, &c.ETHUSDTTLSec}, {"RH_ETHUSD_STALE_SEC", 300, &c.ETHUSDStaleSec},
		{"RH_EVENT_RETENTION_DAYS", 7, &c.EventRetentionDays}, {"RH_EVENT_PURGE_INTERVAL_SEC", 3600, &c.EventPurgeIntervalSec},
		{"RH_EVENT_PURGE_BATCH", 500, &c.EventPurgeBatch}, {"RH_EVENT_PURGE_SLEEP_MS", 100, &c.EventPurgeSleepMS},
		{"RH_EVENT_PURGE_MAX_PER_RUN", 5000, &c.EventPurgeMaxPerRun},
	}
	for _, v := range values {
		if *v.dst, err = envInt(v.key, v.def); err != nil {
			return c, err
		}
	}
	if err = c.setHTTP(envString("RH_HTTP_ADDR", "127.0.0.1:8888")); err != nil {
		return c, err
	}
	loaded, err := loadRPCEndpoints(c.RPCURL, c.RPCEndpointsFile)
	if err != nil {
		return c, err
	}
	c.RPCEndpoints = loaded.Endpoints
	c.RPCEndpointsFile = loaded.Path
	c.SkipHistoryLag = loaded.SkipHistoryLag
	if err = c.Validate(); err != nil {
		return c, err
	}
	return c, nil
}

// Validate 检查必填项、正数间隔及文档定义的安全上限。
func (c Config) Validate() error {
	if len(c.RPCEndpoints) == 0 {
		return fmt.Errorf("扫块 RPC 节点池不能为空")
	}
	if c.ChainID == 0 {
		return fmt.Errorf("RH_CHAIN_ID 必须大于 0")
	}
	if c.SkipHistoryLag < 0 {
		return fmt.Errorf("skip_history_lag 不能为负数")
	}
	positive := map[string]int{"RH_POLL_MS": c.PollMS, "RH_MAX_BLOCKS_PER_TICK": c.MaxBlocksPerTick, "RH_RPC_TIMEOUT_MS": c.RPCTimeoutMS,
		"RH_TRACE_TIMEOUT_MS":   c.TraceTimeoutMS,
		"RH_SCORE_INTERVAL_SEC": c.ScoreIntervalSec, "RH_SIGNAL_INTERVAL_SEC": c.SignalIntervalSec, "RH_HTTP_QUERY_MS": c.HTTPQueryMS,
		"RH_DIRTY_TOKEN_CAP": c.DirtyTokenCap, "RH_ETHUSD_POLL_SEC": c.ETHUSDPollSec, "RH_BINANCE_TIMEOUT_MS": c.BinanceTimeoutMS,
		"RH_ETHUSD_TTL_SEC": c.ETHUSDTTLSec, "RH_ETHUSD_STALE_SEC": c.ETHUSDStaleSec, "RH_EVENT_PURGE_INTERVAL_SEC": c.EventPurgeIntervalSec,
		"RH_EVENT_PURGE_MAX_PER_RUN": c.EventPurgeMaxPerRun}
	for k, v := range positive {
		if v < 1 {
			return fmt.Errorf("%s 必须大于 0", k)
		}
	}
	if c.WalletReloadMS < 1 || c.WalletReloadMS > 1000 {
		return fmt.Errorf("RH_WALLET_RELOAD_MS 必须在 1..1000")
	}
	if c.PriceFlushSec < 1 {
		return fmt.Errorf("RH_PRICE_FLUSH_SEC 必须大于等于 1")
	}
	if c.EventRetentionDays < 1 {
		return fmt.Errorf("RH_EVENT_RETENTION_DAYS 必须大于等于 1")
	}
	if c.EventPurgeBatch < 1 || c.EventPurgeBatch > 5000 {
		return fmt.Errorf("RH_EVENT_PURGE_BATCH 必须在 1..5000")
	}
	if c.EventPurgeSleepMS < 0 {
		return fmt.Errorf("RH_EVENT_PURGE_SLEEP_MS 不能为负数")
	}
	if c.EventPurgeMaxPerRun < c.EventPurgeBatch {
		return fmt.Errorf("RH_EVENT_PURGE_MAX_PER_RUN 不能小于批大小")
	}
	if c.ETHUSDStaleSec < c.ETHUSDTTLSec {
		return fmt.Errorf("RH_ETHUSD_STALE_SEC 不能小于 TTL")
	}
	switch c.LogLevel {
	case "debug", "info", "warn", "error":
	default:
		return fmt.Errorf("LOG_LEVEL 仅支持 debug/info/warn/error")
	}
	if c.LogDir != "" && !filepath.IsAbs(c.LogDir) {
		return fmt.Errorf("RH_LOG_DIR 必须是绝对路径")
	}
	switch c.BlockFetchMode {
	case "batch", "pair":
	default:
		return fmt.Errorf("RH_BLOCK_FETCH_MODE 仅支持 batch/pair")
	}
	switch c.ReceiptMethod {
	case "eth_getBlockReceipts", "alchemy_getTransactionReceipts":
	default:
		return fmt.Errorf("RH_RECEIPT_METHOD 仅支持 eth_getBlockReceipts/alchemy_getTransactionReceipts")
	}
	return nil
}

func (c *Config) setHTTP(addr string) error {
	host, portText, err := net.SplitHostPort(addr)
	if err != nil {
		return fmt.Errorf("RH_HTTP_ADDR 无效: %w", err)
	}
	port, err := strconv.Atoi(portText)
	if err != nil || port < 1 || port > 65535 {
		return fmt.Errorf("RH_HTTP_ADDR 端口无效")
	}
	c.Rest = rest.RestConf{
		ServiceConf: service.ServiceConf{Name: "robinhood-meme", Mode: service.ProMode},
		Host:        host, Port: port, MaxConns: 10000, MaxBytes: 1 << 20, Timeout: 3000,
	}
	return nil
}
func envString(k, d string) string {
	if v := strings.TrimSpace(os.Getenv(k)); v != "" {
		return v
	}
	return d
}
func envInt(k string, d int) (int, error) {
	v := strings.TrimSpace(os.Getenv(k))
	if v == "" {
		return d, nil
	}
	n, e := strconv.Atoi(v)
	if e != nil {
		return 0, fmt.Errorf("%s 必须是整数: %w", k, e)
	}
	return n, nil
}
func envUint(k string, d uint64) (uint64, error) {
	v := strings.TrimSpace(os.Getenv(k))
	if v == "" {
		return d, nil
	}
	n, e := strconv.ParseUint(v, 10, 64)
	if e != nil {
		return 0, fmt.Errorf("%s 必须是非负整数: %w", k, e)
	}
	return n, nil
}
