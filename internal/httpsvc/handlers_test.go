package httpsvc

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"path/filepath"
	"testing"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/store"
	"github.com/zeromicro/go-zero/rest/pathvar"
)

func TestHTTPParameterValidation(t *testing.T) {
	if _, err := parseLimit("0"); err == nil {
		t.Fatal("limit=0 必须拒绝")
	}
	if limit, err := parseLimit(""); err != nil || limit != 50 {
		t.Fatalf("默认 limit 错误: %d %v", limit, err)
	}
	valid := "2026-09-02T08:00:00Z,0x1111111111111111111111111111111111111111"
	if at, token, err := parseLaunchCursor(valid); err != nil ||
		at != "2026-09-02T08:00:00Z" || token != "0x1111111111111111111111111111111111111111" {
		t.Fatalf("合法 cursor 解析错误: %q %q %v", at, token, err)
	}
	for _, invalid := range []string{
		"missing-comma",
		"2026-09-02T08:00:00+08:00,0x1111111111111111111111111111111111111111",
		"2026-09-02T08:00:00Z,invalid",
	} {
		if _, _, err := parseLaunchCursor(invalid); err == nil {
			t.Fatalf("非法 cursor 未拒绝: %s", invalid)
		}
	}
}

func TestWalletEventsReturnsFIFORealizedPnL(t *testing.T) {
	data, err := store.Open(t.Context(), filepath.Join(t.TempDir(), "http.sqlite3"))
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = data.Close() })
	if err = data.Migrate(t.Context(), "../../migrations"); err != nil {
		t.Fatal(err)
	}
	wallet := "0x1111111111111111111111111111111111111111"
	token := "0x2222222222222222222222222222222222222222"
	decimals := uint8(0)
	buyPrice, sellPrice := 2.0, 5.0
	now := time.Date(2026, 9, 2, 8, 0, 0, 0, time.UTC)
	for _, event := range []store.WalletEvent{
		{
			BlockNumber: 1, TxHash: "0x01", ChainTime: now, IngestedAt: now,
			WalletAddress: wallet, Kind: "buy", Category: "pons", TokenAddress: token,
			Direction: "buy", QuoteAmountRaw: "20", TokenAmountRaw: "10",
			TokenDecimals: &decimals, ExecUSDPerToken: &buyPrice, Router: "curve",
		},
		{
			BlockNumber: 2, TxHash: "0x02", ChainTime: now.Add(time.Minute), IngestedAt: now,
			WalletAddress: wallet, Kind: "sell", Category: "pons", TokenAddress: token,
			Direction: "sell", QuoteAmountRaw: "20", TokenAmountRaw: "4",
			TokenDecimals: &decimals, ExecUSDPerToken: &sellPrice, Router: "curve",
		},
	} {
		event := event
		if _, err = data.InsertWalletEvent(t.Context(), &event); err != nil {
			t.Fatal(err)
		}
	}

	server := &Server{store: data}
	request := httptest.NewRequest(http.MethodGet, "/wallets/"+wallet+"/events?limit=10", nil)
	request = pathvar.WithVars(request, map[string]string{"address": wallet})
	response := httptest.NewRecorder()
	server.walletEvents(response, request)
	if response.Code != http.StatusOK {
		t.Fatalf("状态码=%d body=%s", response.Code, response.Body.String())
	}
	var body walletEventList
	if err = json.NewDecoder(response.Body).Decode(&body); err != nil {
		t.Fatal(err)
	}
	if len(body.Items) != 2 || body.Items[0].Kind != "sell" ||
		body.Items[0].RealizedPnLUSD == nil || *body.Items[0].RealizedPnLUSD != 12 {
		t.Fatalf("FIFO 已实现盈亏响应错误: %+v", body.Items)
	}
}
