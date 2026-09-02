// 本文件提供扫描水位的类型化读写。
package store

import (
	"context"
	"database/sql"
	"time"
)

// SyncState 是某条链的持久化扫描水位。
type SyncState struct {
	Name      string
	LastBlock uint64
	LastHash  string
	UpdatedAt time.Time
}

// GetSyncState 查询水位；不存在时返回 sql.ErrNoRows。
func (s *Store) GetSyncState(ctx context.Context, name string) (SyncState, error) {
	var v SyncState
	var at string
	err := s.readDB.QueryRowContext(ctx, `SELECT name,last_block,COALESCE(last_hash,''),updated_at FROM sync_state WHERE name=?`, name).Scan(&v.Name, &v.LastBlock, &v.LastHash, &at)
	if err == nil {
		v.UpdatedAt, err = time.Parse(time.RFC3339, at)
	}
	return v, err
}

// PutSyncState 通过唯一写入口创建或更新扫描水位。
func (s *Store) PutSyncState(ctx context.Context, v SyncState) error {
	return s.writer.Write(ctx, func(tx *sql.Tx) error {
		return putSyncStateTx(ctx, tx, v)
	})
}

// putSyncStateTx 供初始化水位和整块事务复用，调用方负责提交或回滚。
func putSyncStateTx(ctx context.Context, tx *sql.Tx, v SyncState) error {
	_, err := tx.ExecContext(ctx, `INSERT INTO sync_state(name,last_block,last_hash,updated_at) VALUES(?,?,?,?) ON CONFLICT(name) DO UPDATE SET last_block=excluded.last_block,last_hash=excluded.last_hash,updated_at=excluded.updated_at`, v.Name, v.LastBlock, v.LastHash, v.UpdatedAt.UTC().Format(time.RFC3339))
	return err
}

// LoadWatermark 直接满足 chain.WatermarkStore 的基础类型接口，避免 store 反向依赖 chain。
func (s *Store) LoadWatermark(ctx context.Context, name string) (uint64, string, bool, error) {
	v, err := s.GetSyncState(ctx, name)
	if err == sql.ErrNoRows {
		return 0, "", false, nil
	}
	if err != nil {
		return 0, "", false, err
	}
	return v.LastBlock, v.LastHash, true, nil
}

// SaveWatermark 仅由块处理成功或重组事实更新调用。
func (s *Store) SaveWatermark(ctx context.Context, name string, lastBlock uint64, lastHash string, updatedAt time.Time) error {
	return s.PutSyncState(ctx, SyncState{Name: name, LastBlock: lastBlock, LastHash: lastHash, UpdatedAt: updatedAt})
}
