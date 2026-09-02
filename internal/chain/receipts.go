// 本文件实现完整区块读取、整块收据能力探测和有界逐收据回退。
package chain

import (
	"context"
	"encoding/hex"
	"fmt"
	"math/big"
	"strings"
	"sync"
	"time"
)

const maxReceiptConcurrency = 8

// Transaction 保留归因和 ABI 解码所需的完整交易输入。
type Transaction struct {
	Hash, From, To, Value string
	Input                 []byte
	Index                 uint64
}

// Log 是规范化后的 RPC 日志；Index 保留链上 block-global logIndex。
type Log struct {
	Address                string
	Topics                 []string
	Data                   []byte
	Index, ReceiptLogIndex uint64
	Removed                bool
}

type Receipt struct {
	TxHash, BlockHash string
	TxIndex, Status   uint64
	Logs              []Log
}

// BlockBatch 是交给编排层的完整单块事实。
type BlockBatch struct {
	Number, Timestamp uint64
	Hash, ParentHash  string
	ChainTime         time.Time
	Transactions      []Transaction
	Receipts          []Receipt
}

type rawTransaction struct {
	Hash             string `json:"hash"`
	From             string `json:"from"`
	To               string `json:"to"`
	Value            string `json:"value"`
	Input            string `json:"input"`
	TransactionIndex string `json:"transactionIndex"`
}

type rawBlock struct {
	Number, Hash, ParentHash, Timestamp string
	Transactions                        []rawTransaction
}

type rawLog struct {
	Address, Data, LogIndex string
	Topics                  []string
	Removed                 bool
}

type rawReceipt struct {
	TransactionHash, BlockHash, TransactionIndex, Status string
	Logs                                                 []rawLog
}

// ReceiptFetcher 在 Probe 后永久固定整块或逐笔模式。
type ReceiptFetcher struct {
	client      *Client
	probed      bool
	blockMethod bool
}

func NewReceiptFetcher(client *Client) *ReceiptFetcher { return &ReceiptFetcher{client: client} }

// Probe 对一个已存在块仅探测一次；任何失败都会固定回退，不会逐块来回切换。
func (f *ReceiptFetcher) Probe(ctx context.Context, blockNumber uint64) (bool, error) {
	if f.probed {
		return f.blockMethod, nil
	}
	f.probed = true
	var rows []rawReceipt
	err := f.client.Call(ctx, "eth_getBlockReceipts", []any{hexQuantity(blockNumber)}, &rows)
	if err != nil {
		f.blockMethod = false
		return false, nil
	}
	f.blockMethod = true
	return true, nil
}

// FetchBlock 同时读取完整交易和全部收据，并验证两者一一对应。
func (f *ReceiptFetcher) FetchBlock(ctx context.Context, number uint64) (BlockBatch, error) {
	if !f.probed {
		return BlockBatch{}, fmt.Errorf("收据能力尚未探测")
	}
	if f.blockMethod {
		return f.fetchWithBlockReceipts(ctx, number)
	}
	var raw rawBlock
	if err := f.client.Call(ctx, "eth_getBlockByNumber", []any{hexQuantity(number), true}, &raw); err != nil {
		return BlockBatch{}, err
	}
	block, err := decodeBlock(raw)
	if err != nil {
		return BlockBatch{}, err
	}
	if block.Number != number {
		return BlockBatch{}, fmt.Errorf("RPC 返回错误块高: 期望=%d 实际=%d", number, block.Number)
	}
	receipts, err := f.fetchIndividually(ctx, block.Transactions, block.Hash)
	if err != nil {
		return BlockBatch{}, err
	}
	block.Receipts = receipts
	return block, nil
}

// fetchWithBlockReceipts 并行读取块详情和整块收据；任一请求失败会取消另一请求。
func (f *ReceiptFetcher) fetchWithBlockReceipts(ctx context.Context, number uint64) (BlockBatch, error) {
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	var raw rawBlock
	var rows []rawReceipt
	errs := make(chan error, 2)
	go func() {
		errs <- f.client.Call(ctx, "eth_getBlockByNumber", []any{hexQuantity(number), true}, &raw)
	}()
	go func() {
		errs <- f.client.Call(ctx, "eth_getBlockReceipts", []any{hexQuantity(number)}, &rows)
	}()
	var firstErr error
	for range 2 {
		if err := <-errs; err != nil && firstErr == nil {
			firstErr = err
			cancel()
		}
	}
	if firstErr != nil {
		return BlockBatch{}, firstErr
	}

	block, err := decodeBlock(raw)
	if err != nil {
		return BlockBatch{}, err
	}
	if block.Number != number {
		return BlockBatch{}, fmt.Errorf("RPC 返回错误块高: 期望=%d 实际=%d", number, block.Number)
	}
	receipts, err := alignReceipts(rows, block.Transactions, block.Hash)
	if err != nil {
		return BlockBatch{}, err
	}
	block.Receipts = receipts
	return block, nil
}

func (f *ReceiptFetcher) fetchIndividually(ctx context.Context, txs []Transaction, blockHash string) ([]Receipt, error) {
	if len(txs) == 0 {
		return []Receipt{}, nil
	}
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()
	out := make([]Receipt, len(txs))
	jobs := make(chan int)
	var wg sync.WaitGroup
	var firstErr error
	var errMu sync.Mutex
	workers := min(len(txs), maxReceiptConcurrency)
	for range workers {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for i := range jobs {
				var row rawReceipt
				if err := f.client.Call(ctx, "eth_getTransactionReceipt", []any{txs[i].Hash}, &row); err != nil {
					errMu.Lock()
					if firstErr == nil {
						firstErr = err
						cancel()
					}
					errMu.Unlock()
					continue
				}
				receipt, err := decodeReceipt(row, uint64(i), blockHash)
				if err != nil {
					errMu.Lock()
					if firstErr == nil {
						firstErr = err
						cancel()
					}
					errMu.Unlock()
					continue
				}
				if receipt.TxHash != txs[i].Hash {
					errMu.Lock()
					if firstErr == nil {
						firstErr = fmt.Errorf("收据交易哈希与请求不一致")
						cancel()
					}
					errMu.Unlock()
					continue
				}
				out[i] = receipt
			}
		}()
	}
sendLoop:
	for i := range txs {
		select {
		case jobs <- i:
		case <-ctx.Done():
			break sendLoop
		}
	}
	close(jobs)
	wg.Wait()
	if firstErr == nil && ctx.Err() != nil {
		firstErr = ctx.Err()
	}
	return out, firstErr
}

func alignReceipts(rows []rawReceipt, txs []Transaction, blockHash string) ([]Receipt, error) {
	if len(rows) != len(txs) {
		return nil, fmt.Errorf("整块收据数量不匹配: 交易=%d 收据=%d", len(txs), len(rows))
	}
	byHash := make(map[string]rawReceipt, len(rows))
	for _, row := range rows {
		byHash[strings.ToLower(row.TransactionHash)] = row
	}
	out := make([]Receipt, len(txs))
	for i, tx := range txs {
		row, ok := byHash[tx.Hash]
		if !ok {
			return nil, fmt.Errorf("交易 %s 缺少收据", tx.Hash)
		}
		receipt, err := decodeReceipt(row, uint64(i), blockHash)
		if err != nil {
			return nil, err
		}
		out[i] = receipt
	}
	return out, nil
}

func decodeBlock(raw rawBlock) (BlockBatch, error) {
	number, err := parseHexUint64(raw.Number)
	if err != nil {
		return BlockBatch{}, fmt.Errorf("区块号: %w", err)
	}
	timestamp, err := parseHexUint64(raw.Timestamp)
	if err != nil {
		return BlockBatch{}, fmt.Errorf("区块时间: %w", err)
	}
	hash, err := normalizeFixedHex(raw.Hash, 32)
	if err != nil {
		return BlockBatch{}, fmt.Errorf("区块哈希: %w", err)
	}
	parent, err := normalizeFixedHex(raw.ParentHash, 32)
	if err != nil {
		return BlockBatch{}, fmt.Errorf("父哈希: %w", err)
	}
	out := BlockBatch{Number: number, Timestamp: timestamp, Hash: hash, ParentHash: parent, ChainTime: time.Unix(int64(timestamp), 0).UTC()}
	out.Transactions = make([]Transaction, len(raw.Transactions))
	for i, tx := range raw.Transactions {
		value := new(big.Int)
		if _, ok := value.SetString(strings.TrimPrefix(tx.Value, "0x"), 16); !ok {
			return BlockBatch{}, fmt.Errorf("交易 value 无效")
		}
		input, err := decodeHexBytes(tx.Input)
		if err != nil {
			return BlockBatch{}, fmt.Errorf("交易 input: %w", err)
		}
		hash, err := normalizeFixedHex(tx.Hash, 32)
		if err != nil {
			return BlockBatch{}, err
		}
		from, err := normalizeFixedHex(tx.From, 20)
		if err != nil {
			return BlockBatch{}, err
		}
		to := ""
		if tx.To != "" {
			to, err = normalizeFixedHex(tx.To, 20)
			if err != nil {
				return BlockBatch{}, err
			}
		}
		if tx.TransactionIndex != "" {
			index, indexErr := parseHexUint64(tx.TransactionIndex)
			if indexErr != nil || index != uint64(i) {
				return BlockBatch{}, fmt.Errorf("交易 transactionIndex 与块内顺序不一致")
			}
		}
		out.Transactions[i] = Transaction{Hash: hash, From: from, To: to, Value: value.String(), Input: input, Index: uint64(i)}
	}
	return out, nil
}

func decodeReceipt(raw rawReceipt, txIndex uint64, expectedBlockHash string) (Receipt, error) {
	hash, err := normalizeFixedHex(raw.TransactionHash, 32)
	if err != nil {
		return Receipt{}, err
	}
	blockHash, err := normalizeFixedHex(raw.BlockHash, 32)
	if err != nil || blockHash != expectedBlockHash {
		return Receipt{}, fmt.Errorf("收据区块哈希不匹配")
	}
	status, err := parseHexUint64(raw.Status)
	if err != nil || status > 1 {
		return Receipt{}, fmt.Errorf("收据 status 无效")
	}
	if raw.TransactionIndex != "" {
		index, indexErr := parseHexUint64(raw.TransactionIndex)
		if indexErr != nil || index != txIndex {
			return Receipt{}, fmt.Errorf("收据 transactionIndex 与交易顺序不一致")
		}
	}
	out := Receipt{TxHash: hash, BlockHash: blockHash, TxIndex: txIndex, Status: status, Logs: make([]Log, len(raw.Logs))}
	for i, item := range raw.Logs {
		address, err := normalizeFixedHex(item.Address, 20)
		if err != nil {
			return Receipt{}, err
		}
		data, err := decodeHexBytes(item.Data)
		if err != nil {
			return Receipt{}, err
		}
		index, err := parseHexUint64(item.LogIndex)
		if err != nil {
			return Receipt{}, err
		}
		topics := make([]string, len(item.Topics))
		for j, topic := range item.Topics {
			topics[j], err = normalizeFixedHex(topic, 32)
			if err != nil {
				return Receipt{}, err
			}
		}
		out.Logs[i] = Log{Address: address, Topics: topics, Data: data, Index: index, ReceiptLogIndex: uint64(i), Removed: item.Removed}
	}
	return out, nil
}

func normalizeFixedHex(value string, size int) (string, error) {
	value = strings.ToLower(strings.TrimSpace(value))
	if !strings.HasPrefix(value, "0x") || len(value) != 2+size*2 {
		return "", fmt.Errorf("十六进制值长度应为 %d 字节", size)
	}
	if _, err := hex.DecodeString(value[2:]); err != nil {
		return "", err
	}
	return value, nil
}

func decodeHexBytes(value string) ([]byte, error) {
	value = strings.TrimPrefix(strings.ToLower(strings.TrimSpace(value)), "0x")
	if len(value)%2 != 0 {
		return nil, fmt.Errorf("十六进制字节长度必须为偶数")
	}
	return hex.DecodeString(value)
}

func hexQuantity(value uint64) string { return fmt.Sprintf("0x%x", value) }
