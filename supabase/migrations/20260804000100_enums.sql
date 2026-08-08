-- ====================================================================
-- FRINKELs Migration 02 — Enums
-- Timestamp: 20260804000100
-- Description: Create all status / type enums as real PostgreSQL ENUMs.
-- Pre-conditions: extensions migration
-- Idempotency: each CREATE TYPE wrapped in pg_type existence check.
-- ====================================================================

-- --------------------------------------------------------------------
-- job_status — full job lifecycle including draft and terminal states.
-- --------------------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'job_status') THEN
        CREATE TYPE public.job_status AS ENUM (
            'draft',
            'open',
            'filled',
            'completed',
            'cancelled',
            'closed'
        );
    END IF;
END $$;

-- --------------------------------------------------------------------
-- message_type — supports text, media, location, contact, sticker, gif
-- --------------------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'message_type') THEN
        CREATE TYPE public.message_type AS ENUM (
            'text',
            'image',
            'video',
            'voice',
            'file',
            'location',
            'contact',
            'sticker',
            'gif'
        );
    END IF;
END $$;

-- --------------------------------------------------------------------
-- conversation_type — individual or group chat
-- --------------------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'conversation_type') THEN
        CREATE TYPE public.conversation_type AS ENUM (
            'individual',
            'group'
        );
    END IF;
END $$;

-- --------------------------------------------------------------------
-- notification_type — every notification kind the Flutter app emits.
-- Uses snake_case to match Dart enum by-name mapping.
-- --------------------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'notification_type') THEN
        CREATE TYPE public.notification_type AS ENUM (
            'like',
            'comment',
            'mention',
            'follow',
            'mention_in_comment',
            'post_mention',
            'job_application',
            'job_accepted',
            'job_rejected',
            'event_invite',
            'event_reminder',
            'system'
        );
    END IF;
END $$;

-- --------------------------------------------------------------------
-- application_status — job application lifecycle
-- --------------------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'application_status') THEN
        CREATE TYPE public.application_status AS ENUM (
            'pending',
            'reviewed',
            'accepted',
            'rejected'
        );
    END IF;
END $$;

-- --------------------------------------------------------------------
-- user_role — used by community_members and conversation_participants
-- --------------------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_role') THEN
        CREATE TYPE public.user_role AS ENUM (
            'admin',
            'moderator',
            'member'
        );
    END IF;
END $$;

-- --------------------------------------------------------------------
-- business_category — taxonomy for businesses
-- --------------------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'business_category') THEN
        CREATE TYPE public.business_category AS ENUM (
            'food',
            'retail',
            'services',
            'health',
            'education',
            'technology',
            'entertainment',
            'other'
        );
    END IF;
END $$;

-- --------------------------------------------------------------------
-- community_visibility — who can see a community
-- --------------------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'community_visibility') THEN
        CREATE TYPE public.community_visibility AS ENUM (
            'public',
            'private',
            'invite_only'
        );
    END IF;
END $$;

-- --------------------------------------------------------------------
-- story_visibility — who can see a story
-- --------------------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'story_visibility') THEN
        CREATE TYPE public.story_visibility AS ENUM (
            'public',
            'followers',
            'close_friends'
        );
    END IF;
END $$;

-- --------------------------------------------------------------------
-- post_visibility — who can see a post
-- --------------------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'post_visibility') THEN
        CREATE TYPE public.post_visibility AS ENUM (
            'public',
            'followers',
            'private'
        );
    END IF;
END $$;

-- --------------------------------------------------------------------
-- post_type — what kind of post this is (text, image, video, link, poll)
-- --------------------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'post_type') THEN
        CREATE TYPE public.post_type AS ENUM (
            'text',
            'image',
            'video',
            'link',
            'poll'
        );
    END IF;
END $$;

-- --------------------------------------------------------------------
-- story_type — what kind of media this story contains (image, video)
-- --------------------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'story_type') THEN
        CREATE TYPE public.story_type AS ENUM (
            'image',
            'video'
        );
    END IF;
END $$;

-- ====================================================================
-- END Migration 02
-- ====================================================================