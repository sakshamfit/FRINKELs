-- ====================================================================
-- FRINKELs Migration 06 — Indexes (consolidated)
-- Timestamp: 20260804000500
-- Description: All indexes for the 24 tables. B-tree, DESC, composite,
--              and partial indexes included. Plus GIN indexes for array columns.
-- Pre-conditions: tables from migrations 03, 04, 05.
-- Idempotency: CREATE INDEX IF NOT EXISTS throughout.
-- ====================================================================

-- Profiles
CREATE INDEX IF NOT EXISTS idx_profiles_username ON public.profiles(username);
CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles(email);
CREATE INDEX IF NOT EXISTS idx_profiles_profession ON public.profiles(profession);
CREATE INDEX IF NOT EXISTS idx_profiles_is_onboarded ON public.profiles(is_onboarded);
CREATE INDEX IF NOT EXISTS idx_profiles_location ON public.profiles(latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_profiles_followers_count ON public.profiles(followers_count DESC);
CREATE INDEX IF NOT EXISTS idx_profiles_rating ON public.profiles(rating DESC);
CREATE INDEX IF NOT EXISTS idx_profiles_last_seen_at ON public.profiles(last_seen_at);
CREATE INDEX IF NOT EXISTS idx_profiles_is_online ON public.profiles(is_online);
CREATE INDEX IF NOT EXISTS idx_profiles_last_activity ON public.profiles(last_activity);
CREATE INDEX IF NOT EXISTS idx_profiles_status_updated ON public.profiles(status_updated_at);
-- GIN indexes for array columns
CREATE INDEX IF NOT EXISTS idx_profiles_skills ON public.profiles USING GIN (skills);
CREATE INDEX IF NOT EXISTS idx_profiles_interests ON public.profiles USING GIN (interests);

-- Follows
CREATE INDEX IF NOT EXISTS idx_follows_follower_id ON public.follows(follower_id);
CREATE INDEX IF NOT EXISTS idx_follows_followed_id ON public.follows(followed_id);

-- Posts
CREATE INDEX IF NOT EXISTS idx_posts_author_id ON public.posts(author_id);
CREATE INDEX IF NOT EXISTS idx_posts_created_at ON public.posts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_posts_type ON public.posts(type);
-- GIN index for image_urls array
CREATE INDEX IF NOT EXISTS idx_messages_image_urls ON public.messages USING GIN (image_urls);

-- Post likes
CREATE INDEX IF NOT EXISTS idx_post_likes_post_id ON public.post_likes(post_id);
CREATE INDEX IF NOT EXISTS idx_post_likes_user_id ON public.post_likes(user_id);

-- Post bookmarks
CREATE INDEX IF NOT EXISTS idx_post_bookmarks_post_id ON public.post_bookmarks(post_id);
CREATE INDEX IF NOT EXISTS idx_post_bookmarks_user_id ON public.post_bookmarks(user_id);

-- Comments
CREATE INDEX IF NOT EXISTS idx_comments_post_id ON public.comments(post_id);
CREATE INDEX IF NOT EXISTS idx_comments_author_id ON public.comments(author_id);
CREATE INDEX IF NOT EXISTS idx_comments_created_at ON public.comments(created_at DESC);

-- Stories
CREATE INDEX IF NOT EXISTS idx_stories_user_id ON public.stories(user_id);
CREATE INDEX IF NOT EXISTS idx_stories_expires_at ON public.stories(expires_at DESC);

-- Story views
CREATE INDEX IF NOT EXISTS idx_story_views_story_id ON public.story_views(story_id);
CREATE INDEX IF NOT EXISTS idx_story_views_user_id ON public.story_views(user_id);

-- Categories
CREATE INDEX IF NOT EXISTS idx_categories_name ON public.categories(name);

-- Businesses
CREATE INDEX IF NOT EXISTS idx_businesses_owner_id ON public.businesses(owner_id);
CREATE INDEX IF NOT EXISTS idx_businesses_category ON public.businesses(category);
CREATE INDEX IF NOT EXISTS idx_businesses_rating ON public.businesses(rating DESC);

-- Communities
CREATE INDEX IF NOT EXISTS idx_communities_category ON public.communities(category);
CREATE INDEX IF NOT EXISTS idx_communities_member_count ON public.communities(member_count DESC);

-- Community members
CREATE INDEX IF NOT EXISTS idx_community_members_community_id ON public.community_members(community_id);
CREATE INDEX IF NOT EXISTS idx_community_members_user_id ON public.community_members(user_id);

-- Jobs
CREATE INDEX IF NOT EXISTS idx_jobs_posted_by_id ON public.jobs(posted_by_id);
CREATE INDEX IF NOT EXISTS idx_jobs_status ON public.jobs(status);
CREATE INDEX IF NOT EXISTS idx_jobs_type ON public.jobs(type);
CREATE INDEX IF NOT EXISTS idx_jobs_created_at ON public.jobs(created_at DESC);

-- Job applications
CREATE INDEX IF NOT EXISTS idx_job_applications_job_id ON public.job_applications(job_id);
CREATE INDEX IF NOT EXISTS idx_job_applications_applicant_id ON public.job_applications(applicant_id);

-- Notifications
CREATE INDEX IF NOT EXISTS idx_notifications_recipient_id ON public.notifications(recipient_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON public.notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON public.notifications(created_at DESC);

-- Local news
CREATE INDEX IF NOT EXISTS idx_local_news_category ON public.local_news(category);
CREATE INDEX IF NOT EXISTS idx_local_news_location ON public.local_news(location);
CREATE INDEX IF NOT EXISTS idx_local_news_published_at ON public.local_news(published_at DESC);

-- Search trending
CREATE INDEX IF NOT EXISTS idx_search_trending_count ON public.search_trending(search_count DESC);

-- User searches
CREATE INDEX IF NOT EXISTS idx_user_searches_user_id ON public.user_searches(user_id);
CREATE INDEX IF NOT EXISTS idx_user_searches_created_at ON public.user_searches(created_at DESC);

-- Conversations
CREATE INDEX IF NOT EXISTS idx_conversations_updated_at ON public.conversations(updated_at DESC);

-- Conversation participants
CREATE INDEX IF NOT EXISTS idx_conversation_participants_conversation_id ON public.conversation_participants(conversation_id);
CREATE INDEX IF NOT EXISTS idx_conversation_participants_user_id ON public.conversation_participants(user_id);

-- Messages
CREATE INDEX IF NOT EXISTS idx_messages_conversation_id ON public.messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_messages_sender_id ON public.messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON public.messages(created_at);
CREATE INDEX IF NOT EXISTS idx_messages_edited_by ON public.messages(edited_by);
CREATE INDEX IF NOT EXISTS idx_messages_forwarded_from ON public.messages(forwarded_from_message_id);
CREATE INDEX IF NOT EXISTS idx_messages_sticker_pack ON public.messages(sticker_pack_id);
CREATE INDEX IF NOT EXISTS idx_messages_sticker ON public.messages(sticker_id);
CREATE INDEX IF NOT EXISTS idx_messages_is_gif ON public.messages(is_gif);
CREATE INDEX IF NOT EXISTS idx_messages_pinned ON public.messages(pinned) WHERE pinned = true;

-- Message receipts
CREATE INDEX IF NOT EXISTS idx_message_receipts_message_id ON public.message_receipts(message_id);
CREATE INDEX IF NOT EXISTS idx_message_receipts_user_id ON public.message_receipts(user_id);

-- Message reactions
CREATE INDEX IF NOT EXISTS idx_message_reactions_message_id ON public.message_reactions(message_id);
CREATE INDEX IF NOT EXISTS idx_message_reactions_user_id ON public.message_reactions(user_id);
CREATE INDEX IF NOT EXISTS idx_message_reactions_conversation_id ON public.message_reactions(conversation_id);

-- Typing indicators
CREATE INDEX IF NOT EXISTS idx_typing_indicators_conversation_id ON public.typing_indicators(conversation_id);
CREATE INDEX IF NOT EXISTS idx_typing_indicators_user_id ON public.typing_indicators(user_id);
CREATE INDEX IF NOT EXISTS idx_typing_indicators_updated_at ON public.typing_indicators(updated_at);
CREATE INDEX IF NOT EXISTS idx_typing_indicators_active ON public.typing_indicators(conversation_id, is_typing) WHERE is_typing = true;

-- ====================================================================
-- END Migration 06
-- ====================================================================