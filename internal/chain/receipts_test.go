package chain

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/http/httptest"
	"strings"
	"sync"
	"sync/atomic"
	"testing"
	"time"
)

func TestFallbackReceiptsAreBoundedAndBlockIsComplete(t *testing.T) {
	var active, maximum atomic.Int32
	blockHash := "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	parentHash := "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.UserAgent() != "phase-two-test/1" {
			t.Errorf("User-Agent 错误: %q", r.UserAgent())
		}
		var req rpcRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			t.Error(err)
			return
		}
		switch req.Method {
		case "eth_chainId":
			writeRPCResult(w, req.ID, "0x1237")
		case "eth_getBlockReceipts":
			writeRPCError(w, req.ID, -32601, "method not found")
		case "eth_getBlockByNumber":
			txs := make([]map[string]any, 9)
			for i := range txs {
				txs[i] = map[string]any{
					"hash": fmt.Sprintf("0x%064x", i+1), "from": "0x1111111111111111111111111111111111111111",
					"to": "0x2222222222222222222222222222222222222222", "value": "0x2a",
					"input": "0x1234", "transactionIndex": fmt.Sprintf("0x%x", i),
				}
			}
			writeRPCResult(w, req.ID, map[string]any{"number": "0x10", "hash": blockHash, "parentHash": parentHash, "timestamp": "0x64", "transactions": txs})
		case "eth_getTransactionReceipt":
			now := active.Add(1)
			for {
				old := maximum.Load()
				if now <= old || maximum.CompareAndSwap(old, now) {
					break
				}
			}
			time.Sleep(10 * time.Millisecond)
			active.Add(-1)
			var params []string
			raw, _ := json.Marshal(req.Params)
			_ = json.Unmarshal(raw, &params)
			writeRPCResult(w, req.ID, map[string]any{
				"transactionHash": params[0], "blockHash": blockHash,
				"status": "0x1", "logs": []any{},
			})
		default:
			writeRPCError(w, req.ID, -32601, "unexpected")
		}
	}))
	defer server.Close()

	client, err := NewClient(t.Context(), server.URL, "phase-two-test/1", time.Second, 4663)
	if err != nil {
		t.Fatal(err)
	}
	fetcher := NewReceiptFetcher(client)
	supported, err := fetcher.Probe(t.Context(), 16)
	if err != nil || supported {
		t.Fatalf("应固定回退: supported=%v err=%v", supported, err)
	}
	block, err := fetcher.FetchBlock(t.Context(), 16)
	if err != nil {
		t.Fatal(err)
	}
	if maximum.Load() > 8 {
		t.Fatalf("逐收据并发超过上限: %d", maximum.Load())
	}
	if len(block.Transactions) != 9 || len(block.Receipts) != 9 ||
		block.Transactions[0].From != "0x1111111111111111111111111111111111111111" ||
		block.Transactions[0].To != "0x2222222222222222222222222222222222222222" ||
		block.Transactions[0].Value != "42" || fmt.Sprintf("%x", block.Transactions[0].Input) != "1234" ||
		block.Hash != blockHash || block.ParentHash != parentHash || block.Timestamp != 100 {
		t.Fatalf("区块完整字段错误: %+v", block)
	}
}

func TestBlockReceiptsModeFetchesBlockAndReceiptsConcurrently(t *testing.T) {
	var active, maximum atomic.Int32
	release := make(chan struct{})
	var once sync.Once
	blockHash := "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	parentHash := "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		var req rpcRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			t.Error(err)
			return
		}
		now := active.Add(1)
		for {
			old := maximum.Load()
			if now <= old || maximum.CompareAndSwap(old, now) {
				break
			}
		}
		if now == 2 {
			once.Do(func() { close(release) })
		}
		select {
		case <-release:
		case <-r.Context().Done():
			active.Add(-1)
			return
		}
		active.Add(-1)
		switch req.Method {
		case "eth_getBlockByNumber":
			writeRPCResult(w, req.ID, map[string]any{
				"number": "0x10", "hash": blockHash, "parentHash": parentHash,
				"timestamp": "0x64", "transactions": []any{},
			})
		case "eth_getBlockReceipts":
			writeRPCResult(w, req.ID, []any{})
		default:
			writeRPCError(w, req.ID, -32601, "unexpected")
		}
	}))
	defer server.Close()

	client := &Client{endpoint: server.URL, userAgent: "receipt-test", http: server.Client()}
	fetcher := &ReceiptFetcher{client: client, probed: true, blockMethod: true, batch: false, method: ReceiptMethodEthBlock}
	block, err := fetcher.FetchBlock(t.Context(), 16)
	if err != nil {
		t.Fatal(err)
	}
	if maximum.Load() != 2 || block.Number != 16 {
		t.Fatalf("整块模式未并发读取: maximum=%d block=%+v", maximum.Load(), block)
	}
}

func TestBlockReceiptsModeCancelsOtherRequestOnError(t *testing.T) {
	blockStarted := make(chan struct{})
	blockCanceled := make(chan struct{})
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		var req rpcRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			t.Error(err)
			return
		}
		switch req.Method {
		case "eth_getBlockByNumber":
			close(blockStarted)
			<-r.Context().Done()
			close(blockCanceled)
		case "eth_getBlockReceipts":
			<-blockStarted
			http.Error(w, "temporary", http.StatusServiceUnavailable)
		default:
			writeRPCError(w, req.ID, -32601, "unexpected")
		}
	}))
	defer server.Close()

	client := &Client{endpoint: server.URL, userAgent: "receipt-test", http: server.Client()}
	fetcher := &ReceiptFetcher{client: client, probed: true, blockMethod: true, batch: false, method: ReceiptMethodEthBlock}
	if _, err := fetcher.FetchBlock(t.Context(), 16); err == nil {
		t.Fatal("任一 RPC 失败必须返回错误")
	}
	select {
	case <-blockCanceled:
	case <-time.After(time.Second):
		t.Fatal("收据失败后未取消块详情请求")
	}
}

func TestNewClientRejectsWrongChainID(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		var req rpcRequest
		_ = json.NewDecoder(r.Body).Decode(&req)
		writeRPCResult(w, req.ID, "0x1")
	}))
	defer server.Close()
	if _, err := NewClient(t.Context(), server.URL, "test", time.Second, 4663); err == nil {
		t.Fatal("错误 chainId 必须拒绝启动")
	}
}

func TestNewClientTransportErrorDoesNotExposeRPCSecret(t *testing.T) {
	_, err := NewClient(t.Context(), "http://127.0.0.1:1/rpc?api_key=highly-secret", "test", 50*time.Millisecond, 4663)
	if err == nil {
		t.Fatal("不可达 RPC 必须失败")
	}
	if strings.Contains(err.Error(), "highly-secret") || strings.Contains(err.Error(), "api_key") {
		t.Fatalf("RPC 错误不得暴露完整 URL 或密钥: %v", err)
	}
}

func TestBatchModeUsesOneHTTPForBlockAndReceipts(t *testing.T) {
	var httpCalls atomic.Int32
	blockHash := "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	parentHash := "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		httpCalls.Add(1)
		calls, err := decodeRPCCalls(r)
		if err != nil {
			t.Error(err)
			return
		}
		if len(calls) != 2 {
			t.Errorf("批量条数错误: %d", len(calls))
		}
		replies := make([]map[string]any, len(calls))
		for i, req := range calls {
			switch req.Method {
			case "eth_getBlockByNumber":
				replies[i] = map[string]any{"jsonrpc": "2.0", "id": req.ID, "result": map[string]any{
					"number": "0x10", "hash": blockHash, "parentHash": parentHash,
					"timestamp": "0x64", "transactions": []any{},
				}}
			case "eth_getBlockReceipts":
				replies[i] = map[string]any{"jsonrpc": "2.0", "id": req.ID, "result": []any{}}
			default:
				t.Errorf("意外 RPC: %s", req.Method)
				replies[i] = map[string]any{"jsonrpc": "2.0", "id": req.ID, "error": map[string]any{"code": -32601, "message": req.Method}}
			}
		}
		_ = json.NewEncoder(w).Encode(replies)
	}))
	defer server.Close()

	client := &Client{endpoint: server.URL, userAgent: "receipt-test", http: server.Client()}
	fetcher := NewReceiptFetcherMode(client, ReceiptMethodEthBlock, true)
	fetcher.probed = true
	fetcher.blockMethod = true
	block, err := fetcher.FetchBlock(t.Context(), 16)
	if err != nil {
		t.Fatal(err)
	}
	if httpCalls.Load() != 1 || block.Number != 16 || block.Hash != blockHash {
		t.Fatalf("批量模式应单次 HTTP: calls=%d block=%+v", httpCalls.Load(), block)
	}
}

func TestAlchemyReceiptsWrappedArray(t *testing.T) {
	blockHash := "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	parentHash := "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
	txHash := "0xcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc"
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		calls, err := decodeRPCCalls(r)
		if err != nil {
			t.Error(err)
			return
		}
		if len(calls) == 1 {
			writeRPCResult(w, calls[0].ID, map[string]any{"receipts": []any{}})
			return
		}
		replies := make([]map[string]any, len(calls))
		for i, req := range calls {
			switch req.Method {
			case "eth_getBlockByNumber":
				replies[i] = map[string]any{"jsonrpc": "2.0", "id": req.ID, "result": map[string]any{
					"number": "0x10", "hash": blockHash, "parentHash": parentHash, "timestamp": "0x64",
					"transactions": []any{map[string]any{
						"hash": txHash, "from": "0x1111111111111111111111111111111111111111",
						"to": "0x2222222222222222222222222222222222222222", "value": "0x2a",
						"input": "0x1234", "transactionIndex": "0x0",
					}},
				}}
			case "alchemy_getTransactionReceipts":
				replies[i] = map[string]any{"jsonrpc": "2.0", "id": req.ID, "result": map[string]any{
					"receipts": []any{map[string]any{
						"transactionHash": txHash, "blockHash": blockHash, "status": "0x1",
						"transactionIndex": "0x0", "logs": []any{},
					}},
				}}
			default:
				t.Errorf("意外 RPC: %s", req.Method)
			}
		}
		_ = json.NewEncoder(w).Encode(replies)
	}))
	defer server.Close()

	client := &Client{endpoint: server.URL, userAgent: "receipt-test", http: server.Client()}
	fetcher := NewReceiptFetcherMode(client, ReceiptMethodAlchemy, true)
	ok, err := fetcher.Probe(t.Context(), 16)
	if err != nil || !ok {
		t.Fatalf("alchemy 探测失败: ok=%v err=%v", ok, err)
	}
	block, err := fetcher.FetchBlock(t.Context(), 16)
	if err != nil {
		t.Fatal(err)
	}
	if len(block.Receipts) != 1 || block.Receipts[0].TxHash != txHash || fmt.Sprintf("%x", block.Transactions[0].Input) != "1234" {
		t.Fatalf("alchemy 整块对齐错误: %+v", block)
	}
}

func TestCallBatchFailsOnItemError(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		calls, err := decodeRPCCalls(r)
		if err != nil {
			t.Error(err)
			return
		}
		replies := []map[string]any{
			{"jsonrpc": "2.0", "id": calls[0].ID, "result": "0x1"},
			{"jsonrpc": "2.0", "id": calls[1].ID, "error": map[string]any{"code": 429, "message": "compute units"}},
		}
		_ = json.NewEncoder(w).Encode(replies)
	}))
	defer server.Close()
	client := &Client{endpoint: server.URL, userAgent: "receipt-test", http: server.Client()}
	var head string
	var receipts json.RawMessage
	err := client.CallBatch(t.Context(), []BatchCall{
		{Method: "eth_blockNumber", Params: []any{}},
		{Method: "eth_getBlockReceipts", Params: []any{"0x1"}},
	}, []any{&head, &receipts})
	if err == nil || !strings.Contains(err.Error(), "429") {
		t.Fatalf("批量单项错误应失败: %v", err)
	}
}

func decodeRPCCalls(r *http.Request) ([]rpcRequest, error) {
	raw, err := io.ReadAll(r.Body)
	if err != nil {
		return nil, err
	}
	raw = bytesTrimJSON(json.RawMessage(raw))
	if len(raw) == 0 {
		return nil, fmt.Errorf("空 RPC 体")
	}
	if raw[0] == '[' {
		var reqs []rpcRequest
		if err = json.Unmarshal(raw, &reqs); err != nil {
			return nil, err
		}
		return reqs, nil
	}
	var req rpcRequest
	if err = json.Unmarshal(raw, &req); err != nil {
		return nil, err
	}
	return []rpcRequest{req}, nil
}

func writeRPCResult(w http.ResponseWriter, id uint64, result any) {
	_ = json.NewEncoder(w).Encode(map[string]any{"jsonrpc": "2.0", "id": id, "result": result})
}

func writeRPCError(w http.ResponseWriter, id uint64, code int, message string) {
	_ = json.NewEncoder(w).Encode(map[string]any{"jsonrpc": "2.0", "id": id, "error": map[string]any{"code": code, "message": message}})
}
