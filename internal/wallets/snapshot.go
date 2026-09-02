// Package wallets 维护以 SQLite 为事实源的聪明钱包只读快照。
package wallets

import (
	"context"
	"fmt"
	"sync"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/store"
)

// WalletView 是匹配和中文日志所需的最小名单视图。
type WalletView struct {
	Address, DisplayName, PrimaryType, Tags, Level, Status string
}

// Source 提供名单全量读取，便于使用内存假实现测试刷新行为。
type Source interface {
	LoadSmartWallets(context.Context) ([]store.SmartWallet, error)
}

// ErrorLogger 记录刷新失败；失败时快照不会被清空。
type ErrorLogger interface {
	Error(map[string]any)
}

// Snapshot 以原子换表方式提供并发安全的名单读取。
type Snapshot struct {
	source    Source
	logger    ErrorLogger
	refreshMu sync.Mutex
	mu        sync.RWMutex
	all       map[string]WalletView
	active    map[string]WalletView
	lastOK    time.Time
	lastTry   time.Time
}

// New 创建空快照；调用 Load 完成启动强制加载后才能用于匹配。
func New(source Source, logger ErrorLogger) (*Snapshot, error) {
	if source == nil {
		return nil, fmt.Errorf("名单数据源不能为空")
	}
	return &Snapshot{source: source, logger: logger, all: map[string]WalletView{}, active: map[string]WalletView{}}, nil
}

// Load 全量加载名单。SQL 或数据规范化失败会返回错误且保留旧快照。
func (s *Snapshot) Load(ctx context.Context) error {
	rows, err := s.source.LoadSmartWallets(ctx)
	if err != nil {
		return err
	}
	all := make(map[string]WalletView, len(rows))
	active := make(map[string]WalletView, len(rows))
	for _, row := range rows {
		address, normalizeErr := domain.NormalizeAddress(row.Address)
		if normalizeErr != nil {
			return fmt.Errorf("名单地址 %q 无效: %w", row.Address, normalizeErr)
		}
		view := WalletView{
			Address: address, DisplayName: row.DisplayName, PrimaryType: row.PrimaryType,
			Tags: row.Tags, Level: row.Level, Status: row.Status,
		}
		all[address] = view
		if row.Status == "active" {
			active[address] = view
		}
	}
	s.mu.Lock()
	now := time.Now().UTC()
	s.all, s.active, s.lastOK, s.lastTry = all, active, now, now
	s.mu.Unlock()
	return nil
}

// RefreshIfDue 在距上次成功加载达到间隔时刷新；失败沿用旧快照并记录错误。
func (s *Snapshot) RefreshIfDue(ctx context.Context, interval time.Duration) error {
	if interval <= 0 || interval > time.Second {
		return fmt.Errorf("名单刷新间隔必须在 0..1s")
	}
	s.refreshMu.Lock()
	defer s.refreshMu.Unlock()
	s.mu.RLock()
	due := s.lastTry.IsZero() || time.Since(s.lastTry) >= interval
	s.mu.RUnlock()
	if !due {
		return nil
	}
	s.mu.Lock()
	s.lastTry = time.Now().UTC()
	s.mu.Unlock()
	if err := s.Load(ctx); err != nil {
		if s.logger != nil {
			s.logger.Error(map[string]any{"类型": "名单刷新失败", "错误": err})
		}
		return err
	}
	return nil
}

// Active 查询地址是否在当前有效集合，非法地址按不命中处理。
func (s *Snapshot) Active(address string) (WalletView, bool) {
	address, err := domain.NormalizeAddress(address)
	if err != nil {
		return WalletView{}, false
	}
	s.mu.RLock()
	view, ok := s.active[address]
	s.mu.RUnlock()
	return view, ok
}

// Lookup 查询任意状态钱包的展示信息，不影响 active 匹配语义。
func (s *Snapshot) Lookup(address string) (WalletView, bool) {
	address, err := domain.NormalizeAddress(address)
	if err != nil {
		return WalletView{}, false
	}
	s.mu.RLock()
	view, ok := s.all[address]
	s.mu.RUnlock()
	return view, ok
}
