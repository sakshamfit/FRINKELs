# FRINKELs Search System Architecture Specification (`SEARCH_ARCHITECTURE.md`)
**Architected by**: Search & Retrieval Engineering Group  
**Target Application**: FRINKELs Hyperlocal Discovery Engine

---

## 🔍 System Architecture Overview

The FRINKELs Search Subsystem is built as a multi-modal, hybrid search architecture combining:
1. **Full-Text Search (FTS)**: Lexical search using PostgreSQL `tsvector`, `tsquery`, and GIN indexing for fast keyword matches.
2. **Fuzzy Trigram Matching**: Typo-tolerant substring searching powered by `pg_trgm`.
3. **Vector Semantic Search**: High-dimensional vector similarity using `pgvector` and `text-embedding-004` to match context and intent.
4. **Geospatial Proximity Filtering**: PostGIS / Haversine spatial radius constraints.
5. **Reciprocal Rank Fusion (RRF)**: Merges keyword, vector, and spatial relevance scores into a unified ranking score.

---

## 🛠️ Search Pipeline Data Flow

```
[User Query Input / Voice Speech-to-Text]
                │
                ▼
      [Query Pre-Processor]
  (Tokenization, Stopwords, Spelling)
                │
    ┌───────────┴───────────┐
    ▼                       ▼
[Lexical Engine]    [Semantic Vector Engine]
(FTS tsvector)      (Embedding 768-dim)
    │                       │
    └───────────┬───────────┘
                ▼
  [Reciprocal Rank Fusion (RRF)]
                │
                ▼
  [Geospatial & Category Filters]
                │
                ▼
    [Paginated Output JSON]
```

---

## 🎙️ Special Features Architecture

### 1. Voice Search Subsystem
- Client converts microphone audio using native device Speech Recognizer (or WebSpeech API).
- Alternative server-side fallback passes audio binary to OpenAI Whisper / Google Speech-to-Text Edge API.
- Converts transcript directly into search stream.

### 2. Autocomplete & Instant Suggestions
- Low-latency (<15ms) autocomplete engine using PostgreSQL `pg_trgm` prefix indexes over `profiles(username, profession)` and `categories(name)`.

### 3. Trending & Analytics
- Every executed search increments query counter in `search_trending` table via background asynchronous Edge Function trigger.
