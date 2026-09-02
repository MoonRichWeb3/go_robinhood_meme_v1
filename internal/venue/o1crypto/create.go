// Package o1crypto 只解码 Robinhood 上 o1 加密配对工厂，不包含股票盘口逻辑。
package o1crypto

import (
	"fmt"
	"math/big"
	"strings"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/contracts"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

type EventLog struct {
	Address  string
	Topics   []string
	Data     []byte
	LogIndex uint64
}

type TxContext struct {
	From, Hash, Value    string
	BlockNumber, TxIndex uint64
	ChainTime            time.Time
	Logs                 []EventLog
}

// DecodeCreate 解码 Factory.Launched，并用同笔 Initialize 校验池币对、tickSpacing 和加密 Hook。
func DecodeCreate(log EventLog, tx TxContext) (domain.O1CryptoLaunch, error) {
	if strings.ToLower(log.Address) != contracts.O1CryptoFactory || len(log.Topics) != 4 || strings.ToLower(log.Topics[0]) != contracts.TopicO1Launched {
		return domain.O1CryptoLaunch{}, fmt.Errorf("不是 o1 加密 Launched")
	}
	if len(log.Data) != 96 {
		return domain.O1CryptoLaunch{}, fmt.Errorf("Launched data 长度应为 96 字节")
	}
	token, err := topicAddress(log.Topics[1])
	if err != nil {
		return domain.O1CryptoLaunch{}, err
	}
	poolID, err := domain.NormalizeHash(log.Topics[2], 32)
	if err != nil {
		return domain.O1CryptoLaunch{}, err
	}
	creatorEvent, err := topicAddress(log.Topics[3])
	if err != nil {
		return domain.O1CryptoLaunch{}, err
	}
	quote, err := wordAddress(log.Data[0:32])
	if err != nil {
		return domain.O1CryptoLaunch{}, err
	}
	tickSpacing, err := signedInt24(log.Data[64:96])
	if err != nil {
		return domain.O1CryptoLaunch{}, err
	}
	hook, hookWarning, err := validateInitialize(tx.Logs, poolID, token, quote, tickSpacing)
	if err != nil {
		return domain.O1CryptoLaunch{}, err
	}
	creatorEOA, err := domain.NormalizeAddress(tx.From)
	if err != nil {
		return domain.O1CryptoLaunch{}, err
	}
	symbol, decimals := quoteMetadata(quote)
	return domain.O1CryptoLaunch{
		TokenAddress: token, QuoteAddress: quote, QuoteSymbol: symbol, QuoteDecimals: decimals,
		PoolID: poolID, TickSpacing: tickSpacing, Hooks: hook,
		Supply:     new(big.Int).SetBytes(log.Data[32:64]).String(),
		CreatorEOA: creatorEOA, CreatorEvent: creatorEvent,
		NativeLaunchFeeWei: tx.Value, BlockNumber: tx.BlockNumber,
		TxHash: strings.ToLower(tx.Hash), HookWarning: hookWarning,
		LogIndex: log.LogIndex, CreatedAt: tx.ChainTime.UTC(),
	}, nil
}

func validateInitialize(logs []EventLog, poolID, token, quote string, tickSpacing int64) (string, string, error) {
	for _, log := range logs {
		if strings.ToLower(log.Address) != contracts.PoolManager || len(log.Topics) == 0 || strings.ToLower(log.Topics[0]) != contracts.TopicPoolInitialize {
			continue
		}
		if len(log.Topics) != 4 || len(log.Data) != 160 {
			return "", "", fmt.Errorf("Initialize topic/data 长度无效")
		}
		id, err := domain.NormalizeHash(log.Topics[1], 32)
		if err != nil {
			return "", "", err
		}
		if id != poolID {
			continue
		}
		currency0, err := topicAddress(log.Topics[2])
		if err != nil {
			return "", "", err
		}
		currency1, err := topicAddress(log.Topics[3])
		if err != nil {
			return "", "", err
		}
		if !((currency0 == token && currency1 == quote) || (currency0 == quote && currency1 == token)) {
			return "", "", fmt.Errorf("Initialize 币对与 Launched 不一致")
		}
		fee, err := uint24(log.Data[0:32])
		if err != nil {
			return "", "", err
		}
		if fee != 0 {
			return "", "", fmt.Errorf("o1 加密池 fee 应为 0")
		}
		initSpacing, err := signedInt24(log.Data[32:64])
		if err != nil {
			return "", "", err
		}
		if initSpacing != tickSpacing {
			return "", "", fmt.Errorf("Initialize tickSpacing 与 Launched 不一致")
		}
		hook, err := wordAddress(log.Data[64:96])
		if err != nil {
			return "", "", err
		}
		if hook != contracts.O1CryptoHook {
			return hook, "o1 加密池 hooks 与目录不匹配", nil
		}
		return hook, "", nil
	}
	return "", "", fmt.Errorf("Launched 同笔缺少对应 Initialize")
}

func signedInt24(word []byte) (int64, error) {
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
	value := int64(word[29])<<16 | int64(word[30])<<8 | int64(word[31])
	if negative {
		value -= 1 << 24
	}
	return value, nil
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

func topicAddress(topic string) (string, error) {
	topic = strings.TrimPrefix(strings.ToLower(topic), "0x")
	if len(topic) != 64 {
		return "", fmt.Errorf("indexed address topic 长度应为 32 字节")
	}
	return domain.NormalizeAddress(topic[24:])
}

func wordAddress(word []byte) (string, error) {
	if len(word) != 32 {
		return "", fmt.Errorf("address ABI word 长度无效")
	}
	for _, b := range word[:12] {
		if b != 0 {
			return "", fmt.Errorf("address ABI word 高位非零")
		}
	}
	return domain.NormalizeAddress(fmt.Sprintf("%x", word[12:]))
}

func quoteMetadata(address string) (string, uint8) {
	switch address {
	case contracts.ZeroAddress:
		return "ETH", 18
	case contracts.WETHAddress:
		return "WETH", 18
	case contracts.USDGAddress:
		return "USDG", 6
	default:
		return "UNKNOWN", 0
	}
}
