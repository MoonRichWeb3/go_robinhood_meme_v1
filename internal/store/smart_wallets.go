// 本文件提供聪明钱包名单读取及评分快照更新。
package store

import (
	"context"
	"database/sql"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

// SmartWallet 是名单全量读模型及评分更新目标。
type SmartWallet struct {
	Address, DisplayName, Source, PrimaryType, Tags, Level, Note, Status string
	SourceURL, LastSeenAt                                                *string
	Score                                                                float64
	ScoreWinRate, ScoreProfitUSD                                         *float64
	ScoreSampleN                                                         int
	LevelLocked                                                          bool
	CreatedAt, UpdatedAt                                                 time.Time
}

// ListSmartWallets 有界读取名单；limit 必须在 1..5000。
func (s *Store) ListSmartWallets(ctx context.Context, limit int) ([]SmartWallet, error) {
	if limit < 1 || limit > 5000 {
		return nil, domainError("名单 limit 必须在 1..5000")
	}
	rows, err := s.readDB.QueryContext(ctx, `SELECT address,display_name,source,source_url,primary_type,tags,level,score,score_win_rate,score_profit_usd,score_sample_n,note,status,level_locked,created_at,updated_at,last_seen_at FROM smart_wallets ORDER BY address LIMIT ?`, limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := make([]SmartWallet, 0)
	for rows.Next() {
		var v SmartWallet
		var locked int
		var ca, ua string
		if err = rows.Scan(&v.Address, &v.DisplayName, &v.Source, &v.SourceURL, &v.PrimaryType, &v.Tags, &v.Level, &v.Score, &v.ScoreWinRate, &v.ScoreProfitUSD, &v.ScoreSampleN, &v.Note, &v.Status, &locked, &ca, &ua, &v.LastSeenAt); err != nil {
			return nil, err
		}
		v.LevelLocked = locked == 1
		v.CreatedAt, _ = time.Parse(time.RFC3339, ca)
		v.UpdatedAt, _ = time.Parse(time.RFC3339, ua)
		out = append(out, v)
	}
	return out, rows.Err()
}

// LoadSmartWallets 全量读取名单快照；仅供启动和至多每秒一次的热刷新使用。
func (s *Store) LoadSmartWallets(ctx context.Context) ([]SmartWallet, error) {
	rows, err := s.readDB.QueryContext(ctx, `SELECT address,display_name,source,source_url,primary_type,tags,level,score,score_win_rate,score_profit_usd,score_sample_n,note,status,level_locked,created_at,updated_at,last_seen_at FROM smart_wallets ORDER BY address`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := make([]SmartWallet, 0)
	for rows.Next() {
		var v SmartWallet
		var locked int
		var ca, ua string
		if err = rows.Scan(&v.Address, &v.DisplayName, &v.Source, &v.SourceURL, &v.PrimaryType, &v.Tags, &v.Level, &v.Score, &v.ScoreWinRate, &v.ScoreProfitUSD, &v.ScoreSampleN, &v.Note, &v.Status, &locked, &ca, &ua, &v.LastSeenAt); err != nil {
			return nil, err
		}
		v.LevelLocked = locked == 1
		if v.CreatedAt, err = time.Parse(time.RFC3339, ca); err != nil {
			return nil, err
		}
		if v.UpdatedAt, err = time.Parse(time.RFC3339, ua); err != nil {
			return nil, err
		}
		out = append(out, v)
	}
	return out, rows.Err()
}

// UpdateWalletScore 更新评分快照；级别锁定时保留运营设置的级别。
func (s *Store) UpdateWalletScore(ctx context.Context, address string, r domain.ScoreResult, at time.Time) error {
	a, err := domain.NormalizeAddress(address)
	if err != nil {
		return err
	}
	return s.writer.Write(ctx, func(tx *sql.Tx) error {
		_, err := tx.ExecContext(ctx, `UPDATE smart_wallets SET score=?,score_win_rate=?,score_profit_usd=?,score_sample_n=?,level=CASE WHEN level_locked=1 THEN level ELSE ? END,updated_at=? WHERE address=?`, r.Score, r.WinRate, r.ProfitUSD, r.SampleN, r.Level, at.UTC().Format(time.RFC3339), a)
		return err
	})
}

type domainError string

func (e domainError) Error() string { return string(e) }
