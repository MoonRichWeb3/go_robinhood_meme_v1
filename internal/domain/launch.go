// 本文件定义四类发盘共同暴露的瘦目录契约。
package domain

import "time"

// LaunchIndexView 是各盘口向目录层暴露的稳定窄接口。
type LaunchIndexView interface {
	IndexToken() string
	IndexCategory() string
	IndexSymbol() string
	IndexName() string
	IndexPair() (string, string)
	IndexCreators() (string, string)
	IndexCreated() (time.Time, uint64, string)
}

// LaunchIndex 是统一列表所需字段，不承载盘口协议细节。
type LaunchIndex struct {
	TokenAddress, Category, Symbol, Name, PairSymbol, PairAddress string
	CreatorEOA, CreatorContract, TxHash, Status                   string
	CreatedAt, PriceAt                                            time.Time
	BlockNumber, PriceBlock                                       uint64
	PriceUSD                                                      *float64
	PriceTx                                                       string
}
