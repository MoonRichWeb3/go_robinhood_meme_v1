// 本文件提供显式开启的公网只读验收；默认单测不会访问网络。
package chain

import (
	"context"
	"os"
	"testing"
	"time"
)

const (
	liveUser   = "0xc81e6eb9071b702c502e0a26d2c996f3af46d9d1"
	liveBuyTx  = "0x04497713bef880d934b99a0f03daaf34ebcf4ce47bb07be669e9a7a6c1225ba6"
	liveSellTx = "0xa9668ca36d3e8a12756a363b11ff23bf8fc9aa822de645579b2c4a138e792822"
)

// TestLiveRobinhoodRPC 验证公网节点的整块收据，以及真实原生 ETH 买卖净额。
// 仅在 RH_LIVE_TEST=1 时运行，避免常规测试依赖外部网络和第三方限流。
func TestLiveRobinhoodRPC(t *testing.T) {
	if os.Getenv("RH_LIVE_TEST") != "1" {
		t.Skip("设置 RH_LIVE_TEST=1 后执行公网只读验收")
	}
	mainURL := os.Getenv("RH_RPC_URL")
	traceURL := os.Getenv("RH_TRACE_RPC_URL")
	if mainURL == "" || traceURL == "" {
		t.Fatal("公网验收需要 RH_RPC_URL 与 RH_TRACE_RPC_URL")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 45*time.Second)
	defer cancel()

	mainClient, err := NewClient(ctx, mainURL, "go-robinhood-meme/v0-live-test", 10*time.Second, 4663)
	if err != nil {
		t.Fatalf("连接主 RPC: %v", err)
	}
	fetcher := NewReceiptFetcher(mainClient)
	const sampleBlock = uint64(0x31df9ba)
	if _, err = fetcher.Probe(ctx, sampleBlock); err != nil {
		t.Fatalf("探测整块收据: %v", err)
	}
	block, err := fetcher.FetchBlock(ctx, sampleBlock)
	if err != nil {
		t.Fatalf("读取真实区块: %v", err)
	}
	found := false
	for _, tx := range block.Transactions {
		if tx.Hash == liveBuyTx {
			found = true
			break
		}
	}
	if !found {
		t.Fatalf("真实区块 %d 缺少样本交易", sampleBlock)
	}

	traceClient, err := NewClient(ctx, traceURL, "go-robinhood-meme/v0-live-test", 15*time.Second, 4663)
	if err != nil {
		t.Fatalf("连接 trace RPC: %v", err)
	}
	buy, err := traceClient.TraceNativeAmount(ctx, liveBuyTx, liveUser, "buy")
	if err != nil {
		t.Fatalf("追踪真实买入: %v", err)
	}
	if buy != "4000000000000000" {
		t.Fatalf("真实买入净额错误: %s", buy)
	}
	sell, err := traceClient.TraceNativeAmount(ctx, liveSellTx, liveUser, "sell")
	if err != nil {
		t.Fatalf("追踪真实卖出: %v", err)
	}
	if sell != "3840847086384000" {
		t.Fatalf("真实卖出净额错误: %s", sell)
	}
}
