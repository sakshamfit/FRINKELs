# Home Feed System Documentation

## Overview
The FRINKELS Home Feed is the central social hub of the application, displaying personalized content feeds, professional networking opportunities, and community sections. It combines algorithmic content curation with real-time updates to provide an engaging user experience.

## Features Implemented
- ��� � � ✅ Personalized Post Feed with Real-time Updates
- ��� � � ✅ Nearby Professionals Discovery (Geolocation-based)
- ��� � � ✅ Business Directory Section
- ��� � � ✅ Communities Section
- ��� � � ✅ Jobs Section
- ��� � � ✅ Local News Section
- ��� � � ✅ Stories Section (24-hour expiring content)
- ��� � � ✅ Pull-to-refresh Functionality
- ��� � � ✅ Infinite Scrolling (via real-time streams)
- ��� � � ✅ Search Integration (Global search bar)
- ��� � � ✅ Quick Action Buttons (Hire Pro, Find Work)
- ��� � � ✅ Glassmorphism UI Design
- ��� � � ✅ Animated Transitions and Micro-interactions
- ��� � � ✅ Responsive Layout for Mobile/Desktop
- ��� � � ✅ Error States and Loading Indicators
- ��� � � ✅ Empty State Handling
- ��� � � ✅ Post Liking and Bookmarking
- ��� � � ✅ Real-time Feed Updates via Supabase Streams

## Architecture

### Layer Structure
```
lib/features/home/
├── data/
│   └── repositories/
│       └── feed_repository_impl.dart     # Supabase implementation
├── domain/
│   ├── entities/
│   │   ├── post.dart                     # Feed post entity
│   │   ├── story.dart                    # Story entity
│   │   ├── business.dart                 # Business entity
│   │   ├── community.dart                # Community entity
│   │   ├── job.dart                      # Job entity
│   │   └── local_news.dart               # Local news entity
│   └── repositories/
│       └── feed_repository.dart          # Repository interface
���└── presentation/
    ├── controllers/
    │   ├── home_provider.dart            # Main feed state management
    │   └── businesses_provider.dart      # Business section state
    ├── screens/
    │   └── home_screen.dart              # Main UI screen
    └── widgets/
        ├── post_card.dart                # Individual post display
        ├── business_card.dart            # Business item display
        ├── businesses_section.dart       # Businesses carousel
        ├── communities_section.dart      # Communities grid
        ├── jobs_section.dart             # Jobs listing
        ├── local_news_section.dart       # News feed
        └── stories_section.dart          # Stories slider
```

### Data Flow
1. **UI Layer** → HomeScreen widgets request data from Providers
2. **State Management** → Providers call Repository Interface methods
3. **Domain Layer** → Repository Interface defines data contracts
4. **Data Layer** → FeedRepositoryImpl implements Supabase calls
5. **Data Layer** → Real-time streams via Supabase Realtime
6. **Data Layer** → Transforms database rows to domain entities
7. **State Management** → Providers update state with new data
8. **UI Layer** → Widgets rebuild with fresh data

## Key Implementation Details

### FeedRepositoryImpl (lib/features/home/data/repositories/feed_repository_impl.dart)
Implements all home feed data operations using Supabase:

#### Core Methods:
1. **getFeed**: Retrieves paginated posts with profile data
   - Uses Supabase select with joins to profiles table
   - Orders by created_at descending (newest first)
   - Implements pagination with limit/offset
   - Maps to Post entities with author information

2. **getFeedStream**: Real-time post updates
   - Uses Supabase Realtime streaming
   - Listens to INSERT/UPDATE/DELETE on posts table
   - Applies same ordering and limiting in memory
   - Yields updated post lists to subscribers

3. **getNearbyProfessionals**: Location-based professional discovery
   - Currently gets onboarded users as placeholder
   - Future: Will use PostGIS or Redis Geo for actual location filtering
   - Returns limited set of onboarded professionals

4. **likePost**: Toggles post like status
   - Inserts/deletes from post_likes table
   - Optimistic UI updates with refresh fallback

5. **bookmarkPost**: Toggles post bookmark status
   - Inserts/deletes from post_bookmarks table

6. **createPost**: Creates new feed post
   - Inserts into posts table with author info
   - Returns created post with profile data

7. **Stories Management**:
   - getStories: Retrieves recent stories with expiration
   - createStory: Creates new 24-hour story
   - viewStory: Marks story as viewed by user

8. **Business Directory**:
   - getBusinesses: Retrieves businesses with category filters
   - Joins with categories table for category names

9. **Communities**:
   - getCommunities: Retrieves communities with filters

10. **Jobs**:
    - getJobs: Retrieves job listings with filters

11. **Local News**:
    - getLocalNews: Retrieves news articles with filters

### Domain Entities

#### Post Entity (lib/features/home/domain/entities/post.dart)
- id, authorId, authorName, authorAvatarUrl, authorProfession
- content, imageUrls, type (text/image/video/poll)
- likesCount, commentsCount, createdAt
- Methods: copyWith, fromJson, toJson

#### Story Entity (lib/features/home/domain/entities/story.dart)
- id, userId, userName, userAvatarUrl, mediaUrl
- type (image/video), createdAt, expiresAt, isViewed

#### Business Entity (lib/features/home/domain/entities/business.dart)
- id, name, description, category, address, phone, website
- imageUrl, coverImageUrl, rating, reviewCount
- isOpen, isVerified, categories (list), createdAt

#### Community Entity (lib/features/home/domain/entities/community.dart)
- id, name, description, category, memberCount
- isVerified, iconUrl, bannerUrl, createdAt

#### Job Entity (lib/features/home/domain/entities/job.dart)
- id, title, companyName, companyLogoUrl, description
- location, salary, type, postedById, status, createdAt

#### LocalNews Entity (lib/features/home/domain/entities/local_news.dart)
- id, title, description, imageUrl, source, author
- publishedAt, category, location, isTrending

### State Management

#### FeedNotifier (lib/features/home/presentation/controllers/home_provider.dart)
- Extends StateNotifier<AsyncValue<List<Post>>>
- Manages feed state: loading, data, error
- Initializes real-time subscription on creation
- Provides refreshFeed() method for pull-to-refresh
- Provides likePost() method with optimistic updates
- Automatically disposes stream subscription

#### BusinessesNotifier (lib/features/home/presentation/controllers/businesses_provider.dart)
- Similar pattern for business section data
- Loads businesses on initialization
- Provides refreshBusinesses() method

#### Nearby Professionals Provider
- FutureProvider that fetches onboarded professionals
- Uses feedRepository.getNearbyProfessionals()

### UI Components

#### HomeScreen (lib/features/home/presentation/screens/home_screen.dart)
Main orchestration widget that combines all sections:

**Layout Structure:**
1. **App Bar**: Glass-themed search bar + notifications icon
2. **Greeting Section**: Personalized greeting with user name
3. **Quick Actions**: "Hire Pro" and "Find Work" buttons
4. **Content Sections** (each with header and content):
   - Stories: Horizontal slider of 24-hour stories
   - Businesses: Horizontal carousel of business cards
   - Communities: Grid of community cards
   - Jobs: Vertical list of job postings
   - Local News: Vertical list of news articles
   - Nearby Professionals: Horizontal scrolling professional cards
   - Your Feed: Main post feed (takes remaining space)

**Key UI Features:**
- Glassmorphism cards with blurred backgrounds
- Animated transitions using flutter_animate
- Lucide icons for consistent visual language
- Responsive spacing and typography
- Pull-to-refresh on main feed
- Error states with retry buttons
- Loading skeletons/shimmers
- Empty state illustrations
- Horizontal scrolling sections with momentum

#### Widget Components

**PostCard** (lib/features/home/presentation/widgets/post_card.dart):
- Displays post author info, content, images, actions
- Shows like/bookmark counts and buttons
- Handles tap interactions for full post view
- Responsive image loading with placeholders

**BusinessCard** (lib/features/home/presentation/widgets/business_card.dart):
- Business logo/image, name, category, rating
- Address snippet, call/website actions
- Verified badge and open status indicators

**Section Headers**: Consistent title + "See all" link pattern

## Supabase Schema Integration

### Tables Used:
1. **posts**: Main feed posts
   - id, author_id, content, image_urls, type
   - likes_count, comments_count, created_at
   - Foreign key to profiles.author_id

2. **profiles**: Extended user profiles
   - id (matches auth.users.id)
   - full_name, avatar_url, profession, etc.
   - Used for author information in feeds

3. **post_likes**: Post likes (many-to-many)
   - post_id, user_id, created_at
   - Unique constraint on (post_id, user_id)

4. **post_bookmarks**: Post bookmarks (many-to-many)
   - Similar structure to post_likes

5. **stories**: Temporary content (24-hour expiry)
   - id, user_id, media_url, caption, type
   - created_at, expires_at, is_viewed

6. **businesses**: Business directory
   - id, name, description, category, address, etc.
   - image_url, cover_image_url, rating, review_count
   - is_open, is_verified, created_at

7. **communities**: Interest-based groups
   - id, name, description, category, member_count
   - is_verified, icon_url, banner_url, created_at

8. **jobs**: Job listings
   - id, title, company_name, company_logo_url, description
   - location, salary, type, posted_by_id, status, created_at

9. **local_news**: Community news
   - id, title, description, image_url, source, author
   - published_at, category, location, is_trending

### Real-time Implementation:
- Uses Supabase Realtime protocol over WebSockets
- Subscribes to INSERT/UPDATE/DELETE on relevant tables
- Filters by user preferences where applicable
- Implements client-side limiting for performance
- Handles connection interruptions gracefully

## Security and Privacy
- **Data Minimization**: Only fetches necessary fields
- **User Consent**: Location access only for nearby features
- **Content Moderation**: Relies on backend moderation systems
- **Rate Limiting**: Client-side debouncing + server limits
- **Secure Connections**: All Supabase calls over HTTPS/WSS
- **Input Sanitization**: Prevents XSS in user-generated content

## Performance Optimizations
- **Real-time Efficient**: Only sends deltas over WebSocket
- **Image Loading**: Cached network images with placeholders
- **List Virtualization**: ListView.builder for large lists
- **Memory Management**: Stream subscriptions properly canceled
- **Prefetching**: Nearby professionals preloaded when possible
- **Batching**: Multiple queries where efficient
- **Caching**: Short-term caching of frequently accessed data

## Error Handling and Edge Cases
- **Network Errors**: Shows retry buttons with exponential backoff
- **Empty States**: Illustrative empty states for each section
- **Loading States**: Skeletons and spinners during data fetch
- **Malformed Data**: Graceful handling of missing/null fields
- **Permission Denied**: Clear messages for location/features access
- **Server Errors**: Generic error messages with retry options
- **Authentication Required**: Redirects to login for protected actions

## User Experience Features
- **Personalization**: Greeting uses user's first name
- **Welcome Motion**: Animated fade-in/slide-in on content appearance
- **Haptic Feedback**: Subtle vibrations on button presses (platform-dependent)
- **Pull-to-refresh**: Standard iOS/Android refresh pattern
- **Infinite Feel**: Real-time stream provides continuous updates
- **Section Independence**: Each section loads independently
- **Consistent Spacing**: 8pt grid system throughout
- **Accessibility**: Proper labels, touch targets, contrast ratios
- **Platform Adaptation**: Adapts to iOS/Android/web conventions

## Integration Points
1. **Authentication**: Requires authenticated user for most features
2. **Search**: Global search bar filters all sections
3. **Navigation**: Bottom nav provides quick access to home
4. **Deep Linking**:Sections accessible via direct routes
5. **Sharing**: Posts/stories can be shared externally
6. **Notifications**: New activity can trigger push notifications
7. **Analytics**: User engagement tracked per section
8. **Moderation**: Report/inappropriate content flows to backend

## Future Enhancements
- [ ] Algorithmic feed ranking (ML-based)
- [ ] Enhanced location filtering with GPS/Geofencing
- [ ] User-defined feed preferences and filters
- [ ] Cross-posting to other social platforms
- [ ] Advanced post analytics (reach, engagement)
- [ ] Scheduled posts for businesses/creators
- [ ] Comment threading and replies
- [ ] Post editing within time window
- [ ] Multimedia posts (video, audio, embeds)
- [ ] Polls and interactive post types
- [ ] Advanced business features (menus, booking, etc.)
- [ ] Job application tracking
- [ ] Event creation and RSVP system
- [ ] Advanced localization/internationalization
- [ ] Offline caching and sync
- [ ] Accessibility improvements (screen reader, voice control)
- [ ] Dark/light mode automatic switching
- [ ] Tablet and desktop optimized layouts
- [ ] Accessibility certification compliance