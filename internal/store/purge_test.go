package store

import (
	"context"
	"database/sql"
	"path/filepath"
	"testing"
	"time"
)

func TestMigrateAndBoundedPurge(t *testing.T) {
	ctx := context.Background()
	s, err := Open(ctx, filepath.Join(t.TempDir(), "test.sqlite3"))
	if err != nil {
		t.Fatal(err)
	}
	defer s.Close()
	if err = s.Migrate(ctx, "../../migrations"); err != nil {
		t.Fatal(err)
	}
	now := time.Date(2026, 9, 2, 0, 0, 0, 0, time.UTC)
	if err = s.writer.Write(ctx, func(tx *sql.Tx) error {
		_, err := tx.Exec(`INSERT INTO smart_wallets(address,created_at,updated_at) VALUES(?,?,?)`, "0x1111111111111111111111111111111111111111", now.Format(time.RFC3339), now.Format(time.RFC3339))
		return err
	}); err != nil {
		t.Fatal(err)
	}
	for i, at := range []time.Time{now.Add(-8 * 24 * time.Hour), now.Add(-9 * 24 * time.Hour), now.Add(-6 * 24 * time.Hour)} {
		v := WalletEvent{BlockNumber: uint64(i + 1), TxHash: "0x1", ChainTime: at, IngestedAt: now, WalletAddress: "0x1111111111111111111111111111111111111111", Kind: "buy", Category: "pons", TokenAddress: "0x2222222222222222222222222222222222222222", Direction: "buy", QuoteAmountRaw: "1", TokenAmountRaw: "1", Router: "curve"}
		if _, err = s.InsertWalletEvent(ctx, &v); err != nil {
			t.Fatal(err)
		}
	}
	got, err := s.PurgeExpiredWalletEvents(ctx, now, 7, 1, 1, 0)
	if err != nil {
		t.Fatal(err)
	}
	if got.Deleted != 1 || !got.Limited {
		t.Fatalf("清理结果错误: %+v", got)
	}
	var count int
	if err = s.readDB.QueryRow(`SELECT count(*) FROM wallet_events`).Scan(&count); err != nil || count != 2 {
		t.Fatalf("剩余行错误: count=%d err=%v", count, err)
	}
}
