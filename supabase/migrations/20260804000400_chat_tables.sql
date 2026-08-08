-- ====================================================================
-- FRINKELs Migration 05 — Chat Tables
-- Timestamp: 20260804000400
-- Description: All messaging tables. FKs to profiles and conversations
--              resolve because those tables exist in migrations 03 and 04.
-- Pre-conditions: extensions (01), enums (02), profiles (03), core platform (04).
-- Idempotency: CREATE TABLE IF NOT EXISTS throughout.
-- ====================================================================

-- --------------------------------------------------------------------
-- 1. CONVERSATIONS
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type public.conversation_type NOT NULL DEFAULT 'individual',
    name TEXT,
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- --------------------------------------------------------------------
-- 2. CONVERSATION PARTICIPANTS
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.conversation_participants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    role public.user_role NOT NULL DEFAULT 'member',
    joined_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    UNIQUE(conversation_id, user_id)
);

-- --------------------------------------------------------------------
-- 3. MESSAGES
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    type public.message_type NOT NULL DEFAULT 'text',
    content TEXT,
    image_urls TEXT[] NOT NULL DEFAULT '{}',
    video_url TEXT,
    file_url TEXT,
    voice_url TEXT,
    gif_url TEXT,
    is_gif BOOLEAN NOT NULL DEFAULT false,
    duration INTEGER,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    location_title TEXT,
    contact_data JSONB,
    reply_to_message_id UUID REFERENCES public.messages(id) ON DELETE SET NULL,
    forwarded_from_message_id UUID REFERENCES public.messages(id) ON DELETE SET NULL,
    edited_at TIMESTAMP WITH TIME ZONE,
    edited_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    sticker_pack_id UUID,
    sticker_id UUID,
    pinned BOOLEAN NOT NULL DEFAULT false,
    pinned_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    pinned_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE,
    deleted_by UUID[] NOT NULL DEFAULT '{}'
);

-- --------------------------------------------------------------------
-- 4. MESSAGE RECEIPTS (delivered/read status)
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.message_receipts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message_id UUID NOT NULL REFERENCES public.messages(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    status TEXT NOT NULL CHECK (status IN ('delivered', 'read')),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    UNIQUE(message_id, user_id, status)
);

-- --------------------------------------------------------------------
-- 5. MESSAGE REACTIONS
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.message_reactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message_id UUID NOT NULL REFERENCES public.messages(id) ON DELETE CASCADE,
    conversation_id UUID REFERENCES public.conversations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    emoji TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    UNIQUE(message_id, user_id, emoji)
);

-- --------------------------------------------------------------------
-- 6. TYPING INDICATORS
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.typing_indicators (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    is_typing BOOLEAN NOT NULL DEFAULT false,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    UNIQUE(conversation_id, user_id)
);

-- ====================================================================
-- END Migration 05
-- ====================================================================
