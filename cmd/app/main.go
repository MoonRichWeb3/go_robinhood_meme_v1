// Robinhood Meme v0 进程入口：加载环境、组装应用并处理退出信号。
package main

import (
	"context"
	"flag"
	"io"
	"net"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/app"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/config"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/logx"
)

func main() {
	healthcheck := flag.Bool("healthcheck", false, "仅检查本机 HTTP 健康端点")
	flag.Parse()
	if *healthcheck {
		if !checkHealth() {
			os.Exit(1)
		}
		return
	}
	logger := logx.New(os.Stdout, envOr("LOG_LEVEL", "info"))
	cfg, err := config.Load()
	if err != nil {
		logger.Error(map[string]any{"类型": "启动失败", "错误": err})
		os.Exit(1)
	}
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()
	application, err := app.New(ctx, cfg, logger)
	if err != nil {
		logger.Error(map[string]any{"类型": "启动失败", "错误": err})
		os.Exit(1)
	}
	logger.Info("启动", map[string]any{"类型": "RPC已连接", "链ID": cfg.ChainID, "HTTP": cfg.Rest.Host})
	if err = application.Run(ctx); err != nil {
		logger.Error(map[string]any{"类型": "扫块退出", "错误": err})
	}
	if closeErr := application.Close(); closeErr != nil {
		logger.Error(map[string]any{"类型": "关闭失败", "错误": closeErr})
	}
	if err != nil {
		os.Exit(1)
	}
}

func checkHealth() bool {
	address := envOr("RH_HTTP_ADDR", "127.0.0.1:8888")
	_, port, err := net.SplitHostPort(address)
	if err != nil {
		return false
	}
	client := &http.Client{Timeout: 2500 * time.Millisecond}
	response, err := client.Get("http://127.0.0.1:" + port + "/health")
	if err != nil {
		return false
	}
	defer response.Body.Close()
	_, _ = io.Copy(io.Discard, io.LimitReader(response.Body, 64<<10))
	return response.StatusCode >= 200 && response.StatusCode < 300
}

func envOr(key, fallback string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return fallback
}
