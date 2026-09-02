// 本文件实现独立 Binance ETHUSDT 拉取循环和带 TTL/stale 的线程安全缓存。
package price

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"math/big"
	"net/http"
	"net/url"
	"strings"
	"sync"
	"time"
)

const maxBinanceBody = 64 << 10

// FeedLogger 输出中文喂价降级与失败日志。
type FeedLogger interface {
	Error(map[string]any)
}

// BinanceConfig 定义独立行情循环的网络与缓存边界。
type BinanceConfig struct {
	BaseURL, Symbol      string
	PollInterval, TTL    time.Duration
	Stale, RequestTimout time.Duration
}

// BinanceFeed 缓存最近一次成功 ETH/USD 行情；失败永不清零旧值。
type BinanceFeed struct {
	baseURL, symbol  string
	poll, ttl, stale time.Duration
	client           *http.Client
	logger           FeedLogger
	now              func() time.Time
	mu               sync.RWMutex
	price            *big.Rat
	fetchedAt        time.Time
	lastFailed       bool
}

// NewBinanceFeed 校验 URL 和时间窗并创建无 API Key 的 HTTP 行情源。
func NewBinanceFeed(config BinanceConfig, logger FeedLogger) (*BinanceFeed, error) {
	u, err := url.Parse(strings.TrimSpace(config.BaseURL))
	if err != nil || (u.Scheme != "http" && u.Scheme != "https") || u.Host == "" ||
		u.User != nil || u.RawQuery != "" || u.Fragment != "" {
		return nil, fmt.Errorf("Binance base URL 无效")
	}
	if strings.TrimSpace(config.Symbol) == "" || config.PollInterval <= 0 || config.TTL <= 0 ||
		config.Stale < config.TTL || config.RequestTimout <= 0 {
		return nil, fmt.Errorf("Binance 行情配置无效")
	}
	return &BinanceFeed{
		baseURL: strings.TrimRight(u.String(), "/"), symbol: config.Symbol,
		poll: config.PollInterval, ttl: config.TTL, stale: config.Stale,
		client: &http.Client{Timeout: config.RequestTimout}, logger: logger, now: time.Now,
	}, nil
}

// ETHUSD 只读内存缓存；TTL 后可在 stale 窗内降级，超过窗口返回 ErrNoFeed。
func (f *BinanceFeed) ETHUSD() (*big.Rat, error) {
	f.mu.RLock()
	price, fetchedAt, lastFailed := f.price, f.fetchedAt, f.lastFailed
	f.mu.RUnlock()
	age := f.now().UTC().Sub(fetchedAt)
	if price == nil || age > f.stale || (age > f.ttl && !lastFailed) {
		return nil, ErrNoFeed
	}
	return new(big.Rat).Set(price), nil
}

// Run 立即拉取一次后按配置轮询；429 使用 1 秒起、60 秒封顶的指数退避。
func (f *BinanceFeed) Run(ctx context.Context) error {
	delay := time.Duration(0)
	backoff := time.Second
	for {
		if delay > 0 {
			timer := time.NewTimer(delay)
			select {
			case <-timer.C:
			case <-ctx.Done():
				timer.Stop()
				return ctx.Err()
			}
		}
		rateLimited, err := f.fetch(ctx)
		if err != nil {
			f.mu.Lock()
			f.lastFailed = true
			f.mu.Unlock()
			fields := map[string]any{"类型": "喂价失败", "错误": err}
			if _, staleErr := f.ETHUSD(); staleErr == nil {
				fields["降级"] = "旧值"
			}
			if f.logger != nil {
				f.logger.Error(fields)
			}
		}
		if rateLimited {
			delay = backoff
			backoff = min(backoff*2, time.Minute)
		} else {
			delay = f.poll
			backoff = time.Second
		}
		select {
		case <-ctx.Done():
			return ctx.Err()
		default:
		}
	}
}

func (f *BinanceFeed) fetch(ctx context.Context) (bool, error) {
	endpoint := f.baseURL + "/api/v3/ticker/price?symbol=" + url.QueryEscape(f.symbol)
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, endpoint, nil)
	if err != nil {
		return false, err
	}
	resp, err := f.client.Do(req)
	if err != nil {
		return false, err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		io.Copy(io.Discard, io.LimitReader(resp.Body, 4096))
		return resp.StatusCode == http.StatusTooManyRequests, fmt.Errorf("Binance HTTP 状态 %d", resp.StatusCode)
	}
	var payload struct {
		Price string `json:"price"`
	}
	if err = json.NewDecoder(io.LimitReader(resp.Body, maxBinanceBody)).Decode(&payload); err != nil {
		return false, fmt.Errorf("解析 Binance 响应: %w", err)
	}
	value, ok := new(big.Rat).SetString(payload.Price)
	if !ok || value.Sign() <= 0 {
		return false, fmt.Errorf("Binance price 不是正数")
	}
	f.mu.Lock()
	f.price, f.fetchedAt, f.lastFailed = new(big.Rat).Set(value), f.now().UTC(), false
	f.mu.Unlock()
	return false, nil
}
