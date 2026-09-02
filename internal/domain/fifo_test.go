package domain

import (
	"math/big"
	"testing"
)

func rat(v string) *big.Rat { r, _ := new(big.Rat).SetString(v); return r }

func TestReplayFIFO(t *testing.T) {
	events := []FIFOEvent{
		{ID: "1", Direction: "buy", QuantityRaw: "300", TokenDecimals: 0, PriceUSD: rat("1")},
		{ID: "2", Direction: "buy", QuantityRaw: "200", TokenDecimals: 0, PriceUSD: rat("3")},
		{ID: "3", Direction: "sell", QuantityRaw: "600", TokenDecimals: 0, PriceUSD: rat("2")},
	}
	got, err := ReplayFIFO(events)
	if err != nil {
		t.Fatal(err)
	}
	if got[0].MatchedPnL != "100" || got[0].MatchedQty.RatString() != "500" || got[0].OverflowQty.RatString() != "100" {
		t.Fatalf("结果错误: %+v", got[0])
	}
}

func TestReplayFIFOSkipsMissingUSD(t *testing.T) {
	got, err := ReplayFIFO([]FIFOEvent{{ID: "1", Direction: "buy", QuantityRaw: "10", PriceUSD: nil}, {ID: "2", Direction: "sell", QuantityRaw: "2", PriceUSD: rat("2")}})
	if err != nil || got[0].OverflowQty.RatString() != "2" {
		t.Fatalf("got=%v err=%v", got, err)
	}
}
