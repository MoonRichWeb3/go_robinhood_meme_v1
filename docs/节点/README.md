# 节点

- 最新更新时间：2026-09-03 15:10 (UTC+8)
- 适用范围：Chainlist 上列出的 Robinhood 免费/公开 RPC 快照与连通性实测；不改进程配置、不替代 `.env` 的生产节点决策
- 来源清单：
  - 页面：<https://chainlist.org/?search=robinhood>
  - 主网页：<https://chainlist.org/chain/4663>
  - Chainlist 注册：<https://raw.githubusercontent.com/DefiLlama/chainlist/main/constants/additionalChainRegistry/chainid-4663.js>、<https://raw.githubusercontent.com/DefiLlama/chainlist/main/constants/additionalChainRegistry/chainid-46630.js>
  - extraRpcs：<https://github.com/DefiLlama/chainlist/blob/main/constants/extraRpcs.js>（`4663` / `46630`）
  - 扫块接口口径：`docs/功能模块/01-扫块与水位.md`

## 结论先行

Chainlist 搜索 `robinhood` 对应两条链：主网 `4663`、测试网 `46630`。页面上的 RPC 来自注册表官方 URL + `extraRpcs.js`，**不含** Alchemy / QuickNode 等需密钥端点。

主网 HTTP 里，当前能直接用来做本仓库扫块探测（`eth_chainId` + `eth_getBlockByNumber(true)` + `eth_getBlockReceipts` + HTTP JSON-RPC 批量）的有 6 个；RouteMesh 无密钥被限流；3 个 `wss://` 本期未做 WS 握手。公开节点单次探测通过 **不等于** 能追 100ms 出块，连续扫仍可能 429。

完整表格、方法级结果和失败原文见 [`chainlist-rpc实测.md`](chainlist-rpc实测.md)。
