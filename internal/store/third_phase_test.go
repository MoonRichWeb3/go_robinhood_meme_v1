package store

import (
	"context"
	"database/sql"
	"path/filepath"
	"testing"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

func TestCommitBlockAndSignalQuery(t *testing.T) {
	ctx := context.Background()
	data, err := Open(ctx, filepath.Join(t.TempDir(), "phase3.sqlite3"))
	if err != nil {
		t.Fatal(err)
	}
	defer data.Close()
	if err = data.Migrate(ctx, "../../migrations"); err != nil {
		t.Fatal(err)
	}
	now := time.Date(2026, 9, 2, 0, 0, 0, 0, time.UTC)
	wallet := "0x1111111111111111111111111111111111111111"
	if err = data.writer.Write(ctx, func(tx *sql.Tx) error {
		_, execErr := tx.Exec(`INSERT INTO smart_wallets(address,level,score_sample_n,created_at,updated_at) VALUES(?,?,?,?,?)`,
			wallet, "B", 8, now.Format(time.RFC3339), now.Format(time.RFC3339))
		return execErr
	}); err != nil {
		t.Fatal(err)
	}
	token := "0x2222222222222222222222222222222222222222"
	launch := domain.PonsLaunch{
		TokenAddress: token, CurveAddress: "0x3333333333333333333333333333333333333333",
		PairAddress: "0x0000000000000000000000000000000000000000", PairSymbol: "ETH", PairDecimals: 18,
		LaunchConfigID: "1", GraduationThreshold: "2", Deployer: wallet, CreatorEOA: wallet,
		LaunchEntry: "factory", FirstBuyQuote: "0", FirstBuyTokens: "0", Phase: "curve",
		BlockNumber: 1, TxHash: "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
		LogIndex: 0, CreatedAt: now,
	}
	decimals := uint8(18)
	result, err := data.CommitBlock(ctx, BlockChanges{
		Pons: []domain.PonsLaunch{launch},
		Events: []WalletEvent{{
			BlockNumber: 1, TxHash: launch.TxHash, ChainTime: now, IngestedAt: now,
			WalletAddress: wallet, Kind: "launch", Category: "pons", TokenAddress: token,
			Direction: "launch", QuoteAmountRaw: "0", TokenAmountRaw: "0",
			TokenDecimals: &decimals, Router: "unknown",
		}},
	}, SyncState{Name: "test", LastBlock: 1, LastHash: "0x01", UpdatedAt: now})
	if err != nil {
		t.Fatal(err)
	}
	if len(result.PonsInserted) != 1 || len(result.EventInserted) != 1 {
		t.Fatalf("整块结果不完整: %+v", result)
	}
	launches, err := data.ListLaunches(ctx, "", "", "", 50)
	if err != nil {
		t.Fatal(err)
	}
	if len(launches) != 1 || launches[0].PriceUSD != nil {
		t.Fatalf("新盘空价格读取错误: %+v", launches)
	}
	signals, err := data.ListSignals(ctx, "smart_launch", 50, now)
	if err != nil {
		t.Fatal(err)
	}
	if len(signals) != 1 || signals[0].Token != token {
		t.Fatalf("聪明钱发盘信号错误: %+v", signals)
	}
}
