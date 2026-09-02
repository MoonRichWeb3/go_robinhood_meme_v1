// 本文件把 Pons CurveBuy/CurveSell 严格转换为盘口无关 Fill。
package pons

import (
	"fmt"
	"strings"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/contracts"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

// DecodeCurve 只接受已登记曲线；recipient 是用户，buyer/seller 不作为归因结果。
func DecodeCurve(log EventLog, tx TxContext, registration domain.CurveRegistration) (domain.Fill, error) {
	if strings.ToLower(log.Address) != strings.ToLower(registration.Curve) {
		return domain.Fill{}, fmt.Errorf("曲线地址与登记不一致")
	}
	if len(log.Topics) != 3 || len(log.Data) != 128 {
		return domain.Fill{}, fmt.Errorf("CurveBuy/Sell topic/data 长度无效")
	}
	topic := strings.ToLower(log.Topics[0])
	if topic != contracts.TopicPonsCurveBuy && topic != contracts.TopicPonsCurveSell {
		return domain.Fill{}, fmt.Errorf("不是 Pons 曲线成交")
	}
	user, err := addressFromTopic(log.Topics[2])
	if err != nil {
		return domain.Fill{}, err
	}
	fill := domain.Fill{
		Token: registration.Token, Category: "pons", Quote: registration.Quote,
		User: user, Router: "curve", TxHash: strings.ToLower(tx.Hash),
		TokenDecimals: registration.TokenDecimals, QuoteDecimals: registration.QuoteDecimals,
		BlockNumber: tx.BlockNumber, TxIndex: tx.TxIndex, LogIndex: log.LogIndex,
		ChainTime: tx.ChainTime.UTC(), ProtocolContracts: []string{registration.Curve},
	}
	if topic == contracts.TopicPonsCurveBuy {
		fill.Side = "buy"
		fill.QuoteAmountRaw = wordUint(log.Data[0:32]).String()
		fill.MemeAmountRaw = wordUint(log.Data[32:64]).String()
		if warning, err := verifyBuyTransfer(tx.Logs, registration.Token, user); err != nil {
			return domain.Fill{}, err
		} else {
			fill.AttributionWarning = warning
		}
	} else {
		fill.Side = "sell"
		fill.MemeAmountRaw = wordUint(log.Data[0:32]).String()
		fill.QuoteAmountRaw = wordUint(log.Data[32:64]).String()
	}
	return fill, nil
}

func verifyBuyTransfer(logs []EventLog, token, recipient string) (string, error) {
	foundTokenTransfer, matched := false, false
	for _, log := range logs {
		if strings.ToLower(log.Address) != strings.ToLower(token) || len(log.Topics) == 0 || strings.ToLower(log.Topics[0]) != contracts.TopicERC20Transfer {
			continue
		}
		foundTokenTransfer = true
		if len(log.Topics) != 3 || len(log.Data) != 32 {
			return "", fmt.Errorf("meme Transfer topic/data 长度无效")
		}
		to, err := addressFromTopic(log.Topics[2])
		if err != nil {
			return "", err
		}
		if to == recipient {
			matched = true
		}
	}
	if foundTokenTransfer && !matched {
		return "CurveBuy recipient 与 meme Transfer.to 不一致", nil
	}
	return "", nil
}
