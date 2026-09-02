// Package pons 严格解码 Pons V2 创建、曲线成交与毕业事件，不执行数据库写入。
package pons

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
	From, To, Hash, Value string
	BlockNumber, TxIndex  uint64
	ChainTime             time.Time
	Logs                  []EventLog
}

// DecodeCreate 解码 Factory.TokenLaunched，并从同笔 LaunchAndBuy.Launched 补首买字段。
func DecodeCreate(log EventLog, tx TxContext) (domain.PonsLaunch, error) {
	if strings.ToLower(log.Address) != contracts.PonsFactory || len(log.Topics) != 4 || strings.ToLower(log.Topics[0]) != contracts.TopicPonsTokenLaunched {
		return domain.PonsLaunch{}, fmt.Errorf("不是 Pons TokenLaunched")
	}
	if len(log.Data) != 96 {
		return domain.PonsLaunch{}, fmt.Errorf("TokenLaunched data 长度应为 96 字节")
	}
	token, err := addressFromTopic(log.Topics[1])
	if err != nil {
		return domain.PonsLaunch{}, err
	}
	curve, err := addressFromTopic(log.Topics[2])
	if err != nil {
		return domain.PonsLaunch{}, err
	}
	deployer, err := addressFromTopic(log.Topics[3])
	if err != nil {
		return domain.PonsLaunch{}, err
	}
	pair, err := addressFromWord(log.Data[0:32])
	if err != nil {
		return domain.PonsLaunch{}, err
	}
	creator, err := domain.NormalizeAddress(tx.From)
	if err != nil {
		return domain.PonsLaunch{}, err
	}
	entry := "factory"
	if strings.ToLower(tx.To) == contracts.PonsLaunchAndBuy {
		entry = "launch_and_buy"
	}
	pairSymbol, pairDecimals := quoteMetadata(pair)
	out := domain.PonsLaunch{
		TokenAddress: token, CurveAddress: curve, PairAddress: pair,
		PairSymbol: pairSymbol, PairDecimals: pairDecimals,
		LaunchConfigID:      wordUint(log.Data[32:64]).String(),
		GraduationThreshold: wordUint(log.Data[64:96]).String(),
		Deployer:            deployer, CreatorEOA: creator, LaunchEntry: entry,
		FirstBuyQuote: "0", FirstBuyTokens: "0", Phase: "curve",
		BlockNumber: tx.BlockNumber, TxHash: strings.ToLower(tx.Hash),
		LogIndex: log.LogIndex, CreatedAt: tx.ChainTime.UTC(),
	}
	for _, candidate := range tx.Logs {
		quote, tokens, ok, err := decodeLaunchAndBuy(candidate, token, curve)
		if err != nil {
			return domain.PonsLaunch{}, err
		}
		if ok {
			out.FirstBuyQuote, out.FirstBuyTokens = quote, tokens
			break
		}
	}
	return out, nil
}

func decodeLaunchAndBuy(log EventLog, token, curve string) (string, string, bool, error) {
	if strings.ToLower(log.Address) != contracts.PonsLaunchAndBuy || len(log.Topics) == 0 || strings.ToLower(log.Topics[0]) != contracts.TopicPonsLaunched {
		return "", "", false, nil
	}
	if len(log.Topics) != 4 || len(log.Data) != 96 {
		return "", "", false, fmt.Errorf("Launched topic/data 长度无效")
	}
	gotToken, err := addressFromTopic(log.Topics[1])
	if err != nil {
		return "", "", false, err
	}
	gotCurve, err := addressFromTopic(log.Topics[2])
	if err != nil {
		return "", "", false, err
	}
	if gotToken != token || gotCurve != curve {
		return "", "", false, nil
	}
	return wordUint(log.Data[32:64]).String(), wordUint(log.Data[64:96]).String(), true, nil
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

func addressFromTopic(topic string) (string, error) {
	topic = strings.TrimPrefix(strings.ToLower(topic), "0x")
	if len(topic) != 64 {
		return "", fmt.Errorf("indexed address topic 长度应为 32 字节")
	}
	return domain.NormalizeAddress(topic[24:])
}

func addressFromWord(word []byte) (string, error) {
	if len(word) != 32 {
		return "", fmt.Errorf("ABI word 长度应为 32 字节")
	}
	for _, b := range word[:12] {
		if b != 0 {
			return "", fmt.Errorf("address ABI word 高位非零")
		}
	}
	return domain.NormalizeAddress(fmt.Sprintf("%x", word[12:]))
}

func wordUint(word []byte) *big.Int { return new(big.Int).SetBytes(word) }
