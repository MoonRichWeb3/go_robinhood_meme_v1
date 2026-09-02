// Package score 从保留窗内流水重放 FIFO，并定时更新名单评分快照。
package score

import (
	"context"
	"fmt"
	"math/big"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/store"
)

// Store 是评分任务所需的最小存储接口。
type Store interface {
	LoadSmartWallets(context.Context) ([]store.SmartWallet, error)
	ScoreEvents(context.Context, string) ([]store.ScoreEvent, error)
	UpdateWalletScore(context.Context, string, domain.ScoreResult, time.Time) error
}

// Logger 输出单钱包失败和显著分数变化。
type Logger interface {
	Info(string, map[string]any)
	Error(map[string]any)
}

// Recalculator 逐钱包短读、短写，避免一次长事务阻塞扫块 writer。
type Recalculator struct {
	store  Store
	logger Logger
	now    func() time.Time
}

// New 创建评分重算器。
func New(store Store, logger Logger) (*Recalculator, error) {
	if store == nil {
		return nil, fmt.Errorf("评分存储不能为空")
	}
	return &Recalculator{store: store, logger: logger, now: time.Now}, nil
}

// RecalculateAll 重算名单全表，单钱包异常只跳过该钱包并继续。
func (r *Recalculator) RecalculateAll(ctx context.Context) error {
	wallets, err := r.store.LoadSmartWallets(ctx)
	if err != nil {
		return err
	}
	var firstErr error
	now := r.now().UTC()
	for _, wallet := range wallets {
		events, eventErr := r.store.ScoreEvents(ctx, wallet.Address)
		if eventErr != nil {
			firstErr = keepFirst(firstErr, eventErr)
			r.logWalletError(wallet.Address, eventErr)
			continue
		}
		samples, replayErr := samplesFromEvents(events)
		if replayErr != nil {
			firstErr = keepFirst(firstErr, replayErr)
			r.logWalletError(wallet.Address, replayErr)
			continue
		}
		result := domain.ComputeScore(samples, now)
		if !result.Scored {
			result.Level = "D"
		}
		if updateErr := r.store.UpdateWalletScore(ctx, wallet.Address, result, now); updateErr != nil {
			firstErr = keepFirst(firstErr, updateErr)
			r.logWalletError(wallet.Address, updateErr)
			continue
		}
		if r.logger != nil && abs(result.Score-wallet.Score) >= 1 {
			r.logger.Info("评分", map[string]any{
				"钱包": wallet.Address, "分数": result.Score,
				"样本数": result.SampleN, "累计盈亏U": result.ProfitUSD,
			})
		}
	}
	return firstErr
}

func samplesFromEvents(events []store.ScoreEvent) ([]domain.ScoreSample, error) {
	byToken := make(map[string][]store.ScoreEvent)
	for _, event := range events {
		byToken[event.Token] = append(byToken[event.Token], event)
	}
	samples := make([]domain.ScoreSample, 0)
	for _, tokenEvents := range byToken {
		fifo := make([]domain.FIFOEvent, 0, len(tokenEvents))
		times := make(map[string]time.Time, len(tokenEvents))
		for _, event := range tokenEvents {
			fifo = append(fifo, domain.FIFOEvent{
				ID: event.ID, Direction: event.Direction, QuantityRaw: event.QuantityRaw,
				TokenDecimals: event.TokenDecimals, PriceUSD: event.PriceUSD,
			})
			times[event.ID] = event.ChainTime
		}
		results, err := domain.ReplayFIFO(fifo)
		if err != nil {
			return nil, err
		}
		for _, result := range results {
			if result.MatchedQty.Sign() <= 0 {
				continue
			}
			pnl, ok := newRatFloat(result.MatchedPnL)
			if !ok {
				return nil, fmt.Errorf("FIFO 盈亏 %q 无法转换", result.MatchedPnL)
			}
			samples = append(samples, domain.ScoreSample{ProfitUSD: pnl, ChainTime: times[result.EventID]})
		}
	}
	return samples, nil
}

func newRatFloat(value string) (float64, bool) {
	rat, ok := new(big.Rat).SetString(value)
	if !ok {
		return 0, false
	}
	out, _ := rat.Float64()
	return out, true
}

func (r *Recalculator) logWalletError(wallet string, err error) {
	if r.logger != nil {
		r.logger.Error(map[string]any{"类型": "评分失败", "钱包": wallet, "错误": err})
	}
}

func keepFirst(current, next error) error {
	if current != nil {
		return current
	}
	return next
}

func abs(value float64) float64 {
	if value < 0 {
		return -value
	}
	return value
}
