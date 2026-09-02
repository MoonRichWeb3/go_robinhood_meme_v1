package chain

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"net/http/httptest"
	"sync"
	"sync/atomic"
	"testing"
	"time"
)

type watermarkStoreFake struct {
	block, saves    uint64
	hash, savedHash string
	savedBlock      uint64
}

func (s *watermarkStoreFake) LoadWatermark(context.Context, string) (uint64, string, bool, error) {
	return s.block, s.hash, true, nil
}

func (s *watermarkStoreFake) SaveWatermark(_ context.Context, _ string, block uint64, hash string, _ time.Time) error {
	s.saves++
	s.savedBlock = block
	s.savedHash = hash
	return nil
}

func TestPollOnceDelegatesAtomicWatermarkCommit(t *testing.T) {
	parent := "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	hash := "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		var request rpcRequest
		if err := json.NewDecoder(r.Body).Decode(&request); err != nil {
			t.Error(err)
			return
		}
		var result any
		switch request.Method {
		case "eth_blockNumber":
			result = "0x1"
		case "eth_getBlockByNumber":
			result = map[string]any{
				"number": "0x1", "hash": hash, "parentHash": parent,
				"timestamp": "0x1", "transactions": []any{},
			}
		case "eth_getBlockReceipts":
			result = []any{}
		default:
			t.Errorf("意外 RPC: %s", request.Method)
			result = nil
		}
		_ = json.NewEncoder(w).Encode(map[string]any{"jsonrpc": "2.0", "id": request.ID, "result": result})
	}))
	defer server.Close()

	client := &Client{endpoint: server.URL, userAgent: "poller-test", http: server.Client()}
	state := &watermarkStoreFake{block: 0, hash: parent}
	var committed Watermark
	poller := &Poller{
		client: client, receipts: &ReceiptFetcher{client: client, probed: true, blockMethod: true},
		state: state,
		process: func(_ context.Context, block BlockBatch, watermark Watermark) error {
			if block.Number != 1 {
				t.Fatalf("处理块高=%d", block.Number)
			}
			committed = watermark
			return nil
		},
		config: PollerConfig{MaxBlocksPerTick: 1, PollInterval: time.Second},
	}
	processed, err := poller.PollOnce(t.Context())
	if err != nil || processed != 1 {
		t.Fatalf("PollOnce=%d err=%v", processed, err)
	}
	if committed.LastBlock != 1 || committed.LastHash != hash {
		t.Fatalf("未把目标水位交给块处理器: %+v", committed)
	}
	if state.saves != 0 {
		t.Fatalf("处理成功后 Poller 不得另写水位，实际=%d", state.saves)
	}
}

func TestPollOncePrefetchesBoundedAndProcessesInOrder(t *testing.T) {
	client, closeServer := newPollerHeadClient(t, 12, nil)
	defer closeServer()
	state := &watermarkStoreFake{block: 0, hash: testBlockHash(0)}
	var active, maximum atomic.Int32
	release := make(chan struct{})
	var once sync.Once
	var processed []uint64
	poller := &Poller{
		client: client, state: state,
		fetch: func(ctx context.Context, number uint64) (BlockBatch, error) {
			now := active.Add(1)
			for {
				old := maximum.Load()
				if now <= old || maximum.CompareAndSwap(old, now) {
					break
				}
			}
			if now == maxBlockPrefetchConcurrency {
				once.Do(func() { close(release) })
			}
			select {
			case <-release:
			case <-ctx.Done():
				active.Add(-1)
				return BlockBatch{}, ctx.Err()
			}
			time.Sleep(time.Duration(12-number) * time.Millisecond)
			active.Add(-1)
			return testBlock(number), nil
		},
		process: func(_ context.Context, block BlockBatch, _ Watermark) error {
			processed = append(processed, block.Number)
			return nil
		},
		config: PollerConfig{MaxBlocksPerTick: 12, PollInterval: time.Second},
	}

	count, err := poller.PollOnce(t.Context())
	if err != nil || count != 12 {
		t.Fatalf("PollOnce=%d err=%v", count, err)
	}
	if maximum.Load() != maxBlockPrefetchConcurrency {
		t.Fatalf("预取并发=%d，期望=%d", maximum.Load(), maxBlockPrefetchConcurrency)
	}
	for i, number := range processed {
		if number != uint64(i+1) {
			t.Fatalf("处理顺序=%v", processed)
		}
	}
}

func TestPollOnceProcessFailureDoesNotProcessLaterBlocks(t *testing.T) {
	client, closeServer := newPollerHeadClient(t, 6, nil)
	defer closeServer()
	wantErr := errors.New("第三块提交失败")
	var processed []uint64
	var canceled atomic.Int32
	poller := &Poller{
		client: client, state: &watermarkStoreFake{block: 0, hash: testBlockHash(0)},
		fetch: func(ctx context.Context, number uint64) (BlockBatch, error) {
			if number > 3 {
				<-ctx.Done()
				canceled.Add(1)
				return BlockBatch{}, ctx.Err()
			}
			return testBlock(number), nil
		},
		process: func(_ context.Context, block BlockBatch, _ Watermark) error {
			processed = append(processed, block.Number)
			if block.Number == 3 {
				return wantErr
			}
			return nil
		},
		config: PollerConfig{MaxBlocksPerTick: 6, PollInterval: time.Second},
	}

	count, err := poller.PollOnce(t.Context())
	if !errors.Is(err, wantErr) || count != 2 {
		t.Fatalf("PollOnce=%d err=%v", count, err)
	}
	if fmt.Sprint(processed) != "[1 2 3]" {
		t.Fatalf("中间块失败后仍处理了后块: %v", processed)
	}
	if canceled.Load() == 0 {
		t.Fatal("中间块失败后未取消后续预取")
	}
}

func TestPollOnceFetchFailureDoesNotProcessLaterBlocks(t *testing.T) {
	client, closeServer := newPollerHeadClient(t, 5, nil)
	defer closeServer()
	wantErr := errors.New("第三块读取失败")
	var processed []uint64
	poller := &Poller{
		client: client, state: &watermarkStoreFake{block: 0, hash: testBlockHash(0)},
		fetch: func(_ context.Context, number uint64) (BlockBatch, error) {
			if number == 3 {
				return BlockBatch{}, wantErr
			}
			return testBlock(number), nil
		},
		process: func(_ context.Context, block BlockBatch, _ Watermark) error {
			processed = append(processed, block.Number)
			return nil
		},
		config: PollerConfig{MaxBlocksPerTick: 5, PollInterval: time.Second},
	}

	count, err := poller.PollOnce(t.Context())
	if !errors.Is(err, wantErr) || count != 2 {
		t.Fatalf("PollOnce=%d err=%v", count, err)
	}
	if fmt.Sprint(processed) != "[1 2]" {
		t.Fatalf("读取失败后仍处理了后块: %v", processed)
	}
}

func TestPollOnceReorgStillUpdatesCanonicalParentBeforeCommit(t *testing.T) {
	oldHash := testBlockHash(50)
	newHash := testBlockHash(5)
	client, closeServer := newPollerHeadClient(t, 6, func(w http.ResponseWriter, req rpcRequest) bool {
		if req.Method != "eth_getBlockByNumber" {
			return false
		}
		writeRPCResult(w, req.ID, map[string]any{"number": "0x5", "hash": newHash, "parentHash": testBlockHash(4), "timestamp": "0x1", "transactions": []any{}})
		return true
	})
	defer closeServer()
	state := &watermarkStoreFake{block: 5, hash: oldHash}
	var processed uint64
	poller := &Poller{
		client: client, state: state,
		fetch: func(context.Context, uint64) (BlockBatch, error) {
			block := testBlock(6)
			block.ParentHash = newHash
			return block, nil
		},
		process: func(_ context.Context, block BlockBatch, _ Watermark) error {
			processed = block.Number
			return nil
		},
		config: PollerConfig{MaxBlocksPerTick: 1, PollInterval: time.Second},
	}

	count, err := poller.PollOnce(t.Context())
	if err != nil || count != 1 {
		t.Fatalf("PollOnce=%d err=%v", count, err)
	}
	if state.saves != 1 || state.savedBlock != 5 || state.savedHash != newHash || processed != 6 {
		t.Fatalf("重组处理退化: state=%+v processed=%d", state, processed)
	}
}

func TestPollOnceContextCancellationStopsPrefetch(t *testing.T) {
	client, closeServer := newPollerHeadClient(t, 4, nil)
	defer closeServer()
	started := make(chan struct{})
	var once sync.Once
	poller := &Poller{
		client: client, state: &watermarkStoreFake{block: 0, hash: testBlockHash(0)},
		fetch: func(ctx context.Context, _ uint64) (BlockBatch, error) {
			once.Do(func() { close(started) })
			<-ctx.Done()
			return BlockBatch{}, ctx.Err()
		},
		process: func(context.Context, BlockBatch, Watermark) error { return nil },
		config:  PollerConfig{MaxBlocksPerTick: 4, PollInterval: time.Second},
	}
	ctx, cancel := context.WithCancel(t.Context())
	done := make(chan error, 1)
	go func() {
		_, err := poller.PollOnce(ctx)
		done <- err
	}()
	<-started
	cancel()
	select {
	case err := <-done:
		if !errors.Is(err, context.Canceled) {
			t.Fatalf("取消错误=%v", err)
		}
	case <-time.After(time.Second):
		t.Fatal("context 取消后 PollOnce 未退出")
	}
}

func newPollerHeadClient(t *testing.T, head uint64, handle func(http.ResponseWriter, rpcRequest) bool) (*Client, func()) {
	t.Helper()
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		var req rpcRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			t.Error(err)
			return
		}
		if handle != nil && handle(w, req) {
			return
		}
		if req.Method != "eth_blockNumber" {
			t.Errorf("意外 RPC: %s", req.Method)
			writeRPCResult(w, req.ID, nil)
			return
		}
		writeRPCResult(w, req.ID, fmt.Sprintf("0x%x", head))
	}))
	return &Client{endpoint: server.URL, userAgent: "poller-test", http: server.Client()}, server.Close
}

func testBlock(number uint64) BlockBatch {
	return BlockBatch{Number: number, Hash: testBlockHash(number), ParentHash: testBlockHash(number - 1)}
}

func testBlockHash(number uint64) string {
	return fmt.Sprintf("0x%064x", number+1)
}
