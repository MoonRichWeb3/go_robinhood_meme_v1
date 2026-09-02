// 本文件只处理父哈希分叉事实，不删除任何业务记录。
package chain

import (
	"context"
	"fmt"
)

// ResolveCanonicalParent 读取当前链上 n-1 块并验证其哈希就是待处理块的 parentHash。
func ResolveCanonicalParent(ctx context.Context, client *Client, block BlockBatch) (Watermark, error) {
	if block.Number == 0 {
		return Watermark{Name: WatermarkName, LastBlock: 0, LastHash: block.ParentHash}, nil
	}
	var raw rawBlock
	if err := client.Call(ctx, "eth_getBlockByNumber", []any{hexQuantity(block.Number - 1), false}, &raw); err != nil {
		return Watermark{}, err
	}
	hash, err := normalizeFixedHex(raw.Hash, 32)
	if err != nil {
		return Watermark{}, err
	}
	if hash != block.ParentHash {
		return Watermark{}, fmt.Errorf("当前块父哈希与 canonical n-1 不一致")
	}
	return Watermark{Name: WatermarkName, LastBlock: block.Number - 1, LastHash: hash}, nil
}
