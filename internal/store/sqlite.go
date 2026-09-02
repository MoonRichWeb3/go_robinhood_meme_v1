// Package store 提供 SQLite 迁移、唯一写队列、按表 CRUD 与有界查询。
package store

import (
	"context"
	"database/sql"
	"fmt"
	"os"
	"path/filepath"

	_ "modernc.org/sqlite"
)

// Store 持有唯一写连接、串行写入口和隔离的只读连接。
type Store struct {
	writeDB, readDB *sql.DB
	writer          *Writer
}

// Open 打开 SQLite，启用 WAL、外键和忙等待，并创建唯一写队列。
func Open(ctx context.Context, path string) (*Store, error) {
	if err := ensureParent(path); err != nil {
		return nil, err
	}
	dsn := "file:" + filepath.ToSlash(path)
	w, err := sql.Open("sqlite", dsn+"?_pragma=busy_timeout(5000)&_pragma=foreign_keys(1)&_pragma=journal_mode(WAL)")
	if err != nil {
		return nil, fmt.Errorf("打开写库: %w", err)
	}
	w.SetMaxOpenConns(1)
	if err = w.PingContext(ctx); err != nil {
		w.Close()
		return nil, fmt.Errorf("连接写库: %w", err)
	}
	r, err := sql.Open("sqlite", dsn+"?mode=ro&_pragma=busy_timeout(5000)&_pragma=query_only(1)")
	if err != nil {
		w.Close()
		return nil, fmt.Errorf("打开只读库: %w", err)
	}
	r.SetMaxOpenConns(1)
	if err = r.PingContext(ctx); err != nil {
		w.Close()
		r.Close()
		return nil, fmt.Errorf("连接只读库: %w", err)
	}
	s := &Store{writeDB: w, readDB: r}
	s.writer = NewWriter(w)
	return s, nil
}

// Reader 返回仅供查询使用的数据库句柄。
func (s *Store) Reader() *sql.DB { return s.readDB }

// Writer 返回进程内唯一串行写入口。
func (s *Store) Writer() *Writer { return s.writer }

// Close 停止写队列并关闭读写连接。
func (s *Store) Close() error {
	s.writer.Close()
	rerr := s.readDB.Close()
	werr := s.writeDB.Close()
	if werr != nil {
		return werr
	}
	return rerr
}

func ensureParent(path string) error {
	if path == ":memory:" || path == "" {
		return nil
	}
	dir := filepath.Dir(path)
	if dir == "." {
		return nil
	}
	if err := os.MkdirAll(dir, 0o750); err != nil {
		return fmt.Errorf("创建数据库目录: %w", err)
	}
	return nil
}
