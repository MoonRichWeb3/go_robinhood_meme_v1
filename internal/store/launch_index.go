// 本文件提供统一发盘目录的事务写入、价格更新与分页查询。
package store

import (
	"context"
	"database/sql"
	"fmt"
	"math"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

// InsertLaunchResult 描述新盘事务是新插入、幂等跳过还是分类冲突。
type InsertLaunchResult struct{ Inserted bool }

// LaunchCategoryConflictError 表示同一 token 已被登记到另一分类；调用方应按创建事件跳过。
type LaunchCategoryConflictError struct {
	Token, Existing, Incoming string
}

func (e *LaunchCategoryConflictError) Error() string {
	return fmt.Sprintf("代币 %s 分类冲突: 已有=%s 新增=%s", e.Token, e.Existing, e.Incoming)
}

// Signal 是三类现算项目信号的统一只读模型。
type Signal struct {
	Kind, Token, Wallet, Category, Reason string
}

func insertLaunchIndex(ctx context.Context, tx *sql.Tx, v domain.LaunchIndexView) (InsertLaunchResult, error) {
	token, err := domain.NormalizeAddress(v.IndexToken())
	if err != nil {
		return InsertLaunchResult{}, err
	}
	var existing string
	err = tx.QueryRowContext(ctx, `SELECT category FROM launch_index WHERE token_address=?`, token).Scan(&existing)
	if err == nil {
		if existing != v.IndexCategory() {
			return InsertLaunchResult{}, &LaunchCategoryConflictError{
				Token: token, Existing: existing, Incoming: v.IndexCategory(),
			}
		}
		return InsertLaunchResult{}, nil
	}
	if err != sql.ErrNoRows {
		return InsertLaunchResult{}, err
	}
	pair, pairSymbol := v.IndexPair()
	if pair != "" {
		pair, err = domain.NormalizeAddress(pair)
		if err != nil {
			return InsertLaunchResult{}, err
		}
	}
	eoa, contract := v.IndexCreators()
	eoa, err = domain.NormalizeAddress(eoa)
	if err != nil {
		return InsertLaunchResult{}, err
	}
	if contract != "" {
		contract, err = domain.NormalizeAddress(contract)
		if err != nil {
			return InsertLaunchResult{}, err
		}
	}
	at, block, hash := v.IndexCreated()
	_, err = tx.ExecContext(ctx, `INSERT INTO launch_index(token_address,category,symbol,name,pair_symbol,pair_address,creator_eoa,creator_contract,created_at,block_number,tx_hash,status) VALUES(?,?,?,?,?,?,?,?,?,?,?,'active')`, token, v.IndexCategory(), v.IndexSymbol(), v.IndexName(), pairSymbol, nullString(pair), eoa, nullString(contract), at.UTC().Format(time.RFC3339), block, hash)
	return InsertLaunchResult{Inserted: err == nil}, err
}

// CheckLaunchCategory 在创建事件产生副作用前检查已有分类；不存在或相同分类均可继续。
func (s *Store) CheckLaunchCategory(ctx context.Context, token, incoming string) error {
	token, err := domain.NormalizeAddress(token)
	if err != nil {
		return err
	}
	var existing string
	err = s.readDB.QueryRowContext(ctx, `SELECT category FROM launch_index WHERE token_address=?`, token).Scan(&existing)
	if err == sql.ErrNoRows {
		return nil
	}
	if err != nil {
		return err
	}
	if existing != incoming {
		return &LaunchCategoryConflictError{Token: token, Existing: existing, Incoming: incoming}
	}
	return nil
}

// GetLaunchIndex 按代币地址读取目录行，供展示价刷新和只读服务复用。
func (s *Store) GetLaunchIndex(ctx context.Context, token string) (domain.LaunchIndex, error) {
	var v domain.LaunchIndex
	var created string
	var priceAt sql.NullString
	var priceBlock sql.NullInt64
	t, err := domain.NormalizeAddress(token)
	if err != nil {
		return v, err
	}
	err = s.readDB.QueryRowContext(ctx, `SELECT token_address,category,symbol,name,pair_symbol,COALESCE(pair_address,''),creator_eoa,COALESCE(creator_contract,''),created_at,block_number,tx_hash,status,price_usd,price_block,COALESCE(price_tx,''),price_at FROM launch_index WHERE token_address=?`, t).
		Scan(&v.TokenAddress, &v.Category, &v.Symbol, &v.Name, &v.PairSymbol, &v.PairAddress, &v.CreatorEOA, &v.CreatorContract, &created, &v.BlockNumber, &v.TxHash, &v.Status, &v.PriceUSD, &priceBlock, &v.PriceTx, &priceAt)
	if err != nil {
		return v, err
	}
	if v.CreatedAt, err = time.Parse(time.RFC3339, created); err != nil {
		return v, err
	}
	if priceBlock.Valid && priceBlock.Int64 >= 0 {
		v.PriceBlock = uint64(priceBlock.Int64)
	}
	if priceAt.Valid {
		v.PriceAt, err = time.Parse(time.RFC3339, priceAt.String)
	}
	return v, err
}

// ListLaunches 按创建时间和地址倒序有界查询目录。
func (s *Store) ListLaunches(ctx context.Context, category, cursorTime, cursorToken string, limit int) ([]domain.LaunchIndex, error) {
	if limit < 1 || limit > 200 {
		return nil, domainError("新盘 limit 必须在 1..200")
	}
	q := `SELECT token_address,category,symbol,name,pair_symbol,COALESCE(pair_address,''),creator_eoa,COALESCE(creator_contract,''),created_at,block_number,tx_hash,status,price_usd,price_block,COALESCE(price_tx,''),price_at FROM launch_index WHERE 1=1`
	args := []any{}
	if category != "" {
		q += ` AND category=?`
		args = append(args, category)
	}
	if cursorTime != "" {
		t, err := domain.NormalizeAddress(cursorToken)
		if err != nil {
			return nil, err
		}
		q += ` AND (created_at<? OR (created_at=? AND token_address<?))`
		args = append(args, cursorTime, cursorTime, t)
	}
	q += ` ORDER BY created_at DESC,token_address DESC LIMIT ?`
	args = append(args, limit)
	rows, err := s.readDB.QueryContext(ctx, q, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := make([]domain.LaunchIndex, 0)
	for rows.Next() {
		var v domain.LaunchIndex
		var ca string
		var pa sql.NullString
		var pb sql.NullInt64
		if err = rows.Scan(&v.TokenAddress, &v.Category, &v.Symbol, &v.Name, &v.PairSymbol, &v.PairAddress, &v.CreatorEOA, &v.CreatorContract, &ca, &v.BlockNumber, &v.TxHash, &v.Status, &v.PriceUSD, &pb, &v.PriceTx, &pa); err != nil {
			return nil, err
		}
		if v.CreatedAt, err = time.Parse(time.RFC3339, ca); err != nil {
			return nil, err
		}
		if pb.Valid && pb.Int64 >= 0 {
			v.PriceBlock = uint64(pb.Int64)
		}
		if pa.Valid {
			if v.PriceAt, err = time.Parse(time.RFC3339, pa.String); err != nil {
				return nil, err
			}
		}
		out = append(out, v)
	}
	return out, rows.Err()
}

// UpdateLaunchPrice 仅更新目录展示价；未知价应由调用方跳过。
func (s *Store) UpdateLaunchPrice(ctx context.Context, token string, price float64, block uint64, txHash string, at time.Time) error {
	if price <= 0 || math.IsNaN(price) || math.IsInf(price, 0) {
		return domainError("展示价格必须是有限正数")
	}
	t, err := domain.NormalizeAddress(token)
	if err != nil {
		return err
	}
	return s.writer.Write(ctx, func(tx *sql.Tx) error {
		_, err := tx.ExecContext(ctx, `UPDATE launch_index SET price_usd=?,price_block=?,price_tx=?,price_at=? WHERE token_address=?`, price, block, txHash, at.UTC().Format(time.RFC3339), t)
		return err
	})
}

// LoadRegistrations 从本期已落地的 Pons 与 o1 加密表重建曲线、池登记。
func (s *Store) LoadRegistrations(ctx context.Context) ([]domain.PoolRegistration, []domain.CurveRegistration, error) {
	curveRows, err := s.readDB.QueryContext(ctx, `SELECT curve_address,token_address,pair_address,pair_decimals FROM launch_pons`)
	if err != nil {
		return nil, nil, err
	}
	var curves []domain.CurveRegistration
	for curveRows.Next() {
		var v domain.CurveRegistration
		if err = curveRows.Scan(&v.Curve, &v.Token, &v.Quote, &v.QuoteDecimals); err != nil {
			curveRows.Close()
			return nil, nil, err
		}
		curves = append(curves, v)
	}
	if err = curveRows.Close(); err != nil {
		return nil, nil, err
	}

	poolRows, err := s.readDB.QueryContext(ctx, `
		SELECT pool_id,token_address,'pons',pair_address,pair_decimals FROM launch_pons WHERE pool_id IS NOT NULL
		UNION ALL
		SELECT pool_id,token_address,'o1_crypto',quote_address,quote_decimals FROM launch_o1_crypto`)
	if err != nil {
		return nil, nil, err
	}
	defer poolRows.Close()
	var pools []domain.PoolRegistration
	for poolRows.Next() {
		var v domain.PoolRegistration
		if err = poolRows.Scan(&v.PoolID, &v.Token, &v.Category, &v.Quote, &v.QuoteDecimals); err != nil {
			return nil, nil, err
		}
		pools = append(pools, v)
	}
	return pools, curves, poolRows.Err()
}

// ListSignals 使用现有表有界现算三类信号，不创建或写入信号表。
func (s *Store) ListSignals(ctx context.Context, kind string, limit int, now time.Time) ([]Signal, error) {
	if limit < 1 || limit > 200 {
		return nil, domainError("信号 limit 必须在 1..200")
	}
	var query string
	var args []any
	switch kind {
	case "smart_launch":
		query = `SELECT DISTINCT 'smart_launch',li.token_address,sw.address,li.category,'B级以上聪明钱所发'
			FROM launch_index li JOIN smart_wallets sw
			ON sw.address=li.creator_eoa OR sw.address=li.creator_contract
			WHERE sw.level IN ('S','A','B')
			ORDER BY li.created_at DESC,li.token_address DESC LIMIT ?`
		args = []any{limit}
	case "cluster_buy":
		query = `SELECT 'cluster_buy',li.token_address,'',li.category,'开盘一小时内至少两个聪明钱买入'
			FROM launch_index li JOIN wallet_events we ON we.token_address=li.token_address
			WHERE we.kind='buy' AND we.chain_time>=li.created_at
			AND we.chain_time<=strftime('%Y-%m-%dT%H:%M:%SZ',li.created_at,'+1 hour')
			GROUP BY li.token_address HAVING COUNT(DISTINCT we.wallet_address)>=2
			ORDER BY li.created_at DESC,li.token_address DESC LIMIT ?`
		args = []any{limit}
	case "score_launch":
		query = `SELECT DISTINCT 'score_launch',we.token_address,sw.address,we.category,'高分钱包近7日新发盘'
			FROM wallet_events we JOIN smart_wallets sw ON sw.address=we.wallet_address
			WHERE we.kind='launch' AND we.chain_time>=? AND sw.score>=50 AND sw.score_sample_n>=8
			ORDER BY we.chain_time DESC,we.id DESC LIMIT ?`
		args = []any{now.UTC().Add(-7 * 24 * time.Hour).Format(time.RFC3339), limit}
	default:
		return nil, domainError("信号 kind 无效")
	}
	rows, err := s.readDB.QueryContext(ctx, query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := make([]Signal, 0)
	for rows.Next() {
		var signal Signal
		if err = rows.Scan(&signal.Kind, &signal.Token, &signal.Wallet, &signal.Category, &signal.Reason); err != nil {
			return nil, err
		}
		out = append(out, signal)
	}
	return out, rows.Err()
}
