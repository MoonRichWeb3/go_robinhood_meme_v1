-- GMGN Robinhood 钱包导入 smart_wallets
-- 职责：把公开排行快照幂等写入聪明钱名单，不改 schema。
-- 生成时间：2026-09-03 10:30 (UTC+8)
-- 来源：docs/钱包/gmgn_smart_wallets.json (265) + gmgn_kol_wallets.json (213)
-- 去重后 470 行：primary_type=kol 213，winner 257；重叠地址 8 条以 kol 为主类型。
-- 口径：source=gmgn；status=active；level=D；score=0；不写 last_seen_at。
-- 冲突策略：只更新展示名/来源/类型/标签/备注/状态/updated_at，不覆盖 score、level、level_locked、created_at、last_seen_at。
-- 执行：sqlite3 "$DB_PATH" < docs/钱包/insert_smart_wallets.sql

PRAGMA busy_timeout = 5000;
BEGIN IMMEDIATE;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x023ab8e20a4682d315daef4c91db96bd77934d66',
  'milady',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x023ab8e20a4682d315daef4c91db96bd77934d66',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@milady; follow=598',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x037e6b68ca866598d464a370afa060e4583aa0b8',
  'Spanny',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x037e6b68ca866598d464a370afa060e4583aa0b8',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@0xSpanny; follow=2407',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x061825a9195a2fb526735032fcac4ef58c6e52e4',
  'Tekkerrss',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x061825a9195a2fb526735032fcac4ef58c6e52e4',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Tekkerrss; follow=567',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x07591d902e68503c113ac4beca8abb3e3f6b0ab3',
  'driz',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x07591d902e68503c113ac4beca8abb3e3f6b0ab3',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@driz1x_; follow=3777',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x077b9981bc8a2ca417cea41861111da63266988b',
  'clukz',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x077b9981bc8a2ca417cea41861111da63266988b',
  'kol',
  'kol,fomo,smart_degen,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@clukz; follow=29149',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x07cdaf0140c60a0c34681065abf49bb8d85b8cbe',
  'ozark',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x07cdaf0140c60a0c34681065abf49bb8d85b8cbe',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@ohzarke; follow=22944',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x07e8db253624b1cafaf576c54e84ceea2c50fa4a',
  '️',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x07e8db253624b1cafaf576c54e84ceea2c50fa4a',
  'kol',
  'kol,fresh_wallet,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@ignHail; follow=80',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x08d580acba009b4bd2ba839d123168c5fbaaaa53',
  'XX',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x08d580acba009b4bd2ba839d123168c5fbaaaa53',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@XXAntiWar; follow=3108',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x092f8963e749910e23c2fc71d887538fcef9ca19',
  'PasaCrypto',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x092f8963e749910e23c2fc71d887538fcef9ca19',
  'kol',
  'kol,fresh_wallet,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@0xrahaa; follow=9',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x0b3edd0d0bf7c6281a7f8ae5a5630defb94ae78e',
  'Frosty',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x0b3edd0d0bf7c6281a7f8ae5a5630defb94ae78e',
  'kol',
  'kol,smart_degen,gmgn,gmgn_smart,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@frostyyy; overlap=smart_and_kol; follow=5408',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x0cd4d1a9c67a0c7677dcacb37791dadb38ea5666',
  'Inside Calls',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x0cd4d1a9c67a0c7677dcacb37791dadb38ea5666',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@insidecalls; follow=262',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x0f84d2da979180394fbf9c4499febd0f602a6767',
  'Cupsey',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x0f84d2da979180394fbf9c4499febd0f602a6767',
  'kol',
  'kol,smart_degen,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@CupseyV; follow=4558',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x11db1321c3f926334eb155d5fe704f6b2ff6a2f9',
  '达达',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x11db1321c3f926334eb155d5fe704f6b2ff6a2f9',
  'kol',
  'kol,smart_degen,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@andrea1982amor; follow=8288',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x12fba237ac57b408efdbe63c0380ca17ed70b3b1',
  '__The Krypto King',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x12fba237ac57b408efdbe63c0380ca17ed70b3b1',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@thekryptoking_; follow=6248',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x13a7d2fb3f73b57ef539c35c4ec59ed49b1833ca',
  'Crucifore☠️🦎',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x13a7d2fb3f73b57ef539c35c4ec59ed49b1833ca',
  'kol',
  'kol,fomo,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@crucifore; follow=51',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x15fc2ba42a358102044b2270e8207c296e8a3e3f',
  '杀破狼 WolfyXBT',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x15fc2ba42a358102044b2270e8207c296e8a3e3f',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@wolfyxbt; follow=11566',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x170332b75c0859a39bf7288f6cbf0db94bb1f567',
  'TOM 🦞',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x170332b75c0859a39bf7288f6cbf0db94bb1f567',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@okmetom; follow=6505',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x1dde452ba18505865deaa29b84be2191943579ab',
  '0xStar.Z（蜕变打狗天才版）',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x1dde452ba18505865deaa29b84be2191943579ab',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@EdisonZz798; follow=539',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x1df3160f73fd6c1bec394c51fc20b7b2a91d6330',
  'alkuuu | AP',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x1df3160f73fd6c1bec394c51fc20b7b2a91d6330',
  'kol',
  'kol,smart_degen,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@alkuap; follow=9826',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x1fa8bbd3f95f89958930450ee155355588888888',
  'blockdao🇨🇳 下次钻石手',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x1fa8bbd3f95f89958930450ee155355588888888',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@blockdao_1; follow=10973',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x2056c718e295537df3460bd0aa7f0282ff2f59d1',
  'hubz',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x2056c718e295537df3460bd0aa7f0282ff2f59d1',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@hubzify; follow=488',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x28aa4f9ffe21365473b64c161b566c3cdead0108',
  'fierydev 💥',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x28aa4f9ffe21365473b64c161b566c3cdead0108',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@dev_enjoys; follow=576',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x28d3bdece9a0c7f54687f734fa73fba04ecf5785',
  'Yeomyung (theo/acc)',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x28d3bdece9a0c7f54687f734fa73fba04ecf5785',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@duaud9912; follow=975',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x2948ebe47277da144a86f43f2b48981c8ff72a3e',
  '天意',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x2948ebe47277da144a86f43f2b48981c8ff72a3e',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@tianyi88888888; follow=4283',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x2a2619e81d61c09aa9206535bac1b7a5921ea050',
  'Crypto Zeinab',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x2a2619e81d61c09aa9206535bac1b7a5921ea050',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@CryptoZeinab; follow=85',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x2b614bf0cff1dff5d099f88a98ae449604379bc2',
  'REKTRossi 🦇🔊birthday Edition 🤍',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x2b614bf0cff1dff5d099f88a98ae449604379bc2',
  'kol',
  'kol,fomo,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@ksaniroxs; follow=22',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x2bafc1e12704563e329cbfe8332695d72065ba19',
  'FogoNFT',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x2bafc1e12704563e329cbfe8332695d72065ba19',
  'kol',
  'kol,fomo,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@FogoNFT; follow=140',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x2ce9d43d1cba6ae31d7f07bfe0098dfa2d833373',
  '枯坐p小将',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x2ce9d43d1cba6ae31d7f07bfe0098dfa2d833373',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@rob02643673_rob; follow=124231',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x2e846962822c6b5510da214d0760409c7b2c2dc4',
  '社会主义接班人',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x2e846962822c6b5510da214d0760409c7b2c2dc4',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@VIP8888883; follow=36',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x2f1689161ed466ee3a4acbac68b278c295ead606',
  'libapi',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x2f1689161ed466ee3a4acbac68b278c295ead606',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@libapi_; follow=222',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x2f32c70ecdbb198fc1b13db1db3375c3392cc063',
  'Rahim Mahtab',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x2f32c70ecdbb198fc1b13db1db3375c3392cc063',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Rahim_mahtab; follow=59',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x2f47ca870e6febbd7cd9b7fdbe1d76467709a085',
  'linhui',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x2f47ca870e6febbd7cd9b7fdbe1d76467709a085',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@milesjnixon; follow=2333',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x2f84ebb2f7f8edcf8e83a75a12f32bd8d99de3e0',
  'Paingelz',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x2f84ebb2f7f8edcf8e83a75a12f32bd8d99de3e0',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@redarvian; follow=19042',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x2fcc020f72e5d2edd2a24d04f3dc90d7fdfbd1dd',
  'τop τick crypτo 📁 🤖🧠',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x2fcc020f72e5d2edd2a24d04f3dc90d7fdfbd1dd',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@toptickcrypto; follow=483',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x30784ec9b03c039ebb880e3936538e652b1cf5ba',
  'fxnction',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x30784ec9b03c039ebb880e3936538e652b1cf5ba',
  'kol',
  'kol,fomo,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@fxnction; follow=74',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x3310fd13c6c55f054cc128439e1e51cd0cb16fed',
  'rciv',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x3310fd13c6c55f054cc128439e1e51cd0cb16fed',
  'kol',
  'kol,fomo,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@rcivNFT; follow=507',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x3391a39a1b508e54a361924a26056c01c1c2c07d',
  'Rell',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x3391a39a1b508e54a361924a26056c01c1c2c07d',
  'kol',
  'smart_degen,kol,wash_trader,gmgn,gmgn_smart,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Reljoooo; overlap=smart_and_kol; follow=103079',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x347ffc6db9acc54ac2019795173b9599e8b82bd9',
  'pedrolucio (humble arc 😌🙏)',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x347ffc6db9acc54ac2019795173b9599e8b82bd9',
  'kol',
  'kol,wash_trader,smart_degen,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@pe___lu; follow=5926',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x350495a8feab02ccaac6cd16f43dc36dc81aff05',
  'Funky Beach',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x350495a8feab02ccaac6cd16f43dc36dc81aff05',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@FunkyBeaches; follow=2',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x371903abb32f5f69b536b77495e92adedfea25da',
  'Yoda',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x371903abb32f5f69b536b77495e92adedfea25da',
  'kol',
  'kol,fomo,smart_degen,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@yodacalls; follow=11552',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x372ced7af27e31828db5ad1d1b09417c14430fb2',
  'CaptainY',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x372ced7af27e31828db5ad1d1b09417c14430fb2',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@WhyCaptainY; follow=18',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x38e4203f12b1e74d87deb0083d3c8b51ad9a104e',
  'Loopierr',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x38e4203f12b1e74d87deb0083d3c8b51ad9a104e',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Loopierr; follow=18168',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x3a9f45ac308ccc0a1a48b0f9e2f8ce859a0039ea',
  'Monstero',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x3a9f45ac308ccc0a1a48b0f9e2f8ce859a0039ea',
  'kol',
  'kol,fomo,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Monstrecrypto; follow=31',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x3d06315c94ac30b6061c91caf748fc2db04a89f4',
  'tech',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x3d06315c94ac30b6061c91caf748fc2db04a89f4',
  'kol',
  'kol,smart_degen,gmgn,gmgn_smart,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@technoviking46; overlap=smart_and_kol; follow=7940',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x3fae8eb5462ec4bb9c77bbad88cc52743ce58254',
  'Heyitsyolo',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x3fae8eb5462ec4bb9c77bbad88cc52743ce58254',
  'kol',
  'kol,fresh_wallet,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Heyitsyolotv; follow=1254',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x41ccc209d3ba4e81ef0c1fcb6d191127fb5b42f5',
  'ROCKSTAR',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x41ccc209d3ba4e81ef0c1fcb6d191127fb5b42f5',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@rawrstarxdd; follow=5269',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x42910a69effb47b8f8f2cb726fd964a654914131',
  'J777Crypto',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x42910a69effb47b8f8f2cb726fd964a654914131',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@J777Crypto; follow=195',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x4346169036c8d32c422df027e5f46e55b489d2ee',
  'BBA',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x4346169036c8d32c422df027e5f46e55b489d2ee',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@ape6743; follow=643',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x454685dec7796c2c747294f7aa7a30b2c5ab05f7',
  'VA 🟩',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x454685dec7796c2c747294f7aa7a30b2c5ab05f7',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@VirtualAlaska_; follow=164',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x473d3a2005499301dc353afa9d0c9c5980b5188c',
  'yieldfarming',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x473d3a2005499301dc353afa9d0c9c5980b5188c',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@delucinator; follow=606',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x490ecb092c05b37834fd5e8eaacfd1037884581e',
  'Leshka.eth ⛩',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x490ecb092c05b37834fd5e8eaacfd1037884581e',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@leshka_eth; follow=43',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x49b3e70dfc8b18654f5335532c17406794ac5ddd',
  'Dod✞',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x49b3e70dfc8b18654f5335532c17406794ac5ddd',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Dodseven77; follow=3708',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x4a0f12a33719a6444405261845a897f33243c750',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x4a0f12a33719a6444405261845a897f33243c750',
  'kol',
  'kol,fomo,gmgn_kol,renowned',
  'D',
  0,
  'follow=3',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x4a30496554ef401e4b687189f7df6efe4b3e0249',
  'Phero.hl',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x4a30496554ef401e4b687189f7df6efe4b3e0249',
  'kol',
  'kol,smart_degen,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@pheromones_sol; follow=2903',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x4b10707123c79f6e99be486dcd95d60323988d76',
  'Giann',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x4b10707123c79f6e99be486dcd95d60323988d76',
  'kol',
  'kol,smart_degen,fomo,gmgn,gmgn_smart,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Giann2K; overlap=smart_and_kol; follow=3596',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x4d68d0ebc52ce41f2ed057f926960df89b0455f9',
  'Jud',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x4d68d0ebc52ce41f2ed057f926960df89b0455f9',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@judthedev; follow=2482',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x4d6afeb4a4fc177e9fc6a69fb1b390864ae7f60f',
  '𝕜ꪖ𝕣ꪮડꫝⅈ',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x4d6afeb4a4fc177e9fc6a69fb1b390864ae7f60f',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@0xKaroshi; follow=128',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x4d9644d05fe2123b4eafa8d7fd31b0ea430726f3',
  '降雨幾率',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x4d9644d05fe2123b4eafa8d7fd31b0ea430726f3',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@run1ooooo1; follow=107426',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x51f6749dee3510f983c15b7c239cc6df4e4054ea',
  'Rennegade',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x51f6749dee3510f983c15b7c239cc6df4e4054ea',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Stucolley; follow=62',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x5250dbcf6ac11c4c2cbd8dcaf5a6d019f3268ea8',
  'CoCo❕',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x5250dbcf6ac11c4c2cbd8dcaf5a6d019f3268ea8',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@CoCoCookerr; follow=4823',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x54be3a794282c030b15e43ae2bb182e14c409c5e',
  'dingaling',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x54be3a794282c030b15e43ae2bb182e14c409c5e',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@dingalingts; follow=8213',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x54d209d9d224a615e0e5f0476644886897b75e45',
  'Yeon',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x54d209d9d224a615e0e5f0476644886897b75e45',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@yeon__; follow=14326',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x552f01d67b352aaa38bc675e30ced97f2451df63',
  'gcan',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x552f01d67b352aaa38bc675e30ced97f2451df63',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@gCAN9k; follow=37',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x55fade80e573c4594b0dd73041297024f1f2ee95',
  '0X财神（版本之神）',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x55fade80e573c4594b0dd73041297024f1f2ee95',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@0xcaishen_1; follow=5950',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x567469503dbe791e2676e838cd39c115feb34e60',
  'Hamburger 🍔🔶BNB',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x567469503dbe791e2676e838cd39c115feb34e60',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@gold_burger; follow=13637',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x5a9798d5e9956ce8e28f665735c03705bc46455d',
  '路边的草帽',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x5a9798d5e9956ce8e28f665735c03705bc46455d',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@straw_hat1688; follow=4052',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x5b0e0d7905e2fbc008ff2836c0a0ffd815c9c9fd',
  'giocki',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x5b0e0d7905e2fbc008ff2836c0a0ffd815c9c9fd',
  'kol',
  'kol,gmgn,fomo,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@giocki; follow=556',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x5c14c517991c2bd72c3495efed8c9aefdbd8b8e1',
  'Hasan I 哈桑 🇺🇸🇨🇳',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x5c14c517991c2bd72c3495efed8c9aefdbd8b8e1',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@paralog1; follow=40',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x5d802e2fe48392c104ce0401c7eca8a4456f1f16',
  'Toady Hawk',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x5d802e2fe48392c104ce0401c7eca8a4456f1f16',
  'kol',
  'kol,fomo,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@toady_hawk; follow=604',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x5edf27efd02421afed92e3cad25b7f42f6252be8',
  'Djip',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x5edf27efd02421afed92e3cad25b7f42f6252be8',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@CryptoDjip; follow=471',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x5fa57fcaf86e137cb8185c4cb2c01ea7b5b14cfb',
  'Veloce',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x5fa57fcaf86e137cb8185c4cb2c01ea7b5b14cfb',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@VeloceSVJ; follow=2734',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x5fd21eba060ba46ad458d6a2b0db5c050f07feb2',
  'Dith',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x5fd21eba060ba46ad458d6a2b0db5c050f07feb2',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@0xDith; follow=115',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x6078ee8a93697c6d67863fcbff77141d9ab358b2',
  'Inq',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x6078ee8a93697c6d67863fcbff77141d9ab358b2',
  'kol',
  'kol,fomo,wash_trader,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@inquixit; follow=6376',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x609f2c912175f8cd4438c1882f291fa6a4b4c735',
  'whashywash',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x609f2c912175f8cd4438c1882f291fa6a4b4c735',
  'kol',
  'kol,smart_degen,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@whashywash; follow=3154',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x61e1de40854cae288a11feb9b28a064df14d29ef',
  'YOLO',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x61e1de40854cae288a11feb9b28a064df14d29ef',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Yolo_7_; follow=10350',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x61fd0d043d519f5a2bd05785000f30db96809429',
  '0xᴜᴇzhᴀng|985.eth',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x61fd0d043d519f5a2bd05785000f30db96809429',
  'kol',
  'kol,fresh_wallet,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Unipioneer; follow=4124',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x62e5332dcb286f1753d245707c91a38821bb5645',
  'leet',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x62e5332dcb286f1753d245707c91a38821bb5645',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@0xleet; follow=3989',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x64b23c2987aca16b3d3c55ad6f694058783c72ea',
  '钻石手',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x64b23c2987aca16b3d3c55ad6f694058783c72ea',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@CyptoVVV; follow=14685',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x65fef251653b1bb680f22dc695aa72c623864d47',
  '顶尖叙事创造者',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x65fef251653b1bb680f22dc695aa72c623864d47',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@JoonAuYeung; follow=5740',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x664d6645a04be9e27a8b33088f85025f29d45dc1',
  'Tavern',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x664d6645a04be9e27a8b33088f85025f29d45dc1',
  'kol',
  'kol,smart_degen,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@TurtleTavernTV; follow=16771',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x683035da6b84ce48421534c1d3d160a8487cb9bb',
  'tech',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x683035da6b84ce48421534c1d3d160a8487cb9bb',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@technoviking46; follow=1362',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x6994aa3c83455705a514798fc29aff6d94d06da2',
  'Musty',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x6994aa3c83455705a514798fc29aff6d94d06da2',
  'kol',
  'kol,fomo,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@MustyDiapers; follow=88',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x6f20ab4899817c8d9228b0978d4fdbebb8ceaeec',
  'danny',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x6f20ab4899817c8d9228b0978d4fdbebb8ceaeec',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@cladzsol; follow=6501',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x72bb99200a89e608658a9032aad5aef6a41dd46f',
  'rynm',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x72bb99200a89e608658a9032aad5aef6a41dd46f',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@rynm1x; follow=2252',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x72f686dafe610134aa30cbfb63d9cfd720ab6600',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x72f686dafe610134aa30cbfb63d9cfd720ab6600',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'follow=3281',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x7551fd7a88afd941ddcc0a4f1cb62cf85afdae61',
  'kreo',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x7551fd7a88afd941ddcc0a4f1cb62cf85afdae61',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@kreo444; follow=6284',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x758e83c114e36a28ca1f31c4d2adb5ec7c04c578',
  'Cryptk33p3r ❤️ Memecoin',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x758e83c114e36a28ca1f31c4d2adb5ec7c04c578',
  'kol',
  'kol,fomo,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Kryptk33p3r666; follow=1642',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x75b6ff841fca5467272d1f4769f9ee5685a4ef20',
  'Swishi.eth',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x75b6ff841fca5467272d1f4769f9ee5685a4ef20',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@swishi_eth; follow=40',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x777c47498b42dbe449fb4cb810871a46cd777777',
  'Apex',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x777c47498b42dbe449fb4cb810871a46cd777777',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@apex_ether; follow=228',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x77e5efcf4d14f6136242dc2f5618d1854761deef',
  '神手｜Divine hand',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x77e5efcf4d14f6136242dc2f5618d1854761deef',
  'kol',
  'kol,fomo,gmgn,fresh_wallet,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@shenshou888; follow=1374',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x7852346c77b3a622fa73607ee35cc784e53f326b',
  'Han',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x7852346c77b3a622fa73607ee35cc784e53f326b',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@00xhwin; follow=8879',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x7a39f6db93a57810c3db047524b986516d360c33',
  'West',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x7a39f6db93a57810c3db047524b986516d360c33',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@ratwizardx; follow=5040',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x7b3d8e939ee08b52d06ab5e6f85791a6007e8d61',
  'casino',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x7b3d8e939ee08b52d06ab5e6f85791a6007e8d61',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@casino847; follow=16217',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x7b9761145ef55f33dfcd514f1e20f5313da978af',
  '.',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x7b9761145ef55f33dfcd514f1e20f5313da978af',
  'kol',
  'kol,fresh_wallet,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Kevsznx; follow=8127',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x7cad002ceffbe6752ec537afffc4da093f65686a',
  '比特狸狸',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x7cad002ceffbe6752ec537afffc4da093f65686a',
  'kol',
  'kol,fresh_wallet,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@toujifox; follow=157',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x7db1a182cddee6ea0483aead72efe945e11cc873',
  '表弟想自由💰',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x7db1a182cddee6ea0483aead72efe945e11cc873',
  'kol',
  'kol,smart_degen,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Cady_btc; follow=658',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x7decf7a31168778f311c57b9a948abaa7321001e',
  'warrenhimself 🎟💚',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x7decf7a31168778f311c57b9a948abaa7321001e',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@nullinger; follow=41',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x81b24791bc6c6713adf55c4f135f13639e92e5ae',
  '0xAlif',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x81b24791bc6c6713adf55c4f135f13639e92e5ae',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@0xAlif; follow=79',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x835c38e2ffb458f37b47c4967695347caa8502b4',
  'mamad.sol',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x835c38e2ffb458f37b47c4967695347caa8502b4',
  'kol',
  'kol,fresh_wallet,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@blackpuma_xyz; follow=54',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x877af245c61289b24f0c619a4346cdbc68f1aaac',
  '古月月',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x877af245c61289b24f0c619a4346cdbc68f1aaac',
  'kol',
  'kol,smart_degen,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@hzjxhcyy; follow=3927',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x878a051559152383fbd35315eb03f3ef5fbf76a6',
  '葵殿',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x878a051559152383fbd35315eb03f3ef5fbf76a6',
  'kol',
  'kol,smart_degen,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@0xkuidian; follow=3534',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x8a53071b039a2b1b13f0c282c941880d0109d5e3',
  'Shadoss',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x8a53071b039a2b1b13f0c282c941880d0109d5e3',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@shadossxd; follow=45',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x8aab2decdccfa5f2bd4f5bf6545ded7ceab11c49',
  'aloh',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x8aab2decdccfa5f2bd4f5bf6545ded7ceab11c49',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@alohquant; follow=11725',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x8ae497630ad9dd3e7f5dafa2bb4f3ff19f64d379',
  'Avin ☀️🌙⭐️',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x8ae497630ad9dd3e7f5dafa2bb4f3ff19f64d379',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Avin_lucia; follow=35',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x8d12b8c3bef358d1901d891a74fa801aba2b79b0',
  'Shual',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x8d12b8c3bef358d1901d891a74fa801aba2b79b0',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@0xShual; follow=46',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x8d5624fa29526c879a1ca7560961e4c5a08089ae',
  '0xAA',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x8d5624fa29526c879a1ca7560961e4c5a08089ae',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@0xAA_Science; follow=87503',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x8d7bbfa0506ea95c73d864310818acc3e5fa05d9',
  'Oxxyy',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x8d7bbfa0506ea95c73d864310818acc3e5fa05d9',
  'kol',
  'kol,fomo,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Oxxyy13; follow=242',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x8dfb37aae4f8fcbd1f90015a9e75b48f50fd9f59',
  'rxbt 👾',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x8dfb37aae4f8fcbd1f90015a9e75b48f50fd9f59',
  'kol',
  'kol,fresh_wallet,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@0rxbt; follow=1477',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x8e29d0e2ca8e92a9f27192616e2e9f170fd2a035',
  'Tux',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x8e29d0e2ca8e92a9f27192616e2e9f170fd2a035',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@megastuffs; follow=201',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x904a5d05d72a0575c6a60f7de7566abc2ac331e2',
  'bandit',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x904a5d05d72a0575c6a60f7de7566abc2ac331e2',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@bandeeeez; follow=5394',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x9224bbb4e0fbe2f2f8fab55debc41eb21fdfb804',
  'DeScientist',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x9224bbb4e0fbe2f2f8fab55debc41eb21fdfb804',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@GuruG_crypto; follow=127',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x92c371744e71dbe58c603661ba8784fd76472e1b',
  'CryptoLucky',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x92c371744e71dbe58c603661ba8784fd76472e1b',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@sol_lucky_; follow=3806',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x93585d7f5f15d8bc67f41a12d2b3e3966a1ee6a0',
  '加密帅',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x93585d7f5f15d8bc67f41a12d2b3e3966a1ee6a0',
  'kol',
  'kol,smart_degen,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@xlxl114; follow=1218',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x94318ed124785b5910d8e456bf0ca50aaf27835f',
  'Lei_少📈📈',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x94318ed124785b5910d8e456bf0ca50aaf27835f',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@RSZB_leishao168; follow=230',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x94cf7ed19901eb7d487c779e6d1baa87157b2d01',
  '888UP',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x94cf7ed19901eb7d487c779e6d1baa87157b2d01',
  'kol',
  'kol,smart_degen,gmgn,gmgn_smart,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@888upupup; overlap=smart_and_kol; follow=5327',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x9631335762e3603d2a7507d84838aa3236d52745',
  'Sebastian Orellana',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x9631335762e3603d2a7507d84838aa3236d52745',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Saint_pablo123; follow=5252',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x9784a0e3b33856b5b6515301e3f16175926bb31d',
  'Airdrop Mate',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x9784a0e3b33856b5b6515301e3f16175926bb31d',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@AirdropMate; follow=33',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x9897b49174dc565730ef1d116d80081574ccb3ec',
  'K线漂移',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x9897b49174dc565730ef1d116d80081574ccb3ec',
  'kol',
  'kol,wash_trader,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Gs97z; follow=7107',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x990794b0ab59cccc7154ff9aa9888da26b44d3cf',
  'AlexWong 🇭🇰 | 1000X GEM',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x990794b0ab59cccc7154ff9aa9888da26b44d3cf',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@sadd_asd77675; follow=3331',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x99079745001f861ce5e0c1a27f8e4ebe55cac12c',
  'H.E. ZEPUMP',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x99079745001f861ce5e0c1a27f8e4ebe55cac12c',
  'kol',
  'kol,fomo,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@zepump; follow=220',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x9a1ee67e454bb963183884e7e2872fc0016613d3',
  'Erison',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x9a1ee67e454bb963183884e7e2872fc0016613d3',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@erisonmeira; follow=340',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x9dbfded199ee3a6b291c223e65f97d387156aada',
  'Zemrics',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x9dbfded199ee3a6b291c223e65f97d387156aada',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Zemrics; follow=19227',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x9dd3eba1e920838cc07cdcdf5be0d573ed590f75',
  'Wick李🔶 BNB',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x9dd3eba1e920838cc07cdcdf5be0d573ed590f75',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@SuperL9i; follow=179',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xa05ec35f7d1eba823cff2ed26aeaed419683742f',
  'yukaz',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xa05ec35f7d1eba823cff2ed26aeaed419683742f',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@0xyukaz; follow=15629',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xa1426c6f65fe804e05ce3c07a42412d735ef78bc',
  '不知名打狗大师🧢',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xa1426c6f65fe804e05ce3c07a42412d735ef78bc',
  'kol',
  'kol,smart_degen,gmgn,gmgn_smart,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@0xrap9; overlap=smart_and_kol; follow=4680',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xa4beaea04ee42f451f38c771842489d7649b95f2',
  'api5',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xa4beaea04ee42f451f38c771842489d7649b95f2',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@apastala5; follow=2123',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xa7635719e1da3520d99e5be57cf925b4ad21636d',
  '闽南大哥（正心正念）',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xa7635719e1da3520d99e5be57cf925b4ad21636d',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@BTCGM1911; follow=82',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xa7d4ffc4eca3c71af150ce302560a9d04a1d2b9f',
  'MIRRO🔶 BNB',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xa7d4ffc4eca3c71af150ce302560a9d04a1d2b9f',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Mirro7777; follow=108655',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xa7dcc417c63f24f9073b667a5d7149bd38463d0f',
  'H.E. ZEPUMP',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xa7dcc417c63f24f9073b667a5d7149bd38463d0f',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@zepump; follow=717',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xa83b73f5644cde337b61da79589f10ea15548811',
  'AntPositions(蚂蚁仓）☄️',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xa83b73f5644cde337b61da79589f10ea15548811',
  'kol',
  'kol,smart_degen,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@antpositions; follow=91003',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xa866c5adddc1c3570b6328491b510deefa374e0d',
  'William',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xa866c5adddc1c3570b6328491b510deefa374e0d',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Vera548926; follow=5334',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xa8b63e1408e8e607d4cf48e6e3b14bb881b2010e',
  '0xyuxi | 0x雨曦',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xa8b63e1408e8e607d4cf48e6e3b14bb881b2010e',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@0xYuxi; follow=123',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xa96f56923ecaae76dc3601ba4e718bf8a5eb6087',
  '长乐發發 🔶',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xa96f56923ecaae76dc3601ba4e718bf8a5eb6087',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@CL_CLACL; follow=2542',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb0a8ad238ac4cd4fff78080e77933ccefbf785e4',
  'Gonz',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb0a8ad238ac4cd4fff78080e77933ccefbf785e4',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Gonz1495; follow=290',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb1e65ccc2f5d68e447bf321ba9bfba35a94f5ad5',
  '被蜗牛追杀中',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb1e65ccc2f5d68e447bf321ba9bfba35a94f5ad5',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@dong7da7; follow=4834',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb226f97bc5b01978848dc440b40c70faea7c006e',
  'AlexWong 🇭🇰 | 1000X GEM',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb226f97bc5b01978848dc440b40c70faea7c006e',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@sadd_asd77675; follow=12622',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb2d1af0746c410e146272e804b1741f07f83b851',
  'Zephyr',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb2d1af0746c410e146272e804b1741f07f83b851',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@ZephyrTrading; follow=6102',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb2f9bbc5db84a95b598cab0c464cf92d584d8900',
  '100y',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb2f9bbc5db84a95b598cab0c464cf92d584d8900',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@100y_eth; follow=159',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb5168bd818d3c5278377b38b00c3d0adc50b092c',
  'EnigmaFunge',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb5168bd818d3c5278377b38b00c3d0adc50b092c',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@EnigmaFund; follow=27',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb5b731f340554b672f686ca8459d55ced5e5bda4',
  '0xLeaf🍃',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb5b731f340554b672f686ca8459d55ced5e5bda4',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@3ethtomoon; follow=6488',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb5d26158102181dc4ceee75f260a60debd752e45',
  'Ace',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb5d26158102181dc4ceee75f260a60debd752e45',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Ace_da_Book; follow=50',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb8e134b0c9b82914042e03e1b8a07dd0b912bb98',
  '一千万是只猫',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb8e134b0c9b82914042e03e1b8a07dd0b912bb98',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@RXu107; follow=427',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb90d9ea599c2634069ae4d5eecc5ab7234a81a05',
  '从零开始的打狗生活（农场悟道）',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb90d9ea599c2634069ae4d5eecc5ab7234a81a05',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@cryptomoon520; follow=8150',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb9b0252f780ef21aa3c8b3d6bd6ea19c0231edc3',
  '牛顶天（bayue)',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb9b0252f780ef21aa3c8b3d6bd6ea19c0231edc3',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Researchcai; follow=5560',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xbac453b9b7f53b35ac906b641925b2f5f2567a89',
  'Dani',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xbac453b9b7f53b35ac906b641925b2f5f2567a89',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@DaniWorldwide; follow=15681',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xbc2255fb3746403cf1858a69cdabd2e9be77c538',
  'dv',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xbc2255fb3746403cf1858a69cdabd2e9be77c538',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@vibed333; follow=17770',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xbc6cbc95d86a6a9537375640fbc0cf0db8024268',
  'Zack Brenner',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xbc6cbc95d86a6a9537375640fbc0cf0db8024268',
  'kol',
  'kol,fomo,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@zjbrenner; follow=1412',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xbd6b8d8fa94f7307840252548549b56a33c98054',
  'Cooker.hl | 版本之子 (Theo Arc)',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xbd6b8d8fa94f7307840252548549b56a33c98054',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@CookerFlips; follow=18159',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xbf004bff64725914ee36d03b87d6965b0ced4903',
  '阿峰_Afeng',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xbf004bff64725914ee36d03b87d6965b0ced4903',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@aa_AFeng; follow=106863',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc05ed8f3adbc1007d9d8debc21a721aa951fad50',
  'Vengeance 🦇',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc05ed8f3adbc1007d9d8debc21a721aa951fad50',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@DarkKnightBTC; follow=35',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc0f24234a31050186b88c622a1389deec81f133e',
  '冲出重围的屁',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc0f24234a31050186b88c622a1389deec81f133e',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@CCCWDP; follow=242',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc1165124be8dc53a3826a1aa1b6643e9138d167c',
  'Kuji',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc1165124be8dc53a3826a1aa1b6643e9138d167c',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@kujiiii; follow=1461',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc2172a6315c1d7f6855768f843c420ebb36eda97',
  'Tom Lehman',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc2172a6315c1d7f6855768f843c420ebb36eda97',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@dumbnamenumbers; follow=42',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc2c6acd377458010713e733e1b21dd6f670d091c',
  'Ed_x區塊日記🇭🇰',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc2c6acd377458010713e733e1b21dd6f670d091c',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Ed_x0101; follow=11149',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc325a84c48a849bcb6fbdf936b71a628ff1aa530',
  'cryptovillain26',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc325a84c48a849bcb6fbdf936b71a628ff1aa530',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@cryptovillain26; follow=4301',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc4df5f2125151bff3a6aa7328529eae1b9d3cc31',
  'SUN (❖,❖)🍡.edge🦭',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc4df5f2125151bff3a6aa7328529eae1b9d3cc31',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@dsjwin; follow=52',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc652368b05a27dd70d135f636536714e2806bd9a',
  '杀破狼 WolfyXBT',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc652368b05a27dd70d135f636536714e2806bd9a',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@wolfyxbt; follow=10593',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc70ad5249bc432c7c69d71b017436441e9d6e37a',
  'CryptoCharming 🐟',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc70ad5249bc432c7c69d71b017436441e9d6e37a',
  'kol',
  'kol,fresh_wallet,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@CryptoCharming; follow=4463',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc848a7530ed12eb545a01eaa906de55f9491fb59',
  'Skid',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc848a7530ed12eb545a01eaa906de55f9491fb59',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@skid_eth; follow=439',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc9d46b11f3b1bbc85ebedfffca09707f8f28dca1',
  'Smol_Crypto_Brain',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc9d46b11f3b1bbc85ebedfffca09707f8f28dca1',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Smol_crypto_pp; follow=287',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xca1a2fb7f3179d887504966b25d1606978adcd42',
  'A',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xca1a2fb7f3179d887504966b25d1606978adcd42',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Aomake70; follow=10598',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xca434dfa3949a750dc15c15f44450c09a72621c4',
  'Ethan Prosper',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xca434dfa3949a750dc15c15f44450c09a72621c4',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@pr6spr; follow=5149',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xcef99ab15ef93ba9f523e57bf8039a19f1cea636',
  'MenaceToSociety 🥶',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xcef99ab15ef93ba9f523e57bf8039a19f1cea636',
  'kol',
  'kol,fomo,smart_degen,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@NFTsAreNice; follow=861',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xcf2b7c6bc98bfe0d6138a25a3b6162b51f75e05d',
  '0xphoenix.eth',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xcf2b7c6bc98bfe0d6138a25a3b6162b51f75e05d',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@JackieTian7; follow=528',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xcfe30db196c9a99fc80c72ad44fb4a135a53491f',
  '旭旭宝宝',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xcfe30db196c9a99fc80c72ad44fb4a135a53491f',
  'kol',
  'kol,smart_degen,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@xuxubaobao0819; follow=6220',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xd3358b1f39a6a71911c6e33717d185f99d43e80d',
  'Potato',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xd3358b1f39a6a71911c6e33717d185f99d43e80d',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@rdbotato; follow=1643',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xd3abaa759af897122c876b87cf386f748cb213a8',
  'King.sol 🇶🇦',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xd3abaa759af897122c876b87cf386f748cb213a8',
  'kol',
  'kol,fomo,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@teddi_speaks; follow=1578',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xd41feaa24dede516a501862cf1f376defb811772',
  'milito',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xd41feaa24dede516a501862cf1f376defb811772',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@fnmilito; follow=24211',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xd4229d8166dbaa45689589d59fa968abc840b20f',
  'OTTA 💰',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xd4229d8166dbaa45689589d59fa968abc840b20f',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@ottabag; follow=17961',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xd59b6a5dc9126ea0ebacd2d8560584b3ce48f62f',
  'Haze 𝓰𝓶𝓰𝓷𝓪𝓲',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xd59b6a5dc9126ea0ebacd2d8560584b3ce48f62f',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@haze0x; follow=20998',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xd717499568146195938cdcdb4ab8996e3da5491c',
  'DJ TRIX',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xd717499568146195938cdcdb4ab8996e3da5491c',
  'kol',
  'kol,fomo,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@DJTRIXUK; follow=27',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xd77eb80f38fec10d87a192d07329415173307e93',
  '42',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xd77eb80f38fec10d87a192d07329415173307e93',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@el4dos; follow=91',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xd914bb91f451201a8fa56f9f6c6c235abec2e4ed',
  'zpp.eth',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xd914bb91f451201a8fa56f9f6c6c235abec2e4ed',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@zppeth; follow=98',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xda9f482ea717384af879597303e8b67968afcde2',
  '扑街仔🔶 BNB🎒',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xda9f482ea717384af879597303e8b67968afcde2',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@_pogai_; follow=4752',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xdba50a7d04993a36dfabc4fce3a8d599e03c8c33',
  '搞钱小猫.eth',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xdba50a7d04993a36dfabc4fce3a8d599e03c8c33',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@xiaomaogaoqian; follow=3130',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xdd6f338b91f40e5a02c468b7cb49cccc569a3134',
  'Stigman',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xdd6f338b91f40e5a02c468b7cb49cccc569a3134',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Stigman__; follow=3677',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xddac928a240bdace3994c2cc0783d4e29a002127',
  'o大（吸吸喜气欧皇扫链版）',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xddac928a240bdace3994c2cc0783d4e29a002127',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@oooooyoung11; follow=12668',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xe1412eb3a56502c5322eddf4fd6b63097fe9f08e',
  'Jeanne.vr',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xe1412eb3a56502c5322eddf4fd6b63097fe9f08e',
  'kol',
  'kol,fomo,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@0xjvrsky; follow=73',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xe18c8685818cb936dc2448be33349da61b412a4d',
  'Yesp 🔶',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xe18c8685818cb936dc2448be33349da61b412a4d',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@yesp999; follow=5395',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xe24da1c8f33e1dd8b7993b8b028c7109698ddaa5',
  'rain & coffee',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xe24da1c8f33e1dd8b7993b8b028c7109698ddaa5',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@0xRainandCoffee; follow=225',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xe28601398a5448d1147e6e8b0e0c6d686f0d216d',
  'NΞO',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xe28601398a5448d1147e6e8b0e0c6d686f0d216d',
  'kol',
  'kol,smart_degen,fomo,gmgn,gmgn_smart,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@NeoCallss; overlap=smart_and_kol; follow=104825',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xe3210627730c8e14d6bf2117eab28de531650111',
  'Tekkerrss',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xe3210627730c8e14d6bf2117eab28de531650111',
  'kol',
  'kol,fresh_wallet,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Tekkerrss; follow=1052',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xe33b746a030c3b3c512d274b05ea6e40772cf212',
  'Nephew Sam',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xe33b746a030c3b3c512d274b05ea6e40772cf212',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Nephew_Sam_; follow=323',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xe475cd3f0d0a77ec581bb6540abef60b0f3f0d57',
  'Degenerate Brian',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xe475cd3f0d0a77ec581bb6540abef60b0f3f0d57',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Brian_Degens; follow=1005',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xe4aab795881c36a1e199489d084822fd7188cc2c',
  'Bitcoin🐝女博士',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xe4aab795881c36a1e199489d084822fd7188cc2c',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@DoctorMbitcoin; follow=89',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xe5e9ffe707ee071998340972af6fb178f5c64ba6',
  'fhn.gt (🌍,💻)',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xe5e9ffe707ee071998340972af6fb178f5c64ba6',
  'kol',
  'kol,smart_degen,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@fhn_gt; follow=921',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xe6a5f1690fcda05d9ba0a663b6e7ddf3c97eb7b1',
  'Matt Willemsen',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xe6a5f1690fcda05d9ba0a663b6e7ddf3c97eb7b1',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@matt_willemsen; follow=1316',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xe826dd0be78361417809520d292009d7c9d303e9',
  '小鱼Daisy🔶BNB',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xe826dd0be78361417809520d292009d7c9d303e9',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@vvxiaoyu8888; follow=3297',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xe9c4c7a243191961af4fd4df44cafe0fafcb2917',
  'Cendol 岑铎',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xe9c4c7a243191961af4fd4df44cafe0fafcb2917',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Cendolnice; follow=2831',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xea7619909ebdf3cfdff7fd1f4c69e31682b767d3',
  'Capi 🐂',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xea7619909ebdf3cfdff7fd1f4c69e31682b767d3',
  'kol',
  'kol,fomo,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@CapitalCapi; follow=59',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xeb1222a0c07d4e62b0235d8b4b3e7e617d259be2',
  'No.17',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xeb1222a0c07d4e62b0235d8b4b3e7e617d259be2',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@CryptoHtdi; follow=9589',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xeb20b344612e8825ca07206f40f2b88e5afd5dd3',
  'Hydra',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xeb20b344612e8825ca07206f40f2b88e5afd5dd3',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@SmolHydra; follow=113',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xecaebf8f5a28a6ef322bb5428c11270ed057c497',
  '1xharsh',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xecaebf8f5a28a6ef322bb5428c11270ed057c497',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@1xharsh; follow=77',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xeeefff8ce2710fa490e0fcb794235e873c252d2e',
  'Shenron 🐉',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xeeefff8ce2710fa490e0fcb794235e873c252d2e',
  'kol',
  'kol,launchpad_smart,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@shenron__1; follow=3883',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xefbc53e0afdc9f649bc1ab692461df57e70a560f',
  'DRAMA❤️',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xefbc53e0afdc9f649bc1ab692461df57e70a560f',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@drama_moscow; follow=56',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xf0f8a6479a428edd0eab965e624800585b62972c',
  '木木',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xf0f8a6479a428edd0eab965e624800585b62972c',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@0xmmu; follow=2346',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xf100af33f90445d1d482fb63df3f6cdb475eeb0f',
  'Tom',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xf100af33f90445d1d482fb63df3f6cdb475eeb0f',
  'kol',
  'kol,fomo,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@tdmilky; follow=6202',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xf11c526605668d67e1cff264c30605eb2579babf',
  'mr.ghost',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xf11c526605668d67e1cff264c30605eb2579babf',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@mrghostinvblog; follow=738',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xf165d95f8f5d1639994ab3c668ccb66cf65cda13',
  '叶子君Foliage ◎🔶',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xf165d95f8f5d1639994ab3c668ccb66cf65cda13',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Foliage_et; follow=10940',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xf175faaed0df90221315a352fb067ab4d7de3ad5',
  'Rocky Mao',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xf175faaed0df90221315a352fb067ab4d7de3ad5',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@mao_rocky; follow=48',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xf23f6da0ea611a4f3c861f66b8d3c21be0f8a83f',
  '🌱Nero',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xf23f6da0ea611a4f3c861f66b8d3c21be0f8a83f',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@nero8888; follow=6357',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xf38ce55fe4e517e77e1056a54e64f22d43d88c3a',
  'professor',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xf38ce55fe4e517e77e1056a54e64f22d43d88c3a',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@0xossalivan; follow=823',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xf591db9dccd5d3aaf8508da2cffedd5ef5bb920f',
  'pk',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xf591db9dccd5d3aaf8508da2cffedd5ef5bb920f',
  'kol',
  'kol,smart_degen,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@pk79z; follow=154',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xf6f4ff252b28162de985f6b81199cd33212a43a1',
  'Flook',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xf6f4ff252b28162de985f6b81199cd33212a43a1',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Flook_eth; follow=2',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xf78310ed6641e6c4e221e9d676440ac8645d3afe',
  'jez (equity perps era)',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xf78310ed6641e6c4e221e9d676440ac8645d3afe',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@izebel_eth; follow=1288',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xf78b066050e00fdb9b980e265aa9f317ef4b947c',
  'kurtz',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xf78b066050e00fdb9b980e265aa9f317ef4b947c',
  'kol',
  'kol,fomo,smart_degen,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@kurtzxx; follow=11254',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xfad768ad07d485007a31ba1e47b07ac821f941dc',
  'AlxCooks',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xfad768ad07d485007a31ba1e47b07ac821f941dc',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@AlxCooks_off; follow=1804',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xfb4e4fa492217d8401aa9e893c78707b61923953',
  '小财神🔶BNB（慢就是快版）',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xfb4e4fa492217d8401aa9e893c78707b61923953',
  'kol',
  'kol,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@0xZhangCrypto1; follow=8220',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xfcfc3cd8cc507d73619221629131f209bff937b6',
  '路人甲',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xfcfc3cd8cc507d73619221629131f209bff937b6',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@localcat15; follow=4696',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xfe277aa25a4f65a182c0ec135854794eb7131e79',
  'Vali',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xfe277aa25a4f65a182c0ec135854794eb7131e79',
  'kol',
  'kol,fomo,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@vali_eth; follow=2777',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xfea3157ff571174f05fc86af3caee3b870a8495a',
  '游侠🔶Yoxia',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xfea3157ff571174f05fc86af3caee3b870a8495a',
  'kol',
  'kol,smart_degen,gmgn,gmgn_smart,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@Gmf_winner; overlap=smart_and_kol; follow=3128',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xfee4f6e8d6b5706876aceb3ad5185f9fbacf88ec',
  '宝灵灯C🟥',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xfee4f6e8d6b5706876aceb3ad5185f9fbacf88ec',
  'kol',
  'kol,smart_degen,gmgn,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@baolingD; follow=554',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xffc640de6a377252715394cd8c2f0ce04c94883c',
  'PULLUP',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xffc640de6a377252715394cd8c2f0ce04c94883c',
  'kol',
  'kol,gmgn_kol,renowned',
  'D',
  0,
  'twitter=@pullupso; follow=3328',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x0017fc366bb8735c6492e4067d3ffc8bf5f3e97f',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x0017fc366bb8735c6492e4067d3ffc8bf5f3e97f',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=35141',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x0076bc3cfa5963d7d35b929822e6d184146d02a4',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x0076bc3cfa5963d7d35b929822e6d184146d02a4',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=15',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x01bc817163512578f7a3c7c11738f7bd6cd68f36',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x01bc817163512578f7a3c7c11738f7bd6cd68f36',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=368',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x034543d1c475f1cfabc8e37f87bb60cf0ea943d5',
  'Crodie',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x034543d1c475f1cfabc8e37f87bb60cf0ea943d5',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@SergeantCrodie; follow=370',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x0434bbc9c8b1f81139778ed389b1218fd47ff7fc',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x0434bbc9c8b1f81139778ed389b1218fd47ff7fc',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=363',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x043edf03918cfb33b018c943cc7e40c6de98ec6a',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x043edf03918cfb33b018c943cc7e40c6de98ec6a',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=59',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x04b436555dc69ea4bf8ba50d8c591e60443b3ff9',
  '幼儿园高材生',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x04b436555dc69ea4bf8ba50d8c591e60443b3ff9',
  'winner',
  'kol,smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@NotVanGogh88; follow=2681',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x05f195014ce6dd3f6b38966c768e5ce6252f213f',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x05f195014ce6dd3f6b38966c768e5ce6252f213f',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=36',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x0641b51e2ba416dddf5f2853713e7d8977caf8e5',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x0641b51e2ba416dddf5f2853713e7d8977caf8e5',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=14',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x0714b0d24c6d2972a19d083917fe3a49f022a344',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x0714b0d24c6d2972a19d083917fe3a49f022a344',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=9',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x073285f5b826a8b7e1ba42acc5e37fa76bbd43f4',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x073285f5b826a8b7e1ba42acc5e37fa76bbd43f4',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=24',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x07fb753a79177927fa871eaa6eb1ef60a00d3473',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x07fb753a79177927fa871eaa6eb1ef60a00d3473',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=427',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x08216e085129c1c6adf847d1bb69855c41812ef7',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x08216e085129c1c6adf847d1bb69855c41812ef7',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=340',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x09b8211af3d9ab946d8e4e65e1133457e86fb1a2',
  'Jensen Hang',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x09b8211af3d9ab946d8e4e65e1133457e86fb1a2',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@Jensenhanng; follow=49',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x0cfba30f815e6209bb60480236dad04e00e5c7c9',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x0cfba30f815e6209bb60480236dad04e00e5c7c9',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=1389',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x0eb927539651159549cefb2c3df32775446c9d78',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x0eb927539651159549cefb2c3df32775446c9d78',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=187',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x0ec2c400b9db045bab16996cd25d64a05be48752',
  'stwn.',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x0ec2c400b9db045bab16996cd25d64a05be48752',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@0xmarcheria; follow=581',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x0ee649ceb5290da1abe51ee7e3e0a58687e11313',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x0ee649ceb5290da1abe51ee7e3e0a58687e11313',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=100',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x0f4ba96e8aaa68c6dab2e58aac8d4555ac0151d2',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x0f4ba96e8aaa68c6dab2e58aac8d4555ac0151d2',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'follow=45694',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x0f515417765b005bf571a123a0f965b0de2b9be1',
  'koalzy',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x0f515417765b005bf571a123a0f965b0de2b9be1',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@koalzy; follow=557',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x0f970b33dce930c8f3bb6388c536a594497785ab',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x0f970b33dce930c8f3bb6388c536a594497785ab',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=477',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x10817e2a42e966f02ffd85fe5de3ffc41b941198',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x10817e2a42e966f02ffd85fe5de3ffc41b941198',
  'winner',
  'gmgn,smart_degen,gmgn_smart',
  'D',
  0,
  'follow=11',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x119699b9a5164f354496bd0a81607b684ebec201',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x119699b9a5164f354496bd0a81607b684ebec201',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=915',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x11ca9701430f3ef4f79c4aba3f722f6d3d115754',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x11ca9701430f3ef4f79c4aba3f722f6d3d115754',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=402',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x14102761b2a02a9bb030d29152665176bbd87340',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x14102761b2a02a9bb030d29152665176bbd87340',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=1194',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x150952108f28dcaf4e4542090e67cd2696563944',
  'Shinra 👁️',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x150952108f28dcaf4e4542090e67cd2696563944',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@ShinraHQ_; follow=749',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x158044d9888019da7420706c47fbc89290155bbf',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x158044d9888019da7420706c47fbc89290155bbf',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=7',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x15b8ceec9120d30c7284d9d5eee9efb3659211ef',
  'Z1',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x15b8ceec9120d30c7284d9d5eee9efb3659211ef',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@1Z1izy; follow=1090',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x16657de1a0faac319359d6dc15d31b355cb535c0',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x16657de1a0faac319359d6dc15d31b355cb535c0',
  'winner',
  'gmgn,smart_degen,gmgn_smart',
  'D',
  0,
  'follow=525',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x17f4426d25cf6dab1eaf5f26b12f1e14467575a4',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x17f4426d25cf6dab1eaf5f26b12f1e14467575a4',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=411',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x18e5a4c6b95a7a87b1a05300154fbe111152815b',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x18e5a4c6b95a7a87b1a05300154fbe111152815b',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=881',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x195791ffe68c14ca7bdf4fcae6be337ff993f976',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x195791ffe68c14ca7bdf4fcae6be337ff993f976',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=11',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x19ff093a109bcb5c7a72f1e7fd5e4def1472cd36',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x19ff093a109bcb5c7a72f1e7fd5e4def1472cd36',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=363',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x1ad2cdd2537236b54710a616eb3955cf8c3a8151',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x1ad2cdd2537236b54710a616eb3955cf8c3a8151',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=186',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x1adc1eac1847e3095131513b8187573670e7c69c',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x1adc1eac1847e3095131513b8187573670e7c69c',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=82',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x1b30f0a3e7fb54211ab31741a2dc58725157b039',
  'zeldr1s',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x1b30f0a3e7fb54211ab31741a2dc58725157b039',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@_zeldr1ss; follow=1166',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x1d047f47f1e0e1c70f359429e4b7d5f9a813c653',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x1d047f47f1e0e1c70f359429e4b7d5f9a813c653',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'follow=30',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x1d10f5385b81929f5e6db43dfc4e6a941e02422c',
  '只活一次',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x1d10f5385b81929f5e6db43dfc4e6a941e02422c',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@1onlyliveonce_1; follow=1558',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x1dbca6bc329203ed46ab6b80d99287adfa309227',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x1dbca6bc329203ed46ab6b80d99287adfa309227',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=19',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x1e59145625236d3663fc63d000a31d42d3393cee',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x1e59145625236d3663fc63d000a31d42d3393cee',
  'winner',
  'smart_degen,fomo,gmgn_smart',
  'D',
  0,
  'follow=3958',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x1f138f7f2025cf7e18ceafc3cb184586ed3d6802',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x1f138f7f2025cf7e18ceafc3cb184586ed3d6802',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=1283',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x207c3ea79169b45fd01155067c21e5866517ebe1',
  'Log',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x207c3ea79169b45fd01155067c21e5866517ebe1',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@L0GURT; follow=1108',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x20b8f72383d6b0a3e31ebe2bc8569b08a9433e60',
  'Hitman 80',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x20b8f72383d6b0a3e31ebe2bc8569b08a9433e60',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@Hitman0611; follow=158',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x20e5d405062f4ce0311e83cbd54144ca5b59b520',
  'Tomartur(unemployment arc)',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x20e5d405062f4ce0311e83cbd54144ca5b59b520',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@larperinho; follow=24',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x21faf075bbd36f3eaeb651e118ac26363e3704b6',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x21faf075bbd36f3eaeb651e118ac26363e3704b6',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=478',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x24f660054776e1556f7cf4f490f93ce33a2000e4',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x24f660054776e1556f7cf4f490f93ce33a2000e4',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=66',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x2536b5a863731982230ea98f513687a922e4f286',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x2536b5a863731982230ea98f513687a922e4f286',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=93',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x2825cdb4a71ac7942da889f1ff72d536a8209343',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x2825cdb4a71ac7942da889f1ff72d536a8209343',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=231',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x2940c2d836f82a0c62a62b58f9633cf7c7846404',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x2940c2d836f82a0c62a62b58f9633cf7c7846404',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=12',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x29433d971594b68258bf52e666d063c1762f3901',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x29433d971594b68258bf52e666d063c1762f3901',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=6',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x2b73c5d32482988b92d9bf2bdda2f077af8848b5',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x2b73c5d32482988b92d9bf2bdda2f077af8848b5',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=932',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x2d1d96cd6d14b9cc03457eddf1c5e18290e65a86',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x2d1d96cd6d14b9cc03457eddf1c5e18290e65a86',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=711',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x2d67ffc279c0c0010958647110dd02b0cc013c1e',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x2d67ffc279c0c0010958647110dd02b0cc013c1e',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=63',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x2eecd3b6c890d304060feaf52d8b7a6e1f7f65d9',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x2eecd3b6c890d304060feaf52d8b7a6e1f7f65d9',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=4',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x2f4f25ca8f6354f4a65c825bbd393f2ade9ab8fd',
  'brain',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x2f4f25ca8f6354f4a65c825bbd393f2ade9ab8fd',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@crypbrain; follow=231',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x30962be6eea17d0f5023fb5f853773e2519490d5',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x30962be6eea17d0f5023fb5f853773e2519490d5',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=170',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x312b0062389c57f21e074c389a78ca7fc145e96c',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x312b0062389c57f21e074c389a78ca7fc145e96c',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=13',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x313537a983e296a4c7c9dda6d061ac0c2786ea46',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x313537a983e296a4c7c9dda6d061ac0c2786ea46',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=808',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x31acb6dc0c018950632697de37344cc33cfcd3e6',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x31acb6dc0c018950632697de37344cc33cfcd3e6',
  'winner',
  'smart_degen,fomo,gmgn_smart',
  'D',
  0,
  'follow=1148',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x32efcae45a0a4fb54afb3a9ffca1eef5ebd5e0da',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x32efcae45a0a4fb54afb3a9ffca1eef5ebd5e0da',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=69',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x3492d4e6f69d6f524524f42f00c9d5dd948f3966',
  'SuperNipple?',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x3492d4e6f69d6f524524f42f00c9d5dd948f3966',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@SuperNippleOC; follow=21',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x35fafdb17c24813c348e7d1159146b6e4a8dcb48',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x35fafdb17c24813c348e7d1159146b6e4a8dcb48',
  'winner',
  'smart_degen,fomo,gmgn_smart',
  'D',
  0,
  'follow=63',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x361720f153bba7511a486d8bb4967017a937cc49',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x361720f153bba7511a486d8bb4967017a937cc49',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=98',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x3650bb09057496682349f9b63db855d931999999',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x3650bb09057496682349f9b63db855d931999999',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=3',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x37a06ae92f05cfb3bd41a63aa208c8f384e69603',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x37a06ae92f05cfb3bd41a63aa208c8f384e69603',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=2024',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x381fb95a4fa5e83367773bd512ed088210626f10',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x381fb95a4fa5e83367773bd512ed088210626f10',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=878',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x3831fe5ec6766b15667e4515e0b1f4070204f0bd',
  'INSIDER 17',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x3831fe5ec6766b15667e4515e0b1f4070204f0bd',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'twitter=@j17k_cripto; follow=714',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x387bd4252f4fdd1919e8234c37203ce4b2aee1fe',
  '自在',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x387bd4252f4fdd1919e8234c37203ce4b2aee1fe',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@zizai3ro; follow=1458',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x38db7c10d5a96976a4fe4a15982c26fa05e122c5',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x38db7c10d5a96976a4fe4a15982c26fa05e122c5',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=347',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x3a068e7a69953189fab0e50dddbe94366f94d7c0',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x3a068e7a69953189fab0e50dddbe94366f94d7c0',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=4',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x3af87066cef4aded9eecf3a622c0c2b49963c6eb',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x3af87066cef4aded9eecf3a622c0c2b49963c6eb',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=7',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x3b25c7690296e6ad8edcbbbc9458a6bbfee81592',
  'Amy',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x3b25c7690296e6ad8edcbbbc9458a6bbfee81592',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@endbodyshaming; follow=1272',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x3b7bd3fc02e51786e437e813decfe128e468f808',
  'Jinwoo',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x3b7bd3fc02e51786e437e813decfe128e468f808',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@jinwoo_bnb; follow=185',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x3ba2d9a5cf3808b657e4656b75b089df6f37f1c2',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x3ba2d9a5cf3808b657e4656b75b089df6f37f1c2',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=1337',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x3dd47ab4f039895bd645300b264091c30dbe8014',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x3dd47ab4f039895bd645300b264091c30dbe8014',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=763',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x3f6876323d60328626e6b658e26960af83eb461a',
  '机长（不回撤版）',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x3f6876323d60328626e6b658e26960af83eb461a',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@Jizhang00; follow=1270',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x40138613d8cbed439decedfd843d3955db8fc0bb',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x40138613d8cbed439decedfd843d3955db8fc0bb',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=4',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x405ae3f86d8beca2cf9f73d72cf3beb1a94bbd3d',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x405ae3f86d8beca2cf9f73d72cf3beb1a94bbd3d',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'follow=49',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x4077802a645244c7ec69919c689d0aac1ca39352',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x4077802a645244c7ec69919c689d0aac1ca39352',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=240',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x40985581da12d55f2b4aafe65606572a0817b4f8',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x40985581da12d55f2b4aafe65606572a0817b4f8',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=32',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x417c19056b8ef9f6af6dd36928332b6337b4843f',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x417c19056b8ef9f6af6dd36928332b6337b4843f',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=1736',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x41c32a2fce017d177f9b5f7e864a78979be79642',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x41c32a2fce017d177f9b5f7e864a78979be79642',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=9',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x425edb0efdf66f6b19c01c4d944d3341c867ed13',
  'RealBabaO',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x425edb0efdf66f6b19c01c4d944d3341c867ed13',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@RealBabaO; follow=3550',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x44342998b9cd3b45ff992875b93c61c71dcabcf2',
  'sneav',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x44342998b9cd3b45ff992875b93c61c71dcabcf2',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@sneav_; follow=1071',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x444c7091c98e38187f87b025c330b5d2f27fc40d',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x444c7091c98e38187f87b025c330b5d2f27fc40d',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=882',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x44898a65b7ff0da877fb6073b4fc0b7964478781',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x44898a65b7ff0da877fb6073b4fc0b7964478781',
  'winner',
  'gmgn,smart_degen,gmgn_smart',
  'D',
  0,
  'follow=8465',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x451c05e18dd62674ef0d3cb4b084e390e747a09a',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x451c05e18dd62674ef0d3cb4b084e390e747a09a',
  'winner',
  'gmgn,smart_degen,gmgn_smart',
  'D',
  0,
  'follow=22807',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x455f36a418f4d297ba596c5aa48fb05567bd67ad',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x455f36a418f4d297ba596c5aa48fb05567bd67ad',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'follow=349',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x45e0ef868b85255c0902d79008e693d9e70d6e1f',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x45e0ef868b85255c0902d79008e693d9e70d6e1f',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=3130',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x47de5491dc3769c5cd991636f9262bf91be6a086',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x47de5491dc3769c5cd991636f9262bf91be6a086',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=108',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x4992654419b1af932a87d6fc54eab7456bd5fe35',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x4992654419b1af932a87d6fc54eab7456bd5fe35',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=873',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x4998007d47f0c971d6bfa6166acea329680e7a5c',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x4998007d47f0c971d6bfa6166acea329680e7a5c',
  'winner',
  'smart_degen,gmgn,fomo,gmgn_smart',
  'D',
  0,
  'follow=20',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x4bd8598cdca1b218f2f964f3832ebbea354383b8',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x4bd8598cdca1b218f2f964f3832ebbea354383b8',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=3108',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x4cfb4ed241113ae9cb2c37962713017cb3eb8493',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x4cfb4ed241113ae9cb2c37962713017cb3eb8493',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=31',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x51d9ddacf8fbf1ad1d220199619af077ec65e9fd',
  'Lelouch',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x51d9ddacf8fbf1ad1d220199619af077ec65e9fd',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@Leloucharc; follow=22',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x52e8de014c20981fb54d91cd14e6a76d10d72e60',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x52e8de014c20981fb54d91cd14e6a76d10d72e60',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=74',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x533477e39fbb8cc3642369ce47099685653a0882',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x533477e39fbb8cc3642369ce47099685653a0882',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=83',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x55dae249d585b7dd4ea44243c5876d0c54968aec',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x55dae249d585b7dd4ea44243c5876d0c54968aec',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=136',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x56311f46963d93eba214a95a5c55193d6bdaf4da',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x56311f46963d93eba214a95a5c55193d6bdaf4da',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'follow=603',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x56ae84cc333249ba923df4ae7b7b053ff546e4f4',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x56ae84cc333249ba923df4ae7b7b053ff546e4f4',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=666',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x57841a6640bf42d4f2aa7d87308db3c962c3945c',
  '周二下午谁没来',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x57841a6640bf42d4f2aa7d87308db3c962c3945c',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@0xbe777; follow=738',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x578afe9edf2796813e11288616f0bdd5b895390d',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x578afe9edf2796813e11288616f0bdd5b895390d',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=369',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x57c3c3e1063261950cdc847a59b2da41a280cb0a',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x57c3c3e1063261950cdc847a59b2da41a280cb0a',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=38',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x59e8ff7f1c5e917c367d445aa3cfd88cdd4cc2d3',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x59e8ff7f1c5e917c367d445aa3cfd88cdd4cc2d3',
  'winner',
  'gmgn,smart_degen,fomo,gmgn_smart',
  'D',
  0,
  'follow=35',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x5a9b67a77e86fde5b508a2037f46daec0e7f8da6',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x5a9b67a77e86fde5b508a2037f46daec0e7f8da6',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'follow=864',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x5b66fc33849a87fe3c4679367e98615be41006fd',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x5b66fc33849a87fe3c4679367e98615be41006fd',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=30',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x5cc1ed35999ca59555a96f83f9ff3c6f748e9d65',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x5cc1ed35999ca59555a96f83f9ff3c6f748e9d65',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=630',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x5d5a1c0613366e4e1040beaecd28c43daf7ca37c',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x5d5a1c0613366e4e1040beaecd28c43daf7ca37c',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=1064',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x5dee4aa23848d2be100693a1d3d1764793a5e1c0',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x5dee4aa23848d2be100693a1d3d1764793a5e1c0',
  'winner',
  'gmgn,smart_degen,gmgn_smart',
  'D',
  0,
  'follow=1',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x613541adf0dfe84786b4be980faf58f36a12d00c',
  '赌怪gou',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x613541adf0dfe84786b4be980faf58f36a12d00c',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@ggggjjj7314631; follow=200',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x6221761e82d4d6c45d0907211d9ba462933fe069',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x6221761e82d4d6c45d0907211d9ba462933fe069',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=3',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x62799008128c45a4f93440d6282193ac35bfdf1e',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x62799008128c45a4f93440d6282193ac35bfdf1e',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=86',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x640c56a4845b09c9d2ab168e7332d13557f21084',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x640c56a4845b09c9d2ab168e7332d13557f21084',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=19',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x6512306283ce0236b703d39a8e697acb20fff828',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x6512306283ce0236b703d39a8e697acb20fff828',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=539',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x66666697a039a3225391f736d2a6092f5ef0e787',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x66666697a039a3225391f736d2a6092f5ef0e787',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=91',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x66666b6f617e5e89e0eaf2859f1020db2c08aabb',
  'Lkun',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x66666b6f617e5e89e0eaf2859f1020db2c08aabb',
  'winner',
  'smart_degen,fresh_wallet,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@Lkun_web3; follow=719',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x6678adc38078614aae62d16a89eecd734fb5b792',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x6678adc38078614aae62d16a89eecd734fb5b792',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=82',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x66eb8af30805718fef8190bac5c5c66b6505c69a',
  'Mr Kenpachi 🖨️',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x66eb8af30805718fef8190bac5c5c66b6505c69a',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'twitter=@Mr_Kenpachi_; follow=41',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x671ca46a9500aeea5c97dd74f19a58284d75b212',
  'Bastyy',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x671ca46a9500aeea5c97dd74f19a58284d75b212',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'twitter=@nba_Basti; follow=723',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x67411c465c0761efbcb48f6947cdeddaabab9da5',
  '龙飞🔶BNB',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x67411c465c0761efbcb48f6947cdeddaabab9da5',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@Feisheng861976; follow=799',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x675418460d204ca099aead3727e335e853b2009a',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x675418460d204ca099aead3727e335e853b2009a',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=7',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x6add6ea109541366472c446bee41e0fc4aaa7d47',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x6add6ea109541366472c446bee41e0fc4aaa7d47',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=65',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x6bcb89a7d3a6f48cc9708007bc8835ce7f51ba88',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x6bcb89a7d3a6f48cc9708007bc8835ce7f51ba88',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=4224',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x6be4213b9c9a2e8bbaed9a59c5d8224f92272c63',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x6be4213b9c9a2e8bbaed9a59c5d8224f92272c63',
  'winner',
  'gmgn,smart_degen,gmgn_smart',
  'D',
  0,
  'follow=148',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x6d0db8c738f5762b2124a39a004721c66fde20a3',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x6d0db8c738f5762b2124a39a004721c66fde20a3',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'follow=353',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x6d3a4313d2b8c93fef5a6d4c6667a05cd754735d',
  'draco',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x6d3a4313d2b8c93fef5a6d4c6667a05cd754735d',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@smalldracos; follow=1278',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x6e11cce1743f409e78834ee3ebd219eeb8209e3b',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x6e11cce1743f409e78834ee3ebd219eeb8209e3b',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=219',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x6e83c54544084b9f6c185456cc9a92b18f981434',
  'Surpass',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x6e83c54544084b9f6c185456cc9a92b18f981434',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@surpassdd; follow=193',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x6f7ac662f07f58a5c317a2852e0cc2d6bf886213',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x6f7ac662f07f58a5c317a2852e0cc2d6bf886213',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=89',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x710eb2a0f5c2ddef08457f30267fc94333f4d75b',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x710eb2a0f5c2ddef08457f30267fc94333f4d75b',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=34',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x725c287504f613c2c9601611800eb8dc5822c86f',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x725c287504f613c2c9601611800eb8dc5822c86f',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=185',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x73d643fa826db4a146eb03fb0c10c0ee15f3f802',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x73d643fa826db4a146eb03fb0c10c0ee15f3f802',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=251',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x75ba8b3fb9d0a2651ddce16bfdcc54f39025631d',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x75ba8b3fb9d0a2651ddce16bfdcc54f39025631d',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=24',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x7649a32e792d2b59d3d616fef17700ec70e27d1a',
  'hobbes',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x7649a32e792d2b59d3d616fef17700ec70e27d1a',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@hobbesfn; follow=761',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x76f8ae2d1a4765559174bd269cd7f7f1b86c35fb',
  '才子炒币（农村人）',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x76f8ae2d1a4765559174bd269cd7f7f1b86c35fb',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@nongcundev; follow=26',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x770044f898e91b15c14012bf4dd36562d438972d',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x770044f898e91b15c14012bf4dd36562d438972d',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=77',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x77016c16d79a8fb9f83b36dc112a6b7498776e5e',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x77016c16d79a8fb9f83b36dc112a6b7498776e5e',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=267',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x7754540554090c10d70e86a1c931f3c64234fdc7',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x7754540554090c10d70e86a1c931f3c64234fdc7',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=95',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x780d292e298873e88e91dc85a0d3bc74f01d94c9',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x780d292e298873e88e91dc85a0d3bc74f01d94c9',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=384',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x78abb89ba802f0b3794298339d668b4f2c280455',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x78abb89ba802f0b3794298339d668b4f2c280455',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=112',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x7906d5e4a10fbb07f5491018ab29df072a76eb3d',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x7906d5e4a10fbb07f5491018ab29df072a76eb3d',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=992',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x79e54f9e8d73465ef17c0f0847e2ad79d1dfced4',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x79e54f9e8d73465ef17c0f0847e2ad79d1dfced4',
  'winner',
  'gmgn,smart_degen,gmgn_smart',
  'D',
  0,
  'follow=141',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x7ac08f3916eba322972e2d460231553a68847250',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x7ac08f3916eba322972e2d460231553a68847250',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=98',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x7c7469a66ee86124cf830087911fab1af58dd439',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x7c7469a66ee86124cf830087911fab1af58dd439',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=22',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x8146201acece798327c6514d22aa9282f0efca2e',
  'KYRAN',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x8146201acece798327c6514d22aa9282f0efca2e',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@KYRAN7dc; follow=298',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x81d20b2c34d37e406659a80008723b4ea815717d',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x81d20b2c34d37e406659a80008723b4ea815717d',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=1074',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x8295935703d543a6db78b9eede2f67f7d43b8622',
  'Luffy',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x8295935703d543a6db78b9eede2f67f7d43b8622',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@LuffyCallz; follow=474',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x83115470d0992fdc67ffebc6ba31d400dcf9cead',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x83115470d0992fdc67ffebc6ba31d400dcf9cead',
  'winner',
  'gmgn,smart_degen,gmgn_smart',
  'D',
  0,
  'follow=7',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x833a3a852d5edef6120496e7878049b2d29d1c57',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x833a3a852d5edef6120496e7878049b2d29d1c57',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=212',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x875d63b1508fa0f4ade08ca02e561cb60c6d840d',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x875d63b1508fa0f4ade08ca02e561cb60c6d840d',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=59',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x87c2d666d9e26ef6fea2233b5921aa3b06a686e6',
  'B B',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x87c2d666d9e26ef6fea2233b5921aa3b06a686e6',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@BlGBEARS; follow=22',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x8ade93ba431a2ce19fc62a9ce97626e69a4a333f',
  '0xLuck',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x8ade93ba431a2ce19fc62a9ce97626e69a4a333f',
  'winner',
  'kol,smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@0xLuckHK; follow=13840',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x8b4012382de14bc10743588480c8ba4890890505',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x8b4012382de14bc10743588480c8ba4890890505',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=157',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x8b53f6e9c2949f1c9087055eeb4bdf0199635d4e',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x8b53f6e9c2949f1c9087055eeb4bdf0199635d4e',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=46',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x8cb8531b4e419343cd1253285db3d6e14fc6fdf7',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x8cb8531b4e419343cd1253285db3d6e14fc6fdf7',
  'winner',
  'gmgn,smart_degen,gmgn_smart',
  'D',
  0,
  'follow=20708',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x8cf452055050d9a8a4485b4b80298e53ed8c81cf',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x8cf452055050d9a8a4485b4b80298e53ed8c81cf',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=10',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x8d59983af42cba2cedea15e7bfdb0a9ce460ca7f',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x8d59983af42cba2cedea15e7bfdb0a9ce460ca7f',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=168',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x91b1d6b6118caa28eefb115ba2b1962b874418bb',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x91b1d6b6118caa28eefb115ba2b1962b874418bb',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=718',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x91d0824439c4544a3b7bceecddb148cf909f9800',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x91d0824439c4544a3b7bceecddb148cf909f9800',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=454',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x9582e585629cdf48fa2463bc39cce51a115070ea',
  'cockper',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x9582e585629cdf48fa2463bc39cce51a115070ea',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@cockper_; follow=677',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x96c10db3d006b6e549796901faa83c67e4d54c96',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x96c10db3d006b6e549796901faa83c67e4d54c96',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=163',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x973bf6b7aaee56c82fa8694087eb654a78ea8703',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x973bf6b7aaee56c82fa8694087eb654a78ea8703',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=10',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x9746ec37d186f69d3b84e762127ac08a0fd04a2a',
  '哲平',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x9746ec37d186f69d3b84e762127ac08a0fd04a2a',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@erhu0501; follow=112',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x9902a41bcf456caebc7652f00f6e5dd47c911fa4',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x9902a41bcf456caebc7652f00f6e5dd47c911fa4',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=45536',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x9a44d4974cad27175458ee071c189c2619f417c0',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x9a44d4974cad27175458ee071c189c2619f417c0',
  'winner',
  'smart_degen,fomo,gmgn_smart',
  'D',
  0,
  'follow=550',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x9c0f221c134591f7c9d565548ea4417900302ea3',
  'LYXR',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x9c0f221c134591f7c9d565548ea4417900302ea3',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@lyxreth; follow=934',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x9d1255efc7a50b9e2fbbc18cab238733e36ce6f2',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x9d1255efc7a50b9e2fbbc18cab238733e36ce6f2',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'follow=96',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x9d1f619c211315c1311de3eec863d3040726c523',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x9d1f619c211315c1311de3eec863d3040726c523',
  'winner',
  'smart_degen,fomo,gmgn_smart',
  'D',
  0,
  'follow=4',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0x9f1483b5703f432f4c9f2eb81146bfe4fb23a06d',
  'Stormy Man',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0x9f1483b5703f432f4c9f2eb81146bfe4fb23a06d',
  'winner',
  'gmgn,smart_degen,gmgn_smart',
  'D',
  0,
  'twitter=@StormyMan_9999; follow=9766',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xa00599107ffc6ba1a5959cb9ecda5598b828cf20',
  'CanyeEast',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xa00599107ffc6ba1a5959cb9ecda5598b828cf20',
  'winner',
  'gmgn,smart_degen,gmgn_smart',
  'D',
  0,
  'twitter=@canye37301267; follow=995',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xa07c0ba78be732348a64fa264cf8026e79bab3d5',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xa07c0ba78be732348a64fa264cf8026e79bab3d5',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=1575',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xa0e7edba9e45dec08ab92008dc67e4e7e3db6112',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xa0e7edba9e45dec08ab92008dc67e4e7e3db6112',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=883',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xa5019cf0224d21d41437d3cd7648d39a5868282f',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xa5019cf0224d21d41437d3cd7648d39a5868282f',
  'winner',
  'smart_degen,gmgn,fomo,gmgn_smart',
  'D',
  0,
  'follow=2181',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xa8e5ec980778357992b66be7a5f8d804e86ddd70',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xa8e5ec980778357992b66be7a5f8d804e86ddd70',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=713',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xa98a29c75fd9acf4cfe358cd0b659d922c9b165f',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xa98a29c75fd9acf4cfe358cd0b659d922c9b165f',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'follow=573',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xa9f7d92a72428c55f093f6051c43db29f38bf34b',
  'SKX',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xa9f7d92a72428c55f093f6051c43db29f38bf34b',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@SKXonSol; follow=1340',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xaa3b0775a852986c365c2016ec192b1477af2898',
  'stan2001',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xaa3b0775a852986c365c2016ec192b1477af2898',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@stan200106; follow=813',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xab0a5a4fb1444875e8db43b0587e60addcb37bed',
  'Slaxx',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xab0a5a4fb1444875e8db43b0587e60addcb37bed',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@SlaxxTrades; follow=212',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xac2722ab173142eaf33adeb78e79cb31db0e2a96',
  'JGrerg',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xac2722ab173142eaf33adeb78e79cb31db0e2a96',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@JGrerg_; follow=101',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xac3b4dfc6d99387e76fd72d8d222452133d6a92f',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xac3b4dfc6d99387e76fd72d8d222452133d6a92f',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'follow=2248',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xacd7793d92cd870e56db2372b36e41c59ae4fb40',
  'Hyjn (hi-jin)',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xacd7793d92cd870e56db2372b36e41c59ae4fb40',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@LeBronessy; follow=2577',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xadb7d3336a81b54cc650d3edcd0af3906f3bcbe5',
  'x',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xadb7d3336a81b54cc650d3edcd0af3906f3bcbe5',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@0xadb7; follow=511',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xadbac2eaac1e1e3f1c299f38d6df9506ed266b9b',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xadbac2eaac1e1e3f1c299f38d6df9506ed266b9b',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=2',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xadbda56c37f2bb25224982d8ea37d973adfbce96',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xadbda56c37f2bb25224982d8ea37d973adfbce96',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=286',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xaf9fa9ee7cc52d7b2fe9cd3fadf1dd9e9b1d61b0',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xaf9fa9ee7cc52d7b2fe9cd3fadf1dd9e9b1d61b0',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=200',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb180b0c4822758404699c9a6890a6465808f56bc',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb180b0c4822758404699c9a6890a6465808f56bc',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=18',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb2555cc4fc09161479d47ee0bc4c40c2ad8923b8',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb2555cc4fc09161479d47ee0bc4c40c2ad8923b8',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=176',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb260d85ea68ccd981a71966aacd4e7542d3fb5bd',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb260d85ea68ccd981a71966aacd4e7542d3fb5bd',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=14',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb2977c20298e016cc34aa3b9406c81e02daa4057',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb2977c20298e016cc34aa3b9406c81e02daa4057',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=77',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb2b73e992b2d7d3612b140d5920a2a19bf2d0d10',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb2b73e992b2d7d3612b140d5920a2a19bf2d0d10',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=2776',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb323dc508eb6525667477db2a04c4bf748770379',
  'Afeng Junior',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb323dc508eb6525667477db2a04c4bf748770379',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@AfengJunior; follow=72',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb3a3b5a4ca2a4b6f5f7df682d79b4b9ae57ac956',
  'fartcoin dev',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb3a3b5a4ca2a4b6f5f7df682d79b4b9ae57ac956',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@ilostallmysoul; follow=1118',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb4e271c9fd815d7d71e385f4f0ce59813cbf7d0f',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb4e271c9fd815d7d71e385f4f0ce59813cbf7d0f',
  'winner',
  'smart_degen,launchpad_smart,gmgn,gmgn_smart',
  'D',
  0,
  'follow=44',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb61f865417a7d77e1d8b5f8c2ab4f380c33d63f6',
  'Vision',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb61f865417a7d77e1d8b5f8c2ab4f380c33d63f6',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@bettervision7; follow=837',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xb8f795eaddeb1fa5c2505b3ffe132375d76f3e9d',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xb8f795eaddeb1fa5c2505b3ffe132375d76f3e9d',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=23',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xba9768b02221c101ed22c85cad17b863aae8f746',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xba9768b02221c101ed22c85cad17b863aae8f746',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'follow=918',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xbc6dd9f9d78c85a9e18673a1df15459bd7e72afc',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xbc6dd9f9d78c85a9e18673a1df15459bd7e72afc',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=72',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xbd994acb9c906100dc4b8c08d2b6c28cb543425d',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xbd994acb9c906100dc4b8c08d2b6c28cb543425d',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=6223',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xbdb4a0994541f501fd4c9984006120da354b8ea0',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xbdb4a0994541f501fd4c9984006120da354b8ea0',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=57',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xbe053615f67b836a4fded86076faf425b4c6a8f2',
  'MattX_',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xbe053615f67b836a4fded86076faf425b4c6a8f2',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@Mat1t_x; follow=1842',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xbf530f1bfb23bf332d1f1e41be026a5895fcced4',
  'TANG（恩师D滴峰挖财奶）',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xbf530f1bfb23bf332d1f1e41be026a5895fcced4',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@i0ybz0; follow=1307',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc129ca3eff37efab9e013baeaf6bea3185d1e1c2',
  'klimq',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc129ca3eff37efab9e013baeaf6bea3185d1e1c2',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@0xKlimq; follow=709',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc2098bf40a0fa76b43199b2a347d6a7d47c7b26d',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc2098bf40a0fa76b43199b2a347d6a7d47c7b26d',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=20',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc25515fa26a3614c87e7ac944288d86efbe046bc',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc25515fa26a3614c87e7ac944288d86efbe046bc',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=204',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc5d3c566a195cf4a9b8b29dc3c7f8e133d7cf19e',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc5d3c566a195cf4a9b8b29dc3c7f8e133d7cf19e',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=303',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc6792e3b1277d37cb2108e0de9c4603c211cc7e2',
  'HK-雷氏最锋利的剑',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc6792e3b1277d37cb2108e0de9c4603c211cc7e2',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@Amool16448184; follow=837',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc6c0e93e60933bb4a8f7b929a1b98435df6a9140',
  'memeking🔶 BNB',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc6c0e93e60933bb4a8f7b929a1b98435df6a9140',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@memeeth333; follow=1667',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc77b5585ca3cd4beec6051cca89921a2f01d9a5c',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc77b5585ca3cd4beec6051cca89921a2f01d9a5c',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=386',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc84248de43b69297e56366a26c812146628aca16',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc84248de43b69297e56366a26c812146628aca16',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=1040',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc88455b47d70ebd7b28ca8d4ddbffe5cc564d532',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc88455b47d70ebd7b28ca8d4ddbffe5cc564d532',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=6',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xc8df2e717993b6b6453e55088cc03d32a9d68b21',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xc8df2e717993b6b6453e55088cc03d32a9d68b21',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=920',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xcac106eb08664326f1a8c6ffe9b56661e10a0c94',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xcac106eb08664326f1a8c6ffe9b56661e10a0c94',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=10',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xcce7222e9b9fec1ebf52d62a9da692b88090f30b',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xcce7222e9b9fec1ebf52d62a9da692b88090f30b',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=94',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xcea0f3f5c4e44312d21a25b651f09da71b08cc2e',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xcea0f3f5c4e44312d21a25b651f09da71b08cc2e',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'follow=998',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xcea597d9ebf15ccd9467f4e3ac8078af92738051',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xcea597d9ebf15ccd9467f4e3ac8078af92738051',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=302',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xcf7607ff3164df3e1e285d2d798724a929bede0d',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xcf7607ff3164df3e1e285d2d798724a929bede0d',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=8015',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xd04dd0194eb5b7246d83be5fc5d7464d5fabacb2',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xd04dd0194eb5b7246d83be5fc5d7464d5fabacb2',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=1494',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xd24e1ee24f3f6f6b2a3883e956b933b277444c5a',
  '0xBee',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xd24e1ee24f3f6f6b2a3883e956b933b277444c5a',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@PaulJohnso65256; follow=656',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xd2bf587a280a15e4fad7643551335e6dbce37320',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xd2bf587a280a15e4fad7643551335e6dbce37320',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=43',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xd2bfb809376df5575c1af78fb552fb9a0088b45b',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xd2bfb809376df5575c1af78fb552fb9a0088b45b',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=7',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xd3624bab04dfe63b4300a9f4bab43e140000c80f',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xd3624bab04dfe63b4300a9f4bab43e140000c80f',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=837',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xd3aebbbf7895b49d80e907be6282721cd1c013d9',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xd3aebbbf7895b49d80e907be6282721cd1c013d9',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=91',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xd4a7b8a45a3de248d62951bf60381983cb4d7b06',
  'Natsu',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xd4a7b8a45a3de248d62951bf60381983cb4d7b06',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@0xnatsu__; follow=1702',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xd5a868f28870a95feb743d3d6f4cb607965024b8',
  'Wagmi',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xd5a868f28870a95feb743d3d6f4cb607965024b8',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@_Reflectionist; follow=1582',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xd5afbbb5cd64865a22da2c6c308e8ea4de09d6ab',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xd5afbbb5cd64865a22da2c6c308e8ea4de09d6ab',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=651',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xd6b4047a5767aec0cb7737a75bba8202dc21e999',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xd6b4047a5767aec0cb7737a75bba8202dc21e999',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=947',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xd7b83366b001dbdb90de5108f0f291e24d475d31',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xd7b83366b001dbdb90de5108f0f291e24d475d31',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=70',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xd9b3d83893a50a694fb594d1c412bcf5bd8fac23',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xd9b3d83893a50a694fb594d1c412bcf5bd8fac23',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=5',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xda8104f3ff4feb8150e7e48adf04fe0be3290a27',
  'Salted Fish',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xda8104f3ff4feb8150e7e48adf04fe0be3290a27',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@27Pxr; follow=15',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xdc311b398f2e329f433fa45d2fddbc31fd7aa727',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xdc311b398f2e329f433fa45d2fddbc31fd7aa727',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=74',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xde93a926d8059d9d20a93b709312bf2cd8a7046c',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xde93a926d8059d9d20a93b709312bf2cd8a7046c',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=32',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xe033bc25603d27fe4314194acdaef59bc6ded712',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xe033bc25603d27fe4314194acdaef59bc6ded712',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=477',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xe3c495389413b3fc0f2f1a406da7ae3a96d8962c',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xe3c495389413b3fc0f2f1a406da7ae3a96d8962c',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=15',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xe4fd07e37f25f89f7cbf1446d614a5d2c456a914',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xe4fd07e37f25f89f7cbf1446d614a5d2c456a914',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=11',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xe682a492cb696cd1de2d0ae2abaf0320f2f66f84',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xe682a492cb696cd1de2d0ae2abaf0320f2f66f84',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=56',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xe825368f8eb87f1a79c7c4136aeafd1eead567a9',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xe825368f8eb87f1a79c7c4136aeafd1eead567a9',
  'winner',
  'gmgn,smart_degen,gmgn_smart',
  'D',
  0,
  'follow=828',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xe8f25b0e33f7e69bcef19429eadb8ff2450215c2',
  '7',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xe8f25b0e33f7e69bcef19429eadb8ff2450215c2',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@goyimpnl; follow=1472',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xe957a99f5134e7129c30ff87c173b536a38188f2',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xe957a99f5134e7129c30ff87c173b536a38188f2',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=239',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xeaedc9f3606f5dce5d7eb79b710eefd7df3ac732',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xeaedc9f3606f5dce5d7eb79b710eefd7df3ac732',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=271',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xeb399b747d64722a9ecade0a927e7d21399b3464',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xeb399b747d64722a9ecade0a927e7d21399b3464',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=5',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xec76c5e271d5d92ab2f98f2296aa0eb59de73aef',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xec76c5e271d5d92ab2f98f2296aa0eb59de73aef',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=8',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xec87a7e48c23d1ce6b5c169cec41329429d7fa71',
  'req1017',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xec87a7e48c23d1ce6b5c169cec41329429d7fa71',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@req1017; follow=453',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xedcd49a674f8abab023e46fdf9198240b78afe0d',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xedcd49a674f8abab023e46fdf9198240b78afe0d',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=150',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xedf48dd1c4f3aeaaae883dc68c64ba7ef45da920',
  'MsTradez',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xedf48dd1c4f3aeaaae883dc68c64ba7ef45da920',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@ms_tradez; follow=115',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xee8559530e585ddcc2f8a3c4656ebe747ff740f4',
  '0xBinray',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xee8559530e585ddcc2f8a3c4656ebe747ff740f4',
  'winner',
  'smart_degen,fomo,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@0xBinray; follow=997',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xf34f526f4b6a009fffbe7ff41b36ce2fe9aab98a',
  'Midnbeter',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xf34f526f4b6a009fffbe7ff41b36ce2fe9aab98a',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@midnbeter; follow=840',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xf3eacf619238f570d16243f6c6534c70fcfd0439',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xf3eacf619238f570d16243f6c6534c70fcfd0439',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=1088',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xf672ce59fafd2a173d275abc626087b1eae874a2',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xf672ce59fafd2a173d275abc626087b1eae874a2',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=1197',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xf687af47557812da4e117b5f6402e96380c004e6',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xf687af47557812da4e117b5f6402e96380c004e6',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=78',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xf767ea55ac8b0a938864557022ca3553fa0d0b6c',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xf767ea55ac8b0a938864557022ca3553fa0d0b6c',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=72',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xf8a171376339833f8b3544cca226ac3c1954c567',
  'young luk',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xf8a171376339833f8b3544cca226ac3c1954c567',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@j4drasol; follow=155',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xf9410f77573c4793c7d1a8076bc959b9896d2380',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xf9410f77573c4793c7d1a8076bc959b9896d2380',
  'winner',
  'smart_degen,gmgn_smart',
  'D',
  0,
  'follow=82',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xfb0d8b94027c5109ae89c5f08b025cc598cf6f49',
  'PaulyP',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xfb0d8b94027c5109ae89c5f08b025cc598cf6f49',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@paulypauly; follow=644',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xfd7e55a555555c2f25053a38ec744de1afea4fa4',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xfd7e55a555555c2f25053a38ec744de1afea4fa4',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=37120',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xfdaf199ae935753c70824f6c73d4877ddceea57b',
  '',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xfdaf199ae935753c70824f6c73d4877ddceea57b',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'follow=1131',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xfe8d6dd17db7a9a17c08012370b6ed2c6e6e0549',
  '北慕',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xfe8d6dd17db7a9a17c08012370b6ed2c6e6e0549',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@beimu4911; follow=440',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

INSERT INTO smart_wallets (
  address, display_name, source, source_url, primary_type, tags,
  level, score, note, status, level_locked, created_at, updated_at
) VALUES (
  '0xffd500ef2919a20ccdb9b9c3d85643f72cbbfb8a',
  'Osaky ◎',
  'gmgn',
  'https://gmgn.ai/robinhood/address/0xffd500ef2919a20ccdb9b9c3d85643f72cbbfb8a',
  'winner',
  'smart_degen,gmgn,gmgn_smart',
  'D',
  0,
  'twitter=@Osakye; follow=94',
  'active',
  0,
  '2026-09-03T02:26:21Z',
  '2026-09-03T02:26:21Z'
)
ON CONFLICT(address) DO UPDATE SET
  display_name = excluded.display_name,
  source = excluded.source,
  source_url = excluded.source_url,
  primary_type = excluded.primary_type,
  tags = excluded.tags,
  note = excluded.note,
  status = excluded.status,
  updated_at = excluded.updated_at;

COMMIT;

