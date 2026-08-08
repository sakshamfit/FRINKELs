-- ====================================================================
-- FRINKELs Migration 12 — Storage Policies
-- Timestamp: 20260804001100
-- Description: 3 RLS policies on storage.objects.
-- Pre-conditions: storage buckets (migration 10).
-- Idempotency: DROP POLICY IF EXISTS + CREATE POLICY.
-- ====================================================================

-- Public buckets: profile_photos, cover_photos, post_media, uploads.
-- Private buckets: chat_attachments, job_resumes (authenticated only).

DROP POLICY IF EXISTS "Public storage read" ON storage.objects;
CREATE POLICY "Public storage read" ON storage.objects FOR SELECT USING (
    bucket_id IN ('profile_photos', 'cover_photos', 'post_media', 'uploads')
    OR (bucket_id = 'chat_attachments' AND auth.role() = 'authenticated')
    OR (bucket_id = 'job_resumes' AND auth.role() = 'authenticated')
);

DROP POLICY IF EXISTS "Authenticated storage upload" ON storage.objects;
CREATE POLICY "Authenticated storage upload" ON storage.objects FOR INSERT WITH CHECK (
    auth.role() = 'authenticated'
);

DROP POLICY IF EXISTS "Owner storage delete" ON storage.objects;
CREATE POLICY "Owner storage delete" ON storage.objects FOR DELETE USING (
    auth.uid() = owner
);

-- ====================================================================
-- END Migration 12
-- ====================================================================
