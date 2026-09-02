# v4 原生 ETH 成交净额

- 最新更新时间：2026-09-02 16:05 (UTC+8)
- 适用范围：Robinhood Chain 上 `currency=address(0)` 的 Uniswap v4 单 Swap 成交
- 本地落点：`internal/chain/trace.go`、`internal/app/native_quote.go`
- 官方来源：
  - Robinhood Chain 连接文档：<https://docs.robinhood.com/chain/connecting/>
  - Uniswap v4 `IPoolManager.sol`：<https://github.com/Uniswap/v4-core/blob/main/src/interfaces/IPoolManager.sol>
  - Uniswap v4 `PoolManager.sol`：<https://github.com/Uniswap/v4-core/blob/main/src/PoolManager.sol>
- 第三方来源：
  - Blockmachine Robinhood RPC 页面：<https://blockmachine.io/docs/robinhood-rpc>
  - Blockmachine 公开端点：<https://rpc-robinhood.blockmachine.io>
- 链上证据：
  - 买入：<https://robinhoodchain.blockscout.com/tx/0x04497713bef880d934b99a0f03daaf34ebcf4ce47bb07be669e9a7a6c1225ba6>
  - 卖出：<https://robinhoodchain.blockscout.com/tx/0xa9668ca36d3e8a12756a363b11ff23bf8fc9aa822de645579b2c4a138e792822>

## 结论

v4 `Swap.amount0/amount1` 是 PoolManager 记账 delta，不等于聚合器扣费后用户实际支付或到账。原生 ETH 又没有 ERC-20 `Transfer`，因此只能在严格单 Swap 门槛下，以 `debug_traceTransaction` 的 `callTracer` 成功 value 转移计算已归因用户的净流量。

扫块事实与 trace 能力必须分开：

- **Robinhood 官方公开 RPC** `https://rpc.mainnet.chain.robinhood.com`：实测 `eth_chainId=0x1237`，支持整块收据；实测不支持 `debug_traceTransaction`。它仍是扫块主 RPC。
- **Blockmachine 第三方 RPC** `https://rpc-robinhood.blockmachine.io`：实测 `eth_chainId=0x1237`，支持 `debug_traceTransaction` + `callTracer`。其公开页面说明标准端点可无密钥使用，但它不是 Robinhood 官方基础设施。

第三方 trace 不可用时不能回退到 `Swap amount0/amount1`、交易 `value` 或 WETH `Transfer`。服务保留 meme 数量，原生 quote 数量与成交 U 写 `NULL`，记录一条中文错误并继续推进水位。

## 真实样本

池与代币：

- poolId：`0xeb33511bdc99dfd9e38cc75bcf2313f587fdbfb643e1c79e40f39524a19114e1`
- token：`0x1ebc42c5ee785694a9775d5dd917166206eb58f5`
- quote：原生 ETH（零地址）

买入交易 `0x0449…5ba6` 只有一个 PoolManager `Swap`。用户为 `0xc81e…d9d1`；根 `CALL value=4000000000000000 wei`，没有退款，所以用户净流出及实际买入 quote 均为 `4000000000000000 wei`，该值包含费用。

卖出交易 `0xa966…822` 只有一个 PoolManager `Swap`。成功调用链中：

1. PoolManager → GMGN：`3879643521600000 wei`
2. GMGN fee：`38796435216000 wei`
3. GMGN → 用户：`3840847086384000 wei`

所以用户净流入及实际卖出 quote 是 `3840847086384000 wei`，不是 PoolManager 先付给 GMGN 的金额。

## 实现边界

1. 仅 `quote=0x0`、`fill.User` 非空、同一收据 PoolManager `Swap` 总数严格等于 1 时发起 trace。
2. 只累计无错误祖先下成功 `CALL`、`CREATE`、`CREATE2` 的非零 `value`。
3. `DELEGATECALL`、`CALLCODE` 的镜像 value 不计；有错误的调用及整个子树不计。
4. 买入要求用户净流出大于 0；卖出要求用户净流入大于 0；方向不符或净额为 0 均拒绝。
5. RPC 响应最多 16 MiB、调用深度最多 128、节点最多 10000；交易哈希、地址、hex quantity 严格校验。
6. 不落盘 raw trace，不记录完整 trace，不在日志中输出 RPC URL 或密钥。

该算法依赖第三方节点完整且正确地返回 geth `callTracer` 语义。免费端点存在限流、方法调整和可用性风险；失败时的安全结果是“金额未知”，不是猜测金额。
