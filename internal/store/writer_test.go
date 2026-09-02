package store

import (
	"context"
	"database/sql"
	"errors"
	"sync"
	"testing"
	"time"

	_ "modernc.org/sqlite"
)

func TestWriterConcurrentCloseDrainsWaiters(t *testing.T) {
	db, err := sql.Open("sqlite", "file:writer-close?mode=memory&cache=shared")
	if err != nil {
		t.Fatal(err)
	}
	defer db.Close()
	db.SetMaxOpenConns(1)
	writer := NewWriter(db)

	blocked, release := make(chan struct{}), make(chan struct{})
	first := make(chan error, 1)
	go func() {
		first <- writer.Write(context.Background(), func(*sql.Tx) error {
			close(blocked)
			<-release
			return nil
		})
	}()
	<-blocked

	const requests = 64
	results := make(chan error, requests)
	var started sync.WaitGroup
	started.Add(requests)
	for i := 0; i < requests; i++ {
		go func() {
			started.Done()
			results <- writer.Write(context.Background(), func(*sql.Tx) error { return nil })
		}()
	}
	started.Wait()

	const closers = 16
	var closed sync.WaitGroup
	closed.Add(closers)
	for i := 0; i < closers; i++ {
		go func() {
			defer closed.Done()
			writer.Close()
		}()
	}
	close(release)

	waitGroup(t, &closed, "并发 Close")
	if err = receiveError(t, first, "首个写请求"); err != nil {
		t.Fatal(err)
	}
	for i := 0; i < requests; i++ {
		err = receiveError(t, results, "排队写请求")
		if err != nil && !errors.Is(err, ErrWriterClosed) {
			t.Fatalf("排队请求返回非稳定错误: %v", err)
		}
	}
	for i := 0; i < 10; i++ {
		if err = writer.Write(context.Background(), func(*sql.Tx) error { return nil }); !errors.Is(err, ErrWriterClosed) {
			t.Fatalf("关闭后第 %d 次写入错误=%v", i, err)
		}
	}
}

func waitGroup(t *testing.T, group *sync.WaitGroup, name string) {
	t.Helper()
	done := make(chan struct{})
	go func() {
		group.Wait()
		close(done)
	}()
	select {
	case <-done:
	case <-time.After(3 * time.Second):
		t.Fatalf("%s 超时，存在遗留等待者", name)
	}
}

func receiveError(t *testing.T, result <-chan error, name string) error {
	t.Helper()
	select {
	case err := <-result:
		return err
	case <-time.After(3 * time.Second):
		t.Fatalf("%s 超时，存在遗留等待者", name)
		return nil
	}
}
