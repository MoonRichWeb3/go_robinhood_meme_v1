// 本文件集中注册只读路由并统一错误体、超时和 panic 恢复。
package httpsvc

import (
	"context"
	"fmt"
	"net/http"
	"strconv"

	"github.com/zeromicro/go-zero/rest"
	"github.com/zeromicro/go-zero/rest/httpx"
)

type errorBody struct {
	Error   string `json:"error"`
	Message string `json:"message"`
}

func (s *Server) registerRoutes() {
	s.inner.AddRoutes([]rest.Route{
		{Method: http.MethodGet, Path: "/health", Handler: s.wrap(s.health)},
		{Method: http.MethodGet, Path: "/launches", Handler: s.wrap(s.launches)},
		{Method: http.MethodGet, Path: "/wallets/:address/events", Handler: s.wrap(s.walletEvents)},
		{Method: http.MethodGet, Path: "/signals", Handler: s.wrap(s.signals)},
	})
}

func (s *Server) wrap(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		defer func() {
			if recovered := recover(); recovered != nil {
				if s.logger != nil {
					s.logger.Error(map[string]any{"类型": "查询异常", "路径": r.URL.Path})
				}
				writeError(w, http.StatusInternalServerError, "internal_error", "服务内部错误")
			}
		}()
		ctx, cancel := context.WithTimeout(r.Context(), s.config.QueryTimeout)
		defer cancel()
		next(w, r.WithContext(ctx))
	}
}

func notFoundHandler() http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		writeError(w, http.StatusNotFound, "not_found", "路由不存在")
	})
}

func notAllowedHandler() http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		writeError(w, http.StatusMethodNotAllowed, "method_not_allowed", "仅支持只读 GET")
	})
}

func writeError(w http.ResponseWriter, status int, code, message string) {
	httpx.WriteJson(w, status, errorBody{Error: code, Message: message})
}

func queryFailed(s *Server, w http.ResponseWriter, fields map[string]any) {
	if s.logger != nil {
		fields["类型"] = "查询失败"
		s.logger.Error(fields)
	}
	writeError(w, http.StatusInternalServerError, "internal_error", "查询失败")
}

func parseLimit(value string) (int, error) {
	if value == "" {
		return 50, nil
	}
	limit, err := strconv.Atoi(value)
	if err != nil || limit < 1 || limit > 200 {
		return 0, fmt.Errorf("limit 必须在 1..200")
	}
	return limit, nil
}
