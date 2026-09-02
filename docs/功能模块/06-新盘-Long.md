# 06 新盘 · Long

- 最新更新时间：2026-09-02 14:40 (UTC+8)
- 适用范围：`internal/venue/long`
- 来源：FR-01；底稿 §3.6；`docs/调研/09`、`02` §3.5
- 对应需求：FR-01（Long 只认入口）；验收 AC-01
- 落地包：`internal/venue/long`
- **本期状态：暂缓。** 用户要求先只落地 **加密货币**盘口；Long 已核样本 quote 为股票代币，与本期范围不一致。不实现本包、不扫 LongLauncher（目录 `ignore`）。文档保留，恢复时仍 **只认 LongLauncher**，禁止 Airlock。

## 本期不做什么

- 启动不强制 LongLauncher 条目
- 恢复前不要把 Airlock Create 当发现源

以下正文供恢复时实现，**当前写代码不要按下面主路径开工**。

## 职责

只认 **LongLauncher** `LaunchCreated`。产出 `LongLaunch`。买卖走共享 v4。

## 边界

- **禁止** Airlock `Create` 当发现源（Bankr 等共用）
- 不要把代币 owner（Airlock）默认当聪明钱
- 不要假设 meme 永远是 currency1；不要把 `e18` 后缀当硬规则
- `LaunchCreated.poolOrHook` 样本等于代币地址，**不是** PoolKey.hooks；hooks 以 `Initialize` 为准
- v0 不做 Bags/Bankr

## 输入 / 输出

创建：LongLauncher `LaunchCreated` + 同笔 PoolManager `Initialize`。输出领域对象 + 登记 pool。

## 主路径 · 创建

1. emitter = LongLauncher `0x22e99278…eeed`，topic0 = `LaunchCreated`。
2. 解码：asset（token）、numeraire（quote）、launcher、tickerKey、poolInitializer、deployedAt、reservedUntil 等（字段以调研 `09` ABI 为准）。
3. `creator_eoa` = `tx.from`（样本等于 launcher）。`launcher` 另存。`creator_contract` 可空或填事件需要区分的合约侧，**不要填 Airlock 当创建人 EOA**。
4. 同笔 `Initialize.id` → `pool_id`；fee / tickSpacing / hooks 来自 Initialize。样本常见动态费、`tickSpacing=8`、hooks=`DopplerHookInitializer`，以本笔为准不要写死。
5. `quote_symbol`：numeraire 查 `quote_assets`；未知 `UNKNOWN`。
6. `airlock` 列填常量便于审计，不因此监听 Airlock。
7. `integrator` 能从 calldata 解则存。
8. `[新盘] 盘口=Long`。登记 pool。index.category=`long`，price 空。

幂等与分类冲突同前。

## 落库字段（`launch_long`）

底稿 §3.6 定稿：

`token_address`(PK)、`symbol`、`name`、`quote_address`、`quote_symbol`、`quote_decimals`、`pool_id`、`fee`、`tick_spacing`、`hooks`、`ticker_key`、`deployed_at`、`reserved_until`、`pool_initializer`、`launcher`、`creator_eoa`、`integrator`、`airlock`、`initial_supply`、`num_tokens_to_sell`、`block_number`、`tx_hash`、`log_index`、`created_at`。

Airlock 的 `Create`/`FeeScheduleSet` **不落库**。无价格、无 `raw_json`。

## 买卖

模块 `07`。quote = `numeraire`。用户 = meme Transfer 最后一跳 EOA，不用 `Swap.sender`。

## 验收

- 一笔真实 LongLauncher 创建：目录为 Long，能回答配对（股票代码）与创建人。
- 同时间段 Airlock 上非 Long 的 Create：**零条** `launch_long`。

## 调研

`docs/调研/09-Long解析与交易.md`。发现过滤器 emitter **仅** LongLauncher。
