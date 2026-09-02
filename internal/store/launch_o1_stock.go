// 本文件仅提供预留 o1 股票明细模型的只读访问。
package store

import (
	"context"
	"database/sql"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

// GetO1StockLaunch 读取预留的 o1 股票模型；本期不提供插入入口。
func (s *Store) GetO1StockLaunch(ctx context.Context, token string) (domain.O1StockLaunch, error) {
	var v domain.O1StockLaunch
	var anomaly int
	var at string
	t, err := domain.NormalizeAddress(token)
	if err != nil {
		return v, err
	}
	err = s.readDB.QueryRowContext(ctx, `SELECT token_address,symbol,name,contract_uri,quote_address,quote_symbol,quote_decimals,pool_id,tick_spacing,hooks,supply,creator_eoa,creator_event,native_launch_fee_wei,anomaly,block_number,tx_hash,log_index,created_at FROM launch_o1_stock WHERE token_address=?`, t).Scan(&v.TokenAddress, &v.Symbol, &v.Name, &v.ContractURI, &v.QuoteAddress, &v.QuoteSymbol, &v.QuoteDecimals, &v.PoolID, &v.TickSpacing, &v.Hooks, &v.Supply, &v.CreatorEOA, &v.CreatorEvent, &v.NativeLaunchFeeWei, &anomaly, &v.BlockNumber, &v.TxHash, &v.LogIndex, &at)
	if err == nil {
		v.Anomaly = anomaly == 1
		v.CreatedAt, err = time.Parse(time.RFC3339, at)
	}
	if err == sql.ErrNoRows {
		return v, err
	}
	return v, err
}
