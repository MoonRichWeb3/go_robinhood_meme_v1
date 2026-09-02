// 本文件统一管理刷价、名单、评分、信号和交易清理节拍。
package app

import (
	"context"
	"time"
)

func (a *App) runTicks(ctx context.Context) {
	priceTick := time.NewTicker(time.Duration(a.config.PriceFlushSec) * time.Second)
	walletTick := time.NewTicker(time.Duration(a.config.WalletReloadMS) * time.Millisecond)
	scoreTick := time.NewTicker(time.Duration(a.config.ScoreIntervalSec) * time.Second)
	signalTick := time.NewTicker(time.Duration(a.config.SignalIntervalSec) * time.Second)
	purgeTick := time.NewTicker(time.Duration(a.config.EventPurgeIntervalSec) * time.Second)
	defer priceTick.Stop()
	defer walletTick.Stop()
	defer scoreTick.Stop()
	defer signalTick.Stop()
	defer purgeTick.Stop()
	for {
		select {
		case <-ctx.Done():
			return
		case <-priceTick.C:
			_ = a.dirty.Flush(ctx)
		case <-walletTick.C:
			_ = a.wallets.RefreshIfDue(ctx, time.Duration(a.config.WalletReloadMS)*time.Millisecond)
		case <-scoreTick.C:
			_ = a.scorer.RecalculateAll(ctx)
		case <-a.scoreTrigger:
			_ = a.scorer.RecalculateAll(ctx)
		case <-signalTick.C:
			a.logSignals(ctx)
		case <-purgeTick.C:
			a.purgeEvents(ctx)
		}
	}
}

func (a *App) requestScoreAfter(sells int) {
	a.sellSince += sells
	if a.sellSince < 100 {
		return
	}
	a.sellSince = 0
	select {
	case a.scoreTrigger <- struct{}{}:
	default:
	}
}

func (a *App) purgeEvents(ctx context.Context) {
	result, err := a.store.PurgeExpiredWalletEvents(
		ctx, time.Now().UTC(), a.config.EventRetentionDays, a.config.EventPurgeBatch,
		a.config.EventPurgeMaxPerRun, time.Duration(a.config.EventPurgeSleepMS)*time.Millisecond,
	)
	if err != nil {
		a.logger.Error(map[string]any{"类型": "清理失败", "错误": err})
		return
	}
	if result.Deleted > 0 {
		a.logger.Info("清理", map[string]any{
			"类型": "清理", "表": "交易", "截止": result.Cutoff.Format(time.RFC3339),
			"本轮删除": result.Deleted, "提前停止": yesNo(result.Limited),
		})
	}
}

func (a *App) logSignals(ctx context.Context) {
	now := time.Now().UTC()
	for _, kind := range []string{"smart_launch", "cluster_buy", "score_launch"} {
		rows, err := a.store.ListSignals(ctx, kind, 20, now)
		if err != nil {
			a.logger.Error(map[string]any{"类型": "信号查询失败", "规则": kind, "错误": err})
			continue
		}
		for _, row := range rows {
			identity := row.Token
			if identity == "" {
				identity = row.Wallet
			}
			key := now.Format("2006-01-02") + "|" + kind + "|" + identity
			if !a.rememberSignal(key, now) {
				continue
			}
			fields := map[string]any{
				"类型": "信号", "规则": signalRule(kind), "盘口": venueDisplay(row.Category),
			}
			if row.Token != "" {
				fields["代币"] = row.Token
			}
			if row.Wallet != "" {
				fields["钱包"] = row.Wallet
			}
			a.logger.Info("信号", fields)
		}
	}
}

func (a *App) rememberSignal(key string, at time.Time) bool {
	a.signalMu.Lock()
	defer a.signalMu.Unlock()
	if _, exists := a.signalSeen[key]; exists {
		return false
	}
	if len(a.signalSeen) >= 1000 {
		var oldestKey string
		var oldest time.Time
		for candidate, seenAt := range a.signalSeen {
			if oldestKey == "" || seenAt.Before(oldest) {
				oldestKey, oldest = candidate, seenAt
			}
		}
		delete(a.signalSeen, oldestKey)
	}
	a.signalSeen[key] = at
	return true
}

func signalRule(kind string) string {
	switch kind {
	case "smart_launch":
		return "聪明钱所发"
	case "cluster_buy":
		return "开盘同买"
	case "score_launch":
		return "高分新发盘"
	default:
		return kind
	}
}

func yesNo(value bool) string {
	if value {
		return "是"
	}
	return "否"
}
