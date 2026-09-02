package app

import (
	"bytes"
	"database/sql"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/logx"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/store"
)

func TestCollectFillLogsAttributionWarningWithoutWalletEvent(t *testing.T) {
	data, err := store.Open(t.Context(), filepath.Join(t.TempDir(), "app.sqlite3"))
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = data.Close() })
	if err = data.Migrate(t.Context(), "../../migrations"); err != nil {
		t.Fatal(err)
	}
	var output bytes.Buffer
	app := &App{store: data, logger: logx.New(&output, "info")}
	changes := store.BlockChanges{}
	prices := []pricedFill{}
	app.collectFill(t.Context(), domain.Fill{
		Token:              "0x1111111111111111111111111111111111111111",
		Quote:              "0x0000000000000000000000000000000000000000",
		TxHash:             "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
		AttributionWarning: "无法从 Transfer 唯一归因用户",
	}, &changes, &prices)
	if len(changes.Events) != 0 {
		t.Fatalf("完全归因失败不得写 wallet_events: %+v", changes.Events)
	}
	if !strings.Contains(output.String(), "类型=成交归因异常") ||
		!strings.Contains(output.String(), "无法从 Transfer 唯一归因用户") {
		t.Fatalf("缺少中文归因错误日志: %s", output.String())
	}
}

func TestAcceptLaunchCategorySkipsTypedConflict(t *testing.T) {
	data, err := store.Open(t.Context(), filepath.Join(t.TempDir(), "conflict.sqlite3"))
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = data.Close() })
	if err = data.Migrate(t.Context(), "../../migrations"); err != nil {
		t.Fatal(err)
	}
	token := "0x2222222222222222222222222222222222222222"
	now := time.Date(2026, 9, 2, 8, 0, 0, 0, time.UTC).Format(time.RFC3339)
	err = data.Writer().Write(t.Context(), func(tx *sql.Tx) error {
		_, execErr := tx.ExecContext(t.Context(), `INSERT INTO launch_index(token_address,category,creator_eoa,created_at,block_number,tx_hash) VALUES(?,'pons',?,?,1,'0x01')`,
			token, "0x3333333333333333333333333333333333333333", now)
		return execErr
	})
	if err != nil {
		t.Fatal(err)
	}
	var output bytes.Buffer
	app := &App{store: data, logger: logx.New(&output, "info")}
	accepted, err := app.acceptLaunchCategory(t.Context(), token, "o1_crypto", map[string]string{})
	if err != nil || accepted {
		t.Fatalf("已有分类冲突必须按创建事件跳过: accepted=%v err=%v", accepted, err)
	}
	if !strings.Contains(output.String(), "类型=新盘分类冲突") {
		t.Fatalf("缺少中文分类冲突日志: %s", output.String())
	}
}
