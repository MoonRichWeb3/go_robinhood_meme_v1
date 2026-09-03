// Package chain 提供与盘口无关的 Robinhood Chain HTTP JSON-RPC 扫块能力。
package chain

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"math/big"
	"net"
	"net/http"
	"net/url"
	"strconv"
	"strings"
	"sync/atomic"
	"time"
	"unicode/utf8"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

const maxRPCResponseBytes = 64 << 20

// Client 是带固定 User-Agent 和请求超时的 HTTP JSON-RPC 客户端。
type Client struct {
	endpoint  string
	userAgent string
	http      *http.Client
	nextID    atomic.Uint64
}

type rpcRequest struct {
	JSONRPC string `json:"jsonrpc"`
	ID      uint64 `json:"id"`
	Method  string `json:"method"`
	Params  any    `json:"params"`
}

type rpcResponse struct {
	JSONRPC string          `json:"jsonrpc"`
	ID      uint64          `json:"id"`
	Result  json.RawMessage `json:"result"`
	Error   *rpcError       `json:"error"`
}

type rpcError struct {
	Code    int             `json:"code"`
	Message string          `json:"message"`
	Data    json.RawMessage `json:"data,omitempty"`
}

// ERC20Metadata 是成交精度必需的 decimals 及可选展示名称。
type ERC20Metadata struct {
	Name, Symbol string
	Decimals     uint8
}

func (e *rpcError) Error() string { return fmt.Sprintf("RPC %d: %s", e.Code, e.Message) }

// NewClient 校验 URL、UA、超时和 chainId；连到错误链时直接失败。
func NewClient(ctx context.Context, endpoint, userAgent string, timeout time.Duration, expectedChainID uint64) (*Client, error) {
	u, err := url.Parse(strings.TrimSpace(endpoint))
	if err != nil || (u.Scheme != "http" && u.Scheme != "https") || u.Host == "" {
		return nil, fmt.Errorf("RH_RPC_URL 必须是有效的 http/https URL")
	}
	if strings.TrimSpace(userAgent) == "" {
		return nil, fmt.Errorf("RH_HTTP_UA 不能为空")
	}
	if timeout <= 0 {
		return nil, fmt.Errorf("RPC timeout 必须大于 0")
	}
	c := &Client{endpoint: u.String(), userAgent: userAgent, http: &http.Client{Timeout: timeout}}
	var chainID string
	if err = c.Call(ctx, "eth_chainId", []any{}, &chainID); err != nil {
		return nil, fmt.Errorf("读取 chainId: %w", err)
	}
	got, err := parseHexUint64(chainID)
	if err != nil {
		return nil, fmt.Errorf("解析 chainId: %w", err)
	}
	if got != expectedChainID {
		return nil, fmt.Errorf("chainId 不匹配: 期望=%d 实际=%d", expectedChainID, got)
	}
	return c, nil
}

// BatchCall 是 JSON-RPC HTTP 批量中的一条调用。
type BatchCall struct {
	Method string
	Params any
}

// Call 执行一次有界 JSON-RPC 请求并严格处理 HTTP/RPC 错误。
func (c *Client) Call(ctx context.Context, method string, params any, out any) error {
	return c.call(ctx, method, params, out, maxRPCResponseBytes)
}

// CallBatch 一次 HTTP 提交多条 JSON-RPC；任一条错误则整批失败，不使用部分结果。
func (c *Client) CallBatch(ctx context.Context, calls []BatchCall, outs []any) error {
	if len(calls) == 0 {
		return fmt.Errorf("JSON-RPC 批量不能为空")
	}
	if len(outs) != len(calls) {
		return fmt.Errorf("JSON-RPC 批量输出数量必须与调用数量一致")
	}
	reqs := make([]rpcRequest, len(calls))
	ids := make([]uint64, len(calls))
	for i, item := range calls {
		id := c.nextID.Add(1)
		ids[i] = id
		reqs[i] = rpcRequest{JSONRPC: "2.0", ID: id, Method: item.Method, Params: item.Params}
	}
	body, err := json.Marshal(reqs)
	if err != nil {
		return err
	}
	raw, err := c.post(ctx, body, maxRPCResponseBytes)
	if err != nil {
		return err
	}
	raw = bytes.TrimSpace(raw)
	if len(raw) == 0 {
		return fmt.Errorf("解码 RPC 批量响应: 空响应")
	}
	if raw[0] == '{' {
		var envelope rpcResponse
		if err = json.Unmarshal(raw, &envelope); err != nil {
			return fmt.Errorf("解码 RPC 批量响应: %w", err)
		}
		if envelope.Error != nil {
			return envelope.Error
		}
		return fmt.Errorf("RPC 批量响应必须是数组")
	}
	var envelopes []rpcResponse
	if err = json.Unmarshal(raw, &envelopes); err != nil {
		return fmt.Errorf("解码 RPC 批量响应: %w", err)
	}
	if len(envelopes) != len(calls) {
		return fmt.Errorf("RPC 批量响应条数不匹配: 期望=%d 实际=%d", len(calls), len(envelopes))
	}
	byID := make(map[uint64]rpcResponse, len(envelopes))
	for _, envelope := range envelopes {
		if _, ok := byID[envelope.ID]; ok {
			return fmt.Errorf("RPC 批量响应 id 重复: %d", envelope.ID)
		}
		byID[envelope.ID] = envelope
	}
	for i, id := range ids {
		envelope, ok := byID[id]
		if !ok {
			return fmt.Errorf("RPC 响应 id 不匹配: 期望=%d", id)
		}
		if envelope.Error != nil {
			return envelope.Error
		}
		if string(envelope.Result) == "null" {
			return fmt.Errorf("RPC %s 返回 null", calls[i].Method)
		}
		if outs[i] == nil {
			continue
		}
		if err = json.Unmarshal(envelope.Result, outs[i]); err != nil {
			return fmt.Errorf("解码 RPC %s 结果: %w", calls[i].Method, err)
		}
	}
	return nil
}

// call 执行带独立响应上限的 RPC，避免节点返回无界 JSON 占满进程内存。
func (c *Client) call(ctx context.Context, method string, params any, out any, responseLimit int64) error {
	id := c.nextID.Add(1)
	body, err := json.Marshal(rpcRequest{JSONRPC: "2.0", ID: id, Method: method, Params: params})
	if err != nil {
		return err
	}
	raw, err := c.post(ctx, body, responseLimit)
	if err != nil {
		return err
	}
	var envelope rpcResponse
	if err = json.Unmarshal(raw, &envelope); err != nil {
		return fmt.Errorf("解码 RPC 响应: %w", err)
	}
	if envelope.ID != id {
		return fmt.Errorf("RPC 响应 id 不匹配: 期望=%d 实际=%d", id, envelope.ID)
	}
	if envelope.Error != nil {
		return envelope.Error
	}
	if string(envelope.Result) == "null" {
		return fmt.Errorf("RPC %s 返回 null", method)
	}
	if out == nil {
		return nil
	}
	return json.Unmarshal(envelope.Result, out)
}

func (c *Client) post(ctx context.Context, body []byte, responseLimit int64) ([]byte, error) {
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.endpoint, bytes.NewReader(body))
	if err != nil {
		return nil, err
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("User-Agent", c.userAgent)
	resp, err := c.http.Do(req)
	if err != nil {
		if ctxErr := ctx.Err(); ctxErr != nil {
			return nil, ctxErr
		}
		var netErr net.Error
		if errors.As(err, &netErr) && netErr.Timeout() {
			return nil, fmt.Errorf("RPC HTTP 请求超时")
		}
		return nil, fmt.Errorf("RPC HTTP 请求失败")
	}
	defer resp.Body.Close()
	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		io.Copy(io.Discard, io.LimitReader(resp.Body, 4096))
		return nil, fmt.Errorf("RPC HTTP 状态 %d", resp.StatusCode)
	}
	if responseLimit < 1 {
		return nil, fmt.Errorf("RPC 响应上限必须大于 0")
	}
	raw, err := io.ReadAll(io.LimitReader(resp.Body, responseLimit+1))
	if err != nil {
		return nil, fmt.Errorf("读取 RPC 响应: %w", err)
	}
	if int64(len(raw)) > responseLimit {
		return nil, fmt.Errorf("RPC 响应超过 %d 字节上限", responseLimit)
	}
	return raw, nil
}

// BlockNumber 返回当前链头高度。
func (c *Client) BlockNumber(ctx context.Context) (uint64, error) {
	var result string
	if err := c.Call(ctx, "eth_blockNumber", []any{}, &result); err != nil {
		return 0, err
	}
	return parseHexUint64(result)
}

// TokenMetadata 在指定块执行 eth_call；decimals 失败即返回错误，name/symbol 失败安全留空。
func (c *Client) TokenMetadata(ctx context.Context, token string, block uint64) (ERC20Metadata, error) {
	token, err := domain.NormalizeAddress(token)
	if err != nil {
		return ERC20Metadata{}, err
	}
	call := func(selector string) ([]byte, error) {
		var result string
		params := []any{map[string]string{"to": token, "data": selector}, hexQuantity(block)}
		if err := c.Call(ctx, "eth_call", params, &result); err != nil {
			return nil, err
		}
		return decodeHexBytes(result)
	}
	rawDecimals, err := call("0x313ce567")
	if err != nil {
		return ERC20Metadata{}, fmt.Errorf("读取 ERC20 decimals: %w", err)
	}
	if len(rawDecimals) != 32 {
		return ERC20Metadata{}, fmt.Errorf("ERC20 decimals 返回长度应为 32 字节")
	}
	decimals := new(big.Int).SetBytes(rawDecimals)
	if !decimals.IsUint64() || decimals.Uint64() > 255 {
		return ERC20Metadata{}, fmt.Errorf("ERC20 decimals 超出 uint8")
	}
	out := ERC20Metadata{Decimals: uint8(decimals.Uint64())}
	if raw, callErr := call("0x95d89b41"); callErr == nil {
		out.Symbol, _ = decodeABIText(raw)
	}
	if raw, callErr := call("0x06fdde03"); callErr == nil {
		out.Name, _ = decodeABIText(raw)
	}
	return out, nil
}

func decodeABIText(raw []byte) (string, error) {
	if len(raw) == 32 {
		text := strings.TrimRight(string(raw), "\x00")
		if utf8.ValidString(text) {
			return text, nil
		}
	}
	if len(raw) < 64 {
		return "", fmt.Errorf("ABI string 长度不足")
	}
	offset := new(big.Int).SetBytes(raw[:32])
	if !offset.IsUint64() || offset.Uint64() > uint64(len(raw)-32) {
		return "", fmt.Errorf("ABI string offset 无效")
	}
	start := int(offset.Uint64())
	length := new(big.Int).SetBytes(raw[start : start+32])
	if !length.IsUint64() || length.Uint64() > uint64(len(raw)-start-32) {
		return "", fmt.Errorf("ABI string length 无效")
	}
	text := raw[start+32 : start+32+int(length.Uint64())]
	if !utf8.Valid(text) {
		return "", fmt.Errorf("ABI string 不是 UTF-8")
	}
	return string(text), nil
}

func parseHexUint64(value string) (uint64, error) {
	value = strings.TrimPrefix(strings.ToLower(strings.TrimSpace(value)), "0x")
	if value == "" {
		return 0, fmt.Errorf("空十六进制整数")
	}
	return strconv.ParseUint(value, 16, 64)
}
