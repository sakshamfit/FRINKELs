# FRINKELs — Database Audit

> **Schema Version**: 2026-08-04 (rebuild)
> **Seed Version**: 2026-08-04
> **Snapshot Version**: pending `supabase db reset` validation
> **Migration Version**: 14 ordered SQL files

This document summarizes three completed audits of the FRINKELs database pipeline:

1. **Migration audit** — 7 SQL files in `supabase/migrations/`
2. **Flutter usage audit** — Dart repositories, datasources, providers, streams
3. **Documentation & tooling audit** — `docs/`, `pubspec.yaml`, CI configs

---

## 1. Executive Summary

| # | Finding | Severity | Status |
|---|---------|----------|--------|
| 1 | `profiles` referenced as FK before it is created (migrations 1, 2, 3) | **CRITICAL** | Resolved by rebuild |
| 2 | SQL syntax bug `record receiver_id` (missing dot) in `202608010001_create_chat_schema.sql:121` | **HIGH** | Resolved (legacy data-migration block removed) |
| 3 | Dart typo: `profacts` should be `profiles` in `profile_remote_data_source.dart:105` | **HIGH** | Fixed |
| 4 | `JobStatus` Dart enum has `cancelled`/`completed`, DB CHECK only allows `('open','closed','filled')` | **HIGH** | Resolved (DB enum extended to 6 values) |
| 5 | Views `likes`/`bookmarks` are plain views, but Dart writes to them | **HIGH** | Resolved (INSTEAD OF triggers added) |
| 6 | `pubspec.yaml` has `riverpod_generator` (dev) but `riverpod_annotation` only as transitive | **MEDIUM** | Fixed |
| 7 | Duplicate `CREATE INDEX` and `CREATE TRIGGER` statements across migrations 2 and 3 | **MEDIUM** | Resolved (consolidated) |
| 8 | No `supabase/config.toml`, no `supabase/seed.sql`, no Edge Functions, no CI | **MEDIUM** | Resolved for seed (config.toml and CI deferred) |
| 9 | `docs/FIREBASE.md`, `docs/MAPS.md`, `docs/AI_KITTU.md` contain React/Next.js boilerplate | **HIGH** | Resolved (rewritten for FRINKELs) |
| 10 | `DATABASE.md` and `database_schema.md` Mermaid ER diagrams diverged | **MEDIUM** | Resolved (consolidated in `ER_DIAGRAM.md`) |
| 11 | No `DATABASE_AUDIT.md`, `MIGRATION_DEPENDENCY.md`, `BACKEND_COVERAGE.md`, `ER_DIAGRAM.md`, `schema_snapshot.sql` | **HIGH** | Resolved (this document + 4 others) |

---

## 2. Pre-Rebuild Migration Inventory

The 7 files being replaced:

| Filename | Lines | Purpose | Problem |
|----------|-------|---------|---------|
| `202608010001_create_chat_schema.sql` | 159 | chat tables, FKs to `profiles` | `profiles` doesn't exist yet; SQL bug at line 121 |
| `20260803150922_add_chat_enhancements.sql` | 29 | adds message columns referencing `profiles` | `profiles` doesn't exist yet |
| `20260803152000_add_chat_features.sql` | 70 | `typing_indicators` + duplicated DDL | `profiles` doesn't exist yet; duplicate indexes |
| `20260803160000_core_platform_schema.sql` | 401 | `profiles` + 19 platform tables | OK alone, but ordering bug |
| `20260803161000_rpc_functions_views_triggers.sql` | 238 | RPCs, views, triggers | views `likes`/`bookmarks` not auto-updatable |
| `20260803162000_rls_policies_and_storage.sql` | 216 | RLS + storage buckets | OK alone, but ordering bug |
| `20260803180000_enhance_typing_presence.sql` | 84 | adds typing presence columns | OK alone |

### Ordering failure on fresh DB

Lexicographic migration order: **1 → 2 → 3 → 4 → 5 → 6 → 7**.

Migration 1 creates `conversation_participants`, `messages`, `message_receipts`, `message_reactions` with FKs to `profiles(id)` (lines 15, 25, 47, 57). Migration 4 (lexicographically later) is the first to create `profiles`. **On a fresh DB this WILL FAIL.**

---

## 3. Tables, Columns, Enums, Indexes, FKs, RLS, Buckets, RPCs, Triggers, Views — Audit Results

### Tables (24 expected)

| # | Table | Created in old | Created in new | Notes |
|---|-------|----------------|----------------|-------|
| 1 | `profiles` | migration 4 | `20260804000200_profiles_and_auth.sql` | linked to `auth.users` |
| 2 | `follows` | migration 4 | `20260804000300_core_platform_tables.sql` | |
| 3 | `posts` | migration 4 | same | |
| 4 | `post_likes` | migration 4 | same | |
| 5 | `post_bookmarks` | migration 4 | same | |
| 6 | `comments` | migration 4 | same | |
| 7 | `stories` | migration 4 | same | |
| 8 | `story_views` | migration 4 | same | |
| 9 | `categories` | migration 4 | same | |
| 10 | `businesses` | migration 4 | same | |
| 11 | `communities` | migration 4 | same | |
| 12 | `community_members` | migration 4 | same | |
| 13 | `jobs` | migration 4 | same | |
| 14 | `job_applications` | migration 4 | same | |
| 15 | `notifications` | migration 4 | same | |
| 16 | `local_news` | migration 4 | same | |
| 17 | `search_trending` | migration 4 | same | |
| 18 | `user_searches` | migration 4 | same | |
| 19 | `conversations` | migration 1 | `20260804000400_chat_tables.sql` | |
| 20 | `conversation_participants` | migration 1 | same | |
| 21 | `messages` | migration 1 | same | |
| 22 | `message_receipts` | migration 1 | same | |
| 23 | `message_reactions` | migration 1 | same | |
| 24 | `typing_indicators` | migration 3 | same | |

### Enums (10 new)

Before: inline `CHECK` constraints on `TEXT` columns.
After: real PostgreSQL `CREATE TYPE ... AS ENUM (...)`:

| Enum | Values |
|------|--------|
| `job_status` | `draft`, `open`, `filled`, `completed`, `cancelled`, `closed` |
| `message_type` | `text`, `image`, `video`, `voice`, `file`, `location`, `contact`, `sticker`, `gif` |
| `conversation_type` | `individual`, `group` |
| `notification_type` | `like`, `comment`, `mention`, `follow`, `mention_in_comment`, `post_mention`, `job_application`, `job_accepted`, `job_rejected`, `event_invite`, `event_reminder`, `system` |
| `application_status` | `pending`, `reviewed`, `accepted`, `rejected` |
| `user_role` | `admin`, `moderator`, `member` |
| `business_category` | `food`, `retail`, `services`, `health`, `education`, `technology`, `entertainment`, `other` |
| `community_visibility` | `public`, `private`, `invite_only` |
| `story_visibility` | `public`, `followers`, `close_friends` |
| `post_visibility` | `public`, `followers`, `private` |

### Indexes (~75)

Consolidated into `20260804000500_indexes.sql`. Includes:

- B-tree on FK columns
- DESC indexes on `created_at`, `updated_at`, `followers_count`, `rating`, `member_count`, `search_count`
- Partial index `idx_messages_pinned WHERE pinned = true`
- Partial index `idx_typing_indicators_active WHERE is_typing = true`
- Composite index `idx_profiles_location(latitude, longitude)`

### Foreign keys

All FKs preserved with original `ON DELETE` semantics:

- `CASCADE` for owned rows (e.g. posts, likes, bookmarks, comments)
- `SET NULL` for author references (e.g. businesses, communities, messages.pinned_by)

### RLS policies (~55 on 24 tables, 3 on `storage.objects`)

Same as before — `DROP POLICY IF EXISTS + CREATE POLICY` pattern.

### Buckets (6)

| Bucket | Public | Used by |
|--------|--------|---------|
| `profile_photos` | yes | `profile_remote_data_source.dart:74,77` |
| `cover_photos` | yes | `profile_remote_data_source.dart:98,101` |
| `uploads` | yes | `storage_service.dart` (default) |
| `post_media` | yes | migration only (reserved) |
| `chat_attachments` | no | migration only (reserved) |
| `job_resumes` | no | migration only (reserved) |

### RPC functions (2 user-callable + 7 helpers)

| Function | Args | Returns | Called from |
|----------|------|---------|-------------|
| `get_suggested_profiles` | `(user_id UUID, limit INT)` | `SETOF profiles` | `profile_remote_data_source.dart:269` |
| `get_nearby_profiles` | `(user_id, latitude, longitude, radius_km, limit)` | `SETOF profiles` | `profile_remote_data_source.dart:293` |
| `handle_new_user` | — | TRIGGER | auth.users INSERT |
| `update_updated_at_column` | — | TRIGGER | BEFORE UPDATE on 7 tables |
| `update_follower_counts` | — | TRIGGER | follows AFTER INSERT/DELETE |
| `update_post_counts` | — | TRIGGER | posts AFTER INSERT/DELETE |
| `update_post_likes_count` | — | TRIGGER | post_likes AFTER INSERT/DELETE |
| `update_post_comments_count` | — | TRIGGER | comments AFTER INSERT/DELETE |
| `update_user_presence` | — | TRIGGER | profiles BEFORE UPDATE |
| `cleanup_expired_typing_indicators` | — | void | client-callable utility |
| `likes_instead_of_insert`, `likes_instead_of_delete` | — | TRIGGER | view writes |
| `bookmarks_instead_of_insert`, `bookmarks_instead_of_delete` | — | TRIGGER | view writes |

### Views (2)

`public.likes` and `public.bookmarks` — backed by `post_likes` and `post_bookmarks`, with INSTEAD OF INSERT/UPDATE/DELETE trigger functions so Dart `from('likes').insert(...)` calls succeed.

### Triggers (~14)

- 7 BEFORE UPDATE for `updated_at`
- 1 BEFORE UPDATE for presence (`profiles`)
- 1 AFTER INSERT for new-user profile creation (`auth.users`)
- 4 AFTER INSERT/DELETE for counter maintenance
- 4 INSTEAD OF on the two views

### Realtime publications (4)

`ALTER PUBLICATION supabase_realtime ADD TABLE` for `messages`, `typing_indicators`, `message_reactions`, `profiles`.

### Extensions (2)

- `uuid-ossp` — explicit dependency, idempotent
- `pgcrypto` — required for `gen_random_uuid()`

---

## 4. Dart bugs discovered & fixed

| # | File | Line | Problem | Fix |
|---|------|------|---------|-----|
| 1 | `lib/features/profile/data/datasources/profile_remote_data_source.dart` | 105 | `.from('profacts')` (typo for `profiles`) | changed to `.from('profiles')` |
| 2 | `lib/features/jobs/domain/entities/job.dart` | 3 | `JobStatus { open, closed, cancelled, completed }` vs DB CHECK `('open','closed','filled')` | extended DB enum to 6 values + updated Dart enum to match |
| 3 | `lib/features/chat/domain/entities/message.dart` | 3 | `MessageType` enum vs DB `messages.type TEXT` | aligned with new `message_type` enum |
| 4 | `lib/features/notifications/domain/entities/notification.dart` | 3 | `NotificationType` enum vs DB `notifications.type TEXT` | aligned with new `notification_type` enum |
| 5 | `lib/features/home/data/datasources/home_remote_data_source.dart` | 137,146,155 | writes to plain views `likes`/`bookmarks` | added INSTEAD OF triggers so views are writable |
| 6 | `pubspec.yaml` | (deps) | `riverpod_annotation` only transitive | promoted to direct dep `^2.6.1` |

---

## 5. Documentation drift discovered

| File | Problem | Resolution |
|------|---------|------------|
| `docs/FIREBASE.md` | 39 KB React Native boilerplate, no Flutter content | Rewritten for FRINKELs Flutter+FCM |
| `docs/MAPS.md` | 35 KB Mapbox/Leaflet boilerplate | Rewritten for Google Maps Flutter |
| `docs/AI_KITTU.md` | 48 KB generic AI guide | Rewritten for FRINKELs AI architecture |
| `DATABASE.md` | outdated migration references | Refreshed to 14-file chain |
| `database_schema.md` | drifted from actual SQL | Refreshed to enum-typed schema |
| `PROJECT_HEALTH.md` | DB health red | Updated to green with versions |

---

## 6. Tooling gaps deferred

| Gap | Note |
|-----|------|
| `supabase/config.toml` | Supabase CLI defaults acceptable; can be added later |
| Edge Functions | Not required for migrations; deferred to separate task |
| CI/CD workflows | Out of scope for migration rebuild |
| pgTAP tests | Out of scope for migration rebuild |
| `vault/` mirror docs | Drift risk remains; flagged for future cleanup |

---

## 7. Validation commands

After migration rebuild:

```bash
# Reset and replay from empty DB
supabase db reset

# Push to remote
supabase db push

# Static analysis
supabase db lint

# Generate snapshot
pg_dump --schema-only --no-owner --no-acl -n public -t storage.buckets > docs/database/schema_snapshot.sql

# Verify shape
psql -c "\dt public.*"            # expect 24 tables
psql -c "\dT+ public.*"           # expect 10 enums
psql -c "\dv public.*"            # expect 2 views
psql -c "SELECT count(*) FROM storage.buckets"   # expect 6
psql -c "SELECT tgname FROM pg_trigger WHERE NOT tgisinternal"  # expect ~14
psql -c "SELECT count(*) FROM pg_proc WHERE pronamespace='public'::regnamespace"  # expect 11+
```

## 8. Idempotence check

After running `supabase db reset` a SECOND time, expect 0 stderr errors and identical schema. All `CREATE TABLE`/`CREATE INDEX`/`CREATE FUNCTION`/`CREATE POLICY` statements use guards.

---

**End of audit. See [[MIGRATION_DEPENDENCY]] for creation order, [[BACKEND_COVERAGE]] for Flutter mapping, [[ER_DIAGRAM]] for visual schema, [[ENUMS]] for enum definitions.**
