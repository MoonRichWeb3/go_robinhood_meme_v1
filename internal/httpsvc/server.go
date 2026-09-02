// Package httpsvc 提供与扫块同进程、只读且有界的 go-zero HTTP 服务。
package httpsvc

import (
	"context"
	"fmt"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/store"
	"github.com/zeromicro/go-zero/rest"
)

// HeadSource 查询当前链头，健康检查失败时允许返回空链头。
type HeadSource interface {
	Head(context.Context) (uint64, error)
}

// Logger 记录中文查询错误，不输出 SQL 原文给客户端。
type Logger interface {
	Error(map[string]any)
}

// Config 是 HTTP 层需要的已校验配置。
type Config struct {
	Rest          rest.RestConf
	ChainID       uint64
	QueryTimeout  time.Duration
	HealthLagWarn uint64
}

// Server 包装 go-zero server 和只读 handler 依赖。
type Server struct {
	inner  *rest.Server
	store  *store.Store
	head   HeadSource
	logger Logger
	config Config
}

// New 创建并注册四条 GET 路由；创建失败时不会开始监听。
func New(config Config, data *store.Store, head HeadSource, logger Logger) (*Server, error) {
	if data == nil || head == nil || config.QueryTimeout <= 0 {
		return nil, fmt.Errorf("HTTP 服务依赖或超时无效")
	}
	inner, err := rest.NewServer(
		config.Rest,
		rest.WithNotFoundHandler(notFoundHandler()),
		rest.WithNotAllowedHandler(notAllowedHandler()),
	)
	if err != nil {
		return nil, err
	}
	server := &Server{inner: inner, store: data, head: head, logger: logger, config: config}
	server.registerRoutes()
	return server, nil
}

// Start 启动 go-zero 监听并阻塞到服务停止。
func (s *Server) Start() { s.inner.Start() }

// Stop 触发 go-zero 优雅关闭。
func (s *Server) Stop() { s.inner.Stop() }
