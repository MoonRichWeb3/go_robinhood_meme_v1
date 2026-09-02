// Package price 负责成交价精确换算、报价资产折 U 和展示价脏集合。
package price

import (
	"context"
	"errors"
	"fmt"
	"math"
	"math/big"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/store"
)

// ErrNoFeed 表示报价资产当前没有可靠美元价格，调用方必须持久化 NULL。
var ErrNoFeed = errors.New("缺少可靠美元喂价")

// AssetSource 查询报价资产类型与精度。
type AssetSource interface {
	GetQuoteAsset(context.Context, string) (store.QuoteAsset, error)
}

// ETHSource 提供内存 ETH/USD 快照，不允许在调用路径同步访问 HTTP。
type ETHSource interface {
	ETHUSD() (*big.Rat, error)
}

// Converter 使用本地资产目录和内存行情完成折 U。
type Converter struct {
	assets AssetSource
	eth    ETHSource
}

// NewConverter 创建成交价转换器。
func NewConverter(assets AssetSource, eth ETHSource) (*Converter, error) {
	if assets == nil || eth == nil {
		return nil, fmt.Errorf("价格转换器依赖不能为空")
	}
	return &Converter{assets: assets, eth: eth}, nil
}

// ExecQuotePerToken 根据两侧最小单位数量精确计算“一枚代币值多少 quote”。
func ExecQuotePerToken(memeRaw, quoteRaw string, tokenDecimals, quoteDecimals uint8) (*big.Rat, error) {
	meme, ok := new(big.Int).SetString(memeRaw, 10)
	if !ok || meme.Sign() <= 0 {
		return nil, fmt.Errorf("代币数量必须是正十进制整数")
	}
	quote, ok := new(big.Int).SetString(quoteRaw, 10)
	if !ok || quote.Sign() <= 0 {
		return nil, fmt.Errorf("报价数量必须是正十进制整数")
	}
	numerator := new(big.Int).Mul(quote, pow10(tokenDecimals))
	denominator := new(big.Int).Mul(meme, pow10(quoteDecimals))
	return new(big.Rat).SetFrac(numerator, denominator), nil
}

// QuoteUSD 返回一单位 quote 的美元价；USDG 固定为 1，未知和股票返回 ErrNoFeed。
func (c *Converter) QuoteUSD(ctx context.Context, quoteAddress string) (*big.Rat, error) {
	asset, err := c.assets.GetQuoteAsset(ctx, quoteAddress)
	if err != nil {
		return nil, fmt.Errorf("%w: %v", ErrNoFeed, err)
	}
	switch asset.Kind {
	case "usdg":
		return big.NewRat(1, 1), nil
	case "eth":
		return c.eth.ETHUSD()
	default:
		return nil, ErrNoFeed
	}
}

// ExecUSD 将精确 quote 成交价乘以报价资产美元价，并拒绝零、NaN 与无穷值。
func (c *Converter) ExecUSD(ctx context.Context, execQuote *big.Rat, quoteAddress string) (execUSD, quoteUSD *big.Rat, err error) {
	if execQuote == nil || execQuote.Sign() <= 0 {
		return nil, nil, fmt.Errorf("quote 成交价必须大于 0")
	}
	quoteUSD, err = c.QuoteUSD(ctx, quoteAddress)
	if err != nil {
		return nil, nil, err
	}
	if quoteUSD == nil || quoteUSD.Sign() <= 0 {
		return nil, nil, ErrNoFeed
	}
	execUSD = new(big.Rat).Mul(execQuote, quoteUSD)
	if _, err = RatFloat64(execUSD); err != nil {
		return nil, nil, err
	}
	return execUSD, quoteUSD, nil
}

// RatFloat64 将有理数转换成持久化 REAL 前检查有效性和正值。
func RatFloat64(value *big.Rat) (float64, error) {
	if value == nil || value.Sign() <= 0 {
		return 0, fmt.Errorf("价格必须大于 0")
	}
	out, _ := value.Float64()
	if out <= 0 || math.IsNaN(out) || math.IsInf(out, 0) {
		return 0, fmt.Errorf("价格无法安全转换为 float64")
	}
	return out, nil
}

func pow10(decimals uint8) *big.Int {
	return new(big.Int).Exp(big.NewInt(10), big.NewInt(int64(decimals)), nil)
}
