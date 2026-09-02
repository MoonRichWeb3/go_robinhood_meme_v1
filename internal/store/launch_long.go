// 本文件仅提供预留 Long 明细模型的只读访问。
package store

import (
	"context"
	"database/sql"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

// GetLongLaunch 读取预留的 Long 模型；本期不提供插入入口。
func (s *Store) GetLongLaunch(ctx context.Context, token string) (domain.LongLaunch, error) {
	var v domain.LongLaunch
	var deployed, reserved sql.NullString
	var at string
	t, err := domain.NormalizeAddress(token)
	if err != nil {
		return v, err
	}
	err = s.readDB.QueryRowContext(ctx, `SELECT token_address,symbol,name,quote_address,quote_symbol,quote_decimals,pool_id,fee,tick_spacing,hooks,ticker_key,deployed_at,reserved_until,pool_initializer,launcher,creator_eoa,COALESCE(integrator,''),airlock,COALESCE(initial_supply,''),COALESCE(num_tokens_to_sell,''),block_number,tx_hash,log_index,created_at FROM launch_long WHERE token_address=?`, t).Scan(&v.TokenAddress, &v.Symbol, &v.Name, &v.QuoteAddress, &v.QuoteSymbol, &v.QuoteDecimals, &v.PoolID, &v.Fee, &v.TickSpacing, &v.Hooks, &v.TickerKey, &deployed, &reserved, &v.PoolInitializer, &v.Launcher, &v.CreatorEOA, &v.Integrator, &v.Airlock, &v.InitialSupply, &v.NumTokensToSell, &v.BlockNumber, &v.TxHash, &v.LogIndex, &at)
	if err == nil {
		if deployed.Valid {
			x, e := time.Parse(time.RFC3339, deployed.String)
			if e != nil {
				return v, e
			}
			v.DeployedAt = &x
		}
		if reserved.Valid {
			x, e := time.Parse(time.RFC3339, reserved.String)
			if e != nil {
				return v, e
			}
			v.ReservedUntil = &x
		}
		v.CreatedAt, err = time.Parse(time.RFC3339, at)
	}
	return v, err
}
