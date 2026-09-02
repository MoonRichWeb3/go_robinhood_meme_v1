package pons

import (
	"math/big"
	"testing"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/contracts"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

func TestDecodeCurveUsesRecipientAndEventAmounts(t *testing.T) {
	curve := "0x2222222222222222222222222222222222222222"
	token := "0x1111111111111111111111111111111111111111"
	user := "0x9999999999999999999999999999999999999999"
	data := make([]byte, 128)
	putUint(data[0:32], 300)
	putUint(data[32:64], 400)
	log := EventLog{Address: curve, Topics: []string{contracts.TopicPonsCurveBuy, addressTopic(contracts.PonsLaunchAndBuy), addressTopic(user)}, Data: data, LogIndex: 4}
	transfer := EventLog{Address: token, Topics: []string{contracts.TopicERC20Transfer, addressTopic(curve), addressTopic(user)}, Data: uintWord(400)}
	fill, err := DecodeCurve(log, TxContext{Hash: "0xabc", BlockNumber: 8, TxIndex: 2, ChainTime: time.Unix(10, 0), Logs: []EventLog{transfer}}, domain.CurveRegistration{Curve: curve, Token: token, Quote: contracts.USDGAddress, TokenDecimals: 18, QuoteDecimals: 6})
	if err != nil {
		t.Fatal(err)
	}
	if fill.User != user || fill.Side != "buy" || fill.QuoteAmountRaw != "300" || fill.MemeAmountRaw != "400" || fill.Router != "curve" {
		t.Fatalf("曲线 Fill 字段错误: %+v", fill)
	}
}

func TestDecodeGraduationRequiresMatchingInitialize(t *testing.T) {
	token := "0x1111111111111111111111111111111111111111"
	poolID := "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	graduated := EventLog{Address: contracts.PonsFactory, Topics: []string{contracts.TopicPonsGraduated, addressTopic(token)}, Data: make([]byte, 96)}
	initializeData := make([]byte, 160)
	initializeData[63] = 200
	copy(initializeData[76:96], mustAddressBytes(contracts.PonsMemeHook))
	initialize := EventLog{Address: contracts.PoolManager, Topics: []string{contracts.TopicPoolInitialize, poolID, addressTopic(token), addressTopic(contracts.USDGAddress)}, Data: initializeData}
	got, err := DecodeGraduation(graduated, TxContext{ChainTime: time.Unix(20, 0), Logs: []EventLog{initialize}})
	if err != nil {
		t.Fatal(err)
	}
	if got.Token != token || got.PoolID != poolID {
		t.Fatalf("毕业字段错误: %+v", got)
	}
	initialize.Data = initialize.Data[:159]
	if _, err = DecodeGraduation(graduated, TxContext{Logs: []EventLog{initialize}}); err == nil {
		t.Fatal("错误 Initialize 长度必须失败")
	}
}

func addressTopic(address string) string { return "0x000000000000000000000000" + address[2:] }

func putUint(word []byte, value int64) { big.NewInt(value).FillBytes(word) }

func uintWord(value int64) []byte {
	word := make([]byte, 32)
	putUint(word, value)
	return word
}

func mustAddressBytes(address string) []byte {
	word := make([]byte, 20)
	n := new(big.Int)
	n.SetString(address[2:], 16)
	n.FillBytes(word)
	return word
}
