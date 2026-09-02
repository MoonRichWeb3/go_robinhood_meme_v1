package score

import (
	"context"
	"errors"
	"math/big"
	"testing"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/store"
)

type scoreStoreFake struct {
	wallets []store.SmartWallet
	events  map[string][]store.ScoreEvent
	fail    string
	updated []string
}

func (f *scoreStoreFake) LoadSmartWallets(context.Context) ([]store.SmartWallet, error) {
	return f.wallets, nil
}

func (f *scoreStoreFake) ScoreEvents(_ context.Context, wallet string) ([]store.ScoreEvent, error) {
	if wallet == f.fail {
		return nil, errors.New("测试读取失败")
	}
	return f.events[wallet], nil
}

func (f *scoreStoreFake) UpdateWalletScore(_ context.Context, wallet string, _ domain.ScoreResult, _ time.Time) error {
	f.updated = append(f.updated, wallet)
	return nil
}

type scoreLoggerFake struct{ errors int }

func (*scoreLoggerFake) Info(string, map[string]any) {}
func (l *scoreLoggerFake) Error(map[string]any)      { l.errors++ }

func TestRecalculateAllIsolatesWalletFailure(t *testing.T) {
	bad := "0x1111111111111111111111111111111111111111"
	good := "0x2222222222222222222222222222222222222222"
	token := "0x3333333333333333333333333333333333333333"
	now := time.Date(2026, 9, 2, 8, 0, 0, 0, time.UTC)
	fake := &scoreStoreFake{
		wallets: []store.SmartWallet{{Address: bad}, {Address: good}},
		fail:    bad,
		events: map[string][]store.ScoreEvent{good: {
			{Token: token, ID: "buy", Direction: "buy", QuantityRaw: "10", PriceUSD: big.NewRat(2, 1), ChainTime: now},
			{Token: token, ID: "sell", Direction: "sell", QuantityRaw: "4", PriceUSD: big.NewRat(5, 1), ChainTime: now.Add(time.Minute)},
		}},
	}
	logger := &scoreLoggerFake{}
	recalculator, err := New(fake, logger)
	if err != nil {
		t.Fatal(err)
	}
	recalculator.now = func() time.Time { return now }
	if err = recalculator.RecalculateAll(t.Context()); err == nil {
		t.Fatal("应返回首个钱包错误供调度器观测")
	}
	if len(fake.updated) != 1 || fake.updated[0] != good {
		t.Fatalf("单钱包失败阻断了后续钱包: %+v", fake.updated)
	}
	if logger.errors != 1 {
		t.Fatalf("评分失败日志数=%d", logger.errors)
	}
}
