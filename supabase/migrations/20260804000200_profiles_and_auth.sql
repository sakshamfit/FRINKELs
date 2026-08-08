-- ====================================================================
-- FRINKELs Migration 03 — Profiles and Auth
-- Timestamp: 20260804000200
-- Description: Create the public.profiles table linked to auth.users,
--              plus the handle_new_user trigger that auto-inserts a
--              profile row whenever a new auth.users row is created.
-- Pre-conditions: extensions (01), enums (02) migrations.
-- Idempotency: CREATE TABLE IF NOT EXISTS; trigger guarded by pg_trigger.
-- ====================================================================

-- --------------------------------------------------------------------
-- 1. PROFILES TABLE
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT UNIQUE,
    full_name TEXT,
    name TEXT,
    username TEXT UNIQUE,
    profession TEXT,
    bio TEXT,
    location TEXT,
    location_title TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    avatar_url TEXT,
    cover_url TEXT,
    skills TEXT[] NOT NULL DEFAULT '{}',
    interests TEXT[] NOT NULL DEFAULT '{}',
    availability TEXT,
    email_verified BOOLEAN NOT NULL DEFAULT false,
    is_onboarded BOOLEAN NOT NULL DEFAULT false,
    is_online BOOLEAN NOT NULL DEFAULT false,
    last_seen_at TIMESTAMP WITH TIME ZONE,
    last_activity TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    status_updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    rating NUMERIC(3, 2) NOT NULL DEFAULT 0.00,
    followers_count INTEGER NOT NULL DEFAULT 0,
    following_count INTEGER NOT NULL DEFAULT 0,
    posts_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Ensure all expected columns exist on profiles (defensive for partially-built DBs)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='profiles' AND column_name='last_activity') THEN
        ALTER TABLE public.profiles ADD COLUMN last_activity TIMESTAMP WITH TIME ZONE DEFAULT NOW();
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='profiles' AND column_name='status_updated_at') THEN
        ALTER TABLE public.profiles ADD COLUMN status_updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
    END IF;
END $$;

-- --------------------------------------------------------------------
-- 2. HANDLE NEW USER (auth.users -> public.profiles)
-- --------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    INSERT INTO public.profiles (id, email, full_name, avatar_url, created_at, updated_at)
    VALUES (
        NEW.id,
        NEW.email,
        NEW.raw_user_meta_data->>'full_name',
        NEW.raw_user_meta_data->>'avatar_url',
        NOW(),
        NOW()
    )
    ON CONFLICT (id) DO UPDATE SET
        email = EXCLUDED.email,
        updated_at = NOW();
    RETURN NEW;
END;
$$;

-- --------------------------------------------------------------------
-- 3. AUTH TRIGGER (guarded)
-- --------------------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'on_auth_user_created') THEN
        CREATE TRIGGER on_auth_user_created
        AFTER INSERT ON auth.users
        FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
    END IF;
END $$;

-- ====================================================================
-- END Migration 03
-- ====================================================================
