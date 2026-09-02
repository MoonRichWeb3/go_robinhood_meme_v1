# 14 只读 HTTP

- 最新更新时间：2026-09-02 14:51 (UTC+8)
- 适用范围：go-zero rest，`internal/httpsvc`
- 来源：FR-08；架构 §7、图 8
- 对应需求：FR-08；验收 AC-08、AC-10
- 落地包：`internal/httpsvc`

## 职责

本机/内网只读：健康、新盘列表、某钱包流水。与扫块同进程、独立 goroutine。超时不得阻塞扫块。

## 边界

- 无 POST/PUT/DELETE，无鉴权后台，无下单
- 默认绑定 `127.0.0.1`（`RH_HTTP_ADDR`，默认 `127.0.0.1:8888`）
- handler 不解析 ABI、不触发扫块
- 列表必须有 `limit` 上限（默认 50，最大 200）
- JSON 字段英文；不是给人看的中文日志

## 路径（v0 定稿）

| 方法 | 路径 | 作用 |
| --- | --- | --- |
| GET | `/health` | 进程、库、水位 |
| GET | `/launches` | `launch_index` 列表 |
| GET | `/wallets/:address/events` | 该钱包 `wallet_events` |
| GET | `/signals` | 模块 `15` 现算 |

无写接口。未知路径 404。

### GET `/health`

响应：

```json
{
  "ok": true,
  "chain_id": 4663,
  "last_block": 123,
  "head_block": 125,
  "lag": 2,
  "db": "ok"
}
```

`ok=false` 当：打不开库，或 `lag` > `RH_HEALTH_LAG_WARN`（默认 50）。HTTP 状态：库失败 503；仅落后仍 200 但 `ok=false`（便于探活进程活着）。

`head_block` 读失败可空，`lag` 空，打服务端错误日志（中文）。

### GET `/launches`

Query：`category`（可选 `pons` / `o1_crypto`；`o1_stock` / `long` 本期无数据）、`limit`、`cursor`。

`cursor` 定稿：上一页最后一条的 `created_at`（RFC3339 UTC）+ `,` + `token_address`。缺省按 `created_at` 降序、同秒再按 `token_address` 降序。下一页为严格小于该游标的行。

每条：index 列：token、category、symbol、name、pair_symbol、creator_eoa、created_at、price_usd（JSON `null` 不是 0）、tx_hash。

地址查询大小写：内部规范化。

### GET `/wallets/:address/events`

path 地址：补 `0x`、小写后再查（AC-10）。不存在钱包仍 200 空列表（名单外也可能无事件）。

Query：`limit`、`kind` 可选。按 `id` 降序。

每条：id、kind、category、token、direction、amounts、exec_usd_per_token（null 允许）、tx_hash、chain_time。sell 行附 `realized_pnl_usd`（该笔卖出 FIFO 结果；空 U 则为 null）。不要把 FIFO 结果另表持久化。

### 错误体

```json
{ "error": "bad_request", "message": "..." }
```

4xx/5xx。不把 SQL 原文返回给客户端。

## 并发

只读连接或 `PRAGMA query_only`。`busy_timeout` 与写侧一致。查询超时 `RH_HTTP_QUERY_MS` 默认 `3000`。

## 日志

不要用英文 access log 替代业务中文日志。HTTP 错误可 `[错误]` 类型=查询失败。

## 失败

handler panic 必须恢复，返回 500，扫块继续。

## 依赖

只 store 查询 + sync_state + 可选 chain head。禁止 venue。

## 验收

AC-08：三件套可查。AC-10：`0xAbC` 与 `0xabc` 同一钱包流水。绑定非 localhost 必须是显式配置，文档警告勿对公网。

## 调研

无。
