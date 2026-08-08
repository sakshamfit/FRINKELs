-- ====================================================================
-- FRINKELs Migration 07 — Functions (helpers + RPCs)
-- Timestamp: 20260804000600
-- Description: All trigger helper functions and user-callable RPCs.
--              Uses CREATE OR REPLACE FUNCTION for idempotence.
-- Pre-conditions: tables from migrations 03, 04, 05.
-- Idempotency: CREATE OR REPLACE FUNCTION throughout.
-- ====================================================================

-- --------------------------------------------------------------------
-- 1. update_updated_at_column — generic BEFORE UPDATE updated_at setter
-- --------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

-- --------------------------------------------------------------------
-- 2. update_follower_counts — maintains followers_count / following_count
-- --------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.update_follower_counts()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        UPDATE public.profiles SET following_count = following_count + 1 WHERE id = NEW.follower_id;
        UPDATE public.profiles SET followers_count = followers_count + 1 WHERE id = NEW.followed_id;
    ELSIF (TG_OP = 'DELETE') THEN
        UPDATE public.profiles SET following_count = GREATEST(0, following_count - 1) WHERE id = OLD.follower_id;
        UPDATE public.profiles SET followers_count = GREATEST(0, followers_count - 1) WHERE id = OLD.followed_id;
    END IF;
    RETURN NULL;
END;
$$;

-- --------------------------------------------------------------------
-- 3. update_post_counts — maintains posts_count on profiles
-- --------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.update_post_counts()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        UPDATE public.profiles SET posts_count = posts_count + 1 WHERE id = NEW.author_id;
    ELSIF (TG_OP = 'DELETE') THEN
        UPDATE public.profiles SET posts_count = GREATEST(0, posts_count - 1) WHERE id = OLD.author_id;
    END IF;
    RETURN NULL;
END;
$$;

-- --------------------------------------------------------------------
-- 4. update_post_likes_count — maintains likes_count on posts
-- --------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.update_post_likes_count()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = NEW.post_id;
    ELSIF (TG_OP = 'DELETE') THEN
        UPDATE public.posts SET likes_count = GREATEST(0, likes_count - 1) WHERE id = OLD.post_id;
    END IF;
    RETURN NULL;
END;
$$;

-- --------------------------------------------------------------------
-- 5. update_post_comments_count — maintains comments_count on posts
-- --------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.update_post_comments_count()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = NEW.post_id;
    ELSIF (TG_OP = 'DELETE') THEN
        UPDATE public.posts SET comments_count = GREATEST(0, comments_count - 1) WHERE id = OLD.post_id;
    END IF;
    RETURN NULL;
END;
$$;

-- --------------------------------------------------------------------
-- 6. update_user_presence — auto online/offline based on activity
-- --------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.update_user_presence()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.last_activity = GREATEST(COALESCE(NEW.last_activity, OLD.last_activity), NOW());

    IF NEW.last_activity > (COALESCE(OLD.last_activity, NOW() - INTERVAL '5 minutes')) THEN
        NEW.is_online = true;
        NEW.status_updated_at = NOW();
    ELSIF NEW.last_activity < (NOW() - INTERVAL '10 minutes') THEN
        NEW.is_online = false;
        NEW.status_updated_at = NOW();
    END IF;

    IF OLD.is_online = true AND NEW.is_online = false THEN
        NEW.last_seen_at = GREATEST(COALESCE(NEW.last_seen_at, OLD.last_seen_at), NOW());
    END IF;

    RETURN NEW;
END;
$$;

-- --------------------------------------------------------------------
-- 7. cleanup_expired_typing_indicators — client-callable utility
-- --------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.cleanup_expired_typing_indicators()
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM public.typing_indicators WHERE is_typing = true AND expires_at < NOW();
    DELETE FROM public.typing_indicators WHERE updated_at < NOW() - INTERVAL '1 hour';
END;
$$;

-- --------------------------------------------------------------------
-- 8. get_suggested_profiles — RPC, most-followed not yet followed
-- --------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_suggested_profiles(
    user_id UUID,
    "limit" INTEGER DEFAULT 10
)
RETURNS SETOF public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT p.*
    FROM public.profiles p
    WHERE p.id != user_id
      AND p.is_onboarded = true
      AND p.id NOT IN (
          SELECT followed_id FROM public.follows WHERE follower_id = user_id
      )
    ORDER BY p.followers_count DESC, p.created_at DESC
    LIMIT "limit";
END;
$$;

-- --------------------------------------------------------------------
-- 9. get_nearby_profiles — RPC, Haversine distance
-- --------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_nearby_profiles(
    user_id UUID,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    radius_km DOUBLE PRECISION DEFAULT 10.0,
    "limit" INTEGER DEFAULT 20
)
RETURNS SETOF public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    user_lat DOUBLE PRECISION := latitude;
    user_lng DOUBLE PRECISION := longitude;
BEGIN
    IF user_lat IS NULL OR user_lng IS NULL THEN
        SELECT p.latitude, p.longitude INTO user_lat, user_lng
        FROM public.profiles p
        WHERE p.id = user_id;
    END IF;

    RETURN QUERY
    SELECT p.*
    FROM public.profiles p
    WHERE p.id != user_id
      AND p.is_onboarded = true
      AND p.latitude IS NOT NULL
      AND p.longitude IS NOT NULL
      AND (
          6371 * acos(
              cos(radians(user_lat)) * cos(radians(p.latitude)) *
              cos(radians(p.longitude) - radians(user_lng)) +
              sin(radians(user_lat)) * sin(radians(p.latitude))
          )
      ) <= radius_km
    ORDER BY (
        6371 * acos(
            cos(radians(user_lat)) * cos(radians(p.latitude)) *
            cos(radians(p.longitude) - radians(user_lng)) +
            sin(radians(user_lat)) * sin(radians(p.latitude))
        )
    ) ASC
    LIMIT "limit";
END;
$$;

-- --------------------------------------------------------------------
-- 10. likes INSTEAD OF helpers (used by view)
-- --------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.likes_instead_of_insert()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.post_likes (post_id, user_id)
    VALUES (NEW.post_id, NEW.user_id)
    ON CONFLICT (post_id, user_id) DO NOTHING;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.likes_instead_of_delete()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM public.post_likes
    WHERE post_id = OLD.post_id AND user_id = OLD.user_id;
    RETURN OLD;
END;
$$;

-- --------------------------------------------------------------------
-- 11. bookmarks INSTEAD OF helpers (used by view)
-- --------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.bookmarks_instead_of_insert()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.post_bookmarks (post_id, user_id)
    VALUES (NEW.post_id, NEW.user_id)
    ON CONFLICT (post_id, user_id) DO NOTHING;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.bookmarks_instead_of_delete()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM public.post_bookmarks
    WHERE post_id = OLD.post_id AND user_id = OLD.user_id;
    RETURN OLD;
END;
$$;

-- ====================================================================
-- END Migration 07
-- ====================================================================
