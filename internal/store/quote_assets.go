// 本文件提供报价资产目录的类型化读写。
package store

import (
	"context"
	"database/sql"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

// QuoteAsset 是报价资产的本地元数据。
type QuoteAsset struct {
	Address, Symbol, Kind string
	Decimals              uint8
}

// GetQuoteAsset 规范化地址后查询报价资产。
func (s *Store) GetQuoteAsset(ctx context.Context, address string) (QuoteAsset, error) {
	var v QuoteAsset
	a, err := domain.NormalizeAddress(address)
	if err != nil {
		return v, err
	}
	err = s.readDB.QueryRowContext(ctx, `SELECT address,symbol,decimals,kind FROM quote_assets WHERE address=?`, a).Scan(&v.Address, &v.Symbol, &v.Decimals, &v.Kind)
	return v, err
}

// UpsertQuoteAsset 通过唯一写入口补充或更新报价元数据。
func (s *Store) UpsertQuoteAsset(ctx context.Context, v QuoteAsset) error {
	a, err := domain.NormalizeAddress(v.Address)
	if err != nil {
		return err
	}
	return s.writer.Write(ctx, func(tx *sql.Tx) error {
		_, err := tx.ExecContext(ctx, `INSERT INTO quote_assets(address,symbol,decimals,kind) VALUES(?,?,?,?) ON CONFLICT(address) DO UPDATE SET symbol=excluded.symbol,decimals=excluded.decimals,kind=excluded.kind`, a, v.Symbol, v.Decimals, v.Kind)
		return err
	})
}
