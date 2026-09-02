-- v0 初始结构：自然键、NOCASE 地址、无自增代理键、无原始 JSON。
CREATE TABLE smart_wallets (
  address TEXT PRIMARY KEY COLLATE NOCASE,
  display_name TEXT NOT NULL DEFAULT '', source TEXT NOT NULL DEFAULT 'manual',
  source_url TEXT, primary_type TEXT NOT NULL DEFAULT 'unknown',
  tags TEXT NOT NULL DEFAULT '', level TEXT NOT NULL DEFAULT 'D',
  score REAL NOT NULL DEFAULT 0 CHECK(score BETWEEN 0 AND 100),
  score_win_rate REAL, score_profit_usd REAL, score_sample_n INTEGER NOT NULL DEFAULT 0,
  note TEXT NOT NULL DEFAULT '', status TEXT NOT NULL DEFAULT 'active',
  level_locked INTEGER NOT NULL DEFAULT 0 CHECK(level_locked IN (0,1)),
  created_at TEXT NOT NULL, updated_at TEXT NOT NULL, last_seen_at TEXT,
  CHECK(primary_type IN ('launcher','winner','sniper','follower','kol','unknown')),
  CHECK(status IN ('active','paused','blacklisted')),
  CHECK(level IN ('S','A','B','C','D'))
);

CREATE TABLE wallet_events (
  id TEXT PRIMARY KEY,
  block_number INTEGER NOT NULL, tx_index INTEGER NOT NULL, log_index INTEGER NOT NULL,
  tx_hash TEXT NOT NULL COLLATE NOCASE, chain_time TEXT NOT NULL, ingested_at TEXT NOT NULL,
  wallet_address TEXT NOT NULL COLLATE NOCASE,
  kind TEXT NOT NULL CHECK(kind IN ('launch','buy','sell')),
  category TEXT NOT NULL CHECK(category IN ('pons','o1_stock','o1_crypto','long')),
  token_address TEXT NOT NULL COLLATE NOCASE,
  direction TEXT NOT NULL CHECK(direction IN ('launch','buy','sell')),
  quote_address TEXT COLLATE NOCASE, quote_symbol TEXT,
  quote_amount_raw TEXT NOT NULL DEFAULT '0', quote_decimals INTEGER,
  token_amount_raw TEXT NOT NULL DEFAULT '0', token_decimals INTEGER,
  exec_quote_per_token TEXT, exec_usd_per_token REAL, quote_usd REAL,
  router TEXT NOT NULL DEFAULT 'unknown',
  CHECK(router IN ('curve','universal_router','gmgn','launch_and_buy','relay','unknown'))
);
CREATE INDEX idx_wallet_events_wallet_time ON wallet_events(wallet_address, chain_time);
CREATE INDEX idx_wallet_events_token_time ON wallet_events(token_address, chain_time);
CREATE INDEX idx_wallet_events_kind_time ON wallet_events(kind, chain_time);
CREATE INDEX idx_wallet_events_chain_time ON wallet_events(chain_time);

CREATE TABLE launch_index (
  token_address TEXT PRIMARY KEY COLLATE NOCASE,
  category TEXT NOT NULL CHECK(category IN ('pons','o1_stock','o1_crypto','long')),
  symbol TEXT NOT NULL DEFAULT '', name TEXT NOT NULL DEFAULT '',
  pair_symbol TEXT NOT NULL DEFAULT 'UNKNOWN', pair_address TEXT COLLATE NOCASE,
  creator_eoa TEXT NOT NULL COLLATE NOCASE, creator_contract TEXT COLLATE NOCASE,
  created_at TEXT NOT NULL, block_number INTEGER NOT NULL, tx_hash TEXT NOT NULL COLLATE NOCASE,
  status TEXT NOT NULL DEFAULT 'active' CHECK(status IN ('active','graduated','ignored')),
  price_usd REAL, price_block INTEGER, price_tx TEXT COLLATE NOCASE, price_at TEXT
);
CREATE INDEX idx_launch_index_created ON launch_index(created_at DESC, token_address DESC);
CREATE INDEX idx_launch_index_category_created ON launch_index(category, created_at DESC);

CREATE TABLE launch_pons (
  token_address TEXT PRIMARY KEY COLLATE NOCASE,
  symbol TEXT NOT NULL DEFAULT '', name TEXT NOT NULL DEFAULT '', logo TEXT NOT NULL DEFAULT '', description TEXT NOT NULL DEFAULT '',
  curve_address TEXT NOT NULL COLLATE NOCASE, pair_address TEXT NOT NULL COLLATE NOCASE,
  pair_symbol TEXT NOT NULL, pair_decimals INTEGER NOT NULL,
  launch_config_id TEXT NOT NULL, graduation_threshold TEXT NOT NULL,
  deployer TEXT NOT NULL COLLATE NOCASE, creator_eoa TEXT NOT NULL COLLATE NOCASE,
  creator_fee_recipient TEXT COLLATE NOCASE, launch_entry TEXT NOT NULL,
  first_buy_quote TEXT NOT NULL DEFAULT '0', first_buy_tokens TEXT NOT NULL DEFAULT '0',
  phase TEXT NOT NULL, graduated_at TEXT, pool_id TEXT COLLATE NOCASE,
  block_number INTEGER NOT NULL, tx_hash TEXT NOT NULL COLLATE NOCASE, log_index INTEGER NOT NULL, created_at TEXT NOT NULL,
  UNIQUE(tx_hash, log_index), CHECK(launch_entry IN ('factory','launch_and_buy')),
  CHECK(phase IN ('curve','graduated','failed')),
  FOREIGN KEY(token_address) REFERENCES launch_index(token_address)
);

CREATE TABLE launch_o1_stock (
  token_address TEXT PRIMARY KEY COLLATE NOCASE,
  symbol TEXT NOT NULL DEFAULT '', name TEXT NOT NULL DEFAULT '', contract_uri TEXT NOT NULL DEFAULT '',
  quote_address TEXT NOT NULL COLLATE NOCASE, quote_symbol TEXT NOT NULL, quote_decimals INTEGER NOT NULL,
  pool_id TEXT NOT NULL COLLATE NOCASE, tick_spacing INTEGER NOT NULL, hooks TEXT NOT NULL COLLATE NOCASE,
  supply TEXT NOT NULL, creator_eoa TEXT NOT NULL COLLATE NOCASE, creator_event TEXT NOT NULL COLLATE NOCASE,
  native_launch_fee_wei TEXT NOT NULL DEFAULT '0', anomaly INTEGER NOT NULL DEFAULT 0 CHECK(anomaly IN (0,1)),
  block_number INTEGER NOT NULL, tx_hash TEXT NOT NULL COLLATE NOCASE, log_index INTEGER NOT NULL, created_at TEXT NOT NULL,
  UNIQUE(tx_hash, log_index), FOREIGN KEY(token_address) REFERENCES launch_index(token_address)
);

CREATE TABLE launch_o1_crypto (
  token_address TEXT PRIMARY KEY COLLATE NOCASE,
  symbol TEXT NOT NULL DEFAULT '', name TEXT NOT NULL DEFAULT '', contract_uri TEXT NOT NULL DEFAULT '',
  quote_address TEXT NOT NULL COLLATE NOCASE, quote_symbol TEXT NOT NULL, quote_decimals INTEGER NOT NULL,
  pool_id TEXT NOT NULL COLLATE NOCASE, tick_spacing INTEGER NOT NULL, hooks TEXT NOT NULL COLLATE NOCASE,
  supply TEXT NOT NULL, creator_eoa TEXT NOT NULL COLLATE NOCASE, creator_event TEXT NOT NULL COLLATE NOCASE,
  native_launch_fee_wei TEXT NOT NULL DEFAULT '0',
  block_number INTEGER NOT NULL, tx_hash TEXT NOT NULL COLLATE NOCASE, log_index INTEGER NOT NULL, created_at TEXT NOT NULL,
  UNIQUE(tx_hash, log_index), FOREIGN KEY(token_address) REFERENCES launch_index(token_address)
);

CREATE TABLE launch_long (
  token_address TEXT PRIMARY KEY COLLATE NOCASE,
  symbol TEXT NOT NULL DEFAULT '', name TEXT NOT NULL DEFAULT '',
  quote_address TEXT NOT NULL COLLATE NOCASE, quote_symbol TEXT NOT NULL, quote_decimals INTEGER NOT NULL,
  pool_id TEXT NOT NULL COLLATE NOCASE, fee INTEGER NOT NULL, tick_spacing INTEGER NOT NULL, hooks TEXT NOT NULL COLLATE NOCASE,
  ticker_key TEXT NOT NULL, deployed_at TEXT, reserved_until TEXT, pool_initializer TEXT NOT NULL COLLATE NOCASE,
  launcher TEXT NOT NULL COLLATE NOCASE, creator_eoa TEXT NOT NULL COLLATE NOCASE,
  integrator TEXT COLLATE NOCASE, airlock TEXT NOT NULL COLLATE NOCASE,
  initial_supply TEXT, num_tokens_to_sell TEXT,
  block_number INTEGER NOT NULL, tx_hash TEXT NOT NULL COLLATE NOCASE, log_index INTEGER NOT NULL, created_at TEXT NOT NULL,
  UNIQUE(tx_hash, log_index), FOREIGN KEY(token_address) REFERENCES launch_index(token_address)
);

CREATE TABLE quote_assets (
  address TEXT PRIMARY KEY COLLATE NOCASE,
  symbol TEXT NOT NULL, decimals INTEGER NOT NULL, kind TEXT NOT NULL CHECK(kind IN ('eth','usdg','stock'))
);

CREATE TABLE sync_state (
  name TEXT PRIMARY KEY, last_block INTEGER NOT NULL, last_hash TEXT COLLATE NOCASE, updated_at TEXT NOT NULL
);

INSERT INTO quote_assets(address,symbol,decimals,kind) VALUES
('0x0000000000000000000000000000000000000000','ETH',18,'eth'),
('0x0bd7d308f8e1639fab988df18a8011f41eacad73','WETH',18,'eth'),
('0x5fc5360d0400a0fd4f2af552add042d716f1d168','USDG',6,'usdg');
