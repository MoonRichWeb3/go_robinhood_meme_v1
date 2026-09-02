// 本文件实现进程、数据库、水位和链头健康检查。
package httpsvc

import (
	"database/sql"
	"net/http"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/chain"
	"github.com/zeromicro/go-zero/rest/httpx"
)

type healthResponse struct {
	OK        bool    `json:"ok"`
	ChainID   uint64  `json:"chain_id"`
	LastBlock uint64  `json:"last_block"`
	HeadBlock *uint64 `json:"head_block"`
	Lag       *uint64 `json:"lag"`
	DB        string  `json:"db"`
}

func (s *Server) health(w http.ResponseWriter, r *http.Request) {
	response := healthResponse{OK: true, ChainID: s.config.ChainID, DB: "ok"}
	if err := s.store.Reader().PingContext(r.Context()); err != nil {
		response.OK, response.DB = false, "error"
		httpx.WriteJson(w, http.StatusServiceUnavailable, response)
		return
	}
	state, err := s.store.GetSyncState(r.Context(), chain.WatermarkName)
	if err != nil && err != sql.ErrNoRows {
		response.OK, response.DB = false, "error"
		httpx.WriteJson(w, http.StatusServiceUnavailable, response)
		return
	}
	if err == nil {
		response.LastBlock = state.LastBlock
	}
	head, err := s.head.Head(r.Context())
	if err != nil {
		if s.logger != nil {
			s.logger.Error(map[string]any{"类型": "链头查询失败", "错误": err})
		}
		httpx.OkJson(w, response)
		return
	}
	response.HeadBlock = &head
	lag := uint64(0)
	if head > response.LastBlock {
		lag = head - response.LastBlock
	}
	response.Lag = &lag
	if lag > s.config.HealthLagWarn {
		response.OK = false
	}
	httpx.OkJson(w, response)
}
