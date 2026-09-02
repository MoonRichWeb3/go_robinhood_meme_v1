package contracts

import (
	"fmt"
	"sync"
	"testing"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

func TestCatalogRegistrationsAreConcurrentSafe(t *testing.T) {
	catalog, err := NewCatalog()
	if err != nil {
		t.Fatal(err)
	}
	var wg sync.WaitGroup
	errs := make(chan error, 32)
	for i := 1; i <= 16; i++ {
		i := i
		wg.Add(2)
		go func() {
			defer wg.Done()
			id := fmt.Sprintf("0x%064x", i)
			errs <- catalog.RegisterPool(domain.PoolRegistration{PoolID: id, Token: WETHAddress, Quote: USDGAddress, Category: "o1_crypto"})
		}()
		go func() {
			defer wg.Done()
			catalog.Pool(fmt.Sprintf("0x%064x", i))
			catalog.Curve(WETHAddress)
		}()
	}
	wg.Wait()
	close(errs)
	for err := range errs {
		if err != nil {
			t.Fatal(err)
		}
	}
}

func TestCatalogRejectsDeferredVenueRegistration(t *testing.T) {
	catalog, _ := NewCatalog()
	err := catalog.RegisterPool(domain.PoolRegistration{
		PoolID: "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
		Token:  WETHAddress, Quote: USDGAddress, Category: "long",
	})
	if err == nil {
		t.Fatal("本期必须拒绝 Long 池登记")
	}
}
