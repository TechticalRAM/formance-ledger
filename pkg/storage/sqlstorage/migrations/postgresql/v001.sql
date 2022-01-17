--statement
CREATE SCHEMA IF NOT EXISTS "VAR_LEDGER_NAME";
--statement
CREATE TABLE IF NOT EXISTS "VAR_LEDGER_NAME".transactions (
  "id"        bigint,
  "timestamp" varchar,
  "reference" varchar,
  "hash"      varchar,

  UNIQUE("id"),
  UNIQUE("reference")
);
--statement
CREATE TABLE IF NOT EXISTS "VAR_LEDGER_NAME".postings (
  "id"          smallint,
  "txid"        bigint,
  "source"      varchar,
  "destination" varchar,
  "amount"      bigint,
  "asset"       varchar,

  UNIQUE("id", "txid")
);
--statement
CREATE INDEX IF NOT EXISTS p_c0 ON "VAR_LEDGER_NAME".postings (
  "txid" DESC,
  "source",
  "destination"
);
--statement
CREATE TABLE IF NOT EXISTS "VAR_LEDGER_NAME".metadata (
  "meta_id"          bigint,
  "meta_target_type" varchar NOT NULL CHECK (meta_target_type <> ''),
  "meta_target_id"   varchar NOT NULL CHECK (meta_target_id <> ''),
  "meta_key"         varchar NOT NULL CHECK (meta_key <> ''),
  "meta_value"       varchar,
  "timestamp"        varchar NOT NULL CHECK (timestamp <> ''),

  UNIQUE("meta_id")
);
--statement
CREATE TABLE IF NOT EXISTS "VAR_LEDGER_NAME".contract (
    "contract_id" integer,
    "contract_account" varchar,
    "contract_expr" varchar,

    UNIQUE("contract_id")
)
--statement
CREATE INDEX IF NOT EXISTS m_i0 ON "VAR_LEDGER_NAME".metadata (
  "meta_target_type",
  "meta_target_id"
);
--statement
CREATE OR REPLACE VIEW "VAR_LEDGER_NAME".addresses AS SELECT "address" FROM (
  SELECT source as address FROM "VAR_LEDGER_NAME".postings GROUP BY source
  UNION
  SELECT destination as address FROM "VAR_LEDGER_NAME".postings GROUP BY destination
) addr_agg GROUP BY "address";
