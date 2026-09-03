package chain

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"time"
)

func TestRedactRPCURLHidesAlchemyKey(t *testing.T) {
	got := RedactRPCURL("https://robinhood-mainnet.g.alchemy.com/v2/super-secret-key?api_key=hidden")
	if strings.Contains(got, "super-secret-key") || strings.Contains(got, "hidden") || strings.Contains(got, "api_key") {
		t.Fatalf("密钥未脱敏: %s", got)
	}
	if !strings.Contains(got, "robinhood-mainnet.g.alchemy.com/v2/<redacted>") {
		t.Fatalf("脱敏格式错误: %s", got)
	}
}

func TestWeightedPickFollowsQPS(t *testing.T) {
	ready := []*rpcMember{{label: "alchemy", qps: 10}, {label: "public", qps: 1}}
	counts := map[string]int{}
	for range 110 {
		picked := weightedPick(ready)
		counts[picked.label]++
	}
	if counts["alchemy"] < 90 || counts["public"] < 5 {
		t.Fatalf("加权轮询比例错误: %+v", counts)
	}
}

func TestPoolAcquireRespectsOneQPS(t *testing.T) {
	now := time.Date(2026, 9, 3, 7, 0, 0, 0, time.UTC)
	pool := &rpcPool{
		now: func() time.Time { return now },
		members: []*rpcMember{{
			url: "http://127.0.0.1:1", label: "public", qps: 1, tokens: 1, last: now,
		}},
	}
	if _, err := pool.acquire(t.Context()); err != nil {
		t.Fatal(err)
	}
	wait := pool.members[0].waitDuration(now)
	if wait <= 0 {
		t.Fatalf("1qps 第二次应等待, wait=%s tokens=%v", wait, pool.members[0].tokens)
	}
}

func TestHTTP429ErrorIncludesRPC(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusTooManyRequests)
	}))
	defer server.Close()
	client := &Client{endpoint: server.URL, label: RedactRPCURL(server.URL), userAgent: "pool-test", http: server.Client()}
	err := client.Call(t.Context(), "eth_chainId", []any{}, new(string))
	if err == nil {
		t.Fatal("429 应失败")
	}
	endpoint, ok := AsEndpointError(err)
	if !ok || endpoint.Status != 429 || endpoint.RPC == "" {
		t.Fatalf("429 应带 RPC 标签: %+v %v", endpoint, err)
	}
	fields := rpcFailureFields(err)
	if fields["类型"] != "RPC限流" || fields["RPC"] != endpoint.RPC {
		t.Fatalf("日志字段错误: %+v", fields)
	}
}

func TestNewPoolClientSkipsBadChain(t *testing.T) {
	good := httptest.NewServer(jsonRPCChainID("0x1237"))
	defer good.Close()
	bad := httptest.NewServer(jsonRPCChainID("0x1"))
	defer bad.Close()
	client, err := NewPoolClient(t.Context(), []RPCEndpoint{
		{URL: bad.URL, QPS: 1},
		{URL: good.URL, QPS: 10},
	}, "pool-test", time.Second, 4663)
	if err != nil {
		t.Fatal(err)
	}
	if client.EndpointCount() != 1 || len(client.SkippedEndpoints()) != 1 {
		t.Fatalf("应跳过错误链: count=%d skipped=%d", client.EndpointCount(), len(client.SkippedEndpoints()))
	}
}

func jsonRPCChainID(id string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req rpcRequest
		_ = json.NewDecoder(r.Body).Decode(&req)
		_ = json.NewEncoder(w).Encode(map[string]any{"jsonrpc": "2.0", "id": req.ID, "result": id})
	}
}
