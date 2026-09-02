# 功能模块

- 最新更新时间：2026-09-02 14:58 (UTC+8)
- 适用范围：v0 **写代码前**的功能说明书；每个模块对应一块可落地的职责
- 来源：[`docs/需求/01-产品需求说明书.md`](../需求/01-产品需求说明书.md)、[`docs/架构/`](../架构/README.md)、[`docs/调研/`](../调研/README.md)；字段定稿吸收自 [`docs/需求梳理/01-初识需求设定.md`](../需求梳理/01-初识需求设定.md) §3–7（与需求冲突时以需求为准）
- 需求：[`docs/需求/01-产品需求说明书.md`](../需求/01-产品需求说明书.md)
- 架构：[`docs/架构/`](../架构/README.md)
- 链上事实：[`docs/调研/`](../调研/README.md)

**用法：** 实现某包时先打开对应编号文档，不要凭记忆补规则。文档与代码冲突时：需求 > 本目录 > 架构细节 > 调研公式。

| 编号 | 模块 | 落地包（建议） | 需求 |
| --- | --- | --- | --- |
| [`00`](00-阅读约定.md) | 每篇文档怎么写、实现顺序 | — | — |
| [`01`](01-扫块与水位.md) | 拉块、水位、重组不回滚 | `internal/chain` `internal/app` | FR-10 |
| [`02`](02-合约目录与分流.md) | 多合约登记、按 log 分流 | `internal/contracts` `internal/venue/route` | FR-01 |
| [`03`](03-新盘-Pons.md) | Pons 创建与毕业 | `internal/venue/pons` | FR-01 |
| [`04`](04-新盘-o1股票.md) | o1 股票创建（**本期暂缓，不扫不实现**） | `internal/venue/o1stock` | FR-01 |
| [`05`](05-新盘-o1加密.md) | o1 加密创建（**本期落地**） | `internal/venue/o1crypto` | FR-01 |
| [`06`](06-新盘-Long.md) | Long 创建（**本期暂缓**：报价为股票） | `internal/venue/long` | FR-01 |
| [`07`](07-成交与用户归因.md) | 曲线/v4 成交腿、用户是谁 | `venue/pons` `venue/v4fill` | FR-03 FR-05 |
| [`08`](08-聪明钱包名单.md) | 名单热加载、匹配 | `internal/wallets` | FR-02 |
| [`09`](09-交易记录与FIFO.md) | wallet_events、已实现盈亏 | `internal/store` `internal/domain/fifo` | FR-03 FR-04 |
| [`10`](10-展示单价.md) | 3 秒刷 launch_index.price_usd | `internal/price` | FR-05 |
| [`11`](11-折U.md) | quote → 美元；禁止写 0 | `internal/price` | §7 |
| [`12`](12-评分.md) | 聪明钱分数与级别 | `internal/score` | FR-06 |
| [`13`](13-中文日志.md) | stdout 键名与标签 | `internal/logx` | FR-09 |
| [`14`](14-只读HTTP.md) | 健康/新盘/流水 | `internal/httpsvc` | FR-08 |
| [`15`](15-优质项目查询.md) | 信号现算 | `httpsvc` + SQL | FR-07 |
| [`16`](16-存储主键与迁移.md) | SQLite、主键、大小写 | `internal/store` | FR-10 §2.3 |
| [`17`](17-配置启动与Docker.md) | env、组装、容器 | `cmd` `internal/config` | 非功能 |
| [`18`](18-交易表保留与分批删除.md) | `wallet_events` 只留 7 天、小时分批删 | `internal/store` `internal/app` | FR-10 |
| [`19`](19-代码目录与文件清单.md) | 代码/文档物理路径与文件名 | 全仓 | 组织 |

**本期落地盘口：** Pons + o1加密。**暂缓：** o1股票、Long（文档编号不动，写代码时跳过 04/06）。

建议实现顺序：先按 [`19`](19-代码目录与文件清单.md) 建目录，再 16 → 17 → 18 → 01 → 02 → 03 → 05 → 07 → 08 → 11 → 09 → 10 → 13 → 12 → 14 → 15。跳过 04、06。文件名以 19 为准。
