// 本文件关联 Pons PoolGraduated 与同笔 v4 Initialize，拒绝臆造事件中不存在的 poolId。
package pons

import (
	"fmt"
	"strings"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/contracts"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

type Graduation struct {
	Token, PoolID   string
	PositionID      string
	TokenAmount     string
	PairTokenAmount string
	GraduatedAt     time.Time
}

// DecodeGraduation 要求同笔 Initialize 的币对包含 token 且 hooks 为 PonsMemeHook。
func DecodeGraduation(log EventLog, tx TxContext) (Graduation, error) {
	if strings.ToLower(log.Address) != contracts.PonsFactory || len(log.Topics) != 2 || strings.ToLower(log.Topics[0]) != contracts.TopicPonsGraduated {
		return Graduation{}, fmt.Errorf("不是 Pons PoolGraduated")
	}
	if len(log.Data) != 96 {
		return Graduation{}, fmt.Errorf("PoolGraduated data 长度应为 96 字节")
	}
	token, err := addressFromTopic(log.Topics[1])
	if err != nil {
		return Graduation{}, err
	}
	poolID, err := findPonsInitialize(tx.Logs, token)
	if err != nil {
		return Graduation{}, err
	}
	return Graduation{
		Token: token, PoolID: poolID,
		PositionID:      wordUint(log.Data[0:32]).String(),
		TokenAmount:     wordUint(log.Data[32:64]).String(),
		PairTokenAmount: wordUint(log.Data[64:96]).String(),
		GraduatedAt:     tx.ChainTime.UTC(),
	}, nil
}

func findPonsInitialize(logs []EventLog, token string) (string, error) {
	for _, log := range logs {
		if strings.ToLower(log.Address) != contracts.PoolManager || len(log.Topics) == 0 || strings.ToLower(log.Topics[0]) != contracts.TopicPoolInitialize {
			continue
		}
		if len(log.Topics) != 4 || len(log.Data) != 160 {
			return "", fmt.Errorf("Initialize topic/data 长度无效")
		}
		currency0, err := addressFromTopic(log.Topics[2])
		if err != nil {
			return "", err
		}
		currency1, err := addressFromTopic(log.Topics[3])
		if err != nil {
			return "", err
		}
		hook, err := addressFromWord(log.Data[64:96])
		if err != nil {
			return "", err
		}
		fee, err := uint24(log.Data[0:32])
		if err != nil {
			return "", err
		}
		spacing, err := int24(log.Data[32:64])
		if err != nil {
			return "", err
		}
		if hook != contracts.PonsMemeHook || fee != 0 || spacing != 200 || (currency0 != token && currency1 != token) {
			continue
		}
		return domain.NormalizeHash(log.Topics[1], 32)
	}
	return "", fmt.Errorf("PoolGraduated 同笔缺少匹配 Pons hook 的 Initialize")
}

func uint24(word []byte) (uint32, error) {
	if len(word) != 32 {
		return 0, fmt.Errorf("uint24 ABI word 长度无效")
	}
	for _, b := range word[:29] {
		if b != 0 {
			return 0, fmt.Errorf("uint24 ABI 高位非零")
		}
	}
	return uint32(word[29])<<16 | uint32(word[30])<<8 | uint32(word[31]), nil
}

func int24(word []byte) (int32, error) {
	if len(word) != 32 {
		return 0, fmt.Errorf("int24 ABI word 长度无效")
	}
	negative := word[29]&0x80 != 0
	pad := byte(0)
	if negative {
		pad = 0xff
	}
	for _, b := range word[:29] {
		if b != pad {
			return 0, fmt.Errorf("int24 ABI 符号扩展无效")
		}
	}
	value := int32(word[29])<<16 | int32(word[30])<<8 | int32(word[31])
	if negative {
		value -= 1 << 24
	}
	return value, nil
}
