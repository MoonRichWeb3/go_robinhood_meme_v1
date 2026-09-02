// 本文件维护有界“最后成交价”脏集合，并通过同一 SQLite writer 逐项刷新目录。
package price

import (
	"container/list"
	"context"
	"fmt"
	"sync"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
)

// PriceStore 提供目录存在性读取和唯一写入口价格更新。
type PriceStore interface {
	GetLaunchIndex(context.Context, string) (domain.LaunchIndex, error)
	UpdateLaunchPrice(context.Context, string, float64, uint64, string, time.Time) error
}

// PriceLogger 输出价格成功与错误中文日志。
type PriceLogger interface {
	Info(string, map[string]any)
	Error(map[string]any)
}

// Point 是某代币窗口内最后一笔可折 U 成交。
type Point struct {
	Token, TxHash string
	PriceUSD      float64
	Block         uint64
	At            time.Time
	version       uint64
}

type dirtyEntry struct {
	point Point
	order *list.Element
}

// DirtySet 用 FIFO 淘汰保证 token map 永不超过配置容量。
type DirtySet struct {
	store  PriceStore
	logger PriceLogger
	cap    int
	mu     sync.Mutex
	items  map[string]*dirtyEntry
	order  *list.List
	nextID uint64
}

// NewDirtySet 创建有界展示价缓冲。
func NewDirtySet(store PriceStore, capacity int, logger PriceLogger) (*DirtySet, error) {
	if store == nil || capacity < 1 {
		return nil, fmt.Errorf("脏集合依赖或容量无效")
	}
	return &DirtySet{store: store, logger: logger, cap: capacity, items: make(map[string]*dirtyEntry), order: list.New()}, nil
}

// Mark 仅标记已入库 token；同一窗口重复成交覆盖价格并更新为最新顺序。
func (d *DirtySet) Mark(ctx context.Context, point Point) error {
	if point.PriceUSD <= 0 || point.Token == "" || point.TxHash == "" || point.At.IsZero() {
		return fmt.Errorf("展示价点无效")
	}
	index, err := d.store.GetLaunchIndex(ctx, point.Token)
	if err != nil {
		return err
	}
	point.Token = index.TokenAddress
	d.mu.Lock()
	defer d.mu.Unlock()
	d.nextID++
	point.version = d.nextID
	if current, ok := d.items[point.Token]; ok {
		current.point = point
		d.order.MoveToBack(current.order)
		return nil
	}
	if len(d.items) >= d.cap {
		oldest := d.order.Front()
		token := oldest.Value.(string)
		delete(d.items, token)
		d.order.Remove(oldest)
		if d.logger != nil {
			d.logger.Error(map[string]any{"类型": "脏集合溢出", "代币": token, "容量": d.cap})
		}
	}
	element := d.order.PushBack(point.Token)
	d.items[point.Token] = &dirtyEntry{point: point, order: element}
	return nil
}

// Flush 逐项写入最近成交价；失败项和刷新期间被覆盖的项保留到下一轮。
func (d *DirtySet) Flush(ctx context.Context) error {
	d.mu.Lock()
	points := make([]Point, 0, len(d.items))
	for _, item := range d.items {
		points = append(points, item.point)
	}
	d.mu.Unlock()
	var firstErr error
	for _, point := range points {
		index, err := d.store.GetLaunchIndex(ctx, point.Token)
		if err == nil && index.PriceUSD != nil && *index.PriceUSD == point.PriceUSD &&
			index.PriceBlock == point.Block && index.PriceTx == point.TxHash {
			d.removeVersion(point)
			continue
		}
		if err == nil {
			err = d.store.UpdateLaunchPrice(ctx, point.Token, point.PriceUSD, point.Block, point.TxHash, point.At)
		}
		if err != nil {
			if firstErr == nil {
				firstErr = err
			}
			if d.logger != nil {
				d.logger.Error(map[string]any{"类型": "价格刷新失败", "代币": point.Token, "错误": err})
			}
			continue
		}
		d.removeVersion(point)
		if d.logger != nil {
			d.logger.Info("价格", map[string]any{
				"类型": "价格", "盘口": venueName(index.Category), "代币": point.Token,
				"配对": index.PairSymbol, "单价U": point.PriceUSD, "来源": "最近成交",
				"交易": point.TxHash, "块高": point.Block,
			})
		}
	}
	return firstErr
}

func (d *DirtySet) removeVersion(point Point) {
	d.mu.Lock()
	if current, ok := d.items[point.Token]; ok && current.point.version == point.version {
		d.order.Remove(current.order)
		delete(d.items, point.Token)
	}
	d.mu.Unlock()
}

func venueName(category string) string {
	switch category {
	case "pons":
		return "Pons"
	case "o1_crypto":
		return "o1加密"
	case "o1_stock":
		return "o1股票"
	case "long":
		return "Long"
	default:
		return category
	}
}
