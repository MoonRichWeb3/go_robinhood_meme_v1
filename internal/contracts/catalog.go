// 本文件实现静态合约目录以及可原子重建的池、曲线运行时登记。
package contracts

import (
	"fmt"
	"sort"
	"strings"
	"sync"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

type Role string
type Venue string
type Kind string

const (
	RoleFactory      Role  = "factory"
	RoleLaunchAndBuy Role  = "launch_and_buy"
	RoleHook         Role  = "hook"
	RolePoolManager  Role  = "pool_manager"
	RoleRouter       Role  = "router"
	RoleAggregator   Role  = "aggregator"
	RoleIgnore       Role  = "ignore"
	VenuePons        Venue = "pons"
	VenueO1Crypto    Venue = "o1_crypto"
	VenueShared      Venue = "shared"
	VenueNone        Venue = "none"
	KindCreate       Kind  = "create"
	KindCurveBuy     Kind  = "curve_buy"
	KindCurveSell    Kind  = "curve_sell"
	KindGraduated    Kind  = "graduated"
	KindV4Swap       Kind  = "v4_swap"
	KindV4Initialize Kind  = "v4_init"
	KindIgnore       Kind  = "ignore"
)

// Entry 是固定 address+topic0 的唯一分流规则。
type Entry struct {
	Address string
	Topic0  string
	Role    Role
	Venue   Venue
	Kind    Kind
}

// Catalog 同时持有只读静态规则和受读写锁保护的运行时登记。
type Catalog struct {
	entries map[string]Entry
	roles   map[string]Role
	mu      sync.RWMutex
	pools   map[string]domain.PoolRegistration
	curves  map[string]domain.CurveRegistration
}

// NewCatalog 构建本期 Pons、o1 加密与共享 PoolManager 目录并校验必填项。
func NewCatalog() (*Catalog, error) {
	c := &Catalog{
		entries: make(map[string]Entry),
		roles:   make(map[string]Role),
		pools:   make(map[string]domain.PoolRegistration),
		curves:  make(map[string]domain.CurveRegistration),
	}
	for _, e := range defaultEntries() {
		e.Address, e.Topic0 = strings.ToLower(e.Address), strings.ToLower(e.Topic0)
		c.entries[e.Address+"|"+e.Topic0] = e
		c.roles[e.Address] = e.Role
	}
	required := [][2]string{
		{PonsFactory, TopicPonsTokenLaunched},
		{PonsLaunchAndBuy, TopicPonsLaunched},
		{O1CryptoFactory, TopicO1Launched},
		{PoolManager, TopicPoolSwap},
		{PoolManager, TopicPoolInitialize},
	}
	for _, key := range required {
		if _, ok := c.entries[key[0]+"|"+key[1]]; !ok {
			return nil, fmt.Errorf("合约目录缺少本期必填规则 %s %s", key[0], key[1])
		}
	}
	return c, nil
}

func defaultEntries() []Entry {
	return []Entry{
		{PonsFactory, TopicPonsTokenLaunched, RoleFactory, VenuePons, KindCreate},
		{PonsFactory, TopicPonsGraduated, RoleFactory, VenuePons, KindGraduated},
		{PonsFactory, TopicPonsLaunchSwept, RoleFactory, VenuePons, KindIgnore},
		{PonsLaunchAndBuy, TopicPonsLaunched, RoleLaunchAndBuy, VenuePons, KindIgnore},
		{O1CryptoFactory, TopicO1Launched, RoleFactory, VenueO1Crypto, KindCreate},
		{PoolManager, TopicPoolSwap, RolePoolManager, VenueShared, KindV4Swap},
		{PoolManager, TopicPoolInitialize, RolePoolManager, VenueShared, KindV4Initialize},
		{UniversalRouter, "", RoleRouter, VenueNone, KindIgnore},
		{GMGNRouter, "", RoleAggregator, VenueNone, KindIgnore},
		{O1CryptoHook, "", RoleHook, VenueO1Crypto, KindIgnore},
		{PonsMemeHook, "", RoleHook, VenuePons, KindIgnore},
		{O1StockFactory, "", RoleIgnore, VenueNone, KindIgnore},
		{O1StockHook, "", RoleIgnore, VenueNone, KindIgnore},
		{LongLauncher, "", RoleIgnore, VenueNone, KindIgnore},
		{Airlock, "", RoleIgnore, VenueNone, KindIgnore},
	}
}

// MatchExact 查询固定 address+topic0 规则。
func (c *Catalog) MatchExact(address, topic0 string) (Entry, bool) {
	e, ok := c.entries[strings.ToLower(address)+"|"+strings.ToLower(topic0)]
	return e, ok
}

// RoleOf 返回地址角色，供归因排除协议合约。
func (c *Catalog) RoleOf(address string) (Role, bool) {
	role, ok := c.roles[strings.ToLower(address)]
	return role, ok
}

// ProtocolAddresses 返回归因时必须排除的目录地址快照。
func (c *Catalog) ProtocolAddresses() []string {
	out := make([]string, 0, len(c.roles)+1)
	for address, role := range c.roles {
		switch role {
		case RoleRouter, RoleAggregator, RoleFactory, RoleLaunchAndBuy, RolePoolManager, RoleHook, RoleIgnore:
			out = append(out, address)
		}
	}
	out = append(out, Permit2)
	sort.Strings(out)
	return out
}

// RebuildRegistrations 原子替换启动时从 store 读取的全部有效登记。
func (c *Catalog) RebuildRegistrations(pools []domain.PoolRegistration, curves []domain.CurveRegistration) error {
	nextPools := make(map[string]domain.PoolRegistration, len(pools))
	nextCurves := make(map[string]domain.CurveRegistration, len(curves))
	for _, p := range pools {
		if err := normalizePoolRegistration(&p); err != nil {
			return fmt.Errorf("池登记 %q: %w", p.PoolID, err)
		}
		nextPools[p.PoolID] = p
	}
	for _, v := range curves {
		if err := normalizeCurveRegistration(&v); err != nil {
			return fmt.Errorf("曲线登记 %q: %w", v.Curve, err)
		}
		nextCurves[v.Curve] = v
	}
	c.mu.Lock()
	c.pools, c.curves = nextPools, nextCurves
	c.mu.Unlock()
	return nil
}

func (c *Catalog) RegisterPool(v domain.PoolRegistration) error {
	if err := normalizePoolRegistration(&v); err != nil {
		return err
	}
	c.mu.Lock()
	c.pools[v.PoolID] = v
	c.mu.Unlock()
	return nil
}

func (c *Catalog) Pool(id string) (domain.PoolRegistration, bool) {
	c.mu.RLock()
	v, ok := c.pools[strings.ToLower(id)]
	c.mu.RUnlock()
	return v, ok
}

func (c *Catalog) RegisterCurve(v domain.CurveRegistration) error {
	if err := normalizeCurveRegistration(&v); err != nil {
		return err
	}
	c.mu.Lock()
	c.curves[v.Curve] = v
	c.mu.Unlock()
	return nil
}

func (c *Catalog) Curve(address string) (domain.CurveRegistration, bool) {
	c.mu.RLock()
	v, ok := c.curves[strings.ToLower(address)]
	c.mu.RUnlock()
	return v, ok
}

func normalizePoolRegistration(v *domain.PoolRegistration) error {
	var err error
	if v.Category != "pons" && v.Category != "o1_crypto" {
		return fmt.Errorf("本期不登记分类 %q", v.Category)
	}
	if v.PoolID, err = domain.NormalizeHash(v.PoolID, 32); err != nil {
		return err
	}
	if v.Token, err = domain.NormalizeAddress(v.Token); err != nil {
		return err
	}
	if v.Quote, err = domain.NormalizeAddress(v.Quote); err != nil {
		return err
	}
	return nil
}

func normalizeCurveRegistration(v *domain.CurveRegistration) error {
	var err error
	if v.Curve, err = domain.NormalizeAddress(v.Curve); err != nil {
		return err
	}
	if v.Token, err = domain.NormalizeAddress(v.Token); err != nil {
		return err
	}
	if v.Quote, err = domain.NormalizeAddress(v.Quote); err != nil {
		return err
	}
	return nil
}
