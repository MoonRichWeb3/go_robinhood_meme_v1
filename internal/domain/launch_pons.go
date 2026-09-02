// 本文件定义 Pons 独立发盘模型及目录映射。
package domain

import "time"

// PonsLaunch 保存 Pons 创建与毕业状态，不包含展示价格。
type PonsLaunch struct {
	TokenAddress, Symbol, Name, Logo, Description, CurveAddress string
	PairAddress, PairSymbol                                     string
	PairDecimals                                                uint8
	LaunchConfigID, GraduationThreshold, FirstBuyQuote          string
	Deployer, CreatorEOA, CreatorFeeRecipient, LaunchEntry      string
	FirstBuyTokens, Phase, PoolID, TxHash                       string
	GraduatedAt                                                 *time.Time
	BlockNumber, LogIndex                                       uint64
	CreatedAt                                                   time.Time
}

func (v PonsLaunch) IndexToken() string              { return v.TokenAddress }
func (v PonsLaunch) IndexCategory() string           { return "pons" }
func (v PonsLaunch) IndexSymbol() string             { return v.Symbol }
func (v PonsLaunch) IndexName() string               { return v.Name }
func (v PonsLaunch) IndexPair() (string, string)     { return v.PairAddress, v.PairSymbol }
func (v PonsLaunch) IndexCreators() (string, string) { return v.CreatorEOA, v.Deployer }
func (v PonsLaunch) IndexCreated() (time.Time, uint64, string) {
	return v.CreatedAt, v.BlockNumber, v.TxHash
}
