// 本文件编排单块：刷新名单、分流解码、整块写库、登记运行时市场并刷新全市场成交价。
package app

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"time"

	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/chain"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/contracts"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/domain"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/price"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/store"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/venue/o1crypto"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/venue/pons"
	"github.com/MoonRichWeb3/go_robinhood_meme_v1/internal/venue/v4fill"
)

type pricedFill struct {
	fill  domain.Fill
	price float64
}

// ProcessBlock 处理完整区块，并把业务变化与目标水位交给 store 原子提交。
func (a *App) ProcessBlock(ctx context.Context, block chain.BlockBatch, watermark chain.Watermark) (returnErr error) {
	complete := false
	defer func() {
		if !complete {
			a.restoreRegistrations(ctx)
		}
	}()
	_ = a.wallets.RefreshIfDue(ctx, time.Duration(a.config.WalletReloadMS)*time.Millisecond)
	changes := store.BlockChanges{}
	prices := make([]pricedFill, 0)
	metadata := make(map[string]chain.ERC20Metadata)
	pendingCategories := make(map[string]string)
	for txIndex, tx := range block.Transactions {
		if txIndex >= len(block.Receipts) {
			return fmt.Errorf("块 %d 交易与收据数量不一致", block.Number)
		}
		receipt := block.Receipts[txIndex]
		if receipt.Status == 0 {
			continue
		}
		poolManagerSwapCount := countReceiptPoolManagerSwaps(receipt)
		nativeTraceErrorLogged := false
		ponsLogs := toPonsLogs(receipt.Logs)
		o1Logs := toO1Logs(receipt.Logs)
		v4Logs := toV4Logs(receipt.Logs)
		for _, event := range receipt.Logs {
			if event.Removed || len(event.Topics) == 0 {
				continue
			}
			hit, ok := a.router.Route(event.Address, event.Topics[0], event.Topics)
			if !ok || hit.Kind == contracts.KindIgnore || hit.Kind == contracts.KindV4Initialize {
				continue
			}
			switch hit.Kind {
			case contracts.KindCreate:
				if hit.Venue == contracts.VenuePons {
					launch, err := pons.DecodeCreate(toPonsLog(event), pons.TxContext{
						From: tx.From, To: tx.To, Hash: tx.Hash, Value: tx.Value,
						BlockNumber: block.Number, TxIndex: tx.Index, ChainTime: block.ChainTime, Logs: ponsLogs,
					})
					if err != nil {
						a.decodeError(block.Number, tx.Hash, err)
						continue
					}
					accepted, err := a.acceptLaunchCategory(ctx, launch.TokenAddress, launch.IndexCategory(), pendingCategories)
					if err != nil {
						return err
					}
					if !accepted {
						continue
					}
					meta, err := a.client.TokenMetadata(ctx, launch.TokenAddress, block.Number)
					if err != nil {
						return fmt.Errorf("读取新 Pons 代币精度: %w", err)
					}
					metadata[launch.TokenAddress] = meta
					launch.Name, launch.Symbol = prefer(launch.Name, meta.Name), prefer(launch.Symbol, meta.Symbol)
					changes.Pons = append(changes.Pons, launch)
					registration := domain.CurveRegistration{
						Curve: launch.CurveAddress, Token: launch.TokenAddress, Quote: launch.PairAddress,
						TokenDecimals: meta.Decimals, QuoteDecimals: launch.PairDecimals,
					}
					if err = a.catalog.RegisterCurve(registration); err != nil {
						return err
					}
					if event := a.launchWalletEvent(tx, event, launch, meta.Decimals); event != nil {
						changes.Events = append(changes.Events, *event)
					}
				} else if hit.Venue == contracts.VenueO1Crypto {
					launch, err := o1crypto.DecodeCreate(toO1Log(event), o1crypto.TxContext{
						From: tx.From, Hash: tx.Hash, Value: tx.Value,
						BlockNumber: block.Number, TxIndex: tx.Index, ChainTime: block.ChainTime, Logs: o1Logs,
					})
					if err != nil {
						a.decodeError(block.Number, tx.Hash, err)
						continue
					}
					accepted, err := a.acceptLaunchCategory(ctx, launch.TokenAddress, launch.IndexCategory(), pendingCategories)
					if err != nil {
						return err
					}
					if !accepted {
						continue
					}
					meta, err := a.client.TokenMetadata(ctx, launch.TokenAddress, block.Number)
					if err != nil {
						return fmt.Errorf("读取新 o1 加密代币精度: %w", err)
					}
					metadata[launch.TokenAddress] = meta
					launch.Name, launch.Symbol = prefer(launch.Name, meta.Name), prefer(launch.Symbol, meta.Symbol)
					changes.O1Crypto = append(changes.O1Crypto, launch)
					if err = a.catalog.RegisterPool(domain.PoolRegistration{
						PoolID: launch.PoolID, Token: launch.TokenAddress, Category: "o1_crypto",
						Quote: launch.QuoteAddress, TokenDecimals: meta.Decimals, QuoteDecimals: launch.QuoteDecimals,
					}); err != nil {
						return err
					}
					if event := a.launchWalletEvent(tx, event, launch, meta.Decimals); event != nil {
						changes.Events = append(changes.Events, *event)
					}
				}
			case contracts.KindGraduated:
				graduation, err := pons.DecodeGraduation(toPonsLog(event), pons.TxContext{
					From: tx.From, To: tx.To, Hash: tx.Hash, Value: tx.Value,
					BlockNumber: block.Number, TxIndex: tx.Index, ChainTime: block.ChainTime, Logs: ponsLogs,
				})
				if err != nil {
					a.decodeError(block.Number, tx.Hash, err)
					continue
				}
				launch, meta, err := a.ponsRegistrationData(ctx, graduation.Token, block.Number, changes.Pons, metadata)
				if err != nil {
					if errors.Is(err, sql.ErrNoRows) {
						a.logger.Error(map[string]any{"类型": "池登记缺失", "代币": graduation.Token, "交易": tx.Hash})
						continue
					}
					return err
				}
				changes.Graduations = append(changes.Graduations, store.PonsGraduation{
					Token: graduation.Token, PoolID: graduation.PoolID, At: graduation.GraduatedAt,
				})
				if err = a.catalog.RegisterPool(domain.PoolRegistration{
					PoolID: graduation.PoolID, Token: graduation.Token, Category: "pons",
					Quote: launch.PairAddress, TokenDecimals: meta.Decimals, QuoteDecimals: launch.PairDecimals,
				}); err != nil {
					return err
				}
			case contracts.KindCurveBuy, contracts.KindCurveSell:
				fill, err := pons.DecodeCurve(toPonsLog(event), pons.TxContext{
					From: tx.From, To: tx.To, Hash: tx.Hash, Value: tx.Value,
					BlockNumber: block.Number, TxIndex: tx.Index, ChainTime: block.ChainTime, Logs: ponsLogs,
				}, *hit.Curve)
				if err != nil {
					a.decodeError(block.Number, tx.Hash, err)
					continue
				}
				a.collectFill(ctx, fill, &changes, &prices)
			case contracts.KindV4Swap:
				fill, err := v4fill.DecodeSwap(toV4Log(event), v4fill.TxContext{
					To: tx.To, Hash: tx.Hash, BlockNumber: block.Number,
					TxIndex: tx.Index, ChainTime: block.ChainTime, Logs: v4Logs,
				}, *hit.Pool, a.catalog.ProtocolAddresses())
				if err != nil {
					a.decodeError(block.Number, tx.Hash, err)
					continue
				}
				a.enrichNativeQuote(ctx, &fill, poolManagerSwapCount, &nativeTraceErrorLogged)
				a.collectFill(ctx, fill, &changes, &prices)
			}
		}
	}
	result, err := a.store.CommitBlock(ctx, changes, store.SyncState{
		Name: watermark.Name, LastBlock: watermark.LastBlock,
		LastHash: watermark.LastHash, UpdatedAt: watermark.UpdatedAt,
	})
	if err != nil {
		return err
	}
	for _, conflict := range result.Conflicts {
		conflict := conflict
		a.logLaunchCategoryConflict(&conflict)
	}
	if len(result.Conflicts) > 0 {
		a.restoreRegistrations(ctx)
	}
	for _, warning := range result.Warnings {
		a.logger.Error(map[string]any{"类型": "事件主键超宽", "块高": block.Number, "错误": warning})
	}
	a.logLaunches(result)
	sells := 0
	for _, event := range result.EventInserted {
		a.logWalletEvent(ctx, event)
		if event.Kind == "sell" {
			sells++
		}
	}
	if sells > 0 {
		a.requestScoreAfter(sells)
	}
	for _, item := range prices {
		if err = a.dirty.Mark(ctx, price.Point{
			Token: item.fill.Token, TxHash: item.fill.TxHash, PriceUSD: item.price,
			Block: item.fill.BlockNumber, At: item.fill.ChainTime,
		}); err != nil {
			// 水位已与业务原子提交；展示价脏标记是独立短事务，失败只记录并由后续成交重试。
			a.logger.Error(map[string]any{"类型": "标记展示价失败", "代币": item.fill.Token, "交易": item.fill.TxHash, "错误": err})
		}
	}
	complete = true
	return nil
}

func (a *App) collectFill(ctx context.Context, fill domain.Fill, changes *store.BlockChanges, prices *[]pricedFill) {
	if fill.AttributionWarning != "" {
		a.logger.Error(map[string]any{
			"类型": "成交归因异常", "代币": fill.Token,
			"交易": fill.TxHash, "错误": fill.AttributionWarning,
		})
	}
	var execQuoteText *string
	var execUSDValue, quoteUSDValue *float64
	quoteSymbol := ""
	var quoteDecimalsPtr *uint8
	asset, assetErr := a.store.GetQuoteAsset(ctx, fill.Quote)
	if assetErr == nil {
		fill.QuoteDecimals = asset.Decimals
		quoteSymbol = asset.Symbol
		quoteDecimals := asset.Decimals
		quoteDecimalsPtr = &quoteDecimals
	} else if fill.QuoteAmountRaw != "" {
		a.logger.Error(map[string]any{"类型": "错误", "缺价": "是", "报价": fill.Quote, "代币": fill.Token, "交易": fill.TxHash})
	}
	if assetErr == nil && fill.QuoteAmountRaw != "" && fill.MemeAmountRaw != "" {
		execQuote, err := price.ExecQuotePerToken(fill.MemeAmountRaw, fill.QuoteAmountRaw, fill.TokenDecimals, fill.QuoteDecimals)
		if err == nil {
			text := execQuote.RatString()
			execQuoteText = &text
			execUSD, quoteUSD, feedErr := a.converter.ExecUSD(ctx, execQuote, fill.Quote)
			if feedErr == nil {
				if value, valueErr := price.RatFloat64(execUSD); valueErr == nil {
					execUSDValue = &value
					*prices = append(*prices, pricedFill{fill: fill, price: value})
				}
				if value, valueErr := price.RatFloat64(quoteUSD); valueErr == nil {
					quoteUSDValue = &value
				}
			} else {
				a.logger.Error(map[string]any{"类型": "错误", "缺价": "是", "报价": fill.Quote, "代币": fill.Token, "交易": fill.TxHash})
			}
		} else {
			a.logger.Error(map[string]any{"类型": "成交价计算失败", "代币": fill.Token, "交易": fill.TxHash, "错误": err})
		}
	}
	if fill.User == "" {
		return
	}
	view, active := a.wallets.Active(fill.User)
	if !active {
		return
	}
	tokenDecimals := fill.TokenDecimals
	event := store.WalletEvent{
		BlockNumber: fill.BlockNumber, TxIndex: fill.TxIndex, LogIndex: fill.LogIndex,
		TxHash: fill.TxHash, ChainTime: fill.ChainTime, IngestedAt: time.Now().UTC(),
		WalletAddress: view.Address, Kind: fill.Side, Category: fill.Category, TokenAddress: fill.Token,
		Direction: fill.Side, QuoteAddress: fill.Quote, QuoteSymbol: quoteSymbol,
		QuoteAmountRaw: fill.QuoteAmountRaw, QuoteDecimals: quoteDecimalsPtr,
		TokenAmountRaw: zeroIfEmpty(fill.MemeAmountRaw), TokenDecimals: &tokenDecimals,
		ExecQuotePerToken: execQuoteText, ExecUSDPerToken: execUSDValue, QuoteUSD: quoteUSDValue, Router: fill.Router,
	}
	changes.Events = append(changes.Events, event)
}

func (a *App) launchWalletEvent(tx chain.Transaction, event chain.Log, launch domain.LaunchIndexView, decimals uint8) *store.WalletEvent {
	_, contract := launch.IndexCreators()
	wallet := ""
	if _, ok := a.wallets.Active(tx.From); ok {
		wallet = tx.From
	} else if _, ok := a.wallets.Active(contract); ok {
		wallet = contract
	}
	if wallet == "" {
		return nil
	}
	createdAt, blockNumber, hash := launch.IndexCreated()
	return &store.WalletEvent{
		BlockNumber: blockNumber, TxIndex: tx.Index, LogIndex: event.ReceiptLogIndex,
		TxHash: hash, ChainTime: createdAt, IngestedAt: time.Now().UTC(),
		WalletAddress: wallet, Kind: "launch", Category: launch.IndexCategory(),
		TokenAddress: launch.IndexToken(), Direction: "launch",
		QuoteAmountRaw: "0", TokenAmountRaw: "0", TokenDecimals: &decimals, Router: "unknown",
	}
}

func (a *App) logWalletEvent(ctx context.Context, event store.WalletEvent) {
	view, _ := a.wallets.Lookup(event.WalletAddress)
	fields := map[string]any{
		"链上时间": event.ChainTime.UTC().Format(time.RFC3339), "类型": directionName(event.Kind),
		"盘口": venueDisplay(event.Category), "代币": event.TokenAddress, "钱包": event.WalletAddress,
		"钱包名": view.DisplayName, "方向": event.Direction, "配对": event.QuoteSymbol,
		"数量": event.TokenAmountRaw, "成交单价U": "", "交易": event.TxHash, "块高": event.BlockNumber,
	}
	if event.ExecUSDPerToken != nil {
		fields["成交单价U"] = *event.ExecUSDPerToken
	} else if event.Kind != "launch" {
		fields["缺价"] = "是"
	}
	tag := "聪明钱-" + directionName(event.Kind)
	if event.Kind == "sell" {
		fifo, err := a.store.FIFOEvents(ctx, event.WalletAddress, event.TokenAddress)
		if err == nil {
			if results, replayErr := domain.ReplayFIFO(fifo); replayErr == nil {
				for _, result := range results {
					if result.EventID != event.ID {
						continue
					}
					if result.MatchedQty.Sign() > 0 {
						fields["已实现盈亏U"] = result.MatchedPnL
					}
					if result.OverflowQty.Sign() > 0 {
						a.logger.Error(map[string]any{"类型": "卖出超仓", "钱包": event.WalletAddress, "代币": event.TokenAddress, "超出数量": result.OverflowQty.RatString()})
					}
				}
			} else {
				a.logger.Error(map[string]any{"类型": "FIFO失败", "钱包": event.WalletAddress, "错误": replayErr})
			}
		}
	}
	a.logger.Info(tag, fields)
}

func (a *App) logLaunches(result store.BlockWriteResult) {
	for _, launch := range result.PonsInserted {
		a.logger.Info("新盘", launchFields(launch))
	}
	for _, launch := range result.O1CryptoInserted {
		a.logger.Info("新盘", launchFields(launch))
		if launch.HookWarning != "" {
			a.logger.Error(map[string]any{"类型": "Hook异常", "代币": launch.TokenAddress, "错误": launch.HookWarning})
		}
	}
}

func launchFields(launch domain.LaunchIndexView) map[string]any {
	pair, pairSymbol := launch.IndexPair()
	creator, _ := launch.IndexCreators()
	at, block, tx := launch.IndexCreated()
	return map[string]any{
		"盘口": venueDisplay(launch.IndexCategory()), "代币": launch.IndexToken(), "配对": pairSymbol,
		"配对地址": pair, "创建人": creator, "名称": launch.IndexName(), "交易": tx,
		"块高": block, "链上时间": at.UTC().Format(time.RFC3339),
	}
}

func (a *App) ponsRegistrationData(ctx context.Context, token string, block uint64, pending []domain.PonsLaunch, metadata map[string]chain.ERC20Metadata) (domain.PonsLaunch, chain.ERC20Metadata, error) {
	for _, launch := range pending {
		if launch.TokenAddress == token {
			return launch, metadata[token], nil
		}
	}
	launch, err := a.store.GetPonsLaunch(ctx, token)
	if err != nil {
		return launch, chain.ERC20Metadata{}, err
	}
	meta, err := a.client.TokenMetadata(ctx, token, block)
	return launch, meta, err
}

func (a *App) restoreRegistrations(ctx context.Context) {
	pools, curves, err := a.store.LoadRegistrations(ctx)
	if err == nil {
		err = enrichRegistrationDecimals(ctx, a.client, pools, curves)
	}
	if err == nil {
		err = a.catalog.RebuildRegistrations(pools, curves)
	}
	if err != nil {
		a.logger.Error(map[string]any{"类型": "登记恢复失败", "错误": err})
	}
}

func (a *App) decodeError(block uint64, tx string, err error) {
	a.logger.Error(map[string]any{"类型": "解析失败", "块高": block, "交易": tx, "错误": err})
}

func (a *App) acceptLaunchCategory(ctx context.Context, token, incoming string, pending map[string]string) (bool, error) {
	normalized, err := domain.NormalizeAddress(token)
	if err != nil {
		return false, err
	}
	if existing, ok := pending[normalized]; ok && existing != incoming {
		a.logLaunchCategoryConflict(&store.LaunchCategoryConflictError{
			Token: normalized, Existing: existing, Incoming: incoming,
		})
		return false, nil
	}
	err = a.store.CheckLaunchCategory(ctx, normalized, incoming)
	if err != nil {
		var conflict *store.LaunchCategoryConflictError
		if !errors.As(err, &conflict) {
			return false, err
		}
		a.logLaunchCategoryConflict(conflict)
		return false, nil
	}
	pending[normalized] = incoming
	return true, nil
}

func (a *App) logLaunchCategoryConflict(conflict *store.LaunchCategoryConflictError) {
	a.logger.Error(map[string]any{
		"类型": "新盘分类冲突", "代币": conflict.Token,
		"已有分类": conflict.Existing, "新增分类": conflict.Incoming,
	})
}

func toPonsLogs(logs []chain.Log) []pons.EventLog {
	out := make([]pons.EventLog, 0, len(logs))
	for _, event := range logs {
		out = append(out, toPonsLog(event))
	}
	return out
}
func toPonsLog(event chain.Log) pons.EventLog {
	return pons.EventLog{Address: event.Address, Topics: event.Topics, Data: event.Data, LogIndex: event.ReceiptLogIndex}
}
func toO1Logs(logs []chain.Log) []o1crypto.EventLog {
	out := make([]o1crypto.EventLog, 0, len(logs))
	for _, event := range logs {
		out = append(out, toO1Log(event))
	}
	return out
}
func toO1Log(event chain.Log) o1crypto.EventLog {
	return o1crypto.EventLog{Address: event.Address, Topics: event.Topics, Data: event.Data, LogIndex: event.ReceiptLogIndex}
}
func toV4Logs(logs []chain.Log) []v4fill.EventLog {
	out := make([]v4fill.EventLog, 0, len(logs))
	for _, event := range logs {
		out = append(out, toV4Log(event))
	}
	return out
}
func toV4Log(event chain.Log) v4fill.EventLog {
	return v4fill.EventLog{Address: event.Address, Topics: event.Topics, Data: event.Data, LogIndex: event.ReceiptLogIndex}
}

func prefer(current, fallback string) string {
	if current != "" {
		return current
	}
	return fallback
}
func zeroIfEmpty(value string) string {
	if value == "" {
		return "0"
	}
	return value
}
func directionName(kind string) string {
	switch kind {
	case "launch":
		return "发盘"
	case "buy":
		return "买入"
	case "sell":
		return "卖出"
	default:
		return kind
	}
}
func venueDisplay(category string) string {
	switch category {
	case "pons":
		return "Pons"
	case "o1_crypto":
		return "o1加密"
	case "o1_stock":
		return "o1股票"
	case "long":
		return "Long"
	default:
		return category
	}
}
