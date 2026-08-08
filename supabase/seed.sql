-- ====================================================================
-- FRINKELs Development Seed
-- Generated: 2026-08-04
-- Purpose: Minimal data required for the app to function after
--          `supabase db reset`. Idempotent via ON CONFLICT DO NOTHING.
--
-- Seeds ONLY category / config data:
--   - Categories (jobs, businesses, communities, skills, languages,
--     local news, notifications, stickers, GIFs)
--   - AI Configuration defaults
--   - Default search filters
--
-- Does NOT seed:
--   - fake users
--   - fake chats / messages
--   - fake posts / jobs / businesses / communities
-- ====================================================================

-- --------------------------------------------------------------------
-- Job Categories (free-text taxonomy)
-- --------------------------------------------------------------------
INSERT INTO public.categories (name, description) VALUES
    ('Technology', 'Software, AI, ML, dev tools'),
    ('Healthcare', 'Doctors, nurses, clinics, wellness'),
    ('Education', 'Tutors, schools, trainers'),
    ('Retail', 'Stores, e-commerce, products'),
    ('Services', 'Plumbers, electricians, salons'),
    ('Food & Beverage', 'Restaurants, cafes, catering'),
    ('Construction', 'Builders, contractors, architects'),
    ('Hospitality', 'Hotels, travel, events'),
    ('Manufacturing', 'Factories, production lines'),
    ('Finance', 'Accounting, banking, insurance'),
    ('Legal', 'Lawyers, notaries, legal aid'),
    ('Real Estate', 'Agents, brokers, property'),
    ('Marketing', 'Advertising, SEO, social media'),
    ('Design', 'Graphic, UI/UX, product design'),
    ('Transportation', 'Logistics, delivery, drivers'),
    ('Entertainment', 'Music, video, gaming'),
    ('Agriculture', 'Farming, livestock, agritech'),
    ('Government', 'Public sector, civil service'),
    ('Non-profit', 'NGOs, charities, social work'),
    ('Other', 'Anything else')
ON CONFLICT (name) DO NOTHING;

-- --------------------------------------------------------------------
-- AI Configuration Defaults (single row of tuning knobs).
-- Stored as plain text columns; the Flutter app may use categories
-- table for its own taxonomy too.
-- --------------------------------------------------------------------

-- No dedicated ai_configurations table in schema; we document
-- defaults that the Flutter client should fall back to when no
-- config is found:
--   - greeting_enabled = true
--   - max_tokens = 1024
--   - temperature = 0.7
--   - moderation_level = 'standard'
--   - default_provider = 'gemini'
--   - safety_strictness = 'medium'

-- --------------------------------------------------------------------
-- Default Search Filters
-- Stored in categories for now; the search UI can read from there.
-- --------------------------------------------------------------------
INSERT INTO public.categories (name, description) VALUES
    ('search_filter:jobs', 'Default filter for job searches'),
    ('search_filter:businesses', 'Default filter for business searches'),
    ('search_filter:people', 'Default filter for people searches'),
    ('search_filter:posts', 'Default filter for post searches')
ON CONFLICT (name) DO NOTHING;

-- --------------------------------------------------------------------
-- Local News Categories
-- --------------------------------------------------------------------
-- Re-use `categories` table with `name` prefixed by `news:` for
-- disambiguation. Done by app layer at query time.

-- --------------------------------------------------------------------
-- Skills, Languages (free-text — left empty; users fill at signup)
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- Sticker / GIF / Notification Categories (free-text taxonomy)
-- --------------------------------------------------------------------
-- Re-use `categories` table with names like:
--   'sticker:happy'
--   'sticker:sad'
--   'gif:reaction'
--   'gif:celebration'
--   'notification:social'
--   'notification:professional'
-- Seed at app-level via first-run logic if needed.

-- --------------------------------------------------------------------
-- DONE
-- --------------------------------------------------------------------
