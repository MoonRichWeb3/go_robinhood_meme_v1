// 本文件实现新盘目录的稳定复合游标分页。
package httpsvc

import (
	"net/http"
	"strings"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
	"github.com/zeromicro/go-zero/rest/httpx"
)

type launchItem struct {
	Token      string    `json:"token"`
	Category   string    `json:"category"`
	Symbol     string    `json:"symbol"`
	Name       string    `json:"name"`
	PairSymbol string    `json:"pair_symbol"`
	CreatorEOA string    `json:"creator_eoa"`
	CreatedAt  time.Time `json:"created_at"`
	PriceUSD   *float64  `json:"price_usd"`
	TxHash     string    `json:"tx_hash"`
}

type launchList struct {
	Items      []launchItem `json:"items"`
	NextCursor string       `json:"next_cursor,omitempty"`
}

func (s *Server) launches(w http.ResponseWriter, r *http.Request) {
	limit, err := parseLimit(r.URL.Query().Get("limit"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "bad_request", err.Error())
		return
	}
	category := r.URL.Query().Get("category")
	if category != "" && category != "pons" && category != "o1_crypto" {
		writeError(w, http.StatusBadRequest, "bad_request", "category 仅支持 pons 或 o1_crypto")
		return
	}
	cursorTime, cursorToken, err := parseLaunchCursor(r.URL.Query().Get("cursor"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "bad_request", err.Error())
		return
	}
	rows, err := s.store.ListLaunches(r.Context(), category, cursorTime, cursorToken, limit)
	if err != nil {
		queryFailed(s, w, map[string]any{"路径": "/launches", "错误": err})
		return
	}
	response := launchList{Items: make([]launchItem, 0, len(rows))}
	for _, row := range rows {
		response.Items = append(response.Items, launchItem{
			Token: row.TokenAddress, Category: row.Category, Symbol: row.Symbol, Name: row.Name,
			PairSymbol: row.PairSymbol, CreatorEOA: row.CreatorEOA, CreatedAt: row.CreatedAt,
			PriceUSD: row.PriceUSD, TxHash: row.TxHash,
		})
	}
	if len(rows) == limit {
		last := rows[len(rows)-1]
		response.NextCursor = last.CreatedAt.UTC().Format(time.RFC3339) + "," + last.TokenAddress
	}
	httpx.OkJson(w, response)
}

func parseLaunchCursor(cursor string) (string, string, error) {
	if cursor == "" {
		return "", "", nil
	}
	parts := strings.Split(cursor, ",")
	if len(parts) != 2 {
		return "", "", domainError("cursor 格式应为 created_at,token_address")
	}
	at, err := time.Parse(time.RFC3339, parts[0])
	if err != nil || at.Location() != time.UTC {
		return "", "", domainError("cursor 时间必须是 RFC3339 UTC")
	}
	token, err := domain.NormalizeAddress(parts[1])
	if err != nil {
		return "", "", domainError("cursor 代币地址无效")
	}
	return at.UTC().Format(time.RFC3339), token, nil
}

type domainError string

func (e domainError) Error() string { return string(e) }
