// 本文件通过 callTracer 计算目标用户在一笔交易中的原生 ETH 成功调用净额。
package chain

import (
	"context"
	"fmt"
	"math/big"
	"strings"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

const (
	maxTraceResponseBytes int64 = 16 << 20
	maxTraceDepth               = 128
	maxTraceNodes               = 10000
)

type callFrame struct {
	Type  string      `json:"type"`
	From  string      `json:"from"`
	To    string      `json:"to"`
	Value string      `json:"value"`
	Error string      `json:"error"`
	Calls []callFrame `json:"calls"`
}

// TraceNativeAmount 返回目标用户与成交方向一致的原生 ETH 净流量绝对值。
// 仅成功 CALL/CREATE/CREATE2 的非零 value 计入；失败子树与镜像 value 均被排除。
func (c *Client) TraceNativeAmount(ctx context.Context, txHash, user, side string) (string, error) {
	hash, err := domain.NormalizeHash(txHash, 32)
	if err != nil {
		return "", fmt.Errorf("trace 交易哈希无效: %w", err)
	}
	target, err := domain.NormalizeAddress(user)
	if err != nil {
		return "", fmt.Errorf("trace 用户地址无效: %w", err)
	}
	if side != "buy" && side != "sell" {
		return "", fmt.Errorf("trace 成交方向必须是 buy 或 sell")
	}
	var root callFrame
	params := []any{hash, map[string]any{
		"tracer":       "callTracer",
		"tracerConfig": map[string]any{"onlyTopCall": false, "withLog": false},
	}}
	if err = c.call(ctx, "debug_traceTransaction", params, &root, maxTraceResponseBytes); err != nil {
		return "", fmt.Errorf("调用 debug_traceTransaction: %w", err)
	}
	net := new(big.Int)
	nodes := 0
	if err = accumulateNativeNet(root, 1, target, false, &nodes, net); err != nil {
		return "", err
	}
	if (side == "buy" && net.Sign() >= 0) || (side == "sell" && net.Sign() <= 0) {
		return "", fmt.Errorf("原生 ETH 净额与成交方向不一致或为零")
	}
	return new(big.Int).Abs(net).String(), nil
}

func accumulateNativeNet(frame callFrame, depth int, target string, reverted bool, nodes *int, net *big.Int) error {
	*nodes++
	if *nodes > maxTraceNodes {
		return fmt.Errorf("callTracer 节点数超过 %d", maxTraceNodes)
	}
	if depth > maxTraceDepth {
		return fmt.Errorf("callTracer 深度超过 %d", maxTraceDepth)
	}
	kind := strings.ToUpper(strings.TrimSpace(frame.Type))
	switch kind {
	case "CALL", "STATICCALL", "DELEGATECALL", "CALLCODE", "CREATE", "CREATE2", "SELFDESTRUCT":
	default:
		return fmt.Errorf("callTracer 调用类型无效: %q", frame.Type)
	}
	from, err := normalizeTraceAddress(frame.From, "from", false)
	if err != nil {
		return err
	}
	allowEmptyTo := strings.TrimSpace(frame.Error) != "" && (kind == "CREATE" || kind == "CREATE2")
	to, err := normalizeTraceAddress(frame.To, "to", allowEmptyTo)
	if err != nil {
		return err
	}
	value, err := parseTraceValue(frame.Value)
	if err != nil {
		return err
	}
	reverted = reverted || strings.TrimSpace(frame.Error) != ""
	if !reverted && value.Sign() > 0 && (kind == "CALL" || kind == "CREATE" || kind == "CREATE2") {
		if from == target {
			net.Sub(net, value)
		}
		if to == target {
			net.Add(net, value)
		}
	}
	for _, child := range frame.Calls {
		if err = accumulateNativeNet(child, depth+1, target, reverted, nodes, net); err != nil {
			return err
		}
	}
	return nil
}

func normalizeTraceAddress(value, field string, allowEmpty bool) (string, error) {
	if allowEmpty && strings.TrimSpace(value) == "" {
		return "", nil
	}
	normalized, err := domain.NormalizeAddress(value)
	if err != nil || len(strings.TrimSpace(value)) != 42 || !strings.HasPrefix(strings.ToLower(strings.TrimSpace(value)), "0x") {
		return "", fmt.Errorf("callTracer %s 地址无效", field)
	}
	return normalized, nil
}

func parseTraceValue(value string) (*big.Int, error) {
	value = strings.TrimSpace(value)
	// geth callTracer 允许省略零 value；只能把“字段缺失”解释为零，
	// 非空值仍必须是规范的 JSON-RPC 十六进制 quantity。
	if value == "" {
		return new(big.Int), nil
	}
	if len(value) < 3 || !strings.HasPrefix(value, "0x") {
		return nil, fmt.Errorf("callTracer value 必须是 0x 十六进制 quantity")
	}
	digits := value[2:]
	if len(digits) > 1 && digits[0] == '0' {
		return nil, fmt.Errorf("callTracer value 含前导零")
	}
	n := new(big.Int)
	if _, ok := n.SetString(digits, 16); !ok || n.Sign() < 0 || n.BitLen() > 256 {
		return nil, fmt.Errorf("callTracer value 无效或超过 uint256")
	}
	return n, nil
}
