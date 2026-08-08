-- ====================================================================
-- FRINKELs Migration 08 — Triggers
-- Timestamp: 20260804000700
-- Description: All BEFORE/AFTER triggers wired to functions from
--              migration 07. Every CREATE TRIGGER is wrapped in a
--              pg_trigger existence check.
-- Pre-conditions: tables (03,04,05), functions (07).
-- Idempotency: each trigger wrapped in pg_trigger existence check.
-- ====================================================================

-- --------------------------------------------------------------------
-- 1. BEFORE UPDATE updated_at triggers (7 tables)
-- --------------------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_profiles_updated_at') THEN
        CREATE TRIGGER update_profiles_updated_at
        BEFORE UPDATE ON public.profiles
        FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_posts_updated_at') THEN
        CREATE TRIGGER update_posts_updated_at
        BEFORE UPDATE ON public.posts
        FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_businesses_updated_at') THEN
        CREATE TRIGGER update_businesses_updated_at
        BEFORE UPDATE ON public.businesses
        FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_communities_updated_at') THEN
        CREATE TRIGGER update_communities_updated_at
        BEFORE UPDATE ON public.communities
        FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_jobs_updated_at') THEN
        CREATE TRIGGER update_jobs_updated_at
        BEFORE UPDATE ON public.jobs
        FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_conversations_updated_at') THEN
        CREATE TRIGGER update_conversations_updated_at
        BEFORE UPDATE ON public.conversations
        FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_messages_updated_at') THEN
        CREATE TRIGGER update_messages_updated_at
        BEFORE UPDATE ON public.messages
        FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
    END IF;
END $$;

-- --------------------------------------------------------------------
-- 2. BEFORE UPDATE presence trigger on profiles
-- --------------------------------------------------------------------
DROP TRIGGER IF EXISTS trigger_update_user_presence ON public.profiles;
CREATE TRIGGER trigger_update_user_presence
BEFORE UPDATE ON public.profiles
FOR EACH ROW
WHEN (OLD.* IS DISTINCT FROM NEW.*)
EXECUTE FUNCTION public.update_user_presence();

-- --------------------------------------------------------------------
-- 3. AFTER INSERT/DELETE counter triggers
-- --------------------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'on_follow_change') THEN
        CREATE TRIGGER on_follow_change
        AFTER INSERT OR DELETE ON public.follows
        FOR EACH ROW EXECUTE FUNCTION public.update_follower_counts();
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'on_post_change') THEN
        CREATE TRIGGER on_post_change
        AFTER INSERT OR DELETE ON public.posts
        FOR EACH ROW EXECUTE FUNCTION public.update_post_counts();
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'on_post_like_change') THEN
        CREATE TRIGGER on_post_like_change
        AFTER INSERT OR DELETE ON public.post_likes
        FOR EACH ROW EXECUTE FUNCTION public.update_post_likes_count();
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'on_comment_change') THEN
        CREATE TRIGGER on_comment_change
        AFTER INSERT OR DELETE ON public.comments
        FOR EACH ROW EXECUTE FUNCTION public.update_post_comments_count();
    END IF;
END $$;

-- ====================================================================
-- END Migration 08
-- ====================================================================
