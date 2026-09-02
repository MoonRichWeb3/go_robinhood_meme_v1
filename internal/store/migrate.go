// 本文件执行带校验和保护的线性 SQL 迁移。
package store

import (
	"context"
	"crypto/sha256"
	"database/sql"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"time"
)

// Migrate 按文件名顺序执行未应用的 SQL，并拒绝已执行文件被修改。
func (s *Store) Migrate(ctx context.Context, dir string) error {
	entries, err := os.ReadDir(dir)
	if err != nil {
		return fmt.Errorf("读取迁移目录: %w", err)
	}
	files := make([]string, 0)
	for _, e := range entries {
		if !e.IsDir() && strings.HasSuffix(e.Name(), ".sql") {
			files = append(files, e.Name())
		}
	}
	sort.Strings(files)
	return s.writer.Write(ctx, func(tx *sql.Tx) error {
		if _, err := tx.ExecContext(ctx, `CREATE TABLE IF NOT EXISTS schema_migrations(name TEXT PRIMARY KEY, checksum TEXT NOT NULL, applied_at TEXT NOT NULL)`); err != nil {
			return err
		}
		for _, name := range files {
			body, err := os.ReadFile(filepath.Join(dir, name))
			if err != nil {
				return err
			}
			sum := fmt.Sprintf("%x", sha256.Sum256(body))
			var existing string
			err = tx.QueryRowContext(ctx, `SELECT checksum FROM schema_migrations WHERE name=?`, name).Scan(&existing)
			if err == nil {
				if existing != sum {
					return fmt.Errorf("已执行迁移 %s 被修改", name)
				}
				continue
			}
			if err != sql.ErrNoRows {
				return err
			}
			if _, err = tx.ExecContext(ctx, string(body)); err != nil {
				return fmt.Errorf("执行迁移 %s: %w", name, err)
			}
			if _, err = tx.ExecContext(ctx, `INSERT INTO schema_migrations(name,checksum,applied_at) VALUES(?,?,?)`, name, sum, time.Now().UTC().Format(time.RFC3339)); err != nil {
				return err
			}
		}
		return nil
	})
}
