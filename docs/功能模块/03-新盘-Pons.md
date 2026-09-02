# 03 新盘 · Pons

- 最新更新时间：2026-09-02 14:26 (UTC+8)
- 适用范围：`internal/venue/pons`、`internal/domain` 的 `PonsLaunch`
- 来源：`docs/需求/01` FR-01；底稿字段 `docs/需求梳理/01` §3.3；算法 `docs/调研/06`；地址 `docs/调研/02` §3.2
- 对应需求：FR-01；验收 AC-01（Pons 条）
- 落地包：`internal/venue/pons`

## 职责

认 Pons 创建、曲线买卖、毕业；产出 `PonsLaunch` / `Fill` / 毕业补丁。写库由 app+store 做。

## 边界

- 不写 SQLite、不算 FIFO、不匹配名单
- 不把 LaunchAndBuy 当用户钱包
- 毕业不是 `wallet_events`
- 不用 `getReserves()` / `realQuoteReserve()` 当成交价

## 输入 / 输出

| 路径 | 输入 | 输出 |
| --- | --- | --- |
| 创建 | Factory `TokenLaunched` + 同笔 receipts（可选 LaunchAndBuy `Launched`、首买 `CurveBuy`） | `PonsLaunch` + `LaunchIndexView` |
| 曲线买/卖 | `CurveBuy` / `CurveSell` + 曲线登记 | `Fill`（数量腿，用户=recipient） |
| 毕业 | `PoolGraduated` 或调研等价事件 | `phase=graduated`、`pool_id`、登记池 |

## 主路径 · 创建

1. `MatchCreate`：log.address = Pons Factory 且 topic0 = `TokenLaunched`（调研 `02`）。
2. 解码：`token`、`curve`、`deployer`、`pairToken`、`launchConfigId`、`graduationThreshold`。
3. `creator_eoa` = 该笔 `tx.from`（小写）。`deployer` / `creator_contract` = 事件 deployer。
4. `launch_entry`：同笔 `to` 为 LaunchAndBuy → `launch_and_buy`，否则 `factory`。
5. 配对名：`pairToken==0x0` → `ETH`；USDG 地址 → `USDG`；其它查 `quote_assets`，未知则 `UNKNOWN`（可附地址展示，不得用 Debot 名）。
6. TokenParams（name/symbol/logo/description）能从 calldata 解则填，解不出留空，打 `[错误]` 缺字段=名称，仍入库。
7. 同笔首买：LaunchAndBuy `Launched` 的 quoteSpent/tokensReceived 写入 `first_buy_*`；**不**因此写 `wallet_events`（除非模块 `08`/`09` 判定创建人在有效名单——那是发盘，不是这笔曲线买）。曲线首买若 recipient 在名单，另走成交路径（同笔可以既有发盘又有买入）。
8. `phase=curve`。`pool_id` 空。
9. app：INSERT `launch_pons` + `launch_index`（`price_usd` 空）。登记 `curve → token`。打 `[新盘]`。

幂等：`token_address` 已存在且 `category=pons` → 忽略。其它 category 已占用同一 token → `[错误]` 类型=分类冲突，不覆盖。

## 主路径 · 曲线成交

1. topic0 为 CurveBuy/Sell，用 emitter 查曲线登记；未登记则忽略（可能尚未扫到创建，或非 Pons）。
2. **用户地址**：买 = 事件 `recipient`；卖 = 卖侧拿到 quote 的 recipient（ABI 以调研 `06` 为准）。再用同笔 meme Transfer 交叉：买则 Transfer.to 应落到该用户。冲突打 `[错误]`，仍以事件 recipient 为准并记异常，不得改用 `buyer`/`seller`（可能是路由）。
3. 数量：买 `quoteIn` / `tokensOut`；卖 `tokensIn` / `quoteOut`（含税实付，调研口径）。不要减 fee 后再当成交额（fee 已含在官方字段语义里则按文档，禁止自己发明扣税）。
4. 输出 `Fill`：token、quote、两边 raw、decimals、user、`router=curve`。
5. app：已入库代币 → 标脏展示价；user∈有效名单 → 写交易表。

## 主路径 · 毕业

1. 匹配毕业事件（调研 `06` `PoolGraduated` / `LaunchSwept` 以能得到 poolId 者为准）。
2. UPDATE `launch_pons.phase=graduated`、`graduated_at`、`pool_id`；`launch_index.status=graduated`。
3. 登记 `pool_id → token+pons`。之后成交走模块 `07` 的 v4 通道。
4. 不写 `wallet_events`。不打聪明钱日志（除非另有买卖 log）。

## 落库字段（`launch_pons`）

与底稿 §3.3 定稿，实现不得少列、不得加价格列、不得加 `raw_json`：

`token_address`(PK)、`symbol`、`name`、`logo`、`description`、`curve_address`、`pair_address`、`pair_symbol`、`pair_decimals`、`launch_config_id`、`graduation_threshold`、`deployer`、`creator_eoa`、`creator_fee_recipient`、`launch_entry`、`first_buy_quote`、`first_buy_tokens`、`phase`、`graduated_at`、`pool_id`、`block_number`、`tx_hash`、`log_index`、`created_at`。

`launch_index` 同步：category=`pons`，pair 与创建人同上，status=`active`（毕业后 `graduated`）。

## 日志

`[新盘] 盘口=Pons 代币= 配对= 创建人= 名称=`（UTC 时间/链上时间）。解析失败 `[错误]`。

## 失败

| 情况 | 行为 |
| --- | --- |
| ABI 解不出 | `[错误]`，跳过该 log，水位前进 |
| 曲线未登记的 Buy | 忽略（非错误），不写库 |
| pair 未知 | `pair_symbol=UNKNOWN`，仍入库 |

## 依赖

domain 类型、contracts topic 常量。禁止 store。

## 验收

真实一笔 Pons `TokenLaunched`：目录 + `launch_pons` 都有；curve 能用于后续 Buy。LaunchAndBuy 创建分类仍是 Pons。

## 调研

`docs/调研/06-Pons-V2解析与交易.md`、`02` §3.2。不要把 Pons V1 工厂当 V2。
