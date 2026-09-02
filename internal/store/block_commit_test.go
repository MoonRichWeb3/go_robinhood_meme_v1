package store

import (
	"context"
	"database/sql"
	"errors"
	"path/filepath"
	"testing"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

func TestCommitBlockAtomicWatermark(t *testing.T) {
	data := openTestStore(t)
	now := time.Date(2026, 9, 2, 8, 0, 0, 0, time.UTC)
	state := SyncState{Name: "atomic", LastBlock: 42, LastHash: "0x42", UpdatedAt: now}

	t.Run("成功同时推进业务和水位", func(t *testing.T) {
		launch := testPonsLaunch("0x1111111111111111111111111111111111111111", 42, now)
		if _, err := data.CommitBlock(t.Context(), BlockChanges{Pons: []domain.PonsLaunch{launch}}, state); err != nil {
			t.Fatal(err)
		}
		if _, err := data.GetPonsLaunch(t.Context(), launch.TokenAddress); err != nil {
			t.Fatalf("业务行未提交: %v", err)
		}
		got, err := data.GetSyncState(t.Context(), state.Name)
		if err != nil || got.LastBlock != state.LastBlock || got.LastHash != state.LastHash {
			t.Fatalf("水位未原子推进: got=%+v err=%v", got, err)
		}
	})

	t.Run("业务失败同时回滚水位", func(t *testing.T) {
		failedState := SyncState{Name: "rollback", LastBlock: 43, LastHash: "0x43", UpdatedAt: now}
		launch := testPonsLaunch("0x2222222222222222222222222222222222222222", 43, now)
		invalidEvent := WalletEvent{
			BlockNumber: 43, TxHash: launch.TxHash, ChainTime: now, IngestedAt: now,
			WalletAddress: "not-an-address", Kind: "buy", Category: "pons",
			TokenAddress: launch.TokenAddress, Direction: "buy",
			QuoteAmountRaw: "1", TokenAmountRaw: "1", Router: "curve",
		}
		if _, err := data.CommitBlock(t.Context(), BlockChanges{
			Pons: []domain.PonsLaunch{launch}, Events: []WalletEvent{invalidEvent},
		}, failedState); err == nil {
			t.Fatal("无效业务写必须导致整块失败")
		}
		if _, err := data.GetPonsLaunch(t.Context(), launch.TokenAddress); !errors.Is(err, sql.ErrNoRows) {
			t.Fatalf("业务行未回滚: %v", err)
		}
		if _, err := data.GetSyncState(t.Context(), failedState.Name); !errors.Is(err, sql.ErrNoRows) {
			t.Fatalf("水位未回滚: %v", err)
		}
	})
}

func TestCommitBlockSkipsTypedCategoryConflict(t *testing.T) {
	data := openTestStore(t)
	now := time.Date(2026, 9, 2, 9, 0, 0, 0, time.UTC)
	token := "0x3333333333333333333333333333333333333333"
	if _, err := data.InsertPonsLaunch(t.Context(), testPonsLaunch(token, 1, now)); err != nil {
		t.Fatal(err)
	}
	conflicting := testO1Launch(token, 2, now)
	_, directErr := data.InsertO1CryptoLaunch(t.Context(), conflicting)
	var typed *LaunchCategoryConflictError
	if !errors.As(directErr, &typed) || typed.Token != token {
		t.Fatalf("分类冲突必须是类型化错误: %T %v", directErr, directErr)
	}

	decimals := uint8(18)
	wallet := "0x4444444444444444444444444444444444444444"
	conflictEvent := WalletEvent{
		BlockNumber: 2, TxIndex: 0, LogIndex: 1, TxHash: conflicting.TxHash,
		ChainTime: now, IngestedAt: now, WalletAddress: wallet, Kind: "launch",
		Category: "o1_crypto", TokenAddress: token, Direction: "launch",
		QuoteAmountRaw: "0", TokenAmountRaw: "0", TokenDecimals: &decimals, Router: "unknown",
	}
	otherEvent := conflictEvent
	otherEvent.LogIndex = 2
	otherEvent.Kind, otherEvent.Direction, otherEvent.Category = "buy", "buy", "pons"
	result, err := data.CommitBlock(t.Context(), BlockChanges{
		O1Crypto: []domain.O1CryptoLaunch{conflicting},
		Events:   []WalletEvent{conflictEvent, otherEvent},
	}, SyncState{Name: "conflict", LastBlock: 2, LastHash: "0x02", UpdatedAt: now})
	if err != nil {
		t.Fatalf("分类冲突不得阻塞整块: %v", err)
	}
	if len(result.Conflicts) != 1 || len(result.EventInserted) != 1 || result.EventInserted[0].Kind != "buy" {
		t.Fatalf("冲突 token 的 launch 事件未正确隔离: %+v", result)
	}
	state, err := data.GetSyncState(t.Context(), "conflict")
	if err != nil || state.LastBlock != 2 {
		t.Fatalf("分类冲突后水位未推进: %+v %v", state, err)
	}
}

func openTestStore(t *testing.T) *Store {
	t.Helper()
	data, err := Open(context.Background(), filepath.Join(t.TempDir(), "test.sqlite3"))
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = data.Close() })
	if err = data.Migrate(context.Background(), "../../migrations"); err != nil {
		t.Fatal(err)
	}
	return data
}

func testPonsLaunch(token string, block uint64, now time.Time) domain.PonsLaunch {
	return domain.PonsLaunch{
		TokenAddress: token, CurveAddress: "0x5555555555555555555555555555555555555555",
		PairAddress: "0x0000000000000000000000000000000000000000", PairSymbol: "ETH",
		PairDecimals: 18, LaunchConfigID: "1", GraduationThreshold: "2",
		Deployer:    "0x6666666666666666666666666666666666666666",
		CreatorEOA:  "0x7777777777777777777777777777777777777777",
		LaunchEntry: "factory", FirstBuyQuote: "0", FirstBuyTokens: "0", Phase: "curve",
		BlockNumber: block, TxHash: "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
		LogIndex: 0, CreatedAt: now,
	}
}

func testO1Launch(token string, block uint64, now time.Time) domain.O1CryptoLaunch {
	return domain.O1CryptoLaunch{
		TokenAddress: token, QuoteAddress: "0x8888888888888888888888888888888888888888",
		QuoteSymbol: "USDG", QuoteDecimals: 6,
		PoolID: "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
		Hooks:  "0x9999999999999999999999999999999999999999", Supply: "1",
		CreatorEOA:         "0x7777777777777777777777777777777777777777",
		CreatorEvent:       "0x6666666666666666666666666666666666666666",
		NativeLaunchFeeWei: "0", BlockNumber: block,
		TxHash:   "0xcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc",
		LogIndex: 1, CreatedAt: now,
	}
}
