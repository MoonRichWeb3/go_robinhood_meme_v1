// 本文件实现仅针对 wallet_events 的有界过期清理。
package store

import (
	"context"
	"database/sql"
	"fmt"
	"time"
)

// PurgeResult 汇总一次有界清理的删除量、截止时间和是否触及单轮上限。
type PurgeResult struct {
	Deleted int64
	Cutoff  time.Time
	Limited bool
}

// PurgeExpiredWalletEvents 按 chain_time 分批删除过期交易，每批独立入写队列并在批间让出写锁。
func (s *Store) PurgeExpiredWalletEvents(ctx context.Context, now time.Time, retentionDays, batch, maxPerRun int, sleep time.Duration) (PurgeResult, error) {
	result := PurgeResult{Cutoff: now.UTC().Add(-time.Duration(retentionDays) * 24 * time.Hour)}
	if retentionDays < 1 || batch < 1 || batch > 5000 || maxPerRun < 1 {
		return result, fmt.Errorf("清理参数无效")
	}
	for result.Deleted < int64(maxPerRun) {
		size := batch
		if remain := maxPerRun - int(result.Deleted); size > remain {
			size = remain
		}
		var deleted int64
		var more bool
		err := s.writer.Write(ctx, func(tx *sql.Tx) error {
			res, err := tx.ExecContext(ctx, `DELETE FROM wallet_events WHERE id IN (SELECT id FROM wallet_events WHERE chain_time < ? ORDER BY chain_time ASC,id ASC LIMIT ?)`, result.Cutoff.Format(time.RFC3339), size)
			if err != nil {
				return err
			}
			deleted, err = res.RowsAffected()
			if err != nil {
				return err
			}
			if result.Deleted+deleted >= int64(maxPerRun) {
				var exists int
				if err = tx.QueryRowContext(ctx, `SELECT EXISTS(SELECT 1 FROM wallet_events WHERE chain_time < ? LIMIT 1)`, result.Cutoff.Format(time.RFC3339)).Scan(&exists); err != nil {
					return err
				}
				more = exists == 1
			}
			return nil
		})
		if err != nil {
			return result, err
		}
		result.Deleted += deleted
		if deleted < int64(size) {
			return result, nil
		}
		if result.Deleted >= int64(maxPerRun) {
			result.Limited = more
			return result, nil
		}
		if sleep > 0 {
			select {
			case <-time.After(sleep):
			case <-ctx.Done():
				return result, ctx.Err()
			}
		}
	}
	return result, nil
}
