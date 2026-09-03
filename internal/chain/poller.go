// 本文件实现有界 HTTP 轮询、失败退避、处理成功后提交水位。
package chain

import (
	"context"
	"fmt"
	"sync"
	"time"
)

const (
	WatermarkName               = "rh_4663"
	maxBlockPrefetchConcurrency = 8
	defaultRecentBlockOffset    = 10
)

type Watermark struct {
	Name      string
	LastBlock uint64
	LastHash  string
	UpdatedAt time.Time
}

// WatermarkStore 由 store 适配，chain 不依赖具体数据库。
type WatermarkStore interface {
	LoadWatermark(context.Context, string) (lastBlock uint64, lastHash string, found bool, err error)
	SaveWatermark(context.Context, string, uint64, string, time.Time) error
}

type PollLogger interface {
	Error(map[string]any)
}

type PollerConfig struct {
	FromBlock, MaxBlocksPerTick, LagWarn, SkipHistoryLag uint64
	PollInterval                                         time.Duration
	FetchMode, ReceiptMethod                             string
}

type Poller struct {
	client   *Client
	receipts *ReceiptFetcher
	state    WatermarkStore
	process  func(context.Context, BlockBatch, Watermark) error
	logger   PollLogger
	config   PollerConfig
	fetch    func(context.Context, uint64) (BlockBatch, error)
}

// NewPoller 校验资源上限并组装不感知 venue 的扫块器。
func NewPoller(client *Client, state WatermarkStore, process func(context.Context, BlockBatch, Watermark) error, logger PollLogger, config PollerConfig) (*Poller, error) {
	if client == nil || state == nil || process == nil {
		return nil, fmt.Errorf("poller 依赖不能为空")
	}
	if config.MaxBlocksPerTick == 0 || config.PollInterval <= 0 {
		return nil, fmt.Errorf("poller 间隔和单轮块数必须大于 0")
	}
	if config.LagWarn == 0 {
		config.LagWarn = 50
	}
	if config.FetchMode == "" {
		config.FetchMode = FetchModeBatch
	}
	if config.FetchMode != FetchModeBatch && config.FetchMode != FetchModePair {
		return nil, fmt.Errorf("RH_BLOCK_FETCH_MODE 仅支持 batch/pair")
	}
	if config.ReceiptMethod == "" {
		config.ReceiptMethod = ReceiptMethodEthBlock
	}
	if config.ReceiptMethod != ReceiptMethodEthBlock && config.ReceiptMethod != ReceiptMethodAlchemy {
		return nil, fmt.Errorf("RH_RECEIPT_METHOD 仅支持 %s/%s", ReceiptMethodEthBlock, ReceiptMethodAlchemy)
	}
	receipts := NewReceiptFetcherMode(client, config.ReceiptMethod, config.FetchMode == FetchModeBatch)
	return &Poller{
		client: client, receipts: receipts, state: state, process: process, logger: logger, config: config,
		fetch: receipts.FetchBlock,
	}, nil
}

// Run 持续处理同一失败块，退避上限五秒；成功后恢复正常轮询。
func (p *Poller) Run(ctx context.Context) error {
	head, err := p.Head(ctx)
	if err != nil {
		return err
	}
	if _, err = p.receipts.Probe(ctx, head); err != nil {
		return err
	}
	if !p.receipts.blockMethod && p.logger != nil {
		p.logger.Error(map[string]any{"类型": "RPC回退", "方法": "eth_getTransactionReceipt", "原方法": p.receipts.receiptMethod()})
	}
	backoff := 200 * time.Millisecond
	for {
		processed, err := p.PollOnce(ctx)
		if err != nil {
			if p.logger != nil {
				p.logger.Error(rpcFailureFields(err))
			}
			if err = sleepContext(ctx, backoff); err != nil {
				return err
			}
			backoff = min(backoff*2, 5*time.Second)
			continue
		}
		backoff = 200 * time.Millisecond
		if processed == 0 {
			if err = sleepContext(ctx, p.config.PollInterval); err != nil {
				return err
			}
		}
	}
}

// PollOnce 最多处理 MaxBlocksPerTick 个块，任何失败都不越过当前块。
func (p *Poller) PollOnce(ctx context.Context) (uint64, error) {
	lastBlock, lastHash, found, err := p.state.LoadWatermark(ctx, WatermarkName)
	if err != nil {
		return 0, err
	}
	head, err := p.Head(ctx)
	if err != nil {
		return 0, err
	}
	state := Watermark{Name: WatermarkName, LastBlock: lastBlock, LastHash: lastHash}
	skippedHistory := false
	if !found {
		state = Watermark{
			Name:      WatermarkName,
			LastBlock: resolveStartBlock(head, p.config.FromBlock),
			UpdatedAt: time.Now().UTC(),
		}
		if err = p.saveWatermark(ctx, state); err != nil {
			return 0, err
		}
	} else if start, skip := skipHistoryStart(head, lastBlock, p.config.SkipHistoryLag); skip {
		skippedHistory = true
		state = Watermark{Name: WatermarkName, LastBlock: start, UpdatedAt: time.Now().UTC()}
		if p.logger != nil {
			p.logger.Error(map[string]any{
				"类型": "跳过历史", "已处理块": lastBlock, "链头": head, "新起点": start, "阈值": p.config.SkipHistoryLag,
			})
		}
		if err = p.saveWatermark(ctx, state); err != nil {
			return 0, err
		}
	}
	next := state.LastBlock + 1
	if state.LastHash == "" {
		next = state.LastBlock
	}
	if next > head {
		return 0, nil
	}
	if !skippedHistory && p.logger != nil && head-next+1 > p.config.LagWarn {
		p.logger.Error(map[string]any{"类型": "落后", "已处理块": state.LastBlock, "链头": head})
	}
	end := min(head, next+p.config.MaxBlocksPerTick-1)
	return p.processRange(ctx, state, next, end)
}

// resolveStartBlock 在未保存水位且未指定固定块高时，从当前链头前十块开始。
func resolveStartBlock(head, configured uint64) uint64 {
	if configured != 0 {
		return configured
	}
	if head <= defaultRecentBlockOffset {
		return 0
	}
	return head - defaultRecentBlockOffset
}

// skipHistoryStart 在已有水位落后超过阈值时，改从当前链头前十块开始，不再补中间历史。
func skipHistoryStart(head, lastBlock, threshold uint64) (uint64, bool) {
	if threshold == 0 || head <= lastBlock {
		return 0, false
	}
	if head-lastBlock <= threshold {
		return 0, false
	}
	start := resolveStartBlock(head, 0)
	if start <= lastBlock {
		return 0, false
	}
	return start, true
}

type blockFetchResult struct {
	block BlockBatch
	err   error
}

// processRange 并发预取有界批次，但只允许调用方按块高顺序观察结果和提交水位。
func (p *Poller) processRange(ctx context.Context, state Watermark, next, end uint64) (uint64, error) {
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	count := end - next + 1
	results := make([]chan blockFetchResult, count)
	jobs := make(chan uint64, count)
	var workers sync.WaitGroup
	concurrency := min(count, uint64(maxBlockPrefetchConcurrency))
	fetch := p.fetch
	if fetch == nil {
		fetch = p.receipts.FetchBlock
	}
	for range concurrency {
		workers.Add(1)
		go func() {
			defer workers.Done()
			for number := range jobs {
				if ctx.Err() != nil {
					return
				}
				block, err := fetch(ctx, number)
				results[number-next] <- blockFetchResult{block: block, err: err}
			}
		}()
	}
	for number := next; number <= end; number++ {
		results[number-next] = make(chan blockFetchResult, 1)
		jobs <- number
	}
	close(jobs)
	defer workers.Wait()

	var processed uint64
	for number := next; number <= end; number++ {
		var result blockFetchResult
		select {
		case result = <-results[number-next]:
		case <-ctx.Done():
			return processed, ctx.Err()
		}
		if result.err != nil {
			cancel()
			return processed, result.err
		}
		block := result.block
		if state.LastHash != "" && number == state.LastBlock+1 && block.ParentHash != state.LastHash {
			reorgState, err := ResolveCanonicalParent(ctx, p.client, block)
			if err != nil {
				cancel()
				return processed, err
			}
			reorgState.UpdatedAt = time.Now().UTC()
			if p.logger != nil {
				p.logger.Error(map[string]any{"类型": "重组", "块高": number, "旧哈希": state.LastHash, "新父哈希": block.ParentHash})
			}
			if err = p.saveWatermark(ctx, reorgState); err != nil {
				cancel()
				return processed, err
			}
			state = reorgState
		}
		nextState := Watermark{Name: WatermarkName, LastBlock: block.Number, LastHash: block.Hash, UpdatedAt: time.Now().UTC()}
		if err := p.process(ctx, block, nextState); err != nil {
			cancel()
			return processed, err
		}
		// process 必须把本块业务写与 nextState 原子提交；Poller 不再二次写水位。
		state = nextState
		processed++
	}
	return processed, nil
}

func (p *Poller) saveWatermark(ctx context.Context, state Watermark) error {
	return p.state.SaveWatermark(ctx, state.Name, state.LastBlock, state.LastHash, state.UpdatedAt)
}

func (p *Poller) Head(ctx context.Context) (uint64, error) {
	var result string
	if err := p.client.Call(ctx, "eth_blockNumber", []any{}, &result); err != nil {
		return 0, err
	}
	return parseHexUint64(result)
}

func rpcFailureFields(err error) map[string]any {
	fields := map[string]any{"类型": "扫块失败", "错误": err}
	endpoint, ok := AsEndpointError(err)
	if !ok {
		return fields
	}
	fields["RPC"] = endpoint.RPC
	if endpoint.Status == 429 {
		fields["类型"] = "RPC限流"
		fields["状态"] = 429
	}
	return fields
}

func sleepContext(ctx context.Context, delay time.Duration) error {
	timer := time.NewTimer(delay)
	defer timer.Stop()
	select {
	case <-timer.C:
		return nil
	case <-ctx.Done():
		return ctx.Err()
	}
}
