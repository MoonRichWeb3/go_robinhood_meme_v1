// 本文件仅定义后续阶段使用的 Long 盘口存储模型。
package domain

import "time"

// LongLaunch 仅定义未来 Long 盘口的独立存储模型；本期没有 venue 写入路径。
type LongLaunch struct {
	TokenAddress, Symbol, Name, QuoteAddress, QuoteSymbol, PoolID string
	QuoteDecimals                                                 uint8
	Fee                                                           uint64
	TickSpacing                                                   int64
	Hooks, TickerKey, PoolInitializer, Launcher, CreatorEOA       string
	Integrator, Airlock, InitialSupply, NumTokensToSell, TxHash   string
	DeployedAt, ReservedUntil                                     *time.Time
	BlockNumber, LogIndex                                         uint64
	CreatedAt                                                     time.Time
}

func (v LongLaunch) IndexToken() string              { return v.TokenAddress }
func (v LongLaunch) IndexCategory() string           { return "long" }
func (v LongLaunch) IndexSymbol() string             { return v.Symbol }
func (v LongLaunch) IndexName() string               { return v.Name }
func (v LongLaunch) IndexPair() (string, string)     { return v.QuoteAddress, v.QuoteSymbol }
func (v LongLaunch) IndexCreators() (string, string) { return v.CreatorEOA, v.Launcher }
func (v LongLaunch) IndexCreated() (time.Time, uint64, string) {
	return v.CreatedAt, v.BlockNumber, v.TxHash
}
