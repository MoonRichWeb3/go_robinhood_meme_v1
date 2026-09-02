package config

import "testing"

func TestLoadDefaultsAndValidation(t *testing.T) {
	keys := []string{
		"RH_FROM_BLOCK", "RH_CHAIN_ID", "RH_POLL_MS", "RH_MAX_BLOCKS_PER_TICK", "RH_HTTP_UA", "RH_RPC_TIMEOUT_MS",
		"RH_TRACE_RPC_URL", "RH_TRACE_TIMEOUT_MS",
		"RH_SQLITE_PATH", "RH_HTTP_ADDR", "RH_PRICE_FLUSH_SEC", "RH_WALLET_RELOAD_MS", "RH_SCORE_INTERVAL_SEC",
		"RH_SIGNAL_INTERVAL_SEC", "RH_HEALTH_LAG_WARN", "RH_HTTP_QUERY_MS", "LOG_LEVEL", "RH_DIRTY_TOKEN_CAP",
		"RH_BINANCE_BASE_URL", "RH_BINANCE_ETH_SYMBOL", "RH_ETHUSD_POLL_SEC", "RH_BINANCE_TIMEOUT_MS",
		"RH_ETHUSD_TTL_SEC", "RH_ETHUSD_STALE_SEC", "RH_EVENT_RETENTION_DAYS", "RH_EVENT_PURGE_INTERVAL_SEC",
		"RH_EVENT_PURGE_BATCH", "RH_EVENT_PURGE_SLEEP_MS", "RH_EVENT_PURGE_MAX_PER_RUN",
	}
	for _, key := range keys {
		t.Setenv(key, "")
	}
	t.Setenv("RH_RPC_URL", "https://rpc.example")
	got, err := Load()
	if err != nil {
		t.Fatal(err)
	}
	if got.ChainID != 4663 || got.TraceRPCURL != "" || got.TraceTimeoutMS != 8000 ||
		got.WalletReloadMS != 1000 || got.EventRetentionDays != 7 || got.Rest.Port != 8888 {
		t.Fatalf("默认值错误: %+v", got)
	}
	t.Setenv("RH_WALLET_RELOAD_MS", "1001")
	if _, err = Load(); err == nil {
		t.Fatal("超出名单刷新上限应失败")
	}
}
