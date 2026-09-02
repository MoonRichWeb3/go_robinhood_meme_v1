// Package contracts 集中维护 Robinhood Chain 本期监听所需的合约地址与事件主题。
package contracts

const (
	ZeroAddress        = "0x0000000000000000000000000000000000000000"
	WETHAddress        = "0x0bd7d308f8e1639fab988df18a8011f41eacad73"
	USDGAddress        = "0x5fc5360d0400a0fd4f2af552add042d716f1d168"
	PoolManager        = "0x8366a39cc670b4001a1121b8f6a443a643e40951"
	UniversalRouter    = "0x8876789976decbfcbbbe364623c63652db8c0904"
	Permit2            = "0x000000000022d473030f116ddee9f6b43ac78ba3"
	GMGNRouter         = "0x65050a9b7e5075a2ba5ced7b1b64ee66262c40dc"
	PonsFactory        = "0x7ed598bcef8bd9edd8c97a195c6d13f40801ec7e"
	PonsLaunchAndBuy   = "0xe33e9e479df8802cb0866d5d05258bec4cf62948"
	PonsMemeHook       = "0xe5e702641ea86f4ae6cc3cdaed2b886f976be044"
	O1CryptoFactory    = "0x411f21283d3e492bc395027329e08f9f4f560ba5"
	O1CryptoHook       = "0x441f773b3bb1ed4c6457d0528624112e43c02acc"
	O1StockFactory     = "0xe64ac4113848bbc1a6dde1a6d1da96720a36f297"
	O1StockHook        = "0x778b0c4eea7d35d66513b587ba87fc9084b0eacc"
	LongLauncher       = "0x22e99278308b393ea1260859b181ad7e78f5eeed"
	Airlock            = "0xeb7c034704ef8dcd2d32324c1545f62fb4ad0862"
	GraduationExecutor = "0xc7819b64a1daecd7ec19856d026cb14efbd89046"
)

const (
	TopicPonsTokenLaunched = "0x8d4aad4953d0ca700d468f3753aa14432d1b35b43ec6409f051fb6aa43a89607"
	TopicPonsLaunched      = "0xdcacba5e347ae7abd91cb519eb877af8fa7774e347b85dd3ddcd24a2ba8cdf37"
	TopicPonsCurveBuy      = "0xec36bf571f136799e8dc0b0b8bea4b04d8bd3d43de838aab0d5fc21d4cbfc455"
	TopicPonsCurveSell     = "0x8113d738abdcb6b38357e9d53a54a7157861a09031b453651f0fe7fe151f59df"
	TopicPonsLaunchSwept   = "0xcdb72f157fd3666758a6ce201387ffb52038c7562e4fff352828da1096c4b6b4"
	TopicPonsGraduated     = "0x0a44ef75df69c534f43cd6c1aa3ef8983065fe5fe79ef9e79f6494e6f258c259"
	TopicO1Launched        = "0x207384e895174175cc774fe7f7457b37c382f27ebf53d37d5257b862f80eaf9c"
	TopicPoolSwap          = "0x40e9cecb9f5f1f1c5b9c97dec2917b7ee92e57ba5563708daca94dd84ad7112f"
	TopicPoolInitialize    = "0xdd466e674ea557f56295e2d0218a125ea4b4f0f6f3307b95f85e6110838d6438"
	TopicERC20Transfer     = "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"
)
