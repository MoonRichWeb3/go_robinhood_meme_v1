// 本文件提供聪明钱包交易流水、FIFO 输入与有界查询。
package store

import (
	"context"
	"database/sql"
	"fmt"
	"math/big"
	"strconv"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

// WalletEvent 是 wallet_events 的类型化读写模型。
type WalletEvent struct {
	ID                                                        string
	BlockNumber, TxIndex, LogIndex                            uint64
	TxHash                                                    string
	ChainTime, IngestedAt                                     time.Time
	WalletAddress, Kind, Category, TokenAddress, Direction    string
	QuoteAddress, QuoteSymbol, QuoteAmountRaw, TokenAmountRaw string
	QuoteDecimals, TokenDecimals                              *uint8
	ExecQuotePerToken                                         *string
	ExecUSDPerToken, QuoteUSD                                 *float64
	Router                                                    string
}

// ScoreEvent 是评分重放所需的最小交易视图。
type ScoreEvent struct {
	Token, ID, Direction, QuantityRaw string
	TokenDecimals                     uint8
	PriceUSD                          *big.Rat
	ChainTime                         time.Time
}

// InsertWalletEvent 幂等插入事件并在成功插入时更新名单 last_seen_at。
func (s *Store) InsertWalletEvent(ctx context.Context, v *WalletEvent) (bool, error) {
	var widthErr error
	if v.ID == "" {
		v.ID, widthErr = domain.CalcEventID(v.BlockNumber, v.TxIndex, v.LogIndex)
	}
	var err error
	if v.WalletAddress, err = domain.NormalizeAddress(v.WalletAddress); err != nil {
		return false, err
	}
	if v.TokenAddress, err = domain.NormalizeAddress(v.TokenAddress); err != nil {
		return false, err
	}
	if v.QuoteAddress != "" {
		if v.QuoteAddress, err = domain.NormalizeAddress(v.QuoteAddress); err != nil {
			return false, err
		}
	}
	inserted := false
	err = s.writer.Write(ctx, func(tx *sql.Tx) error {
		res, e := tx.ExecContext(ctx, `INSERT OR IGNORE INTO wallet_events(id,block_number,tx_index,log_index,tx_hash,chain_time,ingested_at,wallet_address,kind,category,token_address,direction,quote_address,quote_symbol,quote_amount_raw,quote_decimals,token_amount_raw,token_decimals,exec_quote_per_token,exec_usd_per_token,quote_usd,router) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
			v.ID, v.BlockNumber, v.TxIndex, v.LogIndex, v.TxHash, v.ChainTime.UTC().Format(time.RFC3339), v.IngestedAt.UTC().Format(time.RFC3339), v.WalletAddress, v.Kind, v.Category, v.TokenAddress, v.Direction, nullString(v.QuoteAddress), nullString(v.QuoteSymbol), nullString(v.QuoteAmountRaw), v.QuoteDecimals, v.TokenAmountRaw, v.TokenDecimals, v.ExecQuotePerToken, v.ExecUSDPerToken, v.QuoteUSD, v.Router)
		if e != nil {
			return e
		}
		n, e := res.RowsAffected()
		if e != nil {
			return e
		}
		inserted = n == 1
		if inserted {
			_, e = tx.ExecContext(ctx, `UPDATE smart_wallets SET last_seen_at=?,updated_at=? WHERE address=?`, v.IngestedAt.UTC().Format(time.RFC3339), v.IngestedAt.UTC().Format(time.RFC3339), v.WalletAddress)
		}
		return e
	})
	if err != nil {
		return false, err
	}
	return inserted, widthErr
}

// FIFOEvents 读取同钱包同代币仍在保留窗内的 FIFO 输入。
func (s *Store) FIFOEvents(ctx context.Context, wallet, token string) ([]domain.FIFOEvent, error) {
	w, err := domain.NormalizeAddress(wallet)
	if err != nil {
		return nil, err
	}
	t, err := domain.NormalizeAddress(token)
	if err != nil {
		return nil, err
	}
	rows, err := s.readDB.QueryContext(ctx, `SELECT id,direction,token_amount_raw,token_decimals,exec_usd_per_token FROM wallet_events WHERE wallet_address=? AND token_address=? AND kind IN ('buy','sell') ORDER BY id`, w, t)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := make([]domain.FIFOEvent, 0)
	for rows.Next() {
		var e domain.FIFOEvent
		var dec sql.NullInt64
		var p sql.NullFloat64
		if err = rows.Scan(&e.ID, &e.Direction, &e.QuantityRaw, &dec, &p); err != nil {
			return nil, err
		}
		if !dec.Valid {
			return nil, fmt.Errorf("事件 %s 缺 token_decimals", e.ID)
		}
		e.TokenDecimals = uint8(dec.Int64)
		if p.Valid {
			e.PriceUSD, _ = new(big.Rat).SetString(strconv.FormatFloat(p.Float64, 'g', -1, 64))
		}
		out = append(out, e)
	}
	return out, rows.Err()
}

// ScoreEvents 按 token、自然键顺序读取某钱包仍在保留窗内的全部可重放买卖。
func (s *Store) ScoreEvents(ctx context.Context, wallet string) ([]ScoreEvent, error) {
	w, err := domain.NormalizeAddress(wallet)
	if err != nil {
		return nil, err
	}
	rows, err := s.readDB.QueryContext(ctx, `SELECT token_address,id,direction,token_amount_raw,token_decimals,exec_usd_per_token,chain_time FROM wallet_events WHERE wallet_address=? AND kind IN ('buy','sell') ORDER BY token_address,id`, w)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := make([]ScoreEvent, 0)
	for rows.Next() {
		var event ScoreEvent
		var decimals sql.NullInt64
		var price sql.NullFloat64
		var chainTime string
		if err = rows.Scan(&event.Token, &event.ID, &event.Direction, &event.QuantityRaw, &decimals, &price, &chainTime); err != nil {
			return nil, err
		}
		if !decimals.Valid || decimals.Int64 < 0 || decimals.Int64 > 255 {
			return nil, fmt.Errorf("事件 %s token_decimals 无效", event.ID)
		}
		event.TokenDecimals = uint8(decimals.Int64)
		if price.Valid {
			event.PriceUSD, _ = new(big.Rat).SetString(strconv.FormatFloat(price.Float64, 'g', -1, 64))
		}
		if event.ChainTime, err = time.Parse(time.RFC3339, chainTime); err != nil {
			return nil, fmt.Errorf("事件 %s chain_time 无效: %w", event.ID, err)
		}
		out = append(out, event)
	}
	return out, rows.Err()
}

// ListWalletEvents 按自然键倒序有界查询钱包流水。
func (s *Store) ListWalletEvents(ctx context.Context, wallet, kind string, limit int) ([]WalletEvent, error) {
	if limit < 1 || limit > 200 {
		return nil, domainError("流水 limit 必须在 1..200")
	}
	w, err := domain.NormalizeAddress(wallet)
	if err != nil {
		return nil, err
	}
	q := `SELECT id,block_number,tx_index,log_index,tx_hash,chain_time,ingested_at,wallet_address,kind,category,token_address,direction,COALESCE(quote_address,''),COALESCE(quote_symbol,''),quote_amount_raw,quote_decimals,token_amount_raw,token_decimals,exec_quote_per_token,exec_usd_per_token,quote_usd,router FROM wallet_events WHERE wallet_address=?`
	args := []any{w}
	if kind != "" {
		q += ` AND kind=?`
		args = append(args, kind)
	}
	q += ` ORDER BY id DESC LIMIT ?`
	args = append(args, limit)
	rows, err := s.readDB.QueryContext(ctx, q, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := make([]WalletEvent, 0)
	for rows.Next() {
		var v WalletEvent
		var ct, it string
		var quoteAmount sql.NullString
		if err = rows.Scan(&v.ID, &v.BlockNumber, &v.TxIndex, &v.LogIndex, &v.TxHash, &ct, &it, &v.WalletAddress, &v.Kind, &v.Category, &v.TokenAddress, &v.Direction, &v.QuoteAddress, &v.QuoteSymbol, &quoteAmount, &v.QuoteDecimals, &v.TokenAmountRaw, &v.TokenDecimals, &v.ExecQuotePerToken, &v.ExecUSDPerToken, &v.QuoteUSD, &v.Router); err != nil {
			return nil, err
		}
		v.QuoteAmountRaw = quoteAmount.String
		if v.ChainTime, err = time.Parse(time.RFC3339, ct); err != nil {
			return nil, err
		}
		if v.IngestedAt, err = time.Parse(time.RFC3339, it); err != nil {
			return nil, err
		}
		out = append(out, v)
	}
	return out, rows.Err()
}
func nullString(v string) any {
	if v == "" {
		return nil
	}
	return v
}
