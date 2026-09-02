package app

import (
	"bytes"
	"context"
	"errors"
	"strings"
	"testing"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/contracts"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/logx"
)

type fakeNativeTracer struct {
	amount string
	err    error
	calls  int
}

func (f *fakeNativeTracer) TraceNativeAmount(context.Context, string, string, string) (string, error) {
	f.calls++
	return f.amount, f.err
}

func TestEnrichNativeQuoteAcceptsOnlySingleSwap(t *testing.T) {
	var output bytes.Buffer
	tracer := &fakeNativeTracer{amount: "4000000000000000"}
	a := &App{logger: logx.New(&output, "info"), traceClient: tracer}
	fill := nativeTestFill()
	logged := false

	a.enrichNativeQuote(t.Context(), &fill, 2, &logged)

	if tracer.calls != 0 || fill.QuoteAmountRaw != "" {
		t.Fatalf("多 Swap 不得调用 trace 或填 quote: calls=%d fill=%+v", tracer.calls, fill)
	}
	if strings.Count(output.String(), "类型=原生ETH成交净额失败") != 1 {
		t.Fatalf("多 Swap 必须只打一条中文错误: %s", output.String())
	}
}

func TestEnrichNativeQuoteSafelyDegradesTraceFailure(t *testing.T) {
	var output bytes.Buffer
	tracer := &fakeNativeTracer{err: errors.New("RPC -32601: method not found")}
	a := &App{logger: logx.New(&output, "info"), traceClient: tracer}
	fill := nativeTestFill()
	logged := false

	a.enrichNativeQuote(t.Context(), &fill, 1, &logged)

	if tracer.calls != 1 || fill.MemeAmountRaw != "123" || fill.QuoteAmountRaw != "" {
		t.Fatalf("trace 失败必须保留 meme 数量并留空 quote: %+v", fill)
	}
	if strings.Count(output.String(), "类型=原生ETH成交净额失败") != 1 {
		t.Fatalf("trace 失败必须只打一条中文错误: %s", output.String())
	}
}

func nativeTestFill() domain.Fill {
	return domain.Fill{
		Token: "0x1ebc42c5ee785694a9775d5dd917166206eb58f5", Quote: contracts.ZeroAddress,
		User: traceTestUser, Side: "buy", MemeAmountRaw: "123",
		TxHash: "0x04497713bef880d934b99a0f03daaf34ebcf4ce47bb07be669e9a7a6c1225ba6",
	}
}

const traceTestUser = "0xc81e00000000000000000000000000000000d9d1"
