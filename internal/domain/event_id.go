// 本文件定义交易事件自然主键的稳定拼接规则。
package domain

import "fmt"

// CalcEventID 按块高、交易下标、日志下标拼接自然键；超宽时保留完整数字并返回错误。
func CalcEventID(blockNumber, txIndex, logIndex uint64) (string, error) {
	id := fmt.Sprintf("%08d%04d%04d", blockNumber, txIndex, logIndex)
	if blockNumber > 99999999 || txIndex > 9999 || logIndex > 9999 {
		return id, fmt.Errorf("主键超宽: block=%d tx=%d log=%d", blockNumber, txIndex, logIndex)
	}
	return id, nil
}
