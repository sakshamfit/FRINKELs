-- ====================================================================
-- FRINKELs Migration 14 — Enum Catalog & Documentation
-- Timestamp: 20260804001300
-- Description: Comments on every enum type and a helper view for
--              introspecting them at runtime.
-- Pre-conditions: enums (migration 02).
-- Idempotency: COMMENT ON TYPE is idempotent; CREATE OR REPLACE VIEW.
-- ====================================================================

-- --------------------------------------------------------------------
-- 1. Enum type comments
-- --------------------------------------------------------------------
COMMENT ON TYPE public.job_status IS
    'Lifecycle states for a job posting: draft -> open -> filled | completed | cancelled | closed';
COMMENT ON TYPE public.message_type IS
    'Content kind carried by a chat message';
COMMENT ON TYPE public.conversation_type IS
    'Whether a chat is between two users or a group';
COMMENT ON TYPE public.notification_type IS
    'Event category triggering a notification; matches Dart NotificationType by-name';
COMMENT ON TYPE public.application_status IS
    'Job application review lifecycle: pending -> reviewed -> accepted | rejected';
COMMENT ON TYPE public.user_role IS
    'Role inside a community or conversation';
COMMENT ON TYPE public.business_category IS
    'Top-level taxonomy for businesses';
COMMENT ON TYPE public.community_visibility IS
    'Who can see a community';
COMMENT ON TYPE public.story_visibility IS
    'Who can see a story';
COMMENT ON TYPE public.post_visibility IS
    'Who can see a post';

-- --------------------------------------------------------------------
-- 2. Enum introspection view (read-only)
-- --------------------------------------------------------------------
CREATE OR REPLACE VIEW public.enum_catalog AS
SELECT
    t.typname                       AS enum_name,
    n.nspname                       AS schema_name,
    array_agg(e.enumlabel ORDER BY e.enumsortorder) AS values,
    obj_description(t.oid, 'pg_type') AS description
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
JOIN pg_enum e ON e.enumtypid = t.oid
WHERE t.typtype = 'e'
  AND n.nspname = 'public'
GROUP BY t.typname, n.nspname, t.oid
ORDER BY t.typname;

GRANT SELECT ON public.enum_catalog TO authenticated, anon;

-- ====================================================================
-- END Migration 14
-- ====================================================================
