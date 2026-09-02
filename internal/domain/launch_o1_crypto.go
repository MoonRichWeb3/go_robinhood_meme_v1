// 本文件定义 o1 加密盘口的独立发盘模型及目录映射。
package domain

import "time"

// O1CryptoLaunch 保存 o1 加密工厂创建字段，不与股票盘口共用模型。
type O1CryptoLaunch struct {
	TokenAddress, Symbol, Name, ContractURI, QuoteAddress, QuoteSymbol  string
	QuoteDecimals                                                       uint8
	PoolID                                                              string
	TickSpacing                                                         int64
	Hooks, Supply, CreatorEOA, CreatorEvent, NativeLaunchFeeWei, TxHash string
	HookWarning                                                         string
	BlockNumber, LogIndex                                               uint64
	CreatedAt                                                           time.Time
}

func (v O1CryptoLaunch) IndexToken() string              { return v.TokenAddress }
func (v O1CryptoLaunch) IndexCategory() string           { return "o1_crypto" }
func (v O1CryptoLaunch) IndexSymbol() string             { return v.Symbol }
func (v O1CryptoLaunch) IndexName() string               { return v.Name }
func (v O1CryptoLaunch) IndexPair() (string, string)     { return v.QuoteAddress, v.QuoteSymbol }
func (v O1CryptoLaunch) IndexCreators() (string, string) { return v.CreatorEOA, v.CreatorEvent }
func (v O1CryptoLaunch) IndexCreated() (time.Time, uint64, string) {
	return v.CreatedAt, v.BlockNumber, v.TxHash
}
