# 17 配置启动与 Docker

- 最新更新时间：2026-09-02 22:38 (UTC+8)
- 适用范围：`cmd/`、`internal/config`、镜像与 compose
- 来源：架构 §6、§8；底稿 §7.4、§8；调研 `01`（RPC/UA）、`11`（trace RPC）
- 对应需求：非功能部署；密钥不进镜像
- 落地包：`cmd/app`、`internal/config`；文件名见模块 `19`

## 职责

读环境变量、校验、组装依赖、启动 HTTP 与扫块。缺必填配置拒绝启动。

## 边界

- 配置不含业务规则（FIFO 系数不进 env）
- 名单不进配置文件
- 工厂地址以合约目录为准，env 可覆盖（可选）；**本期缺 Pons / o1 加密 / PoolManager 则不得启动**
- 无私钥、无 mnemonic、无下单模块
- 不把 RPC 密钥写入 git / Dockerfile

## 环境变量（v0 定稿）

| 变量 | 必填 | 默认 | 含义 |
| --- | --- | --- | --- |
| `RH_RPC_URL` | 是 | — | HTTP RPC；密钥只出现在 env |
| `RH_FROM_BLOCK` | 否 | `0` | 仅无水位时使用；`0` 表示动态从当前链头前 10 块开始，非零表示固定起始块 |
| `RH_CHAIN_ID` | 否 | `4663` | 与节点不符则退出 |
| `RH_POLL_MS` | 否 | `80` | 见模块 `01` |
| `RH_MAX_BLOCKS_PER_TICK` | 否 | `10` | 见模块 `01` |
| `RH_HTTP_UA` | 否 | 产品名+版本 | 公开 RPC 需要 |
| `RH_RPC_TIMEOUT_MS` | 否 | `8000` | |
| `RH_TRACE_RPC_URL` | 否 | 空（禁用） | 独立 callTracer RPC；不得与扫块能力混为一谈 |
| `RH_TRACE_TIMEOUT_MS` | 否 | `8000` | 单笔 trace HTTP 超时；必须大于 0 |
| `RH_SQLITE_PATH` | 否 | `/data/robinhood_meme.sqlite3` | 本地开发可 `./data/...` |
| `RH_HTTP_ADDR` | 否 | `127.0.0.1:8888` | |
| `RH_PRICE_FLUSH_SEC` | 否 | `3` | |
| `RH_WALLET_RELOAD_MS` | 否 | `1000` | ≤1000 满足需求 |
| `RH_SCORE_INTERVAL_SEC` | 否 | `3600` | |
| `RH_SIGNAL_INTERVAL_SEC` | 否 | `3600` | |
| `RH_HEALTH_LAG_WARN` | 否 | `50` | |
| `RH_HTTP_QUERY_MS` | 否 | `3000` | |
| `LOG_LEVEL` | 否 | `info` | |
| `RH_DIRTY_TOKEN_CAP` | 否 | `5000` | 展示价脏集合上限 |
| `RH_BINANCE_BASE_URL` | 否 | `https://api.binance.com` | 见调研 `10`；不要把 Key 写进 URL |
| `RH_BINANCE_ETH_SYMBOL` | 否 | `ETHUSDT` | |
| `RH_ETHUSD_POLL_SEC` | 否 | `10` | 币安拉取间隔 |
| `RH_BINANCE_TIMEOUT_MS` | 否 | `3000` | |
| `RH_ETHUSD_TTL_SEC` | 否 | `30` | 缓存新鲜窗 |
| `RH_ETHUSD_STALE_SEC` | 否 | `300` | 失败时旧值最长可用 |
| `RH_EVENT_RETENTION_DAYS` | 否 | `7` | 交易表保留天数；`0` 拒绝启动 |
| `RH_EVENT_PURGE_INTERVAL_SEC` | 否 | `3600` | |
| `RH_EVENT_PURGE_BATCH` | 否 | `500` | 单批 DELETE 上限 |
| `RH_EVENT_PURGE_SLEEP_MS` | 否 | `100` | 批次间隔 |
| `RH_EVENT_PURGE_MAX_PER_RUN` | 否 | `5000` | 单轮最多删除行数 |

校验：`WALLET_RELOAD_MS > 1000` 拒绝启动（需求 ≤1s）。`PRICE_FLUSH_SEC < 1` 拒绝。空 `RH_RPC_URL` 拒绝。`RH_EVENT_RETENTION_DAYS < 1` 拒绝。`RH_EVENT_PURGE_BATCH < 1` 或 `> 5000` 拒绝。

## 启动顺序

1. 解析 config。
2. 打开 SQLite，跑迁移。
3. 加载合约目录并校验必填地址。
4. 主 RPC `eth_chainId` 核对；`RH_TRACE_RPC_URL` 非空时另建客户端并独立核对 chainId，错误则拒绝启动；为空则安全禁用原生 ETH 净额。
5. 从 `launch_*` 重建池/曲线登记。
6. 加载名单快照（允许空表）。
7. 启动 writer 队列。
8. 启动 go-zero HTTP。
9. 启动扫块、刷价 tick、名单 tick、评分 tick、信号 tick、**币安 ETH 拉取**、**交易表过期清理**。

任一步失败：非 0 退出，不要半开监听。

HTTP 挂了不应停扫块；扫块挂了进程退出（否则健康检查撒谎）。

## Docker

```text
镜像：仅二进制 + migrations SQL
挂载：./data → /data
用户：非 root 建议
不 COPY .env
```

compose 用 `env_file`（不入库）。健康检查：`GET /health` 或进程存活 + 可选 lag。

公开 RPC 403：文档写明加 UA；生产供应商 URL。

当前 `.env` 的主 RPC 是 Robinhood 官方公开端点；trace RPC 是 Blockmachine 第三方无密钥公开端点。代码和日志不得落 raw trace、完整 RPC URL 查询参数或密钥。第三方 trace 失败只使对应成交 quote/U 为 NULL，不中断扫块与水位。

## 日志

启动成功打一行中文：RPC 已连接（不要打印完整 URL 中的密钥；脱敏 query）。`[错误]` 启动失败原因。

## 失败

chainId 错误、目录缺地址、迁移失败 → 退出。RPC 瞬时失败允许重试 3 次再退出。

## 依赖

组装所有包。main 禁止写 SQL/ABI。

## 验收

- 无 RPC 起不来。
- 卷上重启 AC-07。
- 镜像层不含密钥文件。
- `WALLET_RELOAD_MS=5000` 起不来。

## 调研

`docs/调研/01` RPC 与 UA；`docs/调研/10` 币安 ETH。不要提交 Alchemy key，不要提交币安 Key（行情也不需要 Key）。

## 明确不做

`internal/trade`、自动买卖、第二数据库、多链配置。
