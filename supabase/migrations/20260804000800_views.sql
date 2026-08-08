-- ====================================================================
-- FRINKELs Migration 09 — Views (likes, bookmarks) with INSTEAD OF
-- Timestamp: 20260804000800
-- Description: Create alias views for post_likes and post_bookmarks,
--              plus INSTEAD OF INSERT/UPDATE/DELETE triggers so the
--              Flutter client can write through .from('likes') etc.
-- Pre-conditions: post_likes, post_bookmarks (migration 04).
-- Idempotency: CREATE OR REPLACE VIEW; triggers guarded.
-- ====================================================================

-- --------------------------------------------------------------------
-- 1. likes view
-- --------------------------------------------------------------------
CREATE OR REPLACE VIEW public.likes AS
SELECT id, post_id, user_id, created_at FROM public.post_likes;

-- INSTEAD OF triggers so INSERT/UPDATE/DELETE work through the view
DROP TRIGGER IF EXISTS likes_instead_of_insert ON public.likes;
CREATE TRIGGER likes_instead_of_insert
INSTEAD OF INSERT ON public.likes
FOR EACH ROW EXECUTE FUNCTION public.likes_instead_of_insert();

DROP TRIGGER IF EXISTS likes_instead_of_delete ON public.likes;
CREATE TRIGGER likes_instead_of_delete
INSTEAD OF DELETE ON public.likes
FOR EACH ROW EXECUTE FUNCTION public.likes_instead_of_delete();

-- --------------------------------------------------------------------
-- 2. bookmarks view
-- --------------------------------------------------------------------
CREATE OR REPLACE VIEW public.bookmarks AS
SELECT id, post_id, user_id, created_at FROM public.post_bookmarks;

DROP TRIGGER IF EXISTS bookmarks_instead_of_insert ON public.bookmarks;
CREATE TRIGGER bookmarks_instead_of_insert
INSTEAD OF INSERT ON public.bookmarks
FOR EACH ROW EXECUTE FUNCTION public.bookmarks_instead_of_insert();

DROP TRIGGER IF EXISTS bookmarks_instead_of_delete ON public.bookmarks;
CREATE TRIGGER bookmarks_instead_of_delete
INSTEAD OF DELETE ON public.bookmarks
FOR EACH ROW EXECUTE FUNCTION public.bookmarks_instead_of_delete();

-- ====================================================================
-- END Migration 09
-- ====================================================================
