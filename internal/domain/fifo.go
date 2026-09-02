// 本文件实现基于保留窗内交易流水的精确 FIFO 盈亏重放。
package domain

import (
	"fmt"
	"math/big"
)

// FIFOEvent 是按链上顺序重放的一条买卖事件；nil 价格表示该行跳过。
type FIFOEvent struct {
	ID, Direction, QuantityRaw string
	TokenDecimals              uint8
	PriceUSD                   *big.Rat
}

// FIFOSellResult 是一笔卖出的匹配结果，数量和盈亏均为精确有理数。
type FIFOSellResult struct {
	EventID, MatchedPnL     string
	MatchedQty, OverflowQty *big.Rat
}

type fifoLot struct {
	qty, price *big.Rat
	decimals   uint8
}

// ReplayFIFO 按输入顺序重放买卖，返回每笔有美元价格卖出的匹配、盈亏和超仓量。
func ReplayFIFO(events []FIFOEvent) ([]FIFOSellResult, error) {
	lots := make([]fifoLot, 0)
	results := make([]FIFOSellResult, 0)
	for _, e := range events {
		if e.Direction != "buy" && e.Direction != "sell" {
			continue
		}
		if e.PriceUSD == nil {
			continue
		}
		qty, err := humanQuantity(e.QuantityRaw, e.TokenDecimals)
		if err != nil {
			return nil, fmt.Errorf("事件 %s 数量无效: %w", e.ID, err)
		}
		if qty.Sign() <= 0 {
			return nil, fmt.Errorf("事件 %s 数量必须大于 0", e.ID)
		}
		if e.Direction == "buy" {
			lots = append(lots, fifoLot{new(big.Rat).Set(qty), new(big.Rat).Set(e.PriceUSD), e.TokenDecimals})
			continue
		}
		remaining, matched, pnl := new(big.Rat).Set(qty), new(big.Rat), new(big.Rat)
		for len(lots) > 0 && remaining.Sign() > 0 {
			if lots[0].decimals != e.TokenDecimals {
				return nil, fmt.Errorf("事件 %s decimals 不一致", e.ID)
			}
			take := minRat(remaining, lots[0].qty)
			pnl.Add(pnl, new(big.Rat).Mul(take, new(big.Rat).Sub(e.PriceUSD, lots[0].price)))
			matched.Add(matched, take)
			remaining.Sub(remaining, take)
			lots[0].qty.Sub(lots[0].qty, take)
			if lots[0].qty.Sign() == 0 {
				lots = lots[1:]
			}
		}
		results = append(results, FIFOSellResult{EventID: e.ID, MatchedPnL: pnl.RatString(), MatchedQty: matched, OverflowQty: remaining})
	}
	return results, nil
}

func humanQuantity(raw string, decimals uint8) (*big.Rat, error) {
	n, ok := new(big.Int).SetString(raw, 10)
	if !ok {
		return nil, fmt.Errorf("不是十进制整数")
	}
	scale := new(big.Int).Exp(big.NewInt(10), big.NewInt(int64(decimals)), nil)
	return new(big.Rat).SetFrac(n, scale), nil
}
func minRat(a, b *big.Rat) *big.Rat {
	if a.Cmp(b) < 0 {
		return new(big.Rat).Set(a)
	}
	return new(big.Rat).Set(b)
}
