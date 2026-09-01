# 09 Long：发射事件、买卖事件、如何解析、如何交易

- 最新更新时间：2026-09-01 17:50 (UTC+8)
- 适用范围：Debot `launchpad=long` 的盘口（24h 金狗约 24%、出金率高于 Pons V2）；只写监听与编码口径，不含 bot 实现
- 来源清单：
  - Blockscout 已验证合约 `LongLauncher` `src/LongLauncher.sol`：<https://robinhoodchain.blockscout.com/address/0x22e99278308B393ea1260859B181AD7E78f5eeED>
  - Doppler 官方 Robinhood 地址表：<https://docs.doppler.lol/reference/contract-addresses>
  - Debot 金狗样本 SENDER 创建交易 `0x0412c0bd…8183`（Blockscout API v2 + `getLogs`）
  - 同工厂样本 ARXIV 创建交易 `0x5adc4c30…c5b1`（完整 log 解码）
  - 产品站 <https://app.long.xyz/>（本环境 Cloudflare 拦截，页面不当指令）
  - 对照：本目录 `02`、`04`、`08`

## 结论先行

**Long 没有 Pons 那种每币一条 bonding 曲线。** 前端入口是 `LongLauncher.create`；合约内部调用 Doppler `Airlock.create`，当场克隆 `DopplerERC20V1`、用 `DopplerHookInitializer` 开 Uniswap v4 池。买卖 = `PoolManager.Swap` + meme `Transfer` 归因，编码走 Universal Router。

和 Bankr / 其它 Airlock 产品的分界：**发现新盘只听 `LongLauncher` 的 `LaunchCreated`，不要把 Airlock 上每一笔 `Create` 都算 Long。** Airlock 是底层；Long 是带 24 小时 ticker 预留的产品壳。

报价资产在已核样本里是 **Robinhood 股票代币**（SENDER = AMZN，ARXIV = MRNA），不是 ETH。用 ETH 直接买会路径错误，除非该笔 `numeraire` 真的是 WETH/ETH。

## 1. 固定合约

| 角色 | 地址 | 依据 |
| --- | --- | --- |
| LongLauncher | `0x22e99278308B393ea1260859B181AD7E78f5eeED` | Blockscout 已验证；构造参数 `airlock` + `trustedTokenFactory` |
| Airlock（Doppler） | `0xeb7C034704eF8Dcd2D32324c1545f62fB4aD0862` | LongLauncher 构造参数；官方 Doppler Robinhood 表 |
| DopplerERC20V1Factory（TRUSTED_TOKEN_FACTORY） | `0x1B37D3a72082029c44B35B604Ea473617580b69a` | 同上；`create` 里 `tokenFactory` 必须等于该地址 |
| DopplerERC20V1 实现 | `0x3Be8B97Fd0e713B5aBE0649Fa830223B6B4BC599` | SENDER 是 EIP-1167 clone，`implementations` 指向它 |
| DopplerHookInitializer（池 hooks / poolInitializer） | `0x4e3468951D49f2EEa976eD0D6e75fFCb44a9a544` | 官方表截断 `0x4e34…a544`；两笔创建的 `Initialize.hooks` |
| NoOpGovernanceFactory | `0x85f37f74Ef2478A770318bc810177a9835911aD7` | 两笔 `create` 的 `governanceFactory` |
| NoOpMigrator | `0xba2F330EDb16cD8056f5988d8CE19BbC63475A0e` | 两笔 `create` 的 `liquidityMigrator` |
| RehypeDopplerHookInitializer | `0x6f02324d20CC679d0E585290CAa6b16baCbC0F77` | ARXIV `FeeScheduleSet`；SENDER 成交里有手续费 Transfer |
| LongLauncher owner | `0x9B7f0d4dcF6a4BaED39B2F4f5Aeae6cA082BED47` | 构造 `initialOwner` |
| integrator（create 参数，EOA） | `0x92d435C96E63c43E12d6D0AB28f6b0B04072F765` | 两笔样本相同；Blockscout 显示非合约 |

源码常量：`RESERVATION_DURATION = 24 hours`。`LaunchCreated.reservedUntil = deployedAt + 86400`。

**建议 / 推断：** 代币地址常以 `e18` 结尾（SENDER、ARXIV），这是 clone/salt 的结果，**不要做成硬规则**（不像 o1 股票盘的 `01` 后缀）。

## 2. 发射事件

### 2.1 入口：`LongLauncher.create`

```text
create((
  uint256 initialSupply,
  uint256 numTokensToSell,
  address numeraire,
  address tokenFactory,
  bytes tokenFactoryData,
  address governanceFactory,
  bytes governanceFactoryData,
  address poolInitializer,
  bytes poolInitializerData,
  address liquidityMigrator,
  bytes liquidityMigratorData,
  address integrator,
  bytes32 salt
) data)
```

- selector：**`0x882db707`**（SENDER / ARXIV 创建交易已解码；`cast sig` 交叉）
- `to` 必须是 LongLauncher，不是 Airlock（用户钱包不直接打 Airlock）
- `msg.value`：两笔样本均为 `0`（报价是股票代币，不付 ETH 当 quote）
- 源码：先校验 `tokenFactory == TRUSTED_TOKEN_FACTORY`，再 `AIRLOCK.create(data)`，最后发 `LaunchCreated`

两笔样本的供应都是 `1e9 * 1e18`（10 亿枚，18 位小数），几乎全部打进 PoolManager 做单边流动性。

### 2.2 发现过滤器：`LaunchCreated`

emitter = **仅 LongLauncher**。

```text
event LaunchCreated(
  address indexed poolOrHook,
  address indexed asset,
  address indexed numeraire,
  address poolInitializer,
  address launcher,
  bytes32 tickerKey,
  uint48 deployedAt,
  uint48 reservedUntil,
  string normalizedTicker
)
```

| 项 | 值 |
| --- | --- |
| topic0 | `0xadc6f1f726f7c710f77ec06adc75f3bb964e5be19581b072c67f7b9b4039267b`（`cast keccak` + ARXIV log） |

两笔样本里 `poolOrHook` **等于 `asset`（代币地址）**，真正的 v4 `hooks` 在同笔 `Initialize` 里，是 `DopplerHookInitializer`。解析时不要把 `LaunchCreated.poolOrHook` 当成 PoolKey.hooks。

`launcher` 与 `tx.from` 两笔都一致（SENDER：`0x8130a792…5F41`；ARXIV：`0xE7f8e9cd…3f83`）。跟单「谁发的」用这两个即可。

同笔还会出现（不要单独当 Long 发现源）：

| 事件 | emitter | 用途 |
| --- | --- | --- |
| `Initialize` | PoolManager | 记下 `poolId`、`currency0/1`、`fee`、`tickSpacing`、`hooks` |
| `Create` | Airlock | Bankr 等也会发；**不能**当 Long 过滤器 |
| `Create` | DopplerHookInitializer | 辅助核对 asset/numeraire |
| `FeeScheduleSet` | RehypeDopplerHookInitializer | Doppler 时段费率；v0 可进 `raw_json` |

### 2.3 已核样本

| 代币 | 创建交易 | 块 / 时间 (UTC) | quote (`numeraire`) | pool 要点 |
| --- | --- | --- | --- | --- |
| SENDER `0x4d41CcAa…01e18` | `0x0412c0bd…8183` | 51337623 / 2026-09-01 01:45:59Z | AMZN `0x12f190a9…bF54` | hooks=`DopplerHookInitializer`；供应 10 亿 |
| ARXIV `0xA8427B49…61e18` | `0x5adc4c30…c5b1` | 51608569 / 2026-09-01 09:21:26Z | MRNA `0x43B07D15…2155` | `poolId=0xc64f0637…c6f1`；`fee=8388608`（`0x800000` 动态费）；`tickSpacing=8` |

ARXIV 的 `currency0=MRNA`、`currency1=ARXIV`（按地址排序）。买卖方向必须用 `Initialize` 的两侧，不能假设 meme 永远是 token1。

## 3. 买卖事件

Long **没有** `CurveBuy`。成交在 v4：

1. 过滤器：`PoolManager.Swap` topic0 `0x40e9cecb…112f`（见 `02`）
2. 用 `Swap.id`（poolId）查本库 `launch_long`；**命中才算 Long 盘口**
3. 用户钱包：同笔 meme `Transfer` 的 `to`（买）/ `from`（卖）。不要用 `Swap.sender`（Router / 聚合器）

**不要**用 `hooks == DopplerHookInitializer` 当 Long 买卖过滤器。该 hook 是 Doppler 单例，Bankr 等 Airlock 产品会共用。

SENDER 近期成交样本：`0x8c84026f…32e7`，入口是 `RelayRouterV3` `0xb92fe925…Ff4f`，selector `0x0a2b8f36`。代币从 PoolManager 经中间合约到用户 `0xF75D21FF…611B`。聪明钱入库仍按 Transfer 归因，`router` 标实际入口（UR / GMGN / Relay 等）。

## 4. 如何交易（调研口径，v0 需求不下单）

与 o1 股票盘同类：**创建即 v4，支付 quote 代币。**

1. 从创建交易的 `Initialize` 取完整 `PoolKey`（不要猜 fee/tick/hooks）
2. `StateView.getSlot0(poolId)` 确认池活着
3. Universal Router `execute`，command `0x10`，`minHopPriceX36=0`
4. 买：先持有并 `approve`/`Permit2` 该 `numeraire`（股票代币或 ETH/WETH/USDG，以事件为准）
5. Doppler/Airlock 可能有「仅白名单 Router」窗口（见 `04`）；跟盘 revert 先查 hook 限制，不要只怪 RPC

公开 RPC 本环境 403，未 `eth_call` `Airlock.getAssetData`。落地时可用该 view 补 timelock / governance / pool，但 **发现路径仍以 `LaunchCreated` 为准**。

## 5. 和 Pons / o1 的差异（需求建模用）

| | Pons V2 | o1 股票 | Long |
| --- | --- | --- | --- |
| 内盘曲线 | 有 | 无 | 无 |
| 创建入口 | Factory / LaunchAndBuy | `createLaunch` | `LongLauncher.create` |
| 发现事件 | `TokenLaunched` | `Launched` | `LaunchCreated` |
| 买卖 | `CurveBuy`/`CurveSell`，毕业后 Swap | Swap + LaunchHook | Swap + DopplerHookInitializer |
| 典型 quote | ETH / USDG | 股票代币 | 已核样本为股票代币 |
| 创建人 | `deployer` / `tx.from` | `tx.from` + Token Deployer 合约 | `tx.from` = `LaunchCreated.launcher`；代币 owner 是 Airlock，**不要把 Airlock/LongLauncher 当聪明钱** |
| Hook | 毕业后才是 Pons meme hook | 股票 LaunchHook 单例 | DopplerHookInitializer 单例（跨产品共用） |

## 6. 显式缺口

- 未逐个交叉 Debot 24h 全部 8 只 `long` 金狗；已核 SENDER（Debot 金狗）+ 同工厂 ARXIV。
- `numeraire` 是否允许 ETH/USDG：ABI 是任意 `address`，本轮样本只有股票代币。实现时按事件存，不要写死 AMZN。
- `app.long.xyz` 被 Cloudflare 拦，未核前端是否还有第二入口。
- Doppler 官方表里 `UniswapV4Initializer` 仍是截断地址；Long 样本用的是 **DopplerHookInitializer**，不要混填。
- 未实测 Airlock 白名单窗口对 UR / GMGN / Relay 的具体秒数。
