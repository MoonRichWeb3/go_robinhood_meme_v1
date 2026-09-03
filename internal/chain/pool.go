// 本文件实现扫块 RPC 节点池：按 qps 加权轮询，并在 429 时带上脱敏后的具体节点。
package chain

import (
	"context"
	"errors"
	"fmt"
	"net/http"
	"net/url"
	"strings"
	"sync"
	"time"
)

const (
	rpcRateLimitPenalty = time.Second
	maxRPCPoolSize      = 32
)

// RPCEndpoint 是节点池配置：HTTP 地址与每秒请求上限。
type RPCEndpoint struct {
	URL string
	QPS int
}

// EndpointError 标注失败发生在哪条 RPC；429 时 Status 为 429。
type EndpointError struct {
	RPC    string
	Status int
	Err    error
}

func (e *EndpointError) Error() string {
	if e == nil {
		return "RPC 错误"
	}
	if e.Status == http.StatusTooManyRequests {
		return fmt.Sprintf("RPC限流 RPC=%s 状态=%d: %v", e.RPC, e.Status, e.Err)
	}
	if e.Status != 0 {
		return fmt.Sprintf("RPC HTTP 状态 %d RPC=%s", e.Status, e.RPC)
	}
	if e.Err != nil {
		return fmt.Sprintf("RPC=%s: %v", e.RPC, e.Err)
	}
	return fmt.Sprintf("RPC=%s", e.RPC)
}

func (e *EndpointError) Unwrap() error {
	if e == nil {
		return nil
	}
	return e.Err
}

// AsEndpointError 取出带节点标签的 RPC 错误。
func AsEndpointError(err error) (*EndpointError, bool) {
	var endpoint *EndpointError
	if errors.As(err, &endpoint) {
		return endpoint, true
	}
	return nil, false
}

type rpcMember struct {
	url, label      string
	qps, current    int
	tokens          float64
	last, coolUntil time.Time
}

type rpcPool struct {
	mu      sync.Mutex
	members []*rpcMember
	now     func() time.Time
}

// SkippedRPC 是启动时 chainId 失败被跳过的节点（URL 已脱敏）。
type SkippedRPC struct {
	RPC, Reason string
}

// NewPoolClient 校验每条节点的 chainId，按 qps 组成扫块池；至少一条成功才能启动。
func NewPoolClient(ctx context.Context, endpoints []RPCEndpoint, userAgent string, timeout time.Duration, expectedChainID uint64) (*Client, error) {
	if len(endpoints) == 0 {
		return nil, fmt.Errorf("扫块 RPC 节点池不能为空")
	}
	if len(endpoints) > maxRPCPoolSize {
		return nil, fmt.Errorf("扫块 RPC 节点池最多 %d 条", maxRPCPoolSize)
	}
	if strings.TrimSpace(userAgent) == "" {
		return nil, fmt.Errorf("RH_HTTP_UA 不能为空")
	}
	if timeout <= 0 {
		return nil, fmt.Errorf("RPC timeout 必须大于 0")
	}
	httpClient := &http.Client{Timeout: timeout}
	pool := &rpcPool{now: time.Now}
	var skipped []SkippedRPC
	for _, item := range endpoints {
		if item.QPS < 1 {
			return nil, fmt.Errorf("RPC qps 必须大于 0")
		}
		probe := &Client{endpoint: item.URL, label: RedactRPCURL(item.URL), userAgent: userAgent, http: httpClient}
		var chainID string
		if err := probe.Call(ctx, "eth_chainId", []any{}, &chainID); err != nil {
			skipped = append(skipped, SkippedRPC{RPC: probe.label, Reason: err.Error()})
			continue
		}
		got, err := parseHexUint64(chainID)
		if err != nil {
			skipped = append(skipped, SkippedRPC{RPC: probe.label, Reason: "解析 chainId: " + err.Error()})
			continue
		}
		if got != expectedChainID {
			skipped = append(skipped, SkippedRPC{RPC: probe.label, Reason: fmt.Sprintf("chainId 不匹配: 期望=%d 实际=%d", expectedChainID, got)})
			continue
		}
		now := pool.now()
		pool.members = append(pool.members, &rpcMember{
			url: item.URL, label: probe.label, qps: item.QPS, tokens: float64(item.QPS), last: now,
		})
	}
	if len(pool.members) == 0 {
		return nil, fmt.Errorf("扫块 RPC 节点池全部不可用: %s", formatSkipped(skipped))
	}
	return &Client{
		userAgent: userAgent,
		http:      httpClient,
		pool:      pool,
		skipped:   skipped,
	}, nil
}

// EndpointCount 返回当前可用于扫块的节点数。
func (c *Client) EndpointCount() int {
	if c == nil {
		return 0
	}
	if c.pool != nil {
		return len(c.pool.members)
	}
	if c.endpoint != "" {
		return 1
	}
	return 0
}

// EndpointLabels 返回脱敏后的节点地址，供日志使用。
func (c *Client) EndpointLabels() []string {
	if c == nil {
		return nil
	}
	if c.pool != nil {
		out := make([]string, len(c.pool.members))
		for i, member := range c.pool.members {
			out[i] = member.label
		}
		return out
	}
	if c.label != "" {
		return []string{c.label}
	}
	if c.endpoint != "" {
		return []string{RedactRPCURL(c.endpoint)}
	}
	return nil
}

// SkippedEndpoints 返回启动时 chainId 失败被跳过的节点。
func (c *Client) SkippedEndpoints() []SkippedRPC {
	if c == nil {
		return nil
	}
	return c.skipped
}

func (c *Client) acquire(ctx context.Context) (*rpcMember, error) {
	if c.pool == nil {
		return &rpcMember{url: c.endpoint, label: c.label}, nil
	}
	return c.pool.acquire(ctx)
}

func (p *rpcPool) acquire(ctx context.Context) (*rpcMember, error) {
	for {
		if err := ctx.Err(); err != nil {
			return nil, err
		}
		now := p.now()
		p.mu.Lock()
		var ready []*rpcMember
		var minWait time.Duration
		for _, member := range p.members {
			wait := member.waitDuration(now)
			if wait == 0 {
				ready = append(ready, member)
				continue
			}
			if minWait == 0 || wait < minWait {
				minWait = wait
			}
		}
		var picked *rpcMember
		if len(ready) > 0 {
			picked = weightedPick(ready)
			picked.take(now)
		}
		p.mu.Unlock()
		if picked != nil {
			return picked, nil
		}
		if minWait <= 0 {
			minWait = 50 * time.Millisecond
		}
		timer := time.NewTimer(minWait)
		select {
		case <-ctx.Done():
			timer.Stop()
			return nil, ctx.Err()
		case <-timer.C:
		}
	}
}

func weightedPick(ready []*rpcMember) *rpcMember {
	total := 0
	var best *rpcMember
	for _, member := range ready {
		total += member.qps
		member.current += member.qps
		if best == nil || member.current > best.current {
			best = member
		}
	}
	best.current -= total
	return best
}

func (m *rpcMember) waitDuration(now time.Time) time.Duration {
	if now.Before(m.coolUntil) {
		return m.coolUntil.Sub(now)
	}
	m.refill(now)
	if m.tokens >= 1 {
		return 0
	}
	need := (1 - m.tokens) / float64(m.qps)
	if need <= 0 {
		return 0
	}
	return time.Duration(need * float64(time.Second))
}

func (m *rpcMember) refill(now time.Time) {
	if m.last.IsZero() {
		m.last = now
		return
	}
	elapsed := now.Sub(m.last).Seconds()
	if elapsed <= 0 {
		return
	}
	m.tokens = min(float64(m.qps), m.tokens+elapsed*float64(m.qps))
	m.last = now
}

func (m *rpcMember) take(now time.Time) {
	m.refill(now)
	if m.tokens >= 1 {
		m.tokens -= 1
	}
}

func (m *rpcMember) penalize(now time.Time) {
	if m == nil {
		return
	}
	m.tokens = 0
	m.last = now
	m.coolUntil = now.Add(rpcRateLimitPenalty)
}

func (p *rpcPool) penalize(member *rpcMember) {
	if p == nil || member == nil {
		return
	}
	p.mu.Lock()
	defer p.mu.Unlock()
	member.penalize(p.now())
}

func wrapEndpointError(member *rpcMember, status int, err error) error {
	label := "<unknown>"
	if member != nil && member.label != "" {
		label = member.label
	}
	return &EndpointError{RPC: label, Status: status, Err: err}
}

func rpcErrorRateLimited(err *rpcError) bool {
	if err == nil {
		return false
	}
	if err.Code == http.StatusTooManyRequests || err.Code == -32029 {
		return true
	}
	return isRateLimitedText(err.Message)
}

func isRateLimitedBody(raw []byte) bool {
	return isRateLimitedText(string(raw))
}

func isRateLimitedText(text string) bool {
	lower := strings.ToLower(text)
	return strings.Contains(lower, "too many requests") ||
		strings.Contains(lower, "rate limit") ||
		strings.Contains(lower, "rate_limited") ||
		strings.Contains(lower, "compute units")
}

func formatSkipped(skipped []SkippedRPC) string {
	if len(skipped) == 0 {
		return "无节点"
	}
	parts := make([]string, 0, len(skipped))
	for _, item := range skipped {
		parts = append(parts, item.RPC+": "+item.Reason)
	}
	return strings.Join(parts, "; ")
}

// RedactRPCURL 去掉用户名、查询串，并把 /v1|/v2 后的密钥段换成 <redacted>。
func RedactRPCURL(raw string) string {
	u, err := url.Parse(strings.TrimSpace(raw))
	if err != nil || u.Host == "" {
		return "<redacted>"
	}
	u.User = nil
	u.RawQuery = ""
	u.RawFragment = ""
	u.Fragment = ""
	parts := strings.Split(strings.Trim(u.Path, "/"), "/")
	for i := 1; i < len(parts); i++ {
		if (parts[i-1] == "v1" || parts[i-1] == "v2") && len(parts[i]) >= 8 {
			parts[i] = "<redacted>"
		}
	}
	if len(parts) == 1 && parts[0] == "" {
		return u.Scheme + "://" + u.Host
	}
	return u.Scheme + "://" + u.Host + "/" + strings.Join(parts, "/")
}
