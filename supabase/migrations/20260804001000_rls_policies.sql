-- ====================================================================
-- FRINKELs Migration 11 — RLS Policies (24 tables)
-- Timestamp: 20260804001000
-- Description: Enable RLS on all 24 tables and add comprehensive policies.
--              Every CREATE POLICY preceded by DROP POLICY IF EXISTS.
-- Pre-conditions: all tables from migrations 03, 04, 05.
-- Idempotency: DROP POLICY IF EXISTS + CREATE POLICY.
-- ====================================================================

-- --------------------------------------------------------------------
-- 1. ENABLE ROW LEVEL SECURITY
-- --------------------------------------------------------------------
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.follows ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.post_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.post_bookmarks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.story_views ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.businesses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.communities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.community_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.job_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.local_news ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.search_trending ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_searches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conversation_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.message_receipts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.message_reactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.typing_indicators ENABLE ROW LEVEL SECURITY;

-- --------------------------------------------------------------------
-- 2. PROFILES
-- --------------------------------------------------------------------
DROP POLICY IF EXISTS "Public profiles are viewable by everyone" ON public.profiles;
CREATE POLICY "Public profiles are viewable by everyone" ON public.profiles FOR SELECT USING (true);
DROP POLICY IF EXISTS "Users can insert their own profile" ON public.profiles;
CREATE POLICY "Users can insert their own profile" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);
DROP POLICY IF EXISTS "Users can delete own profile" ON public.profiles;
CREATE POLICY "Users can delete own profile" ON public.profiles FOR DELETE USING (auth.uid() = id);

-- --------------------------------------------------------------------
-- 3. FOLLOWS
-- --------------------------------------------------------------------
DROP POLICY IF EXISTS "Follows are viewable by everyone" ON public.follows;
CREATE POLICY "Follows are viewable by everyone" ON public.follows FOR SELECT USING (true);
DROP POLICY IF EXISTS "Users can follow" ON public.follows;
CREATE POLICY "Users can follow" ON public.follows FOR INSERT WITH CHECK (auth.uid() = follower_id);
DROP POLICY IF EXISTS "Users can unfollow" ON public.follows;
CREATE POLICY "Users can unfollow" ON public.follows FOR DELETE USING (auth.uid() = follower_id);
-- Note: Intentionally no UPDATE policy for follows as the relationship is immutable once created

-- --------------------------------------------------------------------
-- 4. POSTS
-- --------------------------------------------------------------------
DROP POLICY IF EXISTS "Posts are viewable by everyone" ON public.posts;
CREATE POLICY "Posts are viewable by everyone" ON public.posts FOR SELECT USING (true);
DROP POLICY IF EXISTS "Users can create posts" ON public.posts;
CREATE POLICY "Users can create posts" ON public.posts FOR INSERT WITH CHECK (auth.uid() = author_id);
DROP POLICY IF EXISTS "Users can update own posts" ON public.posts;
CREATE POLICY "Users can update own posts" ON public.posts FOR UPDATE USING (auth.uid() = author_id);
DROP POLICY IF EXISTS "Users can delete own posts" ON public.posts;
CREATE POLICY "Users can delete own posts" ON public.posts FOR DELETE USING (auth.uid() = author_id);

-- --------------------------------------------------------------------
-- 5. POST LIKES
-- --------------------------------------------------------------------
DROP POLICY IF EXISTS "Post likes are viewable by everyone" ON public.post_likes;
CREATE POLICY "Post likes are viewable by everyone" ON public.post_likes FOR SELECT USING (true);
DROP POLICY IF EXISTS "Users can like posts" ON public.post_likes;
CREATE POLICY "Users can like posts" ON public.post_likes FOR INSERT WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users can unlike posts" ON public.post_likes;
CREATE POLICY "Users can unlike posts" ON public.post_likes FOR DELETE USING (auth.uid() = user_id);
-- Note: Intentionally no UPDATE policy for post likes as the relationship is immutable once created

-- --------------------------------------------------------------------
-- 6. POST BOOKMARKS
-- --------------------------------------------------------------------
DROP POLICY IF EXISTS "Bookmarks are viewable by owner" ON public.post_bookmarks;
CREATE POLICY "Bookmarks are viewable by owner" ON public.post_bookmarks FOR SELECT USING (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users can bookmark posts" ON public.post_bookmarks;
CREATE POLICY "Users can bookmark posts" ON public.post_bookmarks FOR INSERT WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users can remove bookmarks" ON public.post_bookmarks;
CREATE POLICY "Users can remove bookmarks" ON public.post_bookmarks FOR DELETE USING (auth.uid() = user_id);
-- Note: Intentionally no UPDATE policy for post bookmarks as the relationship is immutable once created

-- --------------------------------------------------------------------
-- 7. COMMENTS
-- --------------------------------------------------------------------
DROP POLICY IF EXISTS "Comments are viewable by everyone" ON public.comments;
CREATE POLICY "Comments are viewable by everyone" ON public.comments FOR SELECT USING (true);
DROP POLICY IF EXISTS "Users can insert comments" ON public.comments;
CREATE POLICY "Users can insert comments" ON public.comments FOR INSERT WITH CHECK (auth.uid() = author_id);
DROP POLICY IF EXISTS "Users can update own comments" ON public.comments;
CREATE POLICY "Users can update own comments" ON public.comments FOR UPDATE USING (auth.uid() = author_id);
DROP POLICY IF EXISTS "Users can delete own comments" ON public.comments;
CREATE POLICY "Users can delete own comments" ON public.comments FOR DELETE USING (auth.uid() = author_id);

-- --------------------------------------------------------------------
-- 8. STORIES & VIEWS
-- --------------------------------------------------------------------
DROP POLICY IF EXISTS "Non-expired stories are viewable by everyone" ON public.stories;
CREATE POLICY "Non-expired stories are viewable by everyone" ON public.stories FOR SELECT USING (expires_at > NOW());
DROP POLICY IF EXISTS "Users can insert stories" ON public.stories;
CREATE POLICY "Users can insert stories" ON public.stories FOR INSERT WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users can update own stories" ON public.stories;
CREATE POLICY "Users can update own stories" ON public.stories FOR UPDATE USING (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users can delete own stories" ON public.stories;
CREATE POLICY "Users can delete own stories" ON public.stories FOR DELETE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Story views viewable by story creator" ON public.story_views;
CREATE POLICY "Story views viewable by story creator" ON public.story_views FOR SELECT USING (
    auth.uid() = user_id OR auth.uid() IN (SELECT s.user_id FROM public.stories s WHERE s.id = story_id)
);
DROP POLICY IF EXISTS "Users can record story view" ON public.story_views;
CREATE POLICY "Users can record story view" ON public.story_views FOR INSERT WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users can delete own story views" ON public.story_views;
CREATE POLICY "Users can delete own story views" ON public.story_views FOR DELETE USING (auth.uid() = user_id);
-- Note: Intentionally no UPDATE policy for story views as the record is immutable once created

-- --------------------------------------------------------------------
-- 9. BUSINESSES & CATEGORIES
-- --------------------------------------------------------------------
DROP POLICY IF EXISTS "Businesses viewable by everyone" ON public.businesses;
CREATE POLICY "Businesses viewable by everyone" ON public.businesses FOR SELECT USING (true);
DROP POLICY IF EXISTS "Users can insert businesses" ON public.businesses;
CREATE POLICY "Users can insert businesses" ON public.businesses FOR INSERT WITH CHECK (auth.uid() = owner_id);
DROP POLICY IF EXISTS "Owners can update businesses" ON public.businesses;
CREATE POLICY "Owners can update businesses" ON public.businesses FOR UPDATE USING (auth.uid() = owner_id);
DROP POLICY IF EXISTS "Owners can delete own businesses" ON public.businesses;
CREATE POLICY "Owners can delete own businesses" ON public.businesses FOR DELETE USING (auth.uid() = owner_id);

DROP POLICY IF EXISTS "Categories viewable by everyone" ON public.categories;
CREATE POLICY "Categories viewable by everyone" ON public.categories FOR SELECT USING (true);
DROP POLICY IF EXISTS "Users can insert categories" ON public.categories;
CREATE POLICY "Users can insert categories" ON public.categories FOR INSERT WITH CHECK (auth.role() = 'authenticated');
DROP POLICY IF EXISTS "Users can update own categories" ON public.categories;
CREATE POLICY "Users can update own categories" ON public.categories FOR UPDATE USING (auth.uid() = id);
DROP POLICY IF EXISTS "Users can delete own categories" ON public.categories;
CREATE POLICY "Users can delete own categories" ON public.categories FOR DELETE USING (auth.uid() = id);

-- --------------------------------------------------------------------
-- 10. COMMUNITIES & MEMBERS
-- --------------------------------------------------------------------
DROP POLICY IF EXISTS "Communities viewable by everyone" ON public.communities;
CREATE POLICY "Communities viewable by everyone" ON public.communities FOR SELECT USING (true);
DROP POLICY IF EXISTS "Users can create communities" ON public.communities;
CREATE POLICY "Users can create communities" ON public.communities FOR INSERT WITH CHECK (auth.uid() = creator_id);
DROP POLICY IF EXISTS "Users can update own communities" ON public.communities;
CREATE POLICY "Users can update own communities" ON public.communities FOR UPDATE USING (auth.uid() = creator_id);
DROP POLICY IF EXISTS "Users can delete own communities" ON public.communities;
CREATE POLICY "Users can delete own communities" ON public.communities FOR DELETE USING (auth.uid() = creator_id);

DROP POLICY IF EXISTS "Community members viewable by everyone" ON public.community_members;
CREATE POLICY "Community members viewable by everyone" ON public.community_members FOR SELECT USING (true);
DROP POLICY IF EXISTS "Users can join community" ON public.community_members;
CREATE POLICY "Users can join community" ON public.community_members FOR INSERT WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users can update own membership" ON public.community_members;
CREATE POLICY "Users can update own membership" ON public.community_members FOR UPDATE USING (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users can leave community" ON public.community_members;
CREATE POLICY "Users can leave community" ON public.community_members FOR DELETE USING (auth.uid() = user_id);

-- --------------------------------------------------------------------
-- 11. JOBS & APPLICATIONS
-- --------------------------------------------------------------------
DROP POLICY IF EXISTS "Jobs viewable by everyone" ON public.jobs;
CREATE POLICY "Jobs viewable by everyone" ON public.jobs FOR SELECT USING (true);
DROP POLICY IF EXISTS "Users can post jobs" ON public.jobs;
CREATE POLICY "Users can post jobs" ON public.jobs FOR INSERT WITH CHECK (auth.uid() = posted_by_id);
DROP POLICY IF EXISTS "Posters can update jobs" ON public.jobs;
CREATE POLICY "Posters can update jobs" ON public.jobs FOR UPDATE USING (auth.uid() = posted_by_id);
DROP POLICY IF EXISTS "Posters can delete own jobs" ON public.jobs;
CREATE POLICY "Posters can delete own jobs" ON public.jobs FOR DELETE USING (auth.uid() = posted_by_id);

DROP POLICY IF EXISTS "Applications viewable by applicant or job poster" ON public.job_applications;
CREATE POLICY "Applications viewable by applicant or job poster" ON public.job_applications FOR SELECT USING (
    auth.uid() = applicant_id OR auth.uid() = user_id OR auth.uid() IN (SELECT j.posted_by_id FROM public.jobs j WHERE j.id = job_id)
);
DROP POLICY IF EXISTS "Users can apply for jobs" ON public.job_applications;
CREATE POLICY "Users can apply for jobs" ON public.job_applications FOR INSERT WITH CHECK (auth.uid() = applicant_id OR auth.uid() = user_id);
DROP POLICY IF EXISTS "Applicants can update own applications" ON public.job_applications;
CREATE POLICY "Applicants can update own applications" ON public.job_applications FOR UPDATE USING (auth.uid() = applicant_id);
DROP POLICY IF EXISTS "Applicants can delete own applications" ON public.job_applications;
CREATE POLICY "Applicants can delete own applications" ON public.job_applications FOR DELETE USING (auth.uid() = applicant_id);

-- --------------------------------------------------------------------
-- 12. NOTIFICATIONS
-- --------------------------------------------------------------------
DROP POLICY IF EXISTS "Notifications viewable by recipient" ON public.notifications;
CREATE POLICY "Notifications viewable by recipient" ON public.notifications FOR SELECT USING (auth.uid() = recipient_id);
DROP POLICY IF EXISTS "System can insert notifications" ON public.notifications;
CREATE POLICY "System can insert notifications" ON public.notifications FOR INSERT WITH CHECK (auth.role() = 'authenticated' OR auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "Recipient can update notifications" ON public.notifications;
CREATE POLICY "Recipient can update notifications" ON public.notifications FOR UPDATE USING (auth.uid() = recipient_id);
DROP POLICY IF EXISTS "Recipient can delete notifications" ON public.notifications;
CREATE POLICY "Recipient can delete notifications" ON public.notifications FOR DELETE USING (auth.uid() = recipient_id);

-- --------------------------------------------------------------------
-- 13. LOCAL NEWS
-- --------------------------------------------------------------------
DROP POLICY IF EXISTS "Local news viewable by everyone" ON public.local_news;
CREATE POLICY "Local news viewable by everyone" ON public.local_news FOR SELECT USING (true);
DROP POLICY IF EXISTS "Users can insert local news" ON public.local_news;
CREATE POLICY "Users can insert local news" ON public.local_news FOR INSERT WITH CHECK (auth.role() = 'authenticated');
DROP POLICY IF EXISTS "Users can update own local news" ON public.local_news;
CREATE POLICY "Users can update own local news" ON public.local_news FOR UPDATE USING (auth.uid() = id);
DROP POLICY IF EXISTS "Users can delete own local news" ON public.local_news;
CREATE POLICY "Users can delete own local news" ON public.local_news FOR DELETE USING (auth.uid() = id);

-- --------------------------------------------------------------------
-- 14. SEARCH ANALYTICS
-- --------------------------------------------------------------------
DROP POLICY IF EXISTS "Trending searches viewable by everyone" ON public.search_trending;
CREATE POLICY "Trending searches viewable by everyone" ON public.search_trending FOR SELECT USING (true);
DROP POLICY IF EXISTS "System can update search trends" ON public.search_trending;
CREATE POLICY "System can update search trends" ON public.search_trending FOR UPDATE USING (auth.role() = 'authenticated');
DROP POLICY IF EXISTS "System can insert search trends" ON public.search_trending;
CREATE POLICY "System can insert search trends" ON public.search_trending FOR INSERT WITH CHECK (auth.role() = 'authenticated');
DROP POLICY IF EXISTS "System can delete old search trends" ON public.search_trending;
CREATE POLICY "System can delete old search trends" ON public.search_trending FOR DELETE USING (auth.role() = 'authenticated' AND search_count < 5);

-- --------------------------------------------------------------------
-- 15. USER SEARCHES
-- --------------------------------------------------------------------
DROP POLICY IF EXISTS "User search history viewable by owner" ON public.user_searches;
CREATE POLICY "User search history viewable by owner" ON public.user_searches FOR SELECT USING (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users can insert search history" ON public.user_searches;
CREATE POLICY "Users can insert search history" ON public.user_searches FOR INSERT WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users can update own search history" ON public.user_searches;
CREATE POLICY "Users can update own search history" ON public.user_searches FOR UPDATE USING (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users can delete own search history" ON public.user_searches;
CREATE POLICY "Users can delete own search history" ON public.user_searches FOR DELETE USING (auth.uid() = user_id);

-- --------------------------------------------------------------------
-- 16. CONVERSATIONS, PARTICIPANTS, MESSAGES, REACTIONS, TYPING
-- --------------------------------------------------------------------
DROP POLICY IF EXISTS "Participants can view conversations" ON public.conversations;
CREATE POLICY "Participants can view conversations" ON public.conversations FOR SELECT USING (
    auth.uid() IN (SELECT cp.user_id FROM public.conversation_participants cp WHERE cp.conversation_id = id)
);
DROP POLICY IF EXISTS "Authenticated users can create conversations" ON public.conversations;
CREATE POLICY "Authenticated users can create conversations" ON public.conversations FOR INSERT WITH CHECK (auth.role() = 'authenticated');
DROP POLICY IF EXISTS "Participants can update own conversations" ON public.conversations;
CREATE POLICY "Participants can update own conversations" ON public.conversations FOR UPDATE USING (
    auth.uid() IN (SELECT cp.user_id FROM public.conversation_participants cp WHERE cp.conversation_id = id)
);
DROP POLICY IF EXISTS "Participants can delete own conversations" ON public.conversations;
CREATE POLICY "Participants can delete own conversations" ON public.conversations FOR DELETE USING (
    auth.uid() IN (SELECT cp.user_id FROM public.conversation_participants cp WHERE cp.conversation_id = id)
);

DROP POLICY IF EXISTS "Participants can view conversation_participants" ON public.conversation_participants;
CREATE POLICY "Participants can view conversation_participants" ON public.conversation_participants FOR SELECT USING (
    auth.uid() IN (SELECT cp.user_id FROM public.conversation_participants cp WHERE cp.conversation_id = conversation_id)
);
DROP POLICY IF EXISTS "Users can join/add conversation participants" ON public.conversation_participants;
CREATE POLICY "Users can join/add conversation participants" ON public.conversation_participants FOR INSERT WITH CHECK (auth.role() = 'authenticated');
DROP POLICY IF EXISTS "Participants can update own participation" ON public.conversation_participants;
CREATE POLICY "Participants can update own participation" ON public.conversation_participants FOR UPDATE USING (auth.uid() = user_id);
DROP POLICY IF EXISTS "Participants can remove own participation" ON public.conversation_participants;
CREATE POLICY "Participants can remove own participation" ON public.conversation_participants FOR DELETE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Participants can view messages" ON public.messages;
CREATE POLICY "Participants can view messages" ON public.messages FOR SELECT USING (
    auth.uid() IN (SELECT cp.user_id FROM public.conversation_participants cp WHERE cp.conversation_id = conversation_id)
);
DROP POLICY IF EXISTS "Participants can send messages" ON public.messages;
CREATE POLICY "Participants can send messages" ON public.messages FOR INSERT WITH CHECK (
    auth.uid() = sender_id AND auth.uid() IN (SELECT cp.user_id FROM public.conversation_participants cp WHERE cp.conversation_id = conversation_id)
);
DROP POLICY IF EXISTS "Senders can update own messages" ON public.messages;
CREATE POLICY "Senders can update own messages" ON public.messages FOR UPDATE USING (auth.uid() = sender_id);
DROP POLICY IF EXISTS "Senders can delete own messages" ON public.messages;
CREATE POLICY "Senders can delete own messages" ON public.messages FOR DELETE USING (auth.uid() = sender_id);
-- Note: Messages also have system-generated updates (edits, deletes for everyone) handled separately

DROP POLICY IF EXISTS "Participants can view message receipts" ON public.message_receipts;
CREATE POLICY "Participants can view message receipts" ON public.message_receipts FOR SELECT USING (
    auth.uid() IN (SELECT cp.user_id FROM public.conversation_participants cp WHERE cp.conversation_id = (SELECT conversation_id FROM public.messages WHERE id = message_id))
);
DROP POLICY IF EXISTS "System can manage message receipts" ON public.message_receipts;
CREATE POLICY "System can manage message receipts" ON public.message_receipts FOR ALL USING (
    auth.uid() IN (SELECT cp.user_id FROM public.conversation_participants cp WHERE cp.conversation_id = (SELECT conversation_id FROM public.messages WHERE id = message_id))
);

DROP POLICY IF EXISTS "Participants can view message reactions" ON public.message_reactions;
CREATE POLICY "Participants can view message reactions" ON public.message_reactions FOR SELECT USING (
    auth.uid() IN (SELECT cp.user_id FROM public.conversation_participants cp WHERE cp.conversation_id = (SELECT conversation_id FROM public.messages WHERE id = message_id))
);
DROP POLICY IF EXISTS "Users can manage own reactions" ON public.message_reactions;
CREATE POLICY "Users can manage own reactions" ON public.message_reactions FOR ALL USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Participants can view typing indicators" ON public.typing_indicators;
CREATE POLICY "Participants can view typing indicators" ON public.typing_indicators FOR SELECT USING (
    auth.uid() IN (SELECT cp.user_id FROM public.conversation_participants cp WHERE cp.conversation_id = conversation_id)
);
DROP POLICY IF EXISTS "Users can manage own typing status" ON public.typing_indicators;
CREATE POLICY "Users can manage own typing status" ON public.typing_indicators FOR ALL USING (auth.uid() = user_id);

-- ====================================================================
-- END Migration 11
-- ====================================================================