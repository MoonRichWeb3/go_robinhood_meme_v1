# 10 币安 ETH 美元喂价（HTTP）

- 最新更新时间：2026-09-02 14:40 (UTC+8)
- 适用范围：把链上 ETH/WETH 报价折成美元；**独立 HTTP 客户端**，与扫块 RPC 分离；不含下单、不含 API Key
- 来源清单：
  - 官方现货 REST：<https://github.com/binance/binance-spot-api-docs/blob/master/rest-api.md>（Symbol price ticker）
  - 官方说明站（同文）：<https://developers.binance.com/docs/binance-spot-api-docs/rest-api/market-data-endpoints>
  - 仅行情、无需鉴权的备用域名：<https://github.com/binance/binance-spot-api-docs/blob/master/faqs/market_data_only.md>
  - 本仓库需求：`docs/需求/01` §7；落地口径：`docs/功能模块/11-折U.md`
- 本次联网：读取币安官方 GitHub 文档原文；未调用实时行情、未发送本地配置

## 结论先行

ETH 美元价 **只走币安现货 HTTP 行情**，进程内单独一个拉取循环，写入内存缓存，供折 U 读取。不要把币安请求塞进扫块 goroutine，不要为行情申请交易 API Key。

采用：

```text
GET {base}/api/v3/ticker/price?symbol=ETHUSDT
```

默认 `base=https://api.binance.com`。该接口安全类型为 `NONE`（公开行情）。响应 `price` 为 **1 ETH 值多少 USDT**；v0 **把 USDT 当作 1 美元**（与 USDG 按 1 美元同一档简化；USDT 脱锚策略未定）。

股票代币 **不在本文范围**；币安现货没有 Robinhood 股票 token。

## 1. 为什么用 ticker/price

| 接口 | 用途 | 本期是否用 |
| --- | --- | --- |
| `GET /api/v3/ticker/price` | 最新成交价，单 symbol 权重低 | **用** |
| `GET /api/v3/ticker/24hr` | 24h 统计，更重 | 不用 |
| `GET /api/v3/avgPrice` | 5 分钟均价 | 不用（要的是现价折 U） |
| Websocket | 推送 | 不用（需求是独立 HTTP） |

官方字段（单 symbol）：

```json
{ "symbol": "ETHUSDT", "price": "4.00000200" }
```

`price` 为十进制字符串。解析后必须 `> 0` 且非 NaN，否则当缺价。

官方权重（以 `binance-spot-api-docs` 当前表为准，实现勿写死过时的 weight=1）：带 `symbol` 时 weight **2**；省略 symbol 拉全市场 weight **4**。**必须带 `symbol=ETHUSDT`**，禁止拉全市场。

数据源官方标注为 Memory。

## 2. URL 与鉴权

| 项 | 值 |
| --- | --- |
| 主站 | `https://api.binance.com/api/v3/ticker/price?symbol=ETHUSDT` |
| 仅行情备用 | `https://data-api.binance.vision/api/v3/ticker/price?symbol=ETHUSDT`（官方 FAQ：无需 API Key 的行情域名） |
| 方法 | GET，query string |
| Header | 不需要 `X-MBX-APIKEY` |
| 签名 | 不需要 |

地理限制或 DNS 失败时，允许配置换成备用 `base`（env），**不要**为此去爬网页或走非官方镜像当默认。

## 3. 进程内怎么用（调研约束，落地细节见功能模块 11）

```text
独立 goroutine（与 chain RPC 无关）
    定时 GET ETHUSDT
    → 校验 JSON
    → 写入内存 {usd_per_eth, fetched_at}
扫块折 U
    → 只读内存，禁止同步 await 币安
```

约束：

1. **超时**：单次 HTTP 建议 2～3s，失败不影响扫块。
2. **间隔**：建议 5～15s 拉一次；成交折 U 用缓存，不要每笔 Fill 打币安。
3. **429 / 418**：官方按 IP 限流；退避，禁止空转重试。可读响应头 `X-MBX-USED-WEIGHT-*` 打 debug，不要把完整头当业务键打到中文日志。
4. **TTL**：缓存过期且拉不到新价 → 按功能模块 11 的降级（短时可用旧值，超时则缺价，禁止写 0）。
5. **WETH 与 ETH**：本链 WETH 与 native ETH 共用同一 ETHUSDT。

## 4. 明确不做

- 不申请、不保存币安 API Key / Secret
- 不调用下单、账户、User Data Stream
- 不用币安价当链上成交数量（成交数量仍来自曲线/Transfer）
- 不把 `price=0` 或空字符串写成有效喂价
- 不把 USDT 行情用于股票 quote

## 5. 建议核对（落地时）

用本机对官方 URL 打一枪（实现或运维，不把实时价写入本仓库）：

```text
GET /api/v3/ticker/price?symbol=ETHUSDT
HTTP 200 且 price 为可解析正数
```

若 451/403：换备用行情域名或网络出口，仍不要改用非官方站。
