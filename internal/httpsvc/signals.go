// 本文件实现三类有界现算信号查询，不持久化任何信号表。
package httpsvc

import (
	"net/http"
	"time"

	"github.com/zeromicro/go-zero/rest/httpx"
)

type signalItem struct {
	Kind     string `json:"kind"`
	Token    string `json:"token,omitempty"`
	Wallet   string `json:"wallet,omitempty"`
	Category string `json:"category"`
	Reason   string `json:"reason"`
}

type signalList struct {
	Items []signalItem `json:"items"`
}

func (s *Server) signals(w http.ResponseWriter, r *http.Request) {
	kind := r.URL.Query().Get("kind")
	if kind != "smart_launch" && kind != "cluster_buy" && kind != "score_launch" {
		writeError(w, http.StatusBadRequest, "bad_request", "kind 必须是 smart_launch、cluster_buy 或 score_launch")
		return
	}
	limit, err := parseLimit(r.URL.Query().Get("limit"))
	if err != nil {
		writeError(w, http.StatusBadRequest, "bad_request", err.Error())
		return
	}
	rows, err := s.store.ListSignals(r.Context(), kind, limit, time.Now().UTC())
	if err != nil {
		queryFailed(s, w, map[string]any{"路径": "/signals", "错误": err})
		return
	}
	response := signalList{Items: make([]signalItem, 0, len(rows))}
	for _, row := range rows {
		response.Items = append(response.Items, signalItem{
			Kind: row.Kind, Token: row.Token, Wallet: row.Wallet,
			Category: row.Category, Reason: row.Reason,
		})
	}
	httpx.OkJson(w, response)
}
