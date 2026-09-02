package wallets

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/store"
)

type fakeSource struct {
	rows []store.SmartWallet
	err  error
}

func (f *fakeSource) LoadSmartWallets(context.Context) ([]store.SmartWallet, error) {
	return f.rows, f.err
}

func TestRefreshFailureKeepsOldSnapshot(t *testing.T) {
	source := &fakeSource{rows: []store.SmartWallet{{
		Address: "0x00000000000000000000000000000000000000AA", DisplayName: "甲", Status: "active",
	}}}
	snapshot, err := New(source, nil)
	if err != nil {
		t.Fatal(err)
	}
	if err = snapshot.Load(context.Background()); err != nil {
		t.Fatal(err)
	}
	source.err = errors.New("数据库暂不可用")
	snapshot.mu.Lock()
	snapshot.lastOK = time.Now().Add(-time.Second)
	snapshot.lastTry = snapshot.lastOK
	snapshot.mu.Unlock()
	if err = snapshot.RefreshIfDue(context.Background(), time.Millisecond); err == nil {
		t.Fatal("刷新失败应返回错误")
	}
	view, ok := snapshot.Active("0x00000000000000000000000000000000000000aa")
	if !ok || view.DisplayName != "甲" {
		t.Fatalf("旧快照未保留: ok=%v view=%+v", ok, view)
	}
}
