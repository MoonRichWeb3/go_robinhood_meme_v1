# 07 o1 Launchpad（股票配对）：发射事件、买卖事件、如何解析、如何交易

- 最新更新时间：2026-09-02 14:40 (UTC+8)
- 适用范围：Debot 本屏金狗 Rabbit（273x）所属协议；含 Robinhood 上加密货币配对孪生工厂。只调研，不实现
- **本期落地只使用 §1.2 加密工厂。** §1.1 股票工厂文档保留，扫块 ignore，见 `docs/功能模块/04`、`05`。
- 来源清单：
  - <https://docs.o1.exchange/launchpad/reference/production-contracts.md>
  - <https://docs.o1.exchange/launchpad/create/stock-paired-launches.md>
  - <https://docs.o1.exchange/launchpad/reference/events-functions.md>
  - <https://docs.o1.exchange/launchpad/integration/direct.md>
  - <https://docs.o1.exchange/launchpad/trading/fees-referrals.md>
  - Uniswap v4 / v3 `sqrtPriceX96` 定义（与 `02` 共用）
  - Blockscout 已验证 ABI：`RWAERC20LaunchpadFactory`、`LaunchHook`
  - Rabbit 创建交易 `0x2773f014…2672`

## 结论先行

o1 **没有 Pons 那种独立 bonding 合约**。`createLaunch` 当场部署 ERC-20、开 Uniswap v4 池、把供应锁进 LaunchHook 单边流动性。买卖 = 带 LaunchHook 的 v4 Swap + Universal Router。

Rabbit 走的是 **股票配对工厂**，报价资产是股票代币 **WYFI**，不是 ETH。用 ETH 直接买会路径错误。代币地址必须以 `01` 结尾。

**成交价：** exec 用本笔 meme 与 quote 的数量比，再折 U。开盘 anti-snipe 时 exec 会远高于 sqrt 中间价，**交易表必须用 exec**。币对表按需求刷最近成交 U（`01` §3.8），不要每笔写 sqrt。sqrt 公式仍见下节，仅作池子中间价理解。

## 1. 两套 Robinhood 工厂（不要混）

### 1.1 股票配对（Rabbit / Debot 金狗）

| 角色 | 地址 |
| --- | --- |
| Stock-paired Launch Factory（链上名 `RWAERC20LaunchpadFactory`） | `0xe64AC4113848BBC1a6dDE1A6D1da96720A36F297` |
| Launch Hook | `0x778b0c4EeA7D35D66513B587bA87FC9084b0EaCC` |
| Fee Escrow | `0x4f2b1cDa8748CD64C56039bf5E2e54bC13D4A3d7` |
| Launch Token Deployer（Rabbit 的 `creator` 合约） | `0x6544AF3524a8d9135Eb5765CECE6E514d85D615b` |
| Announcement Registry | `0x6a95911db04219674323AA0137c3377523c0E29F` |

官方：194 个已注册股票代币；创建费 0.001 ETH；新创建开启。Rabbit 的 `quote` = WYFI `0x9e7ABD3C9139D14E4c86DcE0e455AAB7A0C2FB3E`。

### 1.2 加密货币配对（ETH / USDG，本屏未见金狗样本）

| 角色 | 地址 |
| --- | --- |
| ERC-20 Launchpad Factory | `0x411F21283D3E492BC395027329e08f9F4F560Ba5` |
| Launch Hook | `0x441F773B3bb1Ed4c6457D0528624112e43C02acc` |
| Fee Escrow | `0x32f7a9A05bD62487D085Ad494e14Ec42543e19d2` |
| Launch Token Deployer | `0x7dA2f15e0bbc564fbde55a4E23147f490061BbAb` |

监听时按 `hooks` 区分股票盘 vs 加密盘，不要只认一个 hook。

共享基础设施（见 `02`）：PoolManager `0x8366a39C…0951`，Universal Router `0x88767899…0904`，Permit2 规范地址。

## 2. 发射事件

Rabbit 创建：`to` = 股票工厂，`createLaunch(LaunchParams) payable`，selector **`0x5b09db59`**（该笔交易解码）。`msg.value` = `nativeLaunchFee`（当前文档 0.001 ETH）。

LaunchParams（已验证 ABI）：

```text
name, symbol, contractURI, salt, quote,
allocationRecipients[], allocationAmounts[], vestedAllocations[],
expectedConfigVersion, deadline, roleMode,
metadataKeys[], metadataValues[]
```

股票盘还要求：先定元数据，读 `launchTokenBytecodeHash`，挖 `salt` 使预测地址以 `01` 结尾。

同笔交易的规范事件：

| 事件 | emitter | topic0 | indexed | data |
| --- | --- | --- | --- | --- |
| `Launched(address,bytes32,address,address,uint256,int24)` | 工厂 | `0x207384e895174175cc774fe7f7457b37c382f27ebf53d37d5257b862f80eaf9c` | token, poolId, creator | quote, supply, tickSpacing |
| `PoolRegistered(bytes32,address,address,uint16)` | LaunchHook | `0x9e95ff6eeb67d651d785e878466df35fc6512fbefcc1e7f2d6a9969c79f9fbc9` | id, creator | platformTreasury, baseFeeBps |
| `Seeded(bytes32,uint256)` | LaunchHook | `0x6d4b4a1164728d1f0da29720fe5dacc0090f960127d964cb532dfb89eaf42014` | id | tokenSeeded |
| `Initialize` | PoolManager | `0xdd466e674e…d6438`（见 `02`） | poolId, currency0, currency1 | fee, tickSpacing, hooks, sqrtPrice, tick |

**解析落地：** 听工厂 `Launched`，一次拿到 token、poolId、quote、tickSpacing。再把 `poolId → (token, quote, hooks)` 写入表。后续 Swap 只有 poolId，没有 token 地址。

官方还提到 Base 上的 `createLaunchAndBuy` / `LaunchBuyExecuted`；Robinhood 股票工厂 ABI 本轮只看到 `createLaunch`。不要假设本链也有原子首买，除非该工厂 ABI 出现对应函数。

## 3. 买卖事件

没有 `CurveBuy`。成交是：

1. PoolManager `Swap`（topic0 `0x40e9cecb…112f`）— 数量与方向（`amount0`/`amount1` 符号）
2. LaunchHook `Trade` — 费用与推荐人，**不是**用户地址

```text
Trade(bytes32 indexed id, address indexed executor, address indexed referrer,
      address feeCurrency, uint256 totalFee, bytes32 comment)
topic0 0x94828ef2a4522ef87a2b6e4888550121212246d1a5b67ae9e967ce88210742ea
```

官方明确：`Trade.executor` 是 Router / callback sender，**不能**当交易者钱包。方向与用户要从整笔 receipt 推：meme `Transfer` 的 `to`/`from`，以及 `tx.from`。

正常手续费 1%，打在 **配对资产**（Rabbit 是 WYFI）。开盘 anti-snipe：Robinhood **16 秒**，总费率从 99% 线性降到 1%；超出 1% 的部分归平台。窗口内只允许 exact-in；exact-out revert `ExactOutputDisabledDuringAntiSnipe`。

## 4. 如何解析一笔交易

```text
新币
  factory.Launched → token, poolId, quote, tickSpacing
  校验 token 末字节 == 0x01（股票盘）
  校验 hooks == 对应 LaunchHook

买卖
  PoolManager.Swap.id == 已知 poolId
  zeroForOne / amount 符号 → 买 token 还是卖 token
  用户：tx.from；若 to==UniversalRouter 或 GMGN 代理，再用 token Transfer 对账
  可选：同 tx 的 LaunchHook.Trade 读 feeCurrency / totalFee / referrer
```

跟 Debot「聪明钱包同时买入」：看 token Transfer 进入 EOA 的 `to`，不要用 `Swap.sender`。

Rabbit 买的是 **WYFI → Rabbit**，不是 ETH → Rabbit。中间若经 GMGN 多跳（样本 2 那种），不要当买入模板。

## 5. 价格计算（股票盘与加密盘同一套池子公式）

o1 没有曲线。价格只来自 Uniswap v4 单例池。股票工厂和加密工厂 **公式相同**，差别只在 quote 是什么、以及 `usd_per_1_quote`。

创建时 `Initialize` 已带 `sqrtPriceX96`、`currency0`、`currency1`。之后每笔 `Swap` 的 data 里也有成交后的 `sqrtPriceX96`，**不必每笔再 `getSlot0`**（call 可作校验）。

### spot（中间价；需求里币对表展示用最近成交 U）

写库节奏见需求 `01` §3.8，不要每笔 Swap UPDATE 币对表。下面公式仍可用于理解池子中间价；**交易表 / 刷盘单价用 exec**。

```text
Q96 = 2^96
raw = (sqrtPriceX96 / Q96)^2     # 1 wei currency0 换多少 wei currency1

# 先分清哪侧是 meme、哪侧是 quote（地址排序，meme 不一定是 token1）
# Rabbit：quote=WYFI，meme=Rabbit；QI 样本 currency0=QUBT、currency1=QI

若 meme == currency1 且 quote == currency0：
    spot_quote = (Q96^2 / sqrtPriceX96^2) * 10^(quoteDec - tokenDec)
    即 1/raw 再缩小数位
若 meme == currency0 且 quote == currency1：
    spot_quote = raw * 10^(quoteDec - tokenDec)

spot_usd = spot_quote * usd_per_1_quote
```

| 分类 | quote | usd_per_1_quote |
| --- | --- | --- |
| `o1_stock` | 股票代币（WYFI、QUBT…） | 该股 USD（喂价待实现） |
| `o1_crypto` | ETH `0x0` / WETH 或 USDG | eth_usd 或 1 |

Robinhood 股票代币样本为 18 decimals；USDG 为 6。必须用链上 `decimals()`，不要写死。

池子 LP `fee=0`，手续费在 LaunchHook（通常 1% 打在 quote 上）。**sqrtPrice 是池子中间价，未含 hook 费。** 这正是币对表要的 spot。

### exec（写交易表）

用本笔 **实际转账的 quote 与 meme**（Transfer 净额优先；Swap `amount0/1` 作交叉）：

```text
exec_quote = abs(quote_amount_human) / abs(token_amount_human)
exec_usd   = exec_quote * usd_per_1_quote
```

方向：meme 流入用户 = 买；meme 离开用户 = 卖。不要用 `Swap.sender`。探测里出现过 Swap 符号与 Transfer 不一致，**exec 以 Transfer 为准**。

anti-snipe（Robinhood 16 秒，费率 99%→1%）：用户实付 quote 远大于中间价。`exec_quote >> spot_quote` 是预期现象；**交易表和币对表展示都用 exec 折 U**，不要用 sqrt 冒充成交价。

无 Swap、只有创建：不刷 `price_usd`，exec 无。

## 6. 如何交易（编码口径，未下单）

官方推荐：v4 Quoter 报价 → Permit2 → Universal Router。保留精确 PoolKey：

- currencies 按地址排序
- LP `fee = 0`（手续费在 hook 上）
- `tickSpacing` 用 `Launched` / `Initialize` 记下的值（文档举例当前模板为 200，**不要写死**）
- `hooks` = 该路由的 LaunchHook

Robinhood UR 必须带 `minHopPriceX36 = 0`（见 `02`）。

hookData（官方 direct 集成）：推荐人地址 + `bytes32` comment。无效推荐人不会把 swap revert，份额改给平台。不要把交易者自己、creator、平台、Router、PoolManager 填进 referrer。

股票盘买：

1. 钱包持有足够 **quote 股票代币**（Rabbit = WYFI）。
2. `approve` Permit2，再 UR `V4_SWAP` exact-in。
3. 16 秒窗口内不要发 exact-out。
4. `deadline` 用时间戳。

股票盘卖：token → 股票代币，手续费从收到的股票代币扣。

o1 另提供 Public API `quote-a-swap` / `prepare-a-swap` 生成 UR calldata。自建 bot **建议 / 推断**仍应自己编 UR，API 只作对照；实现阶段再定。

## 7. 和 Pons / Fourmeme 对照

| | Pons V2 | o1 股票盘 | Fourmeme |
| --- | --- | --- | --- |
| 内盘 | 每币曲线 `buy` | 无，创建即 v4 | 固定 Manager |
| 发现 | `TokenLaunched` | `Launched`（带 poolId） | Create event |
| 成交 | `CurveBuy`/`Sell` | `Swap` + `Trade` | Manager Buy/Sell |
| 报价 | ETH 或 USDG | 股票代币（或加密工厂的 ETH/USDG） | BNB |
| 狙击 | 5 秒指数税，读 `currentSnipeTaxBps` | 16 秒线性 99%→1% | 平台规则不同 |
| 毕业 | 有 | 无（流动性永久锁） | 无 |

## 8. 显式缺口

- Base 的 `createLaunchAndBuy` 适配器未在 Robinhood 股票 ABI 中出现；本链原子首买未证实。
- Rabbit 创建后的一笔具体 Swap calldata 本轮 Blockscout 403，未再拆 UR 字节；编码以官方 direct 集成 + `02` UR 结构为准。
- 194 个股票 quote 地址以官方 catalog 为准，会变；只缓存「已发射池」的 quote，不要全表写死进生产常量。
