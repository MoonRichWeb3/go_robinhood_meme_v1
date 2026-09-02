// 本文件提供 o1 加密发盘明细的事务写入与读取。
package store

import (
	"context"
	"database/sql"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

// InsertO1CryptoLaunch 在同一事务中写入 o1 加密明细和目录。
func (s *Store) InsertO1CryptoLaunch(ctx context.Context, v domain.O1CryptoLaunch) (InsertLaunchResult, error) {
	var err error
	for _, field := range []struct {
		value  string
		target *string
	}{{v.TokenAddress, &v.TokenAddress}, {v.QuoteAddress, &v.QuoteAddress}, {v.CreatorEOA, &v.CreatorEOA}, {v.CreatorEvent, &v.CreatorEvent}, {v.Hooks, &v.Hooks}} {
		if *field.target, err = domain.NormalizeAddress(field.value); err != nil {
			return InsertLaunchResult{}, err
		}
	}
	if v.PoolID, err = domain.NormalizeHash(v.PoolID, 32); err != nil {
		return InsertLaunchResult{}, err
	}
	var result InsertLaunchResult
	err = s.writer.Write(ctx, func(tx *sql.Tx) error {
		var err error
		result, err = insertLaunchIndex(ctx, tx, v)
		if err != nil || !result.Inserted {
			return err
		}
		_, err = tx.ExecContext(ctx, `INSERT INTO launch_o1_crypto(token_address,symbol,name,contract_uri,quote_address,quote_symbol,quote_decimals,pool_id,tick_spacing,hooks,supply,creator_eoa,creator_event,native_launch_fee_wei,block_number,tx_hash,log_index,created_at) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`, v.TokenAddress, v.Symbol, v.Name, v.ContractURI, v.QuoteAddress, v.QuoteSymbol, v.QuoteDecimals, v.PoolID, v.TickSpacing, v.Hooks, v.Supply, v.CreatorEOA, v.CreatorEvent, v.NativeLaunchFeeWei, v.BlockNumber, v.TxHash, v.LogIndex, v.CreatedAt.UTC().Format(timeFormat))
		return err
	})
	return result, err
}

// GetO1CryptoLaunch 按规范化代币地址读取加密盘口明细。
func (s *Store) GetO1CryptoLaunch(ctx context.Context, token string) (domain.O1CryptoLaunch, error) {
	var v domain.O1CryptoLaunch
	var at string
	t, err := domain.NormalizeAddress(token)
	if err != nil {
		return v, err
	}
	err = s.readDB.QueryRowContext(ctx, `SELECT token_address,symbol,name,contract_uri,quote_address,quote_symbol,quote_decimals,pool_id,tick_spacing,hooks,supply,creator_eoa,creator_event,native_launch_fee_wei,block_number,tx_hash,log_index,created_at FROM launch_o1_crypto WHERE token_address=?`, t).Scan(&v.TokenAddress, &v.Symbol, &v.Name, &v.ContractURI, &v.QuoteAddress, &v.QuoteSymbol, &v.QuoteDecimals, &v.PoolID, &v.TickSpacing, &v.Hooks, &v.Supply, &v.CreatorEOA, &v.CreatorEvent, &v.NativeLaunchFeeWei, &v.BlockNumber, &v.TxHash, &v.LogIndex, &at)
	if err == nil {
		v.CreatedAt, err = time.Parse(time.RFC3339, at)
	}
	return v, err
}
