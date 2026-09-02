package venue

import (
	"testing"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/contracts"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

func TestRouteDropsUnregisteredPoolAndIgnoredVenues(t *testing.T) {
	catalog, err := contracts.NewCatalog()
	if err != nil {
		t.Fatal(err)
	}
	router := NewRouter(catalog)
	poolID := "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	topics := []string{contracts.TopicPoolSwap, poolID}
	if _, ok := router.Route(contracts.PoolManager, contracts.TopicPoolSwap, topics); ok {
		t.Fatal("未登记池必须忽略")
	}
	if hit, ok := router.Route(contracts.O1StockFactory, contracts.TopicO1Launched, []string{contracts.TopicO1Launched}); !ok || hit.Kind != contracts.KindIgnore {
		t.Fatal("股票工厂本期必须 ignore")
	}
	if err = catalog.RegisterPool(domain.PoolRegistration{PoolID: poolID, Token: contracts.WETHAddress, Quote: contracts.USDGAddress, Category: "o1_crypto"}); err != nil {
		t.Fatal(err)
	}
	hit, ok := router.Route(contracts.PoolManager, contracts.TopicPoolSwap, topics)
	if !ok || hit.Pool == nil || hit.Pool.Category != "o1_crypto" {
		t.Fatalf("已登记池未正确路由: %+v", hit)
	}
}

func TestCatalogRebuildReplacesRegistrations(t *testing.T) {
	catalog, _ := contracts.NewCatalog()
	oldID := "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	newID := "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
	if err := catalog.RegisterPool(domain.PoolRegistration{PoolID: oldID, Token: contracts.WETHAddress, Quote: contracts.USDGAddress, Category: "pons"}); err != nil {
		t.Fatal(err)
	}
	if err := catalog.RebuildRegistrations(
		[]domain.PoolRegistration{{PoolID: newID, Token: contracts.WETHAddress, Quote: contracts.USDGAddress, Category: "o1_crypto"}},
		[]domain.CurveRegistration{{Curve: contracts.WETHAddress, Token: contracts.USDGAddress, Quote: contracts.ZeroAddress}},
	); err != nil {
		t.Fatal(err)
	}
	if _, ok := catalog.Pool(oldID); ok {
		t.Fatal("重建后旧池不应残留")
	}
	if _, ok := catalog.Pool(newID); !ok {
		t.Fatal("重建后新池缺失")
	}
}
