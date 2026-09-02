// Package venue 只负责把 address+topic0 分流到唯一适配器，不执行 ABI 解码或写库。
package venue

import (
	"strings"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/contracts"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

// RouteHit 是路由结果；动态事件会附带已登记的池或曲线上下文。
type RouteHit struct {
	Venue contracts.Venue
	Kind  contracts.Kind
	Pool  *domain.PoolRegistration
	Curve *domain.CurveRegistration
}

type Router struct{ catalog *contracts.Catalog }

func NewRouter(catalog *contracts.Catalog) *Router { return &Router{catalog: catalog} }

// Route 严格按 ignore、固定目录、Pons 曲线、已登记 v4 池的顺序匹配。
func (r *Router) Route(address, topic0 string, topics []string) (RouteHit, bool) {
	address, topic0 = strings.ToLower(address), strings.ToLower(topic0)
	if role, ok := r.catalog.RoleOf(address); ok && role == contracts.RoleIgnore {
		return RouteHit{Venue: contracts.VenueNone, Kind: contracts.KindIgnore}, true
	}
	if entry, ok := r.catalog.MatchExact(address, topic0); ok {
		if entry.Kind == contracts.KindV4Swap {
			if len(topics) < 2 {
				return RouteHit{}, false
			}
			pool, found := r.catalog.Pool(topics[1])
			if !found {
				return RouteHit{}, false
			}
			return RouteHit{Venue: contracts.VenueShared, Kind: contracts.KindV4Swap, Pool: &pool}, true
		}
		return RouteHit{Venue: entry.Venue, Kind: entry.Kind}, true
	}
	switch topic0 {
	case contracts.TopicPonsCurveBuy:
		curve, ok := r.catalog.Curve(address)
		if !ok {
			return RouteHit{}, false
		}
		return RouteHit{Venue: contracts.VenuePons, Kind: contracts.KindCurveBuy, Curve: &curve}, true
	case contracts.TopicPonsCurveSell:
		curve, ok := r.catalog.Curve(address)
		if !ok {
			return RouteHit{}, false
		}
		return RouteHit{Venue: contracts.VenuePons, Kind: contracts.KindCurveSell, Curve: &curve}, true
	}
	return RouteHit{}, false
}
