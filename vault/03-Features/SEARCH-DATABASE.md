# FRINKELs Search Database Schema & Indexing Guide (`SEARCH_DATABASE.md`)

This document defines the database tables, indexing strategies, extensions, and stored procedures required to power the FRINKELs Search Subsystem.

---

## ⚙️ PostgreSQL Extensions Required

```sql
CREATE EXTENSION IF NOT EXISTS "pg_trgm";   -- Trigram fuzzy matching & autocomplete
CREATE EXTENSION IF NOT EXISTS "vector";    -- Vector embeddings for semantic search
CREATE EXTENSION IF NOT EXISTS "unaccent";  -- Accent-insensitive text search
```

---

## 🗄️ Search Database Tables & Schemas

### 1. `search_trending`
Stores popular search queries aggregated across all users.

| Column | Type | Constraints | Default | Description |
|---|---|---|---|---|
| `id` | `UUID` | `PRIMARY KEY` | `gen_random_uuid()` | Record ID |
| `query` | `TEXT` | `NOT NULL`, `UNIQUE` | - | Normalized query string |
| `category` | `TEXT` | - | - | Optional category filter |
| `search_count` | `INTEGER` | - | `1` | Total execution count |
| `updated_at` | `TIMESTAMPTZ` | - | `NOW()` | Last search time |

### 2. `user_searches`
Tracks private search history per user.

| Column | Type | Constraints | Default | Description |
|---|---|---|---|---|
| `id` | `UUID` | `PRIMARY KEY` | `gen_random_uuid()` | Record ID |
| `user_id` | `UUID` | `REFERENCES profiles(id) ON DELETE CASCADE` | - | Owner user |
| `query` | `TEXT` | `NOT NULL` | - | Search query text |
| `created_at` | `TIMESTAMPTZ` | - | `NOW()` | Timestamp |

### 3. Entity Vector Embeddings Table (`entity_embeddings`)
Holds vector embeddings for cross-entity semantic search.

| Column | Type | Constraints | Default | Description |
|---|---|---|---|---|
| `id` | `UUID` | `PRIMARY KEY` | `gen_random_uuid()` | Embedding ID |
| `entity_type` | `TEXT` | `CHECK (entity_type IN ('profile', 'post', 'job', 'business', 'community'))` | - | Entity classification |
| `entity_id` | `UUID` | `NOT NULL` | - | FK to original entity table |
| `embedding` | `vector(768)` | - | - | 768-dimensional Gemini embedding |
| `updated_at` | `TIMESTAMPTZ` | - | `NOW()` | Vector creation timestamp |

---

## ⚡ Indexing Strategy

```sql
-- GIN Trigram Indexes for Autocomplete & Substring Search
CREATE INDEX IF NOT EXISTS idx_profiles_name_trgm ON profiles USING gin (full_name gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_profiles_profession_trgm ON profiles USING gin (profession gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_posts_content_trgm ON posts USING gin (content gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_jobs_title_trgm ON jobs USING gin (title gin_trgm_ops);

-- Full Text Search GIN Indexes
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS fts_vector tsvector
  GENERATED ALWAYS AS (to_tsvector('english', coalesce(full_name, '') || ' ' || coalesce(profession, '') || ' ' || coalesce(bio, ''))) STORED;
CREATE INDEX IF NOT EXISTS idx_profiles_fts ON profiles USING gin(fts_vector);

-- HNSW Vector Index for Fast Nearest Neighbor Vector Search
CREATE INDEX IF NOT EXISTS idx_entity_embeddings_hnsw ON entity_embeddings USING hnsw (embedding vector_cosine_ops);
```

---

## 🔄 Universal Hybrid Search Stored Procedure (RPC)

```sql
CREATE OR REPLACE FUNCTION public.global_search(
    search_query TEXT,
    filter_category TEXT DEFAULT NULL,
    result_limit INTEGER DEFAULT 20
)
RETURNS TABLE (
    entity_type TEXT,
    entity_id UUID,
    title TEXT,
    subtitle TEXT,
    avatar_url TEXT,
    relevance_score FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    -- Search Profiles
    SELECT
        'profile'::TEXT AS entity_type,
        p.id AS entity_id,
        p.full_name AS title,
        p.profession AS subtitle,
        p.avatar_url AS avatar_url,
        ts_rank(p.fts_vector, websearch_to_tsquery('english', search_query))::FLOAT AS relevance_score
    FROM profiles p
    WHERE p.fts_vector @@ websearch_to_tsquery('english', search_query)
       OR p.full_name ILIKE '%' || search_query || '%'

    UNION ALL

    -- Search Jobs
    SELECT
        'job'::TEXT AS entity_type,
        j.id AS entity_id,
        j.title AS title,
        j.company_name AS subtitle,
        j.company_logo_url AS avatar_url,
        similarity(j.title, search_query)::FLOAT AS relevance_score
    FROM jobs j
    WHERE j.title ILIKE '%' || search_query || '%'
       OR j.company_name ILIKE '%' || search_query || '%'

    ORDER BY relevance_score DESC
    LIMIT result_limit;
END;
$$;
```
