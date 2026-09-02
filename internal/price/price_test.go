package price

import (
	"context"
	"math/big"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

func TestExecQuotePerTokenExact(t *testing.T) {
	got, err := ExecQuotePerToken("2500000000000000000", "5000000", 18, 6)
	if err != nil {
		t.Fatal(err)
	}
	if got.Cmp(big.NewRat(2, 1)) != 0 {
		t.Fatalf("成交价=%s，期望 2", got.RatString())
	}
}

func TestBinanceFeedTTLAndStale(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Query().Get("symbol") != "ETHUSDT" {
			t.Fatalf("symbol=%q", r.URL.Query().Get("symbol"))
		}
		_, _ = w.Write([]byte(`{"price":"4321.25"}`))
	}))
	defer server.Close()
	feed, err := NewBinanceFeed(BinanceConfig{
		BaseURL: server.URL, Symbol: "ETHUSDT", PollInterval: time.Second,
		TTL: time.Second, Stale: 3 * time.Second, RequestTimout: time.Second,
	}, nil)
	if err != nil {
		t.Fatal(err)
	}
	now := time.Unix(100, 0).UTC()
	feed.now = func() time.Time { return now }
	if limited, err := feed.fetch(context.Background()); err != nil || limited {
		t.Fatalf("fetch limited=%v err=%v", limited, err)
	}
	if got, err := feed.ETHUSD(); err != nil || got.RatString() != "17285/4" {
		t.Fatalf("ETHUSD=%v err=%v", got, err)
	}
	now = now.Add(2 * time.Second)
	if _, err := feed.ETHUSD(); err == nil {
		t.Fatal("TTL 过期且没有失败事实时应拒绝旧值")
	}
	feed.mu.Lock()
	feed.lastFailed = true
	feed.mu.Unlock()
	if _, err := feed.ETHUSD(); err != nil {
		t.Fatalf("stale 窗内失败降级应可用: %v", err)
	}
	now = now.Add(2 * time.Second)
	if _, err := feed.ETHUSD(); err == nil {
		t.Fatal("超过 stale 窗必须缺价")
	}
}

type dirtyStore struct {
	index   map[string]domain.LaunchIndex
	updated []string
}

func (s *dirtyStore) GetLaunchIndex(_ context.Context, token string) (domain.LaunchIndex, error) {
	return s.index[token], nil
}
func (s *dirtyStore) UpdateLaunchPrice(_ context.Context, token string, _ float64, _ uint64, _ string, _ time.Time) error {
	s.updated = append(s.updated, token)
	return nil
}

func TestDirtySetEvictsOldest(t *testing.T) {
	store := &dirtyStore{index: map[string]domain.LaunchIndex{
		"0x0000000000000000000000000000000000000001": {TokenAddress: "0x0000000000000000000000000000000000000001"},
		"0x0000000000000000000000000000000000000002": {TokenAddress: "0x0000000000000000000000000000000000000002"},
	}}
	set, err := NewDirtySet(store, 1, nil)
	if err != nil {
		t.Fatal(err)
	}
	for tokenIndex, token := range []string{
		"0x0000000000000000000000000000000000000001",
		"0x0000000000000000000000000000000000000002",
	} {
		if err = set.Mark(context.Background(), Point{Token: token, TxHash: "0x1", PriceUSD: float64(tokenIndex + 1), Block: 1, At: time.Now()}); err != nil {
			t.Fatal(err)
		}
	}
	if err = set.Flush(context.Background()); err != nil {
		t.Fatal(err)
	}
	if len(store.updated) != 1 || store.updated[0] != "0x0000000000000000000000000000000000000002" {
		t.Fatalf("刷价结果=%v", store.updated)
	}
}
