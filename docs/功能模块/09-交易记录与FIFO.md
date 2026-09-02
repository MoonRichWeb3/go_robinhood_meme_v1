# 09 交易记录与 FIFO 盈亏

- 最新更新时间：2026-09-02 14:40 (UTC+8)
- 适用范围：`wallet_events` 写入、`internal/domain/fifo`
- 来源：FR-03、FR-04；底稿 §5.3、§7.2
- 对应需求：FR-03、FR-04；验收 AC-02、AC-04、AC-06、AC-09
- 落地包：`internal/store`（写事件）、`internal/domain/fifo.go`

## 职责

仅对 **当前有效名单** 写入发盘/买/卖；主键幂等；用交易行上的数量与成交单价 U 做 FIFO 已实现盈亏。盈亏 **现算**，不建盈亏表。

## 边界

- 全市场成交不进本表
- 发盘不进 FIFO
- 不用 `launch_index.price_usd` 算盈亏
- 不算未实现盈亏
- 不存 `raw_json`、不存 `spot_*` / `sqrt_price_x96`
- 表内数据只留 7 天：过期删除见模块 `18`，写入规则不变

## 输入 / 输出

| 行为 | 输入 | 写行 |
| --- | --- | --- |
| 发盘 | 创建事件 + 命中模块 `08` | `kind=launch` |
| 买/卖 | `Fill` + User∈active | `kind=buy/sell` |
| FIFO | 同一 wallet+token 的历史买卖行（有 U 的） | 卖出日志字段；**不**另表 |

## 主键

```text
id = 左补零(block_number, 8) + 左补零(tx_index, 4) + 左补零(log_index, 4)
```

缺 tx_index / log_index 当 0。超过宽度 **不截断**，打 `[错误]` 仍写入。`log_index` = 协议事件在 receipt 中的下标（CurveBuy/Swap/LaunchCreated），不是 Transfer。

例：块 `51337623`、tx `12`、log `7` → `5133762300120007`。

冲突（同一 id）：跳过，视为已处理（AC-06）。

纯函数 `CalcEventID` 必须可单测，禁止只在 SQL 里拼。

## 落库字段（`wallet_events`）

底稿 §5.3 定稿：

| 列 | 规则 |
| --- | --- |
| `id` | PK 上文 |
| `block_number` / `tx_index` / `log_index` | 参与拼接 |
| `tx_hash` | 小写，非主键 |
| `chain_time` / `ingested_at` | UTC |
| `wallet_address` | 小写；发盘规则见模块 `08` |
| `kind` / `direction` | `launch` / `buy` / `sell` |
| `category` | 四类英文 |
| `token_address` | 小写 |
| `quote_address` / `quote_symbol` | 发盘可空 |
| `quote_amount_raw` / `quote_decimals` | 最小单位 INTEGER 或 TEXT，不用 REAL 存 wei |
| `token_amount_raw` / `token_decimals` | 同上；发盘可为 0 |
| `exec_quote_per_token` | 1 meme 多少 quote；发盘可空 |
| `exec_usd_per_token` | **成交单价 U**；喂价缺失必须 SQL NULL，禁止 `0` |
| `quote_usd` | 1 单位 quote 的 USD（与折 U 快照）；可空 |
| `router` | 枚举见模块 `07` |
| 禁止列 | `raw_json`、中间价、展示价拷贝 |

索引：`(wallet_address, chain_time)`、`(token_address, chain_time)`、`(kind, chain_time)`、**(chain_time)**（过期删除用，见模块 `18`）。

发盘金额：0 或发射费；`token_address` 为新币。

## 主路径 · 写入

1. 构造行（含模块 `11` 的 U）。
2. INSERT OR IGNORE（或先查 id）。
3. 买/卖成功插入后更新 `smart_wallets.last_seen_at`（仅 active 命中时）。
4. 卖出：调用 FIFO；能算出则日志带 `已实现盈亏U`；超仓打 `[错误]`。
5. U 为空：仍插入（有数量），FIFO 跳过该行，不进评分。

## FIFO（纯函数，脱离 RPC）

范围：同一 `wallet_address` + 同一 `token_address`。顺序：`id` 升序（链上顺序）。

```text
买且 exec_usd_per_token 非空：入队 (qty, priceU)
卖且 exec_usd_per_token 非空：从队头扣
已实现盈亏U = Σ 匹配数量 × (卖出价U − 该仓买入价U)
```

数量用人类单位（raw / 10^decimals）。decimals 必须买卖一致；不一致打 `[错误]` 本笔不匹配。

例：买 100×1U，卖 50×2U → **50U**；余 50×1U。

一笔卖匹配多笔买：各段相加。

卖出超过剩余仓：匹配部分照算；超出部分 `[错误]` 类型=卖出超仓，**不得**用 0 成本。实现返回 `MatchedPnL` + `OverflowQty`。

U 为空的买：不入队。U 为空的卖：不匹配、不评分。

仓位只在内存按「该钱包该币 **表内仍在的** 历史事件」重放，或进程内缓存；v0 允许每次卖出对该钱包+代币重放（名单小）。过期行已被模块 `18` 删除则不再入队。缓存失效：新插入该对事件后。

发盘行跳过。

## 日志

`[聪明钱-发盘|买入|卖出]` 必填：时间、链上时间、钱包、盘口中文名、代币、方向、数量、成交单价U、交易。卖出附加已实现盈亏U（能算时）。U 空时键仍出现，值为空，并另打或缺价键见模块 `13`。

## 失败

写库 busy：整块失败，水位不前进（模块 `01`）。FIFO 超仓：行仍保留，错误日志。

## 依赖

store、fifo 纯函数、price 只提供 U 字段。venue 不直接 INSERT。

## 验收

- AC-04：50U。
- AC-06：同事事件两次仍一行。
- AC-09：不能折 U 时美元列不是 0。
- 单测：补零、FIFO 多段、超仓、空 U 跳过。

## 调研

成交数量算法在 `06`/`07`/`09`，本模块不重写 ABI。
