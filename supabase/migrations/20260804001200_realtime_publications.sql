-- ====================================================================
-- FRINKELs Migration 13 — Realtime Publications
-- Timestamp: 20260804001200
-- Description: Add 4 tables to the supabase_realtime publication so
--              Postgres Change Streams work via .stream() in Flutter.
-- Pre-conditions: tables (03, 04, 05), supabase_realtime publication.
-- Idempotency: each ADD TABLE wrapped in existence check.
-- ====================================================================

DO $$
BEGIN
    -- Messages
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables
        WHERE pubname = 'supabase_realtime' AND tablename = 'messages' AND schemaname = 'public'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;
    END IF;

    -- Typing indicators
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables
        WHERE pubname = 'supabase_realtime' AND tablename = 'typing_indicators' AND schemaname = 'public'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.typing_indicators;
    END IF;

    -- Message reactions
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables
        WHERE pubname = 'supabase_realtime' AND tablename = 'message_reactions' AND schemaname = 'public'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.message_reactions;
    END IF;

    -- Profiles (presence)
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables
        WHERE pubname = 'supabase_realtime' AND tablename = 'profiles' AND schemaname = 'public'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.profiles;
    END IF;
END $$;

-- ====================================================================
-- END Migration 13
-- ====================================================================
