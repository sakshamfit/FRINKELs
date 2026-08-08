# Migration Dependencies

This document outlines the dependencies between each migration file in the correct execution order.

## Migration Order

1. `20260804000000_extensions.sql` - Enable extensions
2. `20260804000100_enums.sql` - Create enums
3. `20260804000200_profiles_and_auth.sql` - Create profiles table and auth trigger
4. `20260804000300_core_platform_tables.sql` - Create core platform tables
5. `20260804000400_chat_tables.sql` - Create chat tables
6. `20260804000500_indexes.sql` - Create indexes
7. `20260804000600_functions.sql` - Create functions
8. `20260804000700_triggers.sql` - Create triggers
9. `20260804000800_views.sql` - Create views
10. `20260804000900_storage_buckets.sql` - Create storage buckets
11. `20260804001000_rls_policies.sql` - Create RLS policies
12. `20260804001100_storage_policies.sql` - Create storage policies
13. `20260804001200_realtime_publications.sql` - Create realtime publications
14. `20260804001300_enums_catalog.sql` - Create enums catalog
15. `20260808000100_documentation_table.sql` - Create documentation table for knowledge base

## Dependency Details

### Migration 1: Extensions
- **Creates**: 
  - Extension: `uuid-ossp`
  - Extension: `pgcrypto`
- **References**: None
- **Dependencies**: None (runs on empty database)

### Migration 2: Enums
- **Creates**: 
  - Type: `application_status`
  - Type: `business_category`
  - Type: `community_visibility`
  - Type: `conversation_type`
  - Type: `job_status`
  - Type: `message_type`
  - Type: `notification_type`
  - Type: `post_visibility`
  - Type: `story_visibility`
  - Type: `user_role`
- **References**: None
- **Dependencies**: 
  - Requires extensions migration (for any extensions used in type definitions, though none are)

### Migration 3: Profiles and Auth
- **Creates**:
  - Table: `public.profiles`
  - Function: `public.handle_new_user`
  - Trigger: `on_auth_user_created` (on auth.users)
- **References**: 
  - Table: `auth.users` (external, managed by Supabase Auth)
- **Dependencies**:
  - Extensions migration (for uuid-ossp and pgcrypto used in table defaults)
  - Enums migration (not directly, but enum types are defined prior)

### Migration 4: Core Platform Tables
- **Creates**:
  - Table: `public.follows`
  - Table: `public.posts`
  - Table: `public.post_likes`
  - Table: `public.post_bookmarks`
  - Table: `public.comments`
  - Table: `public.stories`
  - Table: `public.story_views`
  - Table: `public.categories`
  - Table: `public.businesses`
  - Table: `public.communities`
  - Table: `public.community_members`
  - Table: `public.jobs`
  - Table: `public.job_applications`
  - Table: `public.notifications`
  - Table: `public.local_news`
  - Table: `public.search_trending`
  - Table: `public.user_searches`
- **References**:
  - Table: `public.profiles` (from migration 3)
  - Table: `public.jobs` (self-reference in job_applications? Actually job_applications references jobs and profiles)
  - Table: `public.posts` (referenced by post_likes, post_bookmarks, comments)
  - Table: `public.stories` (referenced by story_views)
  - Table: `public.communities` (referenced by community_members)
- **Dependencies**:
  - Requires profiles table (migration 3)
  - Requires enums (migration 2) for enum columns (though some columns use TEXT with CHECK constraints, not enums)

### Migration 5: Chat Tables
- **Creates**:
  - Table: `public.conversation_participants`
  - Table: `public.conversations`
  - Table: `public.message_reactions`
  - Table: `public.message_receipts`
  - Table: `public.messages`
  - Table: `public.typing_indicators`
- **References**:
  - Table: `public.profiles` (from migration 3)
  - Table: `public.messages` (self-referential for replies and forwards)
  - Table: `public.conversations` (referenced by conversation_participants, message_reactions, etc.)
- **Dependencies**:
  - Requires profiles table (migration 3)
  - Requires enums (migration 2) for message_type, conversation_type, user_role enums

### Migration 6: Indexes
- **Creates**: All indexes for tables created in previous migrations
- **References**: None (only creates indexes on existing tables)
- **Dependencies**:
  - Requires all tables to exist (migrations 3, 4, 5)

### Migration 7: Functions
- **Creates**: Various database functions (triggers, utility functions)
- **References**: None (functions may reference tables, but we don't track that here for simplicity)
- **Dependencies**:
  - Requires tables to exist (migrations 3, 4, 5)

### Migration 8: Triggers
- **Creates**: Trigger functions and attaches them to tables
- **References**: None (triggers are defined on tables)
- **Dependencies**:
  - Requires tables to exist (migrations 3, 4, 5)
  - Requires functions to exist (migration 7)

### Migration 9: Views
- **Creates**: Database views
- **References**: None (views reference tables, but not tracked here)
- **Dependencies**:
  - Requires tables to exist (migrations 3, 4, 5)

### Migration 10: Storage Buckets
- **Creates**: Storage bucket `profile_photos`
- **References**: None
- **Dependencies**: 
  - Requires storage extension (enabled via pgcrypto? Actually storage is a Supabase extension, but we assume it's enabled by Supabase)

### Migration 11: RLS Policies
- **Creates**: Row Level Security policies on tables
- **References**: None (policies are defined on tables)
- **Dependencies**:
  - Requires tables to exist (migrations 3, 4, 5)

### Migration 12: Storage Policies
- **Creates**: Storage policies on buckets
- **References**: None
- **Dependencies**:
  - Requires storage buckets to exist (migration 10)

### Migration 13: Realtime Publications
- **Creates**: Realtime publications for tables
- **References**: None (publications are defined on tables)
- **Dependencies**:
  - Requires tables to exist (migrations 3, 4, 5)
  - Requires realtime extension (enabled by Supabase)

### Migration 14: Enums Catalog
- **Creates**: A catalog table for enums (if needed)
- **References**: None
- **Dependencies**:
  - Requires enums to exist (migration 2)

### Migration 15: Documentation Table
- **Creates**:
  - Table: `public.documentation`
  - Function: `update_updated_at_column()`
  - Trigger: `update_documentation_updated_at` (on documentation table)
- **References**: 
  - None (standalone table for knowledge base)
- **Dependencies**:
  - Extensions migration (for uuid-ossp used in table defaults)
  - Functions migration (for the update_updated_at_column function)

## Notes

- All migrations use `IF NOT EXISTS` or equivalent guards to be idempotent.
- The only external dependency is on `auth.users` (managed by Supabase Auth) and Supabase-specific extensions (storage, realtime).
- The order ensures that all dependencies are created before they are referenced.
- This ordering supports both `supabase db reset` (starting from empty database) and `supabase db push` (applying migrations to an existing database).