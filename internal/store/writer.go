// 本文件实现进程内唯一、有界、可取消的 SQLite 写队列。
package store

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"sync"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

type writeRequest struct {
	ctx  context.Context
	fn   func(*sql.Tx) error
	done chan error
}

// Writer 把扫块、刷价、评分和清理串行到一个有界队列。
type Writer struct {
	db        *sql.DB
	requests  chan writeRequest
	stopped   chan struct{}
	closeOnce sync.Once
	stateMu   sync.RWMutex
	closed    bool
}

// ErrWriterClosed 是关闭后所有新写请求稳定返回的类型化错误。
var ErrWriterClosed = errors.New("写队列已关闭")

// PonsGraduation 是块事务内的 Pons 毕业补丁。
type PonsGraduation struct {
	Token, PoolID string
	At            time.Time
}

// BlockChanges 汇总一块内全部业务写入，确保不存在半块提交。
type BlockChanges struct {
	Pons        []domain.PonsLaunch
	O1Crypto    []domain.O1CryptoLaunch
	Graduations []PonsGraduation
	Events      []WalletEvent
}

// BlockWriteResult 返回真正插入的发盘、事件、按事件跳过的分类冲突及非致命告警。
type BlockWriteResult struct {
	PonsInserted     []domain.PonsLaunch
	O1CryptoInserted []domain.O1CryptoLaunch
	EventInserted    []WalletEvent
	Conflicts        []LaunchCategoryConflictError
	Warnings         []error
}

// NewWriter 创建并启动单写协程；队列有界，调用方可用 context 控制等待。
func NewWriter(db *sql.DB) *Writer {
	w := &Writer{db: db, requests: make(chan writeRequest, 256), stopped: make(chan struct{})}
	go w.run()
	return w
}

// Write 在独立短事务中执行写函数，成功提交、失败回滚。
func (w *Writer) Write(ctx context.Context, fn func(*sql.Tx) error) error {
	req := writeRequest{ctx: ctx, fn: fn, done: make(chan error, 1)}
	w.stateMu.RLock()
	if w.closed {
		w.stateMu.RUnlock()
		return ErrWriterClosed
	}
	select {
	case w.requests <- req:
	case <-ctx.Done():
		w.stateMu.RUnlock()
		return ctx.Err()
	}
	w.stateMu.RUnlock()
	select {
	case err := <-req.done:
		return err
	case <-ctx.Done():
		return ctx.Err()
	}
}

// Close 停止接收新任务并等待当前队列退出。
func (w *Writer) Close() {
	w.closeOnce.Do(func() {
		w.stateMu.Lock()
		w.closed = true
		close(w.requests)
		w.stateMu.Unlock()
	})
	<-w.stopped
}

func (w *Writer) run() {
	defer close(w.stopped)
	for req := range w.requests {
		if err := req.ctx.Err(); err != nil {
			req.done <- err
			continue
		}
		tx, err := w.db.BeginTx(req.ctx, nil)
		if err == nil {
			err = req.fn(tx)
		}
		if err != nil {
			if tx != nil {
				_ = tx.Rollback()
			}
		} else {
			err = tx.Commit()
		}
		req.done <- err
	}
}

// CommitBlock 通过唯一 writer 原子提交整块业务变化和扫描水位。
func (s *Store) CommitBlock(ctx context.Context, changes BlockChanges, watermark SyncState) (BlockWriteResult, error) {
	var result BlockWriteResult
	err := s.writer.Write(ctx, func(tx *sql.Tx) error {
		conflicts := make(map[string]struct{})
		for _, launch := range changes.Pons {
			inserted, err := insertLaunchIndex(ctx, tx, launch)
			if err != nil {
				var conflict *LaunchCategoryConflictError
				if !errors.As(err, &conflict) {
					return err
				}
				result.Conflicts = append(result.Conflicts, *conflict)
				conflicts[conflict.Token+"\x00"+conflict.Incoming] = struct{}{}
				continue
			}
			if !inserted.Inserted {
				continue
			}
			_, err = tx.ExecContext(ctx, `INSERT INTO launch_pons(token_address,symbol,name,logo,description,curve_address,pair_address,pair_symbol,pair_decimals,launch_config_id,graduation_threshold,deployer,creator_eoa,creator_fee_recipient,launch_entry,first_buy_quote,first_buy_tokens,phase,graduated_at,pool_id,block_number,tx_hash,log_index,created_at) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
				launch.TokenAddress, launch.Symbol, launch.Name, launch.Logo, launch.Description, launch.CurveAddress, launch.PairAddress, launch.PairSymbol, launch.PairDecimals, launch.LaunchConfigID, launch.GraduationThreshold, launch.Deployer, launch.CreatorEOA, nullString(launch.CreatorFeeRecipient), launch.LaunchEntry, launch.FirstBuyQuote, launch.FirstBuyTokens, launch.Phase, launch.GraduatedAt, nullString(launch.PoolID), launch.BlockNumber, launch.TxHash, launch.LogIndex, launch.CreatedAt.UTC().Format(time.RFC3339))
			if err != nil {
				return err
			}
			result.PonsInserted = append(result.PonsInserted, launch)
		}
		for _, launch := range changes.O1Crypto {
			inserted, err := insertLaunchIndex(ctx, tx, launch)
			if err != nil {
				var conflict *LaunchCategoryConflictError
				if !errors.As(err, &conflict) {
					return err
				}
				result.Conflicts = append(result.Conflicts, *conflict)
				conflicts[conflict.Token+"\x00"+conflict.Incoming] = struct{}{}
				continue
			}
			if !inserted.Inserted {
				continue
			}
			_, err = tx.ExecContext(ctx, `INSERT INTO launch_o1_crypto(token_address,symbol,name,contract_uri,quote_address,quote_symbol,quote_decimals,pool_id,tick_spacing,hooks,supply,creator_eoa,creator_event,native_launch_fee_wei,block_number,tx_hash,log_index,created_at) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
				launch.TokenAddress, launch.Symbol, launch.Name, launch.ContractURI, launch.QuoteAddress, launch.QuoteSymbol, launch.QuoteDecimals, launch.PoolID, launch.TickSpacing, launch.Hooks, launch.Supply, launch.CreatorEOA, launch.CreatorEvent, launch.NativeLaunchFeeWei, launch.BlockNumber, launch.TxHash, launch.LogIndex, launch.CreatedAt.UTC().Format(time.RFC3339))
			if err != nil {
				return err
			}
			result.O1CryptoInserted = append(result.O1CryptoInserted, launch)
		}
		for _, graduation := range changes.Graduations {
			if _, err := tx.ExecContext(ctx, `UPDATE launch_pons SET phase='graduated',graduated_at=?,pool_id=? WHERE token_address=?`, graduation.At.UTC().Format(time.RFC3339), graduation.PoolID, graduation.Token); err != nil {
				return err
			}
			if _, err := tx.ExecContext(ctx, `UPDATE launch_index SET status='graduated' WHERE token_address=? AND category='pons'`, graduation.Token); err != nil {
				return err
			}
		}
		for i := range changes.Events {
			event := changes.Events[i]
			if event.Kind == "launch" {
				token, normalizeErr := domain.NormalizeAddress(event.TokenAddress)
				if normalizeErr != nil {
					return normalizeErr
				}
				if _, conflicted := conflicts[token+"\x00"+event.Category]; conflicted {
					continue
				}
			}
			if event.ID == "" {
				id, widthErr := domain.CalcEventID(event.BlockNumber, event.TxIndex, event.LogIndex)
				event.ID = id
				if widthErr != nil {
					result.Warnings = append(result.Warnings, widthErr)
				}
			}
			var err error
			if event.WalletAddress, err = domain.NormalizeAddress(event.WalletAddress); err != nil {
				return err
			}
			if event.TokenAddress, err = domain.NormalizeAddress(event.TokenAddress); err != nil {
				return err
			}
			if event.QuoteAddress != "" {
				if event.QuoteAddress, err = domain.NormalizeAddress(event.QuoteAddress); err != nil {
					return err
				}
			}
			res, err := tx.ExecContext(ctx, `INSERT OR IGNORE INTO wallet_events(id,block_number,tx_index,log_index,tx_hash,chain_time,ingested_at,wallet_address,kind,category,token_address,direction,quote_address,quote_symbol,quote_amount_raw,quote_decimals,token_amount_raw,token_decimals,exec_quote_per_token,exec_usd_per_token,quote_usd,router) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
				event.ID, event.BlockNumber, event.TxIndex, event.LogIndex, event.TxHash, event.ChainTime.UTC().Format(time.RFC3339), event.IngestedAt.UTC().Format(time.RFC3339), event.WalletAddress, event.Kind, event.Category, event.TokenAddress, event.Direction, nullString(event.QuoteAddress), nullString(event.QuoteSymbol), nullString(event.QuoteAmountRaw), event.QuoteDecimals, event.TokenAmountRaw, event.TokenDecimals, event.ExecQuotePerToken, event.ExecUSDPerToken, event.QuoteUSD, event.Router)
			if err != nil {
				return err
			}
			count, err := res.RowsAffected()
			if err != nil {
				return err
			}
			if count == 0 {
				continue
			}
			if _, err = tx.ExecContext(ctx, `UPDATE smart_wallets SET last_seen_at=?,updated_at=? WHERE address=? AND status='active'`, event.IngestedAt.UTC().Format(time.RFC3339), event.IngestedAt.UTC().Format(time.RFC3339), event.WalletAddress); err != nil {
				return err
			}
			result.EventInserted = append(result.EventInserted, event)
		}
		return putSyncStateTx(ctx, tx, watermark)
	})
	if err != nil {
		return BlockWriteResult{}, fmt.Errorf("提交整块业务事务: %w", err)
	}
	return result, nil
}
