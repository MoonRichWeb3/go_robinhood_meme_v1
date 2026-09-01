# 06 Pons V2：发射事件、买卖事件、如何解析、如何交易

- 最新更新时间：2026-09-01 21:16 (UTC+8)
- 适用范围：Debot 同屏新盘（Chair / FWOBIN）所属协议；只写监听、编码与**价格算法**，不含 bot 实现
- 来源清单：
  - 官方 <https://docs.ponsfamily.com/v2>（Getting a quote / getReserves）
  - Blockscout 已验证 ABI：`PonsV2LaunchAndBuy`、`PonsV2BondingCurve`
  - Chair / FWOBIN 创建交易（见 `05-Debot金狗发射台.md`）
  - topic0 由 Foundry `cast keccak` 与 Bitquery / 官方事件表交叉

## 结论先行

Pons V2 是 **工厂 + 每币一条 bonding 曲线 + 毕业进 Uniswap v4**。新币发现听工厂 / LaunchAndBuy；内盘买卖听曲线事件（按 topic0 全链滤，不要只听工厂地址）；毕业后买卖走 Universal Router，hooks 必须是 Pons meme hook。

**成交价：** 事件 `quoteIn/tokensOut` 或 `quoteOut/tokensIn`（毕业后改 Transfer 净额）。需求里交易表用这个；币对表展示用最近成交折 U，3 秒刷盘（`01` §3.8）。`getReserves()` 边际价仍可用于理解曲线，不要用 `realQuoteReserve()` 当成交价。

和 Fourmeme 的对应关系：曲线 `buy` ≈ `buyTokenAMAP`；`CurveBuy` ≈ Manager Buy 事件。差别：曲线地址不固定、quote 可以是 ETH 或 USDG、开盘 5 秒有狙击税。

## 1. 固定合约

| 角色 | 地址 |
| --- | --- |
| PonsV2LaunchFactory | `0x7eD598BcEf8bd9Edd8C97A195C6d13f40801EC7e` |
| PonsV2LaunchAndBuy（创建+首买） | `0xe33E9E479dF8802cb0866d5d05258bEc4cF62948` |
| PonsV2MemeHook | `0xE5e702641Ea86F4ae6cc3cdaed2b886f976Be044` |
| PonsV2LaunchLocker | `0x267444D099b10fB5Ed7c3Cc7B7c767AdcA574952` |
| 曲线实现模板（不是每币地址） | `PonsV2BondingCurve` `0x1269178A6e6248ACf4C9c9f3498B45EE1A80e788` |
| 报价 USDG | `0x5fc5360D0400a0Fd4f2af552ADD042D716F1d168`（6 位小数） |
| 报价 ETH | `0x0000000000000000000000000000000000000000` |

每个 token 有自己的曲线实例。Chair 曲线：`0x492607f06055db795e858Ef3CcAF6C0EF775A98B`。

## 2. 发射事件

### 2.1 前端实际入口：`launchAndBuy`

Debot 新盘 Chair / FWOBIN 都打在 LaunchAndBuy，不是工厂的纯 `launchToken`。

```text
launchAndBuy(
  TokenParams params,
  uint256 launchConfigId,
  address pairToken,
  uint256 quoteIn,
  uint256 minTokensOut,
  address recipient,
  address[] snipeTaxExemptions
) payable
returns (address token, address curve, uint256 tokensOut)
```

- selector（Chair 创建交易已解码）：**`0xf85f8e41`**
- `msg.value`：`pairToken == 0x0` 时 = 发射费 + `quoteIn`；USDG 配对时 = 仅发射费，USDG 另 `approve` LaunchAndBuy
- TokenParams：`name, symbol, logo, description, socials, creatorFeeRecipient, creatorTaxBps, buybackEnabled, expectedEconomics, salt`

同笔交易会再发出：

| 事件 | emitter | topic0 | indexed | data |
| --- | --- | --- | --- | --- |
| `Launched(address,address,address,address,uint256,uint256)` | LaunchAndBuy | `0xdcacba5e347ae7abd91cb519eb877af8fa7774e347b85dd3ddcd24a2ba8cdf37` | token, curve, recipient | launcher, quoteSpent, tokensReceived |
| `TokenLaunched(address,address,address,address,uint256,uint256)` | Factory | `0x8d4aad4953d0ca700d468f3753aa14432d1b35b43ec6409f051fb6aa43a89607` | token, curve, deployer | pairToken, launchConfigId, graduationThreshold |
| 首买 `CurveBuy` | 该币曲线 | 见下节 | buyer, recipient | quoteIn, tokensOut, fee, tax |

**解析落地：** 过滤器优先 `TokenLaunched`（工厂地址固定）。记下 `token`、`curve`、`pairToken`。`Launched` 用来确认首买数量。不要从「全链 Transfer mint」扫。

纯创建（无首买）走工厂 `launchToken`，同样发 `TokenLaunched`。

## 3. 内盘买卖事件

曲线地址每币不同。**按 topic0 扫全链 log**，再用本地 `curve → token` 表过滤。

| 事件 | topic0 | indexed | data |
| --- | --- | --- | --- |
| `CurveBuy(address,address,uint256,uint256,uint256,uint256)` | `0xec36bf571f136799e8dc0b0b8bea4b04d8bd3d43de838aab0d5fc21d4cbfc455` | buyer, recipient | quoteIn, tokensOut, fee, tax |
| `CurveSell(address,address,uint256,uint256,uint256,uint256)` | `0x8113d738abdcb6b38357e9d53a54a7157861a09031b453651f0fe7fe151f59df` | seller, recipient | tokensIn, quoteOut, fee, tax |
| `SnipeTaxCharged(address,uint256)` | `0x3bc39a5562b28f5fe8f36cecabfbaa12bb969acf05717994709225fc412a9934` | recipient | amount |
| `CurveBuyRefunded(address,uint256)` | 以 ABI 为准 | buyer | refund |

官方说明：买侧狙击税打进 `CurveBuy.fee`，不单独出现在 `tax` 字段；`tax` 是 creator tax。跟单聪明钱用 **`recipient`（拿到币的钱包）**，不要用 `buyer`（可能是路由合约）。

## 4. 毕业事件

| 事件 | topic0 | 含义 |
| --- | --- | --- |
| `LaunchSwept` | `0xcdb72f157fd3666758a6ce201387ffb52038c7562e4fff352828da1096c4b6b4` | 曲线达到阈值，准备金被抽走 |
| `PoolGraduated(address indexed token, uint256 positionId, uint256 tokenAmount, uint256 pairTokenAmount)` | `0x0a44ef75df69c534f43cd6c1aa3ef8983065fe5fe79ef9e79f6494e6f258c259` | v4 池已建并锁仓 |

毕业池特征（官方）：`fee=0`，`tickSpacing=200`，`hooks=PonsV2MemeHook`。此后曲线 `buy`/`sell` revert `CurveGraduated`。卖会比买更早关闭：`readyToGraduate()` 为真后拒绝卖。

同笔毕业交易还会有 PoolManager `Initialize` / `ModifyLiquidity`。用 hook 地址区分「这是 Pons 毕业盘」还是别的 v4 池。

## 5. 如何解析一笔交易

```text
receipt.logs
  ├── address == Factory && topic0 == TokenLaunched
  │     → 新币：token, curve, pairToken
  ├── topic0 == CurveBuy / CurveSell
  │     → 内盘成交；token = curves[log.address]
  │     → 用户钱包 = recipient
  │     → 方向 = Buy 或 Sell
  ├── address == Factory && topic0 == PoolGraduated
  │     → 切到 v4；后续只看 PoolManager.Swap 且 hooks==PonsMemeHook
  └── address == PoolManager && topic0 == Swap
        → 用 poolId 反查；Swap.sender 是 Router，用户看 meme Transfer.to
```

Chair 这类 USDG 盘：`quoteIn` 按 6 位小数；ETH 盘按 18 位。不要用 Debot 卡片上的美元金额当链上单位。

## 6. 价格计算（成交单价；币对表刷盘见需求 3.8）

链上怎么把储备/事件换成「1 枚多少 quote」如下。**落库：** 聪明钱成交价当场进 `wallet_events`；`launch_index.price_usd` 只对已监控且有成交的代币、默认 3 秒刷一次（需求 `01` §3.8）。本节公式仍可用于算出那笔成交单价。

官方（<https://docs.ponsfamily.com/v2> Getting a quote）：曲线 **没有** `quote()` view。定价是常数积 + **phantom quote**。路由器按下面整数顺序重放，才能和链上成交一致。

### 储备与开盘价

```text
k            = phantomQuote * totalSupply          # 创建时固定
quoteReserve = phantomQuote + realQuoteReserve     # getReserves() 的 x，含虚储备
tokenReserve = 曲线仍持有的 meme                   # getReserves() 的 y
不变式        quoteReserve * tokenReserve == k

getReserves()     → 用来报价、用来算 spot     （官方指定）
realQuoteReserve()→ 曲线实际拿到的 quote      （不能当展示价）
```

边际 **spot**（展示用，不含滑点、不含手续费）：

```text
spot_wei   = quoteReserve / tokenReserve          # quote 最小单位 / token 最小单位
spot_quote = spot_wei * 10^(tokenDec - quoteDec)  # 1 枚 meme 值多少 quote（人类单位）
# ETH 盘 tokenDec=18, quoteDec=18 → 系数 1
# USDG 盘 quoteDec=6 → 乘 10^12
```

开盘时 `realQuoteReserve=0`，spot = `phantomQuote / totalSupply`，所以第一笔买不是零成本（官方原文）。

### 成交价 exec（写交易表）

手续费打在 **quote 腿**，bps 分母 `10000`。

**买：** 先从 `quoteIn` 扣 `feeBps + creatorTaxBps + snipeTaxBps`，剩余进曲线：

```text
amountOut(in, reserveIn, reserveOut) = in * reserveOut / (reserveIn + in)

netIn     = quoteIn - fee - tax - snipe
tokensOut = amountOut(netIn, quoteReserve, tokenReserve)
# 若 tokensOut > sellableTokens：钳到可售量并退款（见官方 quoteBuy）

exec_quote = quoteIn / tokensOut * 10^(tokenDec - quoteDec)
# 用用户实付 quoteIn（含税），不是 netIn。狙击期 exec 会明显高于 spot。
```

**卖：** 先按曲线算出 gross quote，再从产出扣手续费（无狙击税）：

```text
gross      = amountOut(tokensIn, tokenReserve, quoteReserve)
quoteOut   = gross - fee(gross) - tax(gross)
exec_quote = quoteOut / tokensIn * 10^(tokenDec - quoteDec)
```

事件落地更省 RPC：`CurveBuy` 用 `quoteIn / tokensOut`；`CurveSell` 用 `quoteOut / tokensIn`。spot 仍应 `eth_call getReserves()`（或成交后用净流入自己维护 x、y）。call 失败则本笔 `spot_source=trade_vwap`，用 exec 顶上。

### 折 USD

```text
spot_usd = spot_quote * usd_per_1_quote
exec_usd = exec_quote * usd_per_1_quote
```

| pairToken | usd_per_1_quote |
| --- | --- |
| ETH `0x0` | eth_usd（喂价待实现） |
| USDG | 先按 1 |
| 其它已批准 quote（股票等） | 该资产 USD |

狙击窗 5 秒：`currentSnipeTaxBps(recipient)` 很大时，exec 会明显高于曲线边际价；**交易表仍记实际成交 U**（含税），币对表也刷这笔成交 U。不要用 reserves 冒充用户成交价。

### 毕业后

`PoolGraduated` 之后曲线 revert。spot 改 `02` 的 v4 `sqrtPriceX96` 公式，`hooks=PonsV2MemeHook`。exec 改 `|Δquote|/|Δmeme|`（来自 Swap + Transfer）。

## 7. 如何交易（编码口径，未下单）

### 7.1 内盘买 — 对 **曲线** 调 `buy`

```text
buy(uint256 quoteIn, uint256 minTokensOut, address recipient) payable → tokensOut
selector 0x59a87bc1
```

| pairToken | 步骤 |
| --- | --- |
| ETH `0x0` | `to=curve`，`value=quoteIn`，且 `quoteIn` 必须等于 `value` |
| USDG | 先 `USDG.approve(curve, quoteIn)`，再 `buy`，`value=0` |

开盘 5 秒狙击税：从 99% 指数衰减到 0（约 1 秒 25%、2 秒 3%）。必须 `eth_call` `currentSnipeTaxBps(recipient)`，key 是 **收款人** 不是 `msg.sender`。曲线数学报价在窗口内会虚高。

`minTokensOut` 约束的是单价，接近毕业时允许部分成交 + `CurveBuyRefunded`。以事件里的 `tokensOut` 为准。

### 7.2 内盘卖

```text
sell(uint256 tokensIn, uint256 minQuoteOut, address recipient)
selector 0xd04c6983
```

先 `token.approve(curve, tokensIn)`。卖不受狙击税。`readyToGraduate()` 后不要再卖曲线。

### 7.3 毕业后

走本目录 `02` 的 Universal Router `execute`（`0x3593564c`），`PoolKey.hooks = PonsV2MemeHook`，`minHopPriceX36=0`。ETH 盘 `value=amountIn`；USDG 盘走 Permit2 / 授权 UR。

### 7.4 不要做

- 把 `launchAndBuy` 当普通跟买（那是创建+开发者首买）。
- 毕业后还打曲线。
- 用 Fourmeme `buyTokenAMAP` 或未改过的 Uniswap SDK（缺 `minHopPriceX36` 会 revert）。

## 8. 对照 Fourmeme

| | Fourmeme | Pons V2 内盘 |
| --- | --- | --- |
| 创建 | TokenManager Create | `TokenLaunched` / `launchAndBuy` |
| 买入口 | 固定 Manager | **每币曲线** `buy` |
| 买事件 | Manager Buy | `CurveBuy`（全链 topic） |
| 用户地址 | 事件 buyer | 优先 `recipient` |
| 毕业 | 无（一直内盘） | `PoolGraduated` → UR |
