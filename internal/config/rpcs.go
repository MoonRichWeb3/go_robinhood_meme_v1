package config

// 本文件读取扫块配置 JSON：skip_history_lag 与 [{rpc,qps}] 节点池，并展开 ${ENV}。

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/url"
	"os"
	"strings"
)

const (
	defaultRPCEndpointsFile = "configs/rpcs.json"
	defaultSkipHistoryLag   = 100
	maxRPCEndpoints         = 32
	maxRPCQPS               = 1000
)

type rpcFileItem struct {
	RPC string `json:"rpc"`
	QPS int    `json:"qps"`
}

type rpcFileEnvelope struct {
	SkipHistoryLag *int          `json:"skip_history_lag"`
	RPCs           []rpcFileItem `json:"rpcs"`
}

// RPCEndpoint 是扫块节点池中的一条：HTTP URL 与每秒请求上限。
type RPCEndpoint struct {
	URL string
	QPS int
}

type loadedRPCFile struct {
	Path           string
	Endpoints      []RPCEndpoint
	SkipHistoryLag int
}

// loadRPCEndpoints 读取 JSON 节点池与落后跳过阈值；文件不存在时回退到 RH_RPC_URL（qps=1）。
func loadRPCEndpoints(rpcURL, filePath string) (loadedRPCFile, error) {
	filePath = strings.TrimSpace(filePath)
	if filePath == "" {
		filePath = defaultRPCEndpointsFile
	}
	raw, err := os.ReadFile(filePath)
	if err != nil {
		if os.IsNotExist(err) {
			return fallbackRPCEndpoint(rpcURL, filePath)
		}
		return loadedRPCFile{}, fmt.Errorf("读取 RH_RPC_ENDPOINTS_FILE: %w", err)
	}
	endpoints, lag, err := parseRPCFile(raw)
	if err != nil {
		return loadedRPCFile{}, err
	}
	if len(endpoints) == 0 {
		return loadedRPCFile{}, fmt.Errorf("RH_RPC_ENDPOINTS_FILE 展开后没有可用 rpc")
	}
	skipLag, err := resolveSkipHistoryLag(lag)
	if err != nil {
		return loadedRPCFile{}, err
	}
	return loadedRPCFile{Path: filePath, Endpoints: endpoints, SkipHistoryLag: skipLag}, nil
}

func fallbackRPCEndpoint(rpcURL, filePath string) (loadedRPCFile, error) {
	rpcURL = strings.TrimSpace(rpcURL)
	if rpcURL == "" {
		return loadedRPCFile{}, fmt.Errorf("RH_RPC_URL 不能为空")
	}
	if err := validateRPCURL(rpcURL); err != nil {
		return loadedRPCFile{}, err
	}
	skipLag, err := resolveSkipHistoryLag(nil)
	if err != nil {
		return loadedRPCFile{}, err
	}
	return loadedRPCFile{
		Path: filePath, Endpoints: []RPCEndpoint{{URL: rpcURL, QPS: 1}}, SkipHistoryLag: skipLag,
	}, nil
}

func parseRPCFile(raw []byte) ([]RPCEndpoint, *int, error) {
	raw = bytes.TrimSpace(raw)
	if len(raw) == 0 {
		return nil, nil, fmt.Errorf("RH_RPC_ENDPOINTS_FILE 不能为空")
	}
	var items []rpcFileItem
	var lag *int
	switch raw[0] {
	case '[':
		if err := json.Unmarshal(raw, &items); err != nil {
			return nil, nil, fmt.Errorf("RH_RPC_ENDPOINTS_FILE 数组无效: %w", err)
		}
	case '{':
		var envelope rpcFileEnvelope
		if err := json.Unmarshal(raw, &envelope); err != nil {
			return nil, nil, fmt.Errorf("RH_RPC_ENDPOINTS_FILE 对象无效: %w", err)
		}
		items = envelope.RPCs
		lag = envelope.SkipHistoryLag
	default:
		return nil, nil, fmt.Errorf("RH_RPC_ENDPOINTS_FILE 必须是 [{\"rpc\",\"qps\"}] 或 {\"skip_history_lag\",\"rpcs\"}")
	}
	endpoints, err := normalizeRPCItems(items)
	return endpoints, lag, err
}

func normalizeRPCItems(items []rpcFileItem) ([]RPCEndpoint, error) {
	if len(items) == 0 {
		return nil, fmt.Errorf("RH_RPC_ENDPOINTS_FILE 的 rpcs 不能为空")
	}
	if len(items) > maxRPCEndpoints {
		return nil, fmt.Errorf("RH_RPC_ENDPOINTS_FILE 最多 %d 条", maxRPCEndpoints)
	}
	out := make([]RPCEndpoint, 0, len(items))
	seen := make(map[string]struct{}, len(items))
	for i, item := range items {
		expanded := strings.TrimSpace(os.ExpandEnv(item.RPC))
		if expanded == "" || looksUnresolvedEnv(expanded) {
			continue
		}
		if err := validateRPCURL(expanded); err != nil {
			return nil, fmt.Errorf("第 %d 条 rpc 无效: %w", i+1, err)
		}
		if item.QPS < 1 || item.QPS > maxRPCQPS {
			return nil, fmt.Errorf("第 %d 条 qps 必须在 1..%d", i+1, maxRPCQPS)
		}
		if _, ok := seen[expanded]; ok {
			return nil, fmt.Errorf("第 %d 条 rpc 重复", i+1)
		}
		seen[expanded] = struct{}{}
		out = append(out, RPCEndpoint{URL: expanded, QPS: item.QPS})
	}
	return out, nil
}

// resolveSkipHistoryLag：环境变量优先，其次 JSON，缺省 100；0 表示永不跳过、始终补历史。
func resolveSkipHistoryLag(fromFile *int) (int, error) {
	if strings.TrimSpace(os.Getenv("RH_SKIP_HISTORY_LAG")) != "" {
		n, err := envInt("RH_SKIP_HISTORY_LAG", defaultSkipHistoryLag)
		if err != nil {
			return 0, err
		}
		if n < 0 {
			return 0, fmt.Errorf("RH_SKIP_HISTORY_LAG 不能为负数")
		}
		return n, nil
	}
	if fromFile != nil {
		if *fromFile < 0 {
			return 0, fmt.Errorf("skip_history_lag 不能为负数")
		}
		return *fromFile, nil
	}
	return defaultSkipHistoryLag, nil
}

func looksUnresolvedEnv(value string) bool {
	return strings.Contains(value, "${") && strings.Contains(value, "}")
}

func validateRPCURL(raw string) error {
	u, err := url.Parse(raw)
	if err != nil || (u.Scheme != "http" && u.Scheme != "https") || u.Host == "" {
		return fmt.Errorf("rpc 必须是有效的 http/https URL")
	}
	return nil
}
