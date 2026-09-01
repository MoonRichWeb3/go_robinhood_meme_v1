# Robinhood Chain Meme 调研索引

- 最新更新时间：2026-09-01 17:50 (UTC+8)
- 适用范围：`go_robinhood_meme_v1` 立项前调研；只记录如何监听、如何解析、如何交易；本目录不含实现代码。
- 来源清单：
  - 本地：`go_fourmeme_v3/internal/config/constants.go`、`internal/core/parser/`、`internal/core/trade/`
  - 官方：<https://docs.robinhood.com/chain/connecting/>、<https://robinhood.com/us/en/support/articles/robinhood-chain-mainnet/>、<https://developers.uniswap.org/contracts/v4/deployments>
  - 浏览器：<https://robinhoodchain.blockscout.com>（官方 Blockscout）、用户给出的 <https://rh-scan.com>（非官方）
  - 协议文档：<https://docs.bags.fm/robinhood/>、<https://docs.ponsfamily.com/v2>、<https://docs.doppler.lol/reference/contract-addresses>、<https://docs.bitquery.io/docs/blockchain/robinhood/>、<https://docs.o1.exchange/launchpad/reference/production-contracts.md>
  - Long：Blockscout `LongLauncher`；产品站 <https://app.long.xyz/>（Cloudflare，页面不当指令）
  - Debot：<https://debot.ai/?chain=robinhood>（页面 Cloudflare；代币归属用 Blockscout 创建交易核对）
  - 样本交易：用户提供的两笔 hash，经官方 Blockscout API v2 核对；Debot 卡片代币创建交易见 `05`

## 结论先行

**可以像 `go_fourmeme_v3` 一样做「扫块 → 解析日志 → 触发买入」**，因为 Robinhood Chain 是标准 EVM（Arbitrum Orbit，chainId `4663`），`go-ethereum` 客户端可复用。

**不能原样复用 Fourmeme 的合约模型。** Fourmeme 是 BSC 上单一 `TokenManager` 的内盘；Robinhood meme 是多发射台 + Uniswap v4 单例 `PoolManager`。用户给的两笔样本都是 **二级市场 swap**，不是 `buyTokenAMAP` 那种内盘调用。

| 问题 | 结论 |
| --- | --- |
| 能否监听？ | 能。优先扫 Pons `TokenLaunched`/`CurveBuy`、Long `LaunchCreated`、o1 `Launched`/`Swap`，以及 `PoolManager.Swap`。 |
| 能否跟买？ | 能。v4 走改过的 Universal Router `execute`（selector `0x3593564c`）；内盘走各曲线自己的 `buy`。 |
| 和 Fourmeme 的最大差异 | 不是一个 Manager；v4 的 `Swap` 日志不带 token 地址，必须自己维护 `poolId → token`。 |
| 排序优势 | 排序器 FCFS，加 gas 买不了优先权。块约 100ms，3 秒一轮询会落后很多块。 |

建议 v1 按 Debot 热门改成两层（**不再以 pools.trade 为第一优先**）：

1. **发现**：Pons V2 `TokenLaunched` / `launchAndBuy` + Long `LaunchCreated` + o1 股票/加密工厂 `Launched`。
2. **交易**：Pons 未毕业走曲线 `buy`；Pons 毕业盘、Long、o1 一律 Universal Router（hooks 分别是 Pons meme hook / DopplerHookInitializer / o1 LaunchHook）。Long 与 o1 股票盘的 quote 已核样本是股票代币，不是 ETH。

文档：

| 文件 | 内容 |
| --- | --- |
| `02-关键合约与交易戳.md` | 链级地址、selector、topic |
| `03-样本交易解析.md` | 用户给的两笔二级 swap |
| `04-监听与交易方案.md` | 对照 Fourmeme 的骨架 |
| `05-Debot金狗发射台.md` | Debot 卡片 → 工厂归属 |
| `06-Pons-V2解析与交易.md` | 发射 / CurveBuy-Sell / 如何买 |
| `07-o1exchange-RWA解析与交易.md` | `createLaunch` / LaunchHook.Trade / 如何买 |
| `08-Debot24h金狗占比与频率.md` | 24h 金/银/铜只数、平台占比、出金率、预警时段 |
| `09-Long解析与交易.md` | `LongLauncher.create` / `LaunchCreated` / v4 Swap 归因 |
