// 本文件编排 v4 原生 ETH quote 净额追踪及其不阻塞扫块的降级策略。
package app

import (
	"context"
	"strings"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/chain"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/contracts"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

type nativeTraceClient interface {
	TraceNativeAmount(ctx context.Context, txHash, user, side string) (string, error)
}

func (a *App) enrichNativeQuote(ctx context.Context, fill *domain.Fill, swapCount int, errorLogged *bool) {
	if fill.Quote != contracts.ZeroAddress || fill.User == "" {
		return
	}
	fill.QuoteAmountRaw = ""
	if swapCount != 1 {
		a.logNativeTraceError(fill, "同一收据的 PoolManager Swap 数量不是 1", errorLogged)
		return
	}
	if a.traceClient == nil {
		a.logNativeTraceError(fill, "RH_TRACE_RPC_URL 未配置，原生 ETH 净额已安全禁用", errorLogged)
		return
	}
	amount, err := a.traceClient.TraceNativeAmount(ctx, fill.TxHash, fill.User, fill.Side)
	if err != nil {
		a.logNativeTraceError(fill, err.Error(), errorLogged)
		return
	}
	fill.QuoteAmountRaw = amount
}

func (a *App) logNativeTraceError(fill *domain.Fill, message string, logged *bool) {
	if *logged {
		return
	}
	*logged = true
	a.logger.Error(map[string]any{
		"类型": "原生ETH成交净额失败", "交易": fill.TxHash,
		"代币": fill.Token, "错误": message,
	})
}

func countReceiptPoolManagerSwaps(receipt chain.Receipt) int {
	count := 0
	for _, event := range receipt.Logs {
		if event.Removed || !strings.EqualFold(event.Address, contracts.PoolManager) ||
			len(event.Topics) == 0 || !strings.EqualFold(event.Topics[0], contracts.TopicPoolSwap) {
			continue
		}
		count++
	}
	return count
}
