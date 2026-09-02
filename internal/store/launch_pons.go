// 本文件提供 Pons 发盘明细的事务写入、毕业更新与读取。
package store

import (
	"context"
	"database/sql"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

// InsertPonsLaunch 在同一事务中写入 Pons 明细和目录，分类冲突时整体回滚。
func (s *Store) InsertPonsLaunch(ctx context.Context, v domain.PonsLaunch) (InsertLaunchResult, error) {
	var err error
	for _, field := range []struct {
		value  string
		target *string
	}{{v.TokenAddress, &v.TokenAddress}, {v.CurveAddress, &v.CurveAddress}, {v.PairAddress, &v.PairAddress}, {v.Deployer, &v.Deployer}, {v.CreatorEOA, &v.CreatorEOA}} {
		if *field.target, err = domain.NormalizeAddress(field.value); err != nil {
			return InsertLaunchResult{}, err
		}
	}
	if v.CreatorFeeRecipient != "" {
		if v.CreatorFeeRecipient, err = domain.NormalizeAddress(v.CreatorFeeRecipient); err != nil {
			return InsertLaunchResult{}, err
		}
	}
	if v.PoolID != "" {
		if v.PoolID, err = domain.NormalizeHash(v.PoolID, 32); err != nil {
			return InsertLaunchResult{}, err
		}
	}
	var result InsertLaunchResult
	err = s.writer.Write(ctx, func(tx *sql.Tx) error {
		var err error
		result, err = insertLaunchIndex(ctx, tx, v)
		if err != nil || !result.Inserted {
			return err
		}
		_, err = tx.ExecContext(ctx, `INSERT INTO launch_pons(token_address,symbol,name,logo,description,curve_address,pair_address,pair_symbol,pair_decimals,launch_config_id,graduation_threshold,deployer,creator_eoa,creator_fee_recipient,launch_entry,first_buy_quote,first_buy_tokens,phase,graduated_at,pool_id,block_number,tx_hash,log_index,created_at) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`, v.TokenAddress, v.Symbol, v.Name, v.Logo, v.Description, v.CurveAddress, v.PairAddress, v.PairSymbol, v.PairDecimals, v.LaunchConfigID, v.GraduationThreshold, v.Deployer, v.CreatorEOA, nullString(v.CreatorFeeRecipient), v.LaunchEntry, v.FirstBuyQuote, v.FirstBuyTokens, v.Phase, v.GraduatedAt, nullString(v.PoolID), v.BlockNumber, v.TxHash, v.LogIndex, v.CreatedAt.UTC().Format(timeFormat))
		return err
	})
	return result, err
}

// GraduatePonsLaunch 原子更新 Pons 毕业状态及目录状态。
func (s *Store) GraduatePonsLaunch(ctx context.Context, token, poolID string, at time.Time) error {
	t, err := domain.NormalizeAddress(token)
	if err != nil {
		return err
	}
	p, err := domain.NormalizeHash(poolID, 32)
	if err != nil {
		return err
	}
	return s.writer.Write(ctx, func(tx *sql.Tx) error {
		if _, err := tx.ExecContext(ctx, `UPDATE launch_pons SET phase='graduated',graduated_at=?,pool_id=? WHERE token_address=?`, at.UTC().Format(time.RFC3339), p, t); err != nil {
			return err
		}
		_, err := tx.ExecContext(ctx, `UPDATE launch_index SET status='graduated' WHERE token_address=? AND category='pons'`, t)
		return err
	})
}

const timeFormat = "2006-01-02T15:04:05Z07:00"

// GetPonsLaunch 按规范化代币地址读取 Pons 明细。
func (s *Store) GetPonsLaunch(ctx context.Context, token string) (domain.PonsLaunch, error) {
	var v domain.PonsLaunch
	var graduated sql.NullString
	var at string
	t, err := domain.NormalizeAddress(token)
	if err != nil {
		return v, err
	}
	err = s.readDB.QueryRowContext(ctx, `SELECT token_address,symbol,name,logo,description,curve_address,pair_address,pair_symbol,pair_decimals,launch_config_id,graduation_threshold,deployer,creator_eoa,COALESCE(creator_fee_recipient,''),launch_entry,first_buy_quote,first_buy_tokens,phase,graduated_at,COALESCE(pool_id,''),block_number,tx_hash,log_index,created_at FROM launch_pons WHERE token_address=?`, t).Scan(&v.TokenAddress, &v.Symbol, &v.Name, &v.Logo, &v.Description, &v.CurveAddress, &v.PairAddress, &v.PairSymbol, &v.PairDecimals, &v.LaunchConfigID, &v.GraduationThreshold, &v.Deployer, &v.CreatorEOA, &v.CreatorFeeRecipient, &v.LaunchEntry, &v.FirstBuyQuote, &v.FirstBuyTokens, &v.Phase, &graduated, &v.PoolID, &v.BlockNumber, &v.TxHash, &v.LogIndex, &at)
	if err == nil {
		if graduated.Valid {
			x, e := time.Parse(time.RFC3339, graduated.String)
			if e != nil {
				return v, e
			}
			v.GraduatedAt = &x
		}
		v.CreatedAt, err = time.Parse(time.RFC3339, at)
	}
	return v, err
}
