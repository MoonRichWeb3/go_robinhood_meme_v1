package chain

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"time"
)

const (
	traceUser = "0xc81e00000000000000000000000000000000d9d1"
	traceGMGN = "0x65050a9b7e5075a2ba5ced7b1b64ee66262c40dc"
	tracePool = "0x8366a39cc670b4001a1121b8f6a443a643e40951"
)

func TestTraceNativeAmountRealSampleShapes(t *testing.T) {
	tests := []struct {
		name, tx, side, want string
		frame                callFrame
	}{
		{
			name: "买入根调用实付含费", tx: "0x04497713bef880d934b99a0f03daaf34ebcf4ce47bb07be669e9a7a6c1225ba6",
			side: "buy", want: "4000000000000000",
			frame: callFrame{Type: "CALL", From: traceUser, To: traceGMGN, Value: "0xe35fa931a0000"},
		},
		{
			name: "卖出经GMGN扣费后到账", tx: "0xa9668ca36d3e8a12756a363b11ff23bf8fc9aa822de645579b2c4a138e792822",
			side: "sell", want: "3840847086384000",
			frame: callFrame{
				Type: "CALL", From: traceUser, To: traceGMGN, Value: "0x0",
				Calls: []callFrame{
					{Type: "CALL", From: tracePool, To: traceGMGN, Value: "0xdc883e5f5ca00"},
					{Type: "CALL", From: traceGMGN, To: "0x1111111111111111111111111111111111111111", Value: "0x2348ffbd5680"},
					{Type: "CALL", From: traceGMGN, To: traceUser, Value: "0xda53ae6387380"},
				},
			},
		},
	}
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			client := newTraceTestClient(t, func(w http.ResponseWriter, req rpcRequest) {
				if req.Method == "eth_chainId" {
					writeRPCResult(w, req.ID, "0x1237")
					return
				}
				if req.Method != "debug_traceTransaction" {
					t.Fatalf("意外方法: %s", req.Method)
				}
				writeRPCResult(w, req.ID, test.frame)
			})
			got, err := client.TraceNativeAmount(t.Context(), test.tx, traceUser, test.side)
			if err != nil || got != test.want {
				t.Fatalf("净额错误: got=%s want=%s err=%v", got, test.want, err)
			}
		})
	}
}

func TestTraceNativeAmountExcludesDelegatecallAndRevertedSubtree(t *testing.T) {
	root := callFrame{
		Type: "CALL", From: traceUser, To: traceGMGN, Value: "0x64",
		Calls: []callFrame{
			{Type: "DELEGATECALL", From: traceGMGN, To: tracePool, Value: "0x64"},
			{Type: "CALL", From: traceGMGN, To: traceUser, Value: "0x32", Error: "execution reverted",
				Calls: []callFrame{{Type: "CALL", From: traceGMGN, To: traceUser, Value: "0x32"}}},
		},
	}
	client := newTraceTestClient(t, func(w http.ResponseWriter, req rpcRequest) {
		if req.Method == "eth_chainId" {
			writeRPCResult(w, req.ID, "0x1237")
		} else {
			writeRPCResult(w, req.ID, root)
		}
	})
	got, err := client.TraceNativeAmount(t.Context(),
		"0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb", traceUser, "buy")
	if err != nil || got != "100" {
		t.Fatalf("镜像或回滚 value 被重复计入: got=%s err=%v", got, err)
	}
}

func TestParseTraceValueAcceptsOmittedZero(t *testing.T) {
	value, err := parseTraceValue("")
	if err != nil {
		t.Fatal(err)
	}
	if value.Sign() != 0 {
		t.Fatalf("省略的 callTracer value 应解析为零: %s", value)
	}
}

func TestTraceNativeAmountMethodUnavailableDegradesToError(t *testing.T) {
	client := newTraceTestClient(t, func(w http.ResponseWriter, req rpcRequest) {
		if req.Method == "eth_chainId" {
			writeRPCResult(w, req.ID, "0x1237")
		} else {
			writeRPCError(w, req.ID, -32601, "method not found")
		}
	})
	_, err := client.TraceNativeAmount(t.Context(),
		"0xcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc", traceUser, "buy")
	if err == nil || !strings.Contains(err.Error(), "-32601") {
		t.Fatalf("method unavailable 应作为可降级错误返回: %v", err)
	}
}

func newTraceTestClient(t *testing.T, handler func(http.ResponseWriter, rpcRequest)) *Client {
	t.Helper()
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		var req rpcRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			t.Error(err)
			return
		}
		handler(w, req)
	}))
	t.Cleanup(server.Close)
	client, err := NewClient(t.Context(), server.URL, "trace-test", time.Second, 4663)
	if err != nil {
		t.Fatal(err)
	}
	return client
}
