// 本文件实现钱包流水查询，并从保留窗内买卖现算每笔卖出的 FIFO 盈亏。
package httpsvc

import (
	"math/big"
	"net/http"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
	"github.com/zeromicro/go-zero/rest/httpx"
	"github.com/zeromicro/go-zero/rest/pathvar"
)

type amountView struct {
	QuoteRaw      string `json:"quote_raw"`
	QuoteDecimals *uint8 `json:"quote_decimals"`
	TokenRaw      string `json:"token_raw"`
	TokenDecimals *uint8 `json:"token_decimals"`
}

type walletEventItem struct {
	ID              string     `json:"id"`
	Kind            string     `json:"kind"`
	Category        string     `json:"category"`
	Token           string     `json:"token"`
	Direction       string     `json:"direction"`
	TxHash          string     `json:"tx_hash"`
	Amounts         amountView `json:"amounts"`
	ExecUSDPerToken *float64   `json:"exec_usd_per_token"`
	RealizedPnLUSD  *float64   `json:"realized_pnl_usd"`
	ChainTime       time.Time  `json:"chain_time"`
}

type walletEventList struct {
	Items []walletEventItem `json:"items"`
}

func (s *Server) walletEvents(w http.ResponseWriter, r *http.Request) {
	limit, err := parseLimit(r.URL.Query().Get("limit"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "bad_request", err.Error())
		return
	}
	kind := r.URL.Query().Get("kind")
	if kind != "" && kind != "launch" && kind != "buy" && kind != "sell" {
		writeError(w, http.StatusBadRequest, "bad_request", "kind 仅支持 launch、buy 或 sell")
		return
	}
	wallet, err := domain.NormalizeAddress(pathvar.Vars(r)["address"])
	if err != nil {
		writeError(w, http.StatusBadRequest, "bad_request", "钱包地址无效")
		return
	}
	rows, err := s.store.ListWalletEvents(r.Context(), wallet, kind, limit)
	if err != nil {
		queryFailed(s, w, map[string]any{"路径": "/wallets/:address/events", "错误": err})
		return
	}
	pnl := make(map[string]*float64)
	loaded := make(map[string]bool)
	response := walletEventList{Items: make([]walletEventItem, 0, len(rows))}
	for _, row := range rows {
		if row.Kind == "sell" && !loaded[row.TokenAddress] {
			loaded[row.TokenAddress] = true
			fifo, fifoErr := s.store.FIFOEvents(r.Context(), wallet, row.TokenAddress)
			if fifoErr != nil {
				queryFailed(s, w, map[string]any{"路径": "/wallets/:address/events", "错误": fifoErr})
				return
			}
			results, replayErr := domain.ReplayFIFO(fifo)
			if replayErr != nil {
				queryFailed(s, w, map[string]any{"路径": "/wallets/:address/events", "错误": replayErr})
				return
			}
			for _, result := range results {
				if result.MatchedQty.Sign() > 0 {
					pnl[result.EventID] = ratStringFloat(result.MatchedPnL)
				}
			}
		}
		response.Items = append(response.Items, walletEventItem{
			ID: row.ID, Kind: row.Kind, Category: row.Category, Token: row.TokenAddress,
			Direction: row.Direction, TxHash: row.TxHash, ChainTime: row.ChainTime,
			ExecUSDPerToken: row.ExecUSDPerToken, RealizedPnLUSD: pnl[row.ID],
			Amounts: amountView{
				QuoteRaw: row.QuoteAmountRaw, QuoteDecimals: row.QuoteDecimals,
				TokenRaw: row.TokenAmountRaw, TokenDecimals: row.TokenDecimals,
			},
		})
	}
	httpx.OkJson(w, response)
}

func ratStringFloat(value string) *float64 {
	rat, ok := new(big.Rat).SetString(value)
	if !ok {
		return nil
	}
	out, _ := rat.Float64()
	return &out
}
