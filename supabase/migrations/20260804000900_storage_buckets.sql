-- ====================================================================
-- FRINKELs Migration 10 — Storage Buckets
-- Timestamp: 20260804000900
-- Description: Register 6 storage buckets in storage.buckets.
--              ON CONFLICT (id) DO UPDATE for idempotence.
-- Pre-conditions: storage schema (Supabase managed).
-- Idempotency: ON CONFLICT (id) DO UPDATE.
-- ====================================================================

INSERT INTO storage.buckets (id, name, public) VALUES
    ('profile_photos', 'profile_photos', true),
    ('cover_photos', 'cover_photos', true),
    ('uploads', 'uploads', true),
    ('post_media', 'post_media', true),
    ('chat_attachments', 'chat_attachments', false),
    ('job_resumes', 'job_resumes', false)
ON CONFLICT (id) DO UPDATE SET
    public = EXCLUDED.public,
    name = EXCLUDED.name;

-- ====================================================================
-- END Migration 10
-- ====================================================================
