-- ====================================================================
-- FRINKELs Migration 01 — Extensions
-- Timestamp: 20260804000000
-- Description: Enable required PostgreSQL extensions idempotently.
-- Pre-conditions: (none — runs on empty database)
-- Idempotency: CREATE EXTENSION IF NOT EXISTS
-- ====================================================================

-- uuid-ossp: optional, used by some generators; pgcrypto covers gen_random_uuid
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- pgcrypto: provides gen_random_uuid() used as default for UUID PK columns
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ====================================================================
-- END Migration 01
-- ====================================================================
