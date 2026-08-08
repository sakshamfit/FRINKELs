# FRINKELs API & Data Source Index (`API_INDEX.md`)

This document indexes all remote data sources, repositories, Supabase RPC stored procedures, Edge Functions, and storage APIs within FRINKELs.

---

## 📡 Remote Data Sources Index

1. **`AuthRemoteDataSource`**: `signInWithEmail()`, `signUpWithEmail()`, `signOut()`, `getCurrentUser()`.
2. **`ProfileRemoteDataSource`**: `getProfile()`, `getUserProfile()`, `updateProfile()`, `updateProfilePicture()`, `followUser()`, `unfollowUser()`, `getFollowers()`, `getFollowing()`, `getSuggestedProfiles()`, `getNearbyProfiles()`.
3. **`HomeRemoteDataSource`**: `getFeed()`, `createPost()`, `likePost()`, `unlikePost()`, `bookmarkPost()`.
4. **`ChatRemoteDataSource`**: `getMessages()`, `sendMessage()`, `markAsDelivered()`, `markAsRead()`, `sendTypingIndicator()`, `updatePresence()`, `reactToMessage()`, `editMessage()`, `deleteMessage()`, `pinMessage()`.
5. **`JobRemoteDataSource`**: `getJobs()`, `postJob()`, `applyForJob()`.
6. **`NotificationRemoteDataSource`**: `getNotifications()`, `getUnreadCount()`, `markAsRead()`, `markAllAsRead()`, `deleteNotification()`.
7. **`SearchRemoteDataSource`**: `searchUsers()`, `searchPosts()`, `searchJobs()`, `searchProfessionals()`, `getTrendingSearches()`, `getRecentSearches()`, `saveSearch()`, `clearSearchHistory()`.
8. **`StorageService`**: `uploadFile()`, `uploadFileWithProgress()`, `downloadFile()`, `deleteFile()`, `getPublicUrl()`.

---

## ⚡ Stored Procedures & Edge Functions Index

| Name | Type | Signature | Description |
|---|---|---|---|
| `get_suggested_profiles` | Postgres RPC | `(user_id UUID, limit INT)` | Returns suggested profiles for user |
| `get_nearby_profiles` | Postgres RPC | `(user_id UUID, lat FLOAT, lng FLOAT, radius FLOAT, limit INT)` | Spatial Haversine distance proximity query |
| `global_search` | Postgres RPC | `(search_query TEXT, filter_category TEXT, result_limit INT)` | Multi-entity full-text hybrid search |
| `/ai-chat-stream` | Edge Function | `POST { prompt, conversation_history }` | Server-Sent Event (SSE) AI streaming endpoint |
| `/ai-greeting` | Edge Function | `POST { user_id }` | Generates dynamic personalized daily greeting |
| `/ai-match-jobs` | Edge Function | `POST { user_id, job_id }` | Computes candidate-job vector similarity |
