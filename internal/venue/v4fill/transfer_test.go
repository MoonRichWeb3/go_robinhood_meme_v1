package v4fill

import (
	"math/big"
	"testing"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/contracts"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

func TestDecodeSwapAttributesGMGNUserAndNetAmounts(t *testing.T) {
	token := "0x1111111111111111111111111111111111111111"
	quote := "0x2222222222222222222222222222222222222222"
	user := "0x9999999999999999999999999999999999999999"
	poolID := "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	logs := []EventLog{
		transferLog(token, contracts.PoolManager, user, 100),
		transferLog(quote, user, contracts.PoolManager, 250),
	}
	swapData := make([]byte, 192)
	putSigned128(swapData[0:32], -100)
	putSigned128(swapData[32:64], 250)
	swapData[95] = 1
	swap := EventLog{Address: contracts.PoolManager, Topics: []string{contracts.TopicPoolSwap, poolID, addressTopic(contracts.UniversalRouter)}, Data: swapData, LogIndex: 12}
	registration := domain.PoolRegistration{PoolID: poolID, Token: token, Quote: quote, Category: "o1_crypto", TokenDecimals: 18, QuoteDecimals: 6}
	fill, err := DecodeSwap(swap, TxContext{To: contracts.GMGNRouter, Hash: "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb", BlockNumber: 5, TxIndex: 1, ChainTime: time.Unix(100, 0), Logs: logs}, registration, []string{contracts.PoolManager, contracts.UniversalRouter, contracts.GMGNRouter})
	if err != nil {
		t.Fatal(err)
	}
	if fill.User != user || fill.Side != "buy" || fill.Router != "gmgn" ||
		fill.MemeAmountRaw != "100" || fill.QuoteAmountRaw != "250" ||
		fill.LogIndex != 12 || fill.AttributionWarning != "" {
		t.Fatalf("Fill 字段错误: %+v", fill)
	}
}

func TestDecodeTransfersRejectsWrongLength(t *testing.T) {
	log := transferLog("0x1111111111111111111111111111111111111111", contracts.PoolManager, "0x9999999999999999999999999999999999999999", 1)
	log.Data = log.Data[:31]
	if _, err := DecodeTransfers([]EventLog{log}, log.Address); err == nil {
		t.Fatal("错误 Transfer data 长度必须失败")
	}
}

func TestDecodeSwapKeepsReliableLegsWithoutAttribution(t *testing.T) {
	token := "0x1111111111111111111111111111111111111111"
	quote := "0x2222222222222222222222222222222222222222"
	userA := "0x7777777777777777777777777777777777777777"
	userB := "0x8888888888888888888888888888888888888888"
	poolID := "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	swapData := make([]byte, 192)
	putSigned128(swapData[0:32], -100)
	putSigned128(swapData[32:64], 999) // quote delta 故意不同，确保实现不拿它伪造 quote。
	swapData[95] = 1
	swap := EventLog{
		Address: contracts.PoolManager,
		Topics:  []string{contracts.TopicPoolSwap, poolID, addressTopic(contracts.UniversalRouter)},
		Data:    swapData,
	}
	logs := []EventLog{
		swap,
		transferLog(token, contracts.PoolManager, userA, 100),
		transferLog(token, contracts.PoolManager, userB, 100),
		transferLog(quote, userA, contracts.PoolManager, 250),
	}
	registration := domain.PoolRegistration{
		PoolID: poolID, Token: token, Quote: quote, Category: "o1_crypto",
		TokenDecimals: 18, QuoteDecimals: 6,
	}
	fill, err := DecodeSwap(swap, TxContext{To: contracts.UniversalRouter, Hash: "0xbb", Logs: logs}, registration,
		[]string{contracts.PoolManager, contracts.UniversalRouter})
	if err != nil {
		t.Fatal(err)
	}
	if fill.User != "" || fill.Side != "" || fill.MemeAmountRaw != "100" ||
		fill.QuoteAmountRaw != "250" || fill.AttributionWarning == "" {
		t.Fatalf("无归因双腿 Fill 错误: %+v", fill)
	}

	logs = append(logs, swap)
	if _, err = DecodeSwap(swap, TxContext{To: contracts.UniversalRouter, Hash: "0xbb", Logs: logs}, registration,
		[]string{contracts.PoolManager, contracts.UniversalRouter}); err == nil {
		t.Fatal("多 Swap 不得进行无归因分摊")
	}
}

func transferLog(token, from, to string, amount int64) EventLog {
	data := make([]byte, 32)
	big.NewInt(amount).FillBytes(data)
	return EventLog{Address: token, Topics: []string{contracts.TopicERC20Transfer, addressTopic(from), addressTopic(to)}, Data: data}
}

func addressTopic(address string) string {
	return "0x000000000000000000000000" + address[2:]
}

func putSigned128(word []byte, value int64) {
	n := big.NewInt(value)
	if value < 0 {
		for i := range word {
			word[i] = 0xff
		}
		n.Add(n, new(big.Int).Lsh(big.NewInt(1), 128))
	}
	n.FillBytes(word[16:])
}
