// Package domain 定义与基础设施无关的地址、成交、发盘、FIFO 与评分规则。
package domain

import (
	"encoding/hex"
	"fmt"
	"strings"

	"github.com/ethereum/go-ethereum/common"
)

// NormalizeAddress 把 20 字节十六进制地址规范为小写 0x 形式。
func NormalizeAddress(value string) (string, error) {
	value = strings.TrimSpace(value)
	if !strings.HasPrefix(strings.ToLower(value), "0x") {
		value = "0x" + value
	}
	if !common.IsHexAddress(value) || len(value) != 42 {
		return "", fmt.Errorf("地址必须包含 40 个十六进制字符")
	}
	return strings.ToLower(common.HexToAddress(value).Hex()), nil
}

// NormalizeHash 把指定字节长度的十六进制值规范为小写 0x 形式。
func NormalizeHash(value string, bytes int) (string, error) {
	value = strings.TrimSpace(value)
	if !strings.HasPrefix(strings.ToLower(value), "0x") {
		value = "0x" + value
	}
	if len(value) != 2+bytes*2 {
		return "", fmt.Errorf("十六进制值长度应为 %d 字节", bytes)
	}
	if _, err := hex.DecodeString(value[2:]); err != nil {
		return "", fmt.Errorf("十六进制值无效: %w", err)
	}
	return strings.ToLower(value), nil
}
