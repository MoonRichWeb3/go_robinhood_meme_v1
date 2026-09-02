// 本文件仅定义后续阶段使用的 o1 股票盘口存储模型。
package domain

import "time"

// O1StockLaunch 仅定义未来股票盘口的独立存储模型；本期没有 venue 写入路径。
type O1StockLaunch struct {
	TokenAddress, Symbol, Name, ContractURI, QuoteAddress, QuoteSymbol  string
	QuoteDecimals                                                       uint8
	PoolID                                                              string
	TickSpacing                                                         int64
	Hooks, Supply, CreatorEOA, CreatorEvent, NativeLaunchFeeWei, TxHash string
	Anomaly                                                             bool
	BlockNumber, LogIndex                                               uint64
	CreatedAt                                                           time.Time
}

func (v O1StockLaunch) IndexToken() string              { return v.TokenAddress }
func (v O1StockLaunch) IndexCategory() string           { return "o1_stock" }
func (v O1StockLaunch) IndexSymbol() string             { return v.Symbol }
func (v O1StockLaunch) IndexName() string               { return v.Name }
func (v O1StockLaunch) IndexPair() (string, string)     { return v.QuoteAddress, v.QuoteSymbol }
func (v O1StockLaunch) IndexCreators() (string, string) { return v.CreatorEOA, v.CreatorEvent }
func (v O1StockLaunch) IndexCreated() (time.Time, uint64, string) {
	return v.CreatedAt, v.BlockNumber, v.TxHash
}
