package config

import (
	"os"
	"path/filepath"
	"testing"
)

func TestParseRPCFileArray(t *testing.T) {
	t.Setenv("RH_ALCHEMY_RPC_URL", "https://robinhood-mainnet.g.alchemy.com/v2/test-key-value")
	raw := []byte(`[
		{"rpc":"${RH_ALCHEMY_RPC_URL}","qps":10},
		{"rpc":"https://rpc.mainnet.chain.robinhood.com","qps":1},
		{"rpc":"${RH_MISSING_RPC}","qps":1}
	]`)
	got, lag, err := parseRPCFile(raw)
	if err != nil {
		t.Fatal(err)
	}
	if lag != nil {
		t.Fatalf("数组格式不应带 skip_history_lag: %v", *lag)
	}
	if len(got) != 2 || got[0].QPS != 10 || got[1].QPS != 1 {
		t.Fatalf("解析结果错误: %+v", got)
	}
	if got[0].URL != "https://robinhood-mainnet.g.alchemy.com/v2/test-key-value" {
		t.Fatalf("Alchemy 未展开: %s", got[0].URL)
	}
}

func TestParseRPCFileObjectSkipHistoryLag(t *testing.T) {
	raw := []byte(`{"skip_history_lag":80,"rpcs":[{"rpc":"https://rpc.example/a","qps":1}]}`)
	got, lag, err := parseRPCFile(raw)
	if err != nil || len(got) != 1 || lag == nil || *lag != 80 {
		t.Fatalf("对象格式解析错误: %v %+v %v", err, got, lag)
	}
}

func TestLoadRPCEndpointsFile(t *testing.T) {
	dir := t.TempDir()
	path := filepath.Join(dir, "rpcs.json")
	body := `{"skip_history_lag":100,"rpcs":[{"rpc":"https://rpc.example/a","qps":10},{"rpc":"https://rpc.example/b","qps":1}]}`
	if err := os.WriteFile(path, []byte(body), 0o644); err != nil {
		t.Fatal(err)
	}
	got, err := loadRPCEndpoints("", path)
	if err != nil || got.Path != path || len(got.Endpoints) != 2 || got.Endpoints[0].QPS != 10 || got.SkipHistoryLag != 100 {
		t.Fatalf("加载 JSON 失败: %v %+v", err, got)
	}
}

func TestLoadRPCEndpointsRejectsBadQPS(t *testing.T) {
	if _, _, err := parseRPCFile([]byte(`[{"rpc":"https://rpc.example","qps":0}]`)); err == nil {
		t.Fatal("qps=0 应失败")
	}
}

func TestLoadRPCEndpointsFallback(t *testing.T) {
	got, err := loadRPCEndpoints("https://rpc.example/fallback", filepath.Join(t.TempDir(), "missing.json"))
	if err != nil || len(got.Endpoints) != 1 || got.Endpoints[0].QPS != 1 || got.Endpoints[0].URL != "https://rpc.example/fallback" || got.SkipHistoryLag != 100 {
		t.Fatalf("回退失败: %v %+v", err, got)
	}
}

func TestResolveSkipHistoryLagEnvOverridesJSON(t *testing.T) {
	t.Setenv("RH_SKIP_HISTORY_LAG", "0")
	lag := 80
	got, err := resolveSkipHistoryLag(&lag)
	if err != nil || got != 0 {
		t.Fatalf("环境变量应覆盖 JSON: %v %d", err, got)
	}
}
