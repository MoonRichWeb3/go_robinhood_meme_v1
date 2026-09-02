// 本文件严格解码 PoolManager.Swap，并以 Transfer 净额而非 Swap.sender 归因。
package v4fill

import (
	"fmt"
	"math/big"
	"strings"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/contracts"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

type TxContext struct {
	To, Hash             string
	BlockNumber, TxIndex uint64
	ChainTime            time.Time
	Logs                 []EventLog
}

// DecodeSwap 要求 poolId 已登记；quote 为 ERC-20 时按同一用户净额填 quote 腿。
func DecodeSwap(log EventLog, tx TxContext, pool domain.PoolRegistration, protocolAddresses []string) (domain.Fill, error) {
	fill := domain.Fill{
		Token: pool.Token, Category: pool.Category, Quote: pool.Quote,
		TokenDecimals: pool.TokenDecimals, QuoteDecimals: pool.QuoteDecimals,
		TxHash: strings.ToLower(tx.Hash), BlockNumber: tx.BlockNumber,
		TxIndex: tx.TxIndex, LogIndex: log.LogIndex, ChainTime: tx.ChainTime.UTC(),
		ProtocolContracts: append([]string(nil), protocolAddresses...),
	}
	if strings.ToLower(log.Address) != contracts.PoolManager || len(log.Topics) != 3 || strings.ToLower(log.Topics[0]) != contracts.TopicPoolSwap {
		return fill, fmt.Errorf("不是 PoolManager Swap")
	}
	if len(log.Data) != 192 {
		return fill, fmt.Errorf("Swap data 长度应为 192 字节")
	}
	id, err := domain.NormalizeHash(log.Topics[1], 32)
	if err != nil || id != strings.ToLower(pool.PoolID) {
		return fill, fmt.Errorf("Swap poolId 未登记或不匹配")
	}
	if _, err = topicAddress(log.Topics[2]); err != nil {
		return fill, err
	}
	amount0, err := signedInt128(log.Data[0:32])
	if err != nil {
		return fill, err
	}
	amount1, err := signedInt128(log.Data[32:64])
	if err != nil {
		return fill, err
	}
	if err = validateSwapTail(log.Data[64:]); err != nil {
		return fill, err
	}
	tokenDelta := amount1
	if currencyLess(pool.Token, pool.Quote) {
		tokenDelta = amount0
	}
	fill.Router = routerName(tx.To)
	memeTransfers, err := DecodeTransfers(tx.Logs, pool.Token)
	if err != nil {
		return fill, err
	}
	user, side, memeAmount, err := AttributeUser(memeTransfers, protocolAddresses)
	if err != nil {
		fill.AttributionWarning = err.Error()
		if fallbackErr := completeUnattributedFill(&fill, tx.Logs, pool, protocolAddresses, tokenDelta); fallbackErr != nil {
			return fill, err
		}
		return fill, nil
	}
	fill.User, fill.Side, fill.MemeAmountRaw = user, side, memeAmount.String()

	if pool.Quote != contracts.ZeroAddress {
		quoteTransfers, decodeErr := DecodeTransfers(tx.Logs, pool.Quote)
		if decodeErr != nil {
			return fill, decodeErr
		}
		if quoteAmount := netAmountFor(user, quoteTransfers); quoteAmount.Sign() > 0 {
			fill.QuoteAmountRaw = quoteAmount.String()
		}
	}
	expectedSide := "sell"
	if tokenDelta.Sign() < 0 {
		expectedSide = "buy"
	}
	if tokenDelta.Sign() != 0 && expectedSide != fill.Side {
		fill.AttributionWarning = "Swap amount 符号与 meme Transfer 净额方向不一致"
	}
	return fill, nil
}

// completeUnattributedFill 仅在单 Swap 且 ERC-20 quote Transfer 可唯一取量时保留双腿价格数据。
// 用户和方向保持为空，确保上层绝不会写 wallet_events；quote 不使用 Swap delta 推导。
func completeUnattributedFill(fill *domain.Fill, logs []EventLog, pool domain.PoolRegistration, protocolAddresses []string, tokenDelta *big.Int) error {
	if pool.Quote == contracts.ZeroAddress || tokenDelta.Sign() == 0 || countSwaps(logs) != 1 {
		return fmt.Errorf("归因失败后无法可靠取得单 Swap 的 ERC-20 双腿")
	}
	quoteTransfers, err := DecodeTransfers(logs, pool.Quote)
	if err != nil {
		return err
	}
	_, _, quoteAmount, err := AttributeUser(quoteTransfers, protocolAddresses)
	if err != nil || quoteAmount.Sign() == 0 {
		return fmt.Errorf("归因失败后 quote Transfer 无法唯一取量")
	}
	fill.MemeAmountRaw = new(big.Int).Abs(new(big.Int).Set(tokenDelta)).String()
	fill.QuoteAmountRaw = quoteAmount.String()
	return nil
}

func countSwaps(logs []EventLog) int {
	count := 0
	for _, event := range logs {
		if strings.ToLower(event.Address) == contracts.PoolManager &&
			len(event.Topics) > 0 && strings.ToLower(event.Topics[0]) == contracts.TopicPoolSwap {
			count++
		}
	}
	return count
}

func routerName(address string) string {
	switch strings.ToLower(address) {
	case contracts.GMGNRouter:
		return "gmgn"
	case contracts.UniversalRouter:
		return "universal_router"
	default:
		return "unknown"
	}
}

func currencyLess(a, b string) bool {
	return strings.ToLower(a) < strings.ToLower(b)
}

func signedInt128(word []byte) (*big.Int, error) {
	if len(word) != 32 {
		return nil, fmt.Errorf("int128 ABI word 长度无效")
	}
	negative := word[16]&0x80 != 0
	pad := byte(0)
	if negative {
		pad = 0xff
	}
	for _, b := range word[:16] {
		if b != pad {
			return nil, fmt.Errorf("int128 ABI 符号扩展无效")
		}
	}
	value := new(big.Int).SetBytes(word[16:])
	if negative {
		value.Sub(value, new(big.Int).Lsh(big.NewInt(1), 128))
	}
	return value, nil
}

func validateSwapTail(data []byte) error {
	if len(data) != 128 {
		return fmt.Errorf("Swap 尾部长度无效")
	}
	for _, b := range data[0:12] {
		if b != 0 {
			return fmt.Errorf("sqrtPriceX96 超出 uint160")
		}
	}
	for _, b := range data[32:48] {
		if b != 0 {
			return fmt.Errorf("liquidity 超出 uint128")
		}
	}
	if err := validateSigned24(data[64:96]); err != nil {
		return err
	}
	for _, b := range data[96:125] {
		if b != 0 {
			return fmt.Errorf("fee 超出 uint24")
		}
	}
	return nil
}

func validateSigned24(word []byte) error {
	negative := word[29]&0x80 != 0
	pad := byte(0)
	if negative {
		pad = 0xff
	}
	for _, b := range word[:29] {
		if b != pad {
			return fmt.Errorf("tick int24 符号扩展无效")
		}
	}
	return nil
}
