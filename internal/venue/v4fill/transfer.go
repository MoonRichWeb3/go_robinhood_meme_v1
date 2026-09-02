// Package v4fill 用 Swap 与同笔 ERC-20 Transfer 净额完成用户归因，不写数据库。
package v4fill

import (
	"fmt"
	"math/big"
	"strings"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/contracts"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

type EventLog struct {
	Address  string
	Topics   []string
	Data     []byte
	LogIndex uint64
}

type Transfer struct {
	Token, From, To string
	Amount          *big.Int
}

// DecodeTransfers 严格解码指定 ERC-20 的 Transfer；其它 token 和其它 topic 被忽略。
func DecodeTransfers(logs []EventLog, token string) ([]Transfer, error) {
	token, err := domain.NormalizeAddress(token)
	if err != nil {
		return nil, err
	}
	var out []Transfer
	for _, log := range logs {
		if strings.ToLower(log.Address) != token || len(log.Topics) == 0 || strings.ToLower(log.Topics[0]) != contracts.TopicERC20Transfer {
			continue
		}
		if len(log.Topics) != 3 || len(log.Data) != 32 {
			return nil, fmt.Errorf("Transfer topic/data 长度无效")
		}
		from, err := topicAddress(log.Topics[1])
		if err != nil {
			return nil, err
		}
		to, err := topicAddress(log.Topics[2])
		if err != nil {
			return nil, err
		}
		out = append(out, Transfer{Token: token, From: from, To: to, Amount: new(big.Int).SetBytes(log.Data)})
	}
	return out, nil
}

// AttributeUser 从 meme 净额中选出最大净流入或净流出的非协议地址；并列最大值视为无法可靠归因。
func AttributeUser(transfers []Transfer, protocolAddresses []string) (user, side string, amount *big.Int, err error) {
	excluded := map[string]bool{contracts.ZeroAddress: true}
	for _, address := range protocolAddresses {
		if normalized, normalizeErr := domain.NormalizeAddress(address); normalizeErr == nil {
			excluded[normalized] = true
		}
	}
	net := make(map[string]*big.Int)
	add := func(address string, delta *big.Int) {
		if net[address] == nil {
			net[address] = new(big.Int)
		}
		net[address].Add(net[address], delta)
	}
	for _, transfer := range transfers {
		if transfer.Amount == nil || transfer.Amount.Sign() < 0 {
			return "", "", nil, fmt.Errorf("Transfer amount 无效")
		}
		from, fromErr := domain.NormalizeAddress(transfer.From)
		to, toErr := domain.NormalizeAddress(transfer.To)
		if fromErr != nil || toErr != nil {
			return "", "", nil, fmt.Errorf("Transfer 地址无效")
		}
		if from != contracts.ZeroAddress {
			add(from, new(big.Int).Neg(transfer.Amount))
		}
		if to != contracts.ZeroAddress {
			add(to, new(big.Int).Set(transfer.Amount))
		}
	}
	var bestAbs = new(big.Int)
	tied := false
	var bestNet *big.Int
	for address, value := range net {
		if excluded[address] || value.Sign() == 0 {
			continue
		}
		absolute := new(big.Int).Abs(value)
		switch absolute.Cmp(bestAbs) {
		case 1:
			user, bestAbs, bestNet, tied = address, absolute, new(big.Int).Set(value), false
		case 0:
			tied = true
		}
	}
	if user == "" || tied {
		return "", "", nil, fmt.Errorf("无法从 meme Transfer 唯一归因用户")
	}
	if bestNet.Sign() > 0 {
		side = "buy"
	} else {
		side = "sell"
	}
	return user, side, bestAbs, nil
}

func netAmountFor(address string, transfers []Transfer) *big.Int {
	out := new(big.Int)
	for _, transfer := range transfers {
		if transfer.To == address {
			out.Add(out, transfer.Amount)
		}
		if transfer.From == address {
			out.Sub(out, transfer.Amount)
		}
	}
	return new(big.Int).Abs(out)
}

func topicAddress(topic string) (string, error) {
	topic = strings.TrimPrefix(strings.ToLower(topic), "0x")
	if len(topic) != 64 {
		return "", fmt.Errorf("indexed address topic 长度应为 32 字节")
	}
	return domain.NormalizeAddress(topic[24:])
}
