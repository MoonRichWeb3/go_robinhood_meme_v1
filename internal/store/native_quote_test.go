package store

import (
	"database/sql"
	"testing"
	"time"
)

func TestWalletEventPersistsUnknownNativeQuoteAsNull(t *testing.T) {
	data := openTestStore(t)
	now := time.Date(2026, 9, 2, 8, 5, 0, 0, time.UTC)
	decimals := uint8(18)
	event := WalletEvent{
		BlockNumber: 1, TxHash: "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
		ChainTime: now, IngestedAt: now,
		WalletAddress:  "0xc81e00000000000000000000000000000000d9d1",
		Kind:           "buy",
		Category:       "o1_crypto",
		TokenAddress:   "0x1ebc42c5ee785694a9775d5dd917166206eb58f5",
		Direction:      "buy",
		QuoteAddress:   "0x0000000000000000000000000000000000000000",
		TokenAmountRaw: "123",
		TokenDecimals:  &decimals,
		Router:         "gmgn",
	}
	if _, err := data.InsertWalletEvent(t.Context(), &event); err != nil {
		t.Fatal(err)
	}
	var quote sql.NullString
	var token string
	if err := data.readDB.QueryRowContext(t.Context(),
		`SELECT quote_amount_raw,token_amount_raw FROM wallet_events WHERE id=?`, event.ID).Scan(&quote, &token); err != nil {
		t.Fatal(err)
	}
	if quote.Valid || token != "123" {
		t.Fatalf("未知 quote 应为 NULL 且 token 数量保留: quote=%+v token=%s", quote, token)
	}
}
