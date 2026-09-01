# 05 Debot 金狗 / 银狗 / 铜狗：发射台归属

- 最新更新时间：2026-09-01 16:30 (UTC+8)
- 适用范围：从 Debot Robinhood 页反查热门发射台；只调研，不实现交易代码
- 来源清单：
  - Debot 页面 <https://debot.ai/?chain=robinhood>（自动化浏览器被 Cloudflare 拦截；卡片数据来自用户截图）
  - 官方 Blockscout API v2：代币创建交易的 `to` / `method` / `decoded_input`
  - Pons：<https://docs.ponsfamily.com/v2>
  - o1：<https://docs.o1.exchange/launchpad/reference/production-contracts.md>、<https://docs.o1.exchange/launchpad/create/stock-paired-launches.md>
  - 对照：本目录 `02-关键合约与交易戳.md`、`04-监听与交易方案.md`

## 结论先行

**当前 Debot 屏上「真正的金狗」不是 pools.trade，也不是单一猫标平台。**

| 角色 | 平台 | 依据 |
| --- | --- | --- |
| 大金狗（Rabbit，约 273x，市值约 $11M，持有人约 7k） | **o1 Launchpad 股票配对工厂** | 创建 `to` = `0xe64AC411…F297`，方法 `createLaunch` `0x5b09db59`；官方文档把该地址标为 Stock-paired Launch Factory |
| 同屏新盘（Chair 1h、FWOBIN） | **Pons V2** | 创建 `to` = `0xe33E9E47…F62948`（`PonsV2LaunchAndBuy`），方法 `launchAndBuy` `0xf85f8e41` |
| 第一轮假设的 pools.trade | 本屏未见金狗样本 | 样本 1 的 LKDOG 仍像 hooks=0 的 v4 池，但 Debot 热榜不是它 |

v1 监听优先级应改为：

1. **Pons V2**：覆盖 Debot 卡片里大量 1h 级新盘（银/铜、高发射密度）。
2. **o1 股票配对 +（可选）o1 加密货币配对**：覆盖 Debot 24h 密度条上那种已经走出曲线、市值上百万的金狗。
3. pools.trade / Bags / hood.fun：保留过滤器，不当本屏热门主力。

**不要用 Debot 卡片上的猫标 /「猫脉」反推发射台。** 同屏 Rabbit 与 Chair 都带同类图标，但链上工厂完全不同。以创建交易的 `to` + selector 为准。

## 1. Debot 能说明什么、不能说明什么

能说明：哪些币此刻被标成金/银/铜、市值、持有人、聪明钱同时买入数。

不能说明：发射台官方名。Debot 前端标签与链上合约没有公开对照表；本轮页面本身无法抓取（Cloudflare）。

反查步骤（已做）：截图代币名 → Blockscout 搜 token → 读 `creation_transaction` 的 `to` / `method_id` → 对照官方部署表。

## 2. 样本表（本屏卡片）

| Debot 卡 | 合约 | 创建入口 `to` | 方法 / selector | 平台 | 配对资产 |
| --- | --- | --- | --- | --- | --- |
| Rabbit 兔子（~12h，273x） | `0xCD1cca2B3d0A11b295c42fe765ea8f895c2D0901`（地址以 `01` 结尾，符合 o1 股票盘规则） | `0xe64AC4113848BBC1a6dDE1A6D1da96720A36F297` | `createLaunch` `0x5b09db59` | o1 股票配对 | **WYFI**（WhiteFiber 股票代币 `0x9e7ABD3C…2FB3E`） |
| Chair 主席（~1h） | `0x4D3a5cdb64C46FFe779950D2Eb2295Dcaa950466` | `0xe33E9E479dF8802cb0866d5d05258bEc4cF62948` | `launchAndBuy` `0xf85f8e41` | Pons V2 | **USDG** |
| FWOBIN | `0xD6B1A7F2631Be6841C9FEBB41336E0F4C59aa0a8` | 同上 LaunchAndBuy | `launchAndBuy` `0xf85f8e41` | Pons V2 | **ETH**（`pairToken=0x0`） |
| FOX 福克斯（~35d） | `0x2103faA9D1762e27a716C61718b3aCf3Ec1F9bf1` | 创建交易本轮超时 | 合约名 `LaunchToken` | **未确认**（Pons V1 / 早期 o1 / 其它都可能） | 未确认 |
| Oilinu 奥利努 | `0xD29f09B80a4EfF193bB022d5FFeD45cE1b01677E` | `to` 为空 | 原始部署字节码 `0x61016060…` | **自定义 ERC-20 部署**，不是发射台工厂 | — |

Rabbit 创建交易：`0x2773f0142d0e2c66bbcdbd75e0b0559285da0f98802c9861757e1d4effde2672`。  
Chair 创建交易：`0x063b0766544f378df7f5a69e5f92568233688802df090af3483019c1de9b620d`。曲线（mint 接收方）`0x492607f06055db795e858Ef3CcAF6C0EF775A98B`；首买 quote 约 `470080366` 最小单位 USDG（6 位小数 ≈ 470 USDG）。

## 3. 两个热门平台怎么分

```text
Debot 24h 密度条上的「已经爆了」的币
        └── 多数应走 o1：创建当下就是 v4 + LaunchHook，没有独立 bonding 合约
Debot 网格里 1h 级新盘 / 聪明钱刚进场
        └── 多数应走 Pons V2：先曲线内盘，卖完再毕业进 v4 + Pons hook
```

独立解析与交易：

- Pons V2 → `06-Pons-V2解析与交易.md`
- o1 股票配对（及加密货币配对孪生工厂）→ `07-o1exchange-RWA解析与交易.md`

## 4. 其它发射台（本屏不是金狗主力，仍可能出币）

| 平台 | 工厂 / 入口 | 本屏角色 |
| --- | --- | --- |
| pools.trade | `0x0000ffffbe8efe702c8703ae3477ff5de3d319c0` 等 | 第一轮样本 1 像这类；Debot 本屏无金狗样本 |
| o1 加密货币配对（ETH/USDG） | `0x411F21283D3E492BC395027329e08f9F4F560Ba5` | 官方第二套 o1 工厂；本屏金狗 Rabbit 走的是股票工厂，不是这一套 |
| Bags | `0xe8Cc4431adF8b5A847C113EF0c6af9043219Cb37` | 未出现在本屏金狗卡 |
| hood.fun | `0x5fcc1df0dc020cf454e742e9a8ae2554c37a452c` | 毕业走 v3，不是 v4 |
| Doppler Airlock | `0xeb7C034704eF8Dcd2D32324c1545f62fB4aD0862` | 未出现 |

## 5. 显式缺口

- Debot 5 分钟热榜（Rusty / UP / CAT 等）未逐个反查创建入口；**建议 / 推断**它们更可能是 Pons 新盘，但不能当事实。
- FOX 创建交易未核到 `to`。
- Debot 猫标官方含义未知。
- 本环境后半段 Blockscout API 出现 403，Rabbit 的后续 Swap 收据未再拉一轮；买卖解析以已验证 ABI + 官方文档为准。
