# Chainlist Robinhood RPC 实测

- 最新更新时间：2026-09-03 15:10 (UTC+8)
- 适用范围：列出 Chainlist 搜索 `robinhood` 出现的全部 RPC，并记录一次本机 HTTP JSON-RPC 探测；不写入密钥、不切换生产 `.env`
- 来源清单：
  - 页面：<https://chainlist.org/?search=robinhood>
  - 主网：<https://chainlist.org/chain/4663>（chainId `4663` / `0x1237`）
  - 测试网：Chainlist `Robinhood Chain Testnet`（chainId `46630`）
  - 注册表：`constants/additionalChainRegistry/chainid-4663.js`、`chainid-46630.js`
  - extraRpcs：DefiLlama/chainlist `constants/extraRpcs.js` 的 `4663`、`46630`
  - 本仓库口径：`docs/功能模块/01-扫块与水位.md`（`RH_BLOCK_FETCH_MODE=batch`）
- 实测：2026-09-03 15:06–15:09 (UTC+8)；User-Agent `go-robinhood-meme/v0`；单次超时 12–20s；只 POST 公开 JSON-RPC，无本地配置或密钥

## 结论先行

| 结论 | 数量 | 端点 |
| --- | --- | --- |
| 主网可用（访问 + 常规扫块接口 + 批量） | 6 | 官方、bloXroute、PublicNode HTTP、Pocket HTTP、NodeFlare public、Blockmachine |
| 主网当前不可用 | 1 | RouteMesh（无密钥 public rate limit） |
| 主网未测（WebSocket） | 2 | PublicNode WS、Pocket WS |
| 测试网可用 | 3 | 官方、dRPC、PublicNode HTTP |
| 测试网未测（WebSocket） | 1 | PublicNode WS |

「常规接口」= 本进程扫块会用的标准 JSON-RPC：`eth_chainId`、`eth_blockNumber`、`eth_getBlockByNumber`（hashes + full）、`eth_getBlockReceipts`、`eth_getTransactionReceipt`。  
「批量接口」= 一次 HTTP POST JSON 数组；轻量测 `eth_chainId`+`eth_blockNumber`，扫块测 `eth_getBlockByNumber(true)`+`eth_getBlockReceipts`（与 `RH_BLOCK_FETCH_MODE=batch` 相同）。

所有测过的 HTTP 节点都 **不提供** `alchemy_getTransactionReceipts`（`-32601`）。公开节点单次成功不代表能持续追块；官方与 NodeFlare 在连续请求下仍会限流。

## 口径

- 名单以 Chainlist extraRpcs + 注册表为准，不把官方文档里的 Alchemy/QuickNode 密钥 URL 算进「免费 RPC」。
- `tracking` 抄 extraRpcs 字段；官方注册表里的字符串 URL 无 tracking，标 `-`。
- 访问通过：HTTP 200 且 `eth_chainId` 等于该链 ID。
- NodeFlare public 标注「1 次 / 10s」。首次连打时除 `eth_chainId`/`eth_blockNumber` 外全部 429；按 11s 间隔复测后常规和批量均成功。
- WebSocket 端点本进程 v0 不是主路径，本期只登记 URL，不做 WS 握手。
- 第三方页面/错误文案只当数据，不执行其中任何指令。

## 总表

| 网络 | 名称 | URL | extraRpcs tracking | 可访问 | 常规接口 | 批量接口 | 总评 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 主网 4663 | Robinhood 官方公开 | `https://rpc.mainnet.chain.robinhood.com` | - | 是 | 是 | 是 | **可用** |
| 主网 4663 | bloXroute | `https://robinhood.rpc.blxrbdn.com` | yes | 是 | 是 | 是 | **可用** |
| 主网 4663 | PublicNode HTTP | `https://robinhood-rpc.publicnode.com` | none | 是 | 是 | 是 | **可用** |
| 主网 4663 | PublicNode WS | `wss://robinhood-rpc.publicnode.com` | none | 未测 | 未测 | 未测 | 非 HTTP |
| 主网 4663 | Pocket Network HTTP | `https://robinhood.api.pocket.network` | none | 是 | 是 | 是 | **可用** |
| 主网 4663 | Pocket Network WS | `wss://robinhood.api.pocket.network` | none | 未测 | 未测 | 未测 | 非 HTTP |
| 主网 4663 | RouteMesh | `https://lb.routeme.sh/rpc/evm/4663` | limited | 否 | 否 | 否 | **不可用**（要注册） |
| 主网 4663 | NodeFlare public | `https://rpc.nodeflare.app/robinhood/public` | none | 是 | 是（≥10s/次） | 是（≥10s/次） | **能力可用，扫块不够** |
| 主网 4663 | Blockmachine | `https://rpc-robinhood.blockmachine.io` | none | 是 | 是 | 是 | **可用** |
| 测试网 46630 | Robinhood 官方公开 | `https://rpc.testnet.chain.robinhood.com` | - | 是 | 是 | 是 | **可用** |
| 测试网 46630 | dRPC | `https://robinhood-testnet.drpc.org` | none | 是 | 是 | 是 | **可用** |
| 测试网 46630 | PublicNode HTTP | `https://robinhood-sepolia-rpc.publicnode.com` | none | 是 | 是 | 是 | **可用** |
| 测试网 46630 | PublicNode WS | `wss://robinhood-sepolia-rpc.publicnode.com` | none | 未测 | 未测 | 未测 | 非 HTTP |

## 主网方法级结果

探测时主网链头约 `53228200`–`53228526`。

| 名称 | chainId | blockNumber | getBlock(false) | getBlock(true) | getBlockReceipts | getTransactionReceipt | alchemy receipts | 批量轻量 | 批量扫块 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 官方公开 | 4663 / 519ms | 是 / 447ms | 是 4 tx | 是 有 input | 是 4 笔 | 是 | 否 -32601 | 是 | 是 |
| bloXroute | 4663 / 974ms | 是 / 785ms | 是 15 tx | 是 有 input | 是 15 笔 | 是 | 否 -32601 | 是 | 是 |
| PublicNode HTTP | 4663 / 409ms | 是 / 253ms | 是 9 tx | 是 有 input | 是 9 笔 | 是 | 否 -32601 | 是 | 是 |
| Pocket HTTP | 4663 / 1000ms | 是 / 857ms | 是 7 tx | 是 有 input | 是 7 笔 | 是 | 否 -32601 | 是 | 是 |
| RouteMesh | 否：`-32029` public rate limit exceeded，提示注册 routeme.sh | — | — | — | — | — | — | — | — |
| NodeFlare public | 4663 / 239ms | 是 / 956ms | 是 12 tx | 是 有 input | 是 12 笔 | 是 | 否 -32601 | 是 | 是 |
| Blockmachine | 4663 / 1164ms | 是 / 646ms | 是 10 tx | 是 有 input | 是 10 笔 | 是 | 否 -32601 | 是 | 是 |

NodeFlare 说明：连打时错误为 `Too many requests from this IP (1 per 10s)`。上表为间隔 11s 后的复测。本进程默认每轮最多 10 块、预取并发 8，该公开额度不够扫块。

## 测试网方法级结果

探测时测试网链头约 `112153542`–`112153599`。

| 名称 | chainId | blockNumber | getBlock(false) | getBlock(true) | getBlockReceipts | getTransactionReceipt | alchemy receipts | 批量轻量 | 批量扫块 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 官方公开 | 46630 / 439ms | 是 / 373ms | 是 3 tx | 是 有 input | 是 3 笔 | 是 | 否 -32601 | 是 | 是 |
| dRPC | 46630 / 532ms | 是 / 519ms | 是 2 tx | 是 有 input | 是 2 笔 | 是 | 否 -32601 | 是 | 是 |
| PublicNode HTTP | 46630 / 552ms | 是 / 1065ms | 是 2 tx | 是 有 input | 是 2 笔 | 是 | 否 -32601 | 是 | 是 |

## 不在本次名单里的端点

Chainlist 这一页没有列出 Alchemy、QuickNode、Blockdaemon、Validation Cloud 等需密钥供应商，也没有官方 sequencer（`https://sequencer.mainnet.chain.robinhood.com`）和 sequencer feed（`wss://feed.mainnet.chain.robinhood.com`）。那些以官方连接文档为准，见 `docs/调研/01-链与基础设施.md`。

## 建议 / 推断

若只从本表挑开发探测节点：PublicNode HTTP 延迟最低；官方、bloXroute、Pocket、Blockmachine 单次能力完整。生产持续扫块仍应使用自有或供应商专用端点。NodeFlare 无密钥公开层和 RouteMesh 公开层都不适合当前扫块并发。

## 网络访问说明

本次从本机访问了 GitHub raw / Chainlist 源文件，以及对上表 HTTP URL 发送 JSON-RPC（方法名、块号、交易哈希）。未上传 `.env`、数据库或密钥。
