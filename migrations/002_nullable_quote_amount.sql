-- 原生 ETH trace 不可用时保留 meme 数量，并以 NULL 明确表示 quote 净额未知。
ALTER TABLE wallet_events RENAME TO wallet_events_before_nullable_quote;

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
  quote_amount_raw TEXT, quote_decimals INTEGER,
  token_amount_raw TEXT NOT NULL DEFAULT '0', token_decimals INTEGER,
  exec_quote_per_token TEXT, exec_usd_per_token REAL, quote_usd REAL,
  router TEXT NOT NULL DEFAULT 'unknown',
  CHECK(router IN ('curve','universal_router','gmgn','launch_and_buy','relay','unknown'))
);

INSERT INTO wallet_events
SELECT * FROM wallet_events_before_nullable_quote;

DROP TABLE wallet_events_before_nullable_quote;

CREATE INDEX idx_wallet_events_wallet_time ON wallet_events(wallet_address, chain_time);
CREATE INDEX idx_wallet_events_token_time ON wallet_events(token_address, chain_time);
CREATE INDEX idx_wallet_events_kind_time ON wallet_events(kind, chain_time);
CREATE INDEX idx_wallet_events_chain_time ON wallet_events(chain_time);
