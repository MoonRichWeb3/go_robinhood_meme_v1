// 本文件定义跨盘口共享的成交腿领域对象。
package domain

import "time"

// Fill 表示已归因的一条盘口无关成交腿；原始数量使用十进制文本避免 wei 精度损失。
type Fill struct {
	Token, Category, Quote, User, Side, Router, TxHash string
	AttributionWarning                                 string
	MemeAmountRaw, QuoteAmountRaw                      string
	TokenDecimals, QuoteDecimals                       uint8
	BlockNumber, TxIndex, LogIndex                     uint64
	ChainTime                                          time.Time
	ProtocolContracts                                  []string
}

// PoolRegistration 是从发盘表重建的 v4 池归因元数据。
type PoolRegistration struct {
	PoolID, Token, Category, Quote string
	TokenDecimals, QuoteDecimals   uint8
}

// CurveRegistration 是从 Pons 发盘表重建的曲线归因元数据。
type CurveRegistration struct {
	Curve, Token, Quote string
	TokenDecimals       uint8
	QuoteDecimals       uint8
}
