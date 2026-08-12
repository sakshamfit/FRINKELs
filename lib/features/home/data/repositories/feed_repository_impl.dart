import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/failures/failure.dart';
import 'dart:async';
import '../../domain/entities/post.dart';
import '../../domain/entities/story.dart';
import '../../domain/entities/business.dart';
import '../../domain/entities/community.dart';
import '../../../jobs/domain/entities/job.dart';
import '../../domain/entities/local_news.dart';
import '../../../auth/domain/entities/user.dart' as auth_user;
import '../../domain/repositories/feed_repository.dart';

class FeedRepositoryImpl implements FeedRepository {
  final SupabaseClient _supabase;

  FeedRepositoryImpl(this._supabase);

  @override
  Future<Either<Failure, List<Post>>> getFeed({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('posts')
          .select('*, profiles(full_name, avatar_url, profession)')
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      final List<dynamic> data = response as List<dynamic>;
      final posts = data.map((json) {
        final profile = json['profiles'];
        return Post(
          id: json['id'],
          authorId: json['author_id'],
          authorName: profile['full_name'] ?? 'Anonymous',
          authorAvatarUrl: profile['avatar_url'],
          authorProfession: profile['profession'],
          content: json['content'] ?? '',
          imageUrls: List<String>.from(json['image_urls'] ?? []),
          type: PostType.values.firstWhere(
            (e) => e.name == (json['type'] ?? 'text'),
            orElse: () => PostType.text,
          ),
          likesCount: json['likes_count'] ?? 0,
          commentsCount: json['comments_count'] ?? 0,
          createdAt: DateTime.parse(json['created_at']),
        );
      }).toList();

      return Right(posts);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<Post>>> getFeedStream({int limit = 20}) async* {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        yield Left(AuthenticationFailure(message: 'User not authenticated'));
        return;
      }

      // Stream posts ordered by creation date (newest first)
      // We'll handle limiting in memory for simplicity, similar to chat implementation
      final stream = _supabase
          .from('posts')
          .stream(primaryKey: ['id'])
          .order('created_at', ascending: false);

      await for (final data in stream) {
        // Convert raw data to Post entities
        final posts = data.map((json) {
          final profile = json['profiles'] as Map<String, dynamic>?;
          return Post(
            id: json['id'] as String,
            authorId: json['author_id'] as String,
            authorName: (profile?['full_name'] as String?) ?? 'Anonymous',
            authorAvatarUrl: profile?['avatar_url'] as String?,
            authorProfession: profile?['profession'] as String?,
            content: json['content'] as String? ?? '',
            imageUrls: List<String>.from(json['image_urls'] ?? []),
            type: PostType.values.firstWhere(
              (e) => e.name == (json['type'] as String?),
              orElse: () => PostType.text,
            ),
            likesCount: (json['likes_count'] as int?) ?? 0,
            commentsCount: (json['comments_count'] as int?) ?? 0,
            createdAt: DateTime.parse(json['created_at'] as String),
          );
        }).toList();

        // Apply limit (take most recent posts)
        final limitedPosts = posts.take(limit).toList();
        yield Right(limitedPosts);
      }
    } catch (e) {
      yield Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<auth_user.User>>> getNearbyProfessionals() async {
    try {
      // Real implementation would use PostGIS or a specific RPC for location-based filtering
      // For now, we're getting onboarded users as a placeholder for "nearby"
      final response = await _supabase
          .from('profiles')
          .select('''
            id,
            email,
            full_name,
            username,
            profession,
            skills,
            interests,
            bio,
            location,
            availability,
            avatar_url,
            cover_url,
            email_verified,
            is_onboarded,
            created_at
          ''')
          .eq('is_onboarded', true)
          .limit(10);

      final List<dynamic> data = response as List<dynamic>;
      final users = data
          .map(
            (json) => auth_user.User(
              id: json['id'],
              email: json['email'] ?? '',
              name: json['full_name'],
              username: json['username'],
              profession: json['profession'],
              skills: List<String>.from(json['skills'] ?? []),
              interests: List<String>.from(json['interests'] ?? []),
              bio: json['bio'] ?? '',
              location: json['location'] ?? '',
              availability: json['availability'] ?? '',
              avatarUrl: json['avatar_url'],
              coverUrl: json['cover_url'],
              emailVerified: json['email_verified'] ?? false,
              isOnboarded: json['is_onboarded'] ?? false,
              createdAt: DateTime.parse(json['created_at']),
            ),
          )
          .toList();

      return Right(users);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> likePost(String postId) async {
    try {
      // Supabase logic for liking a post (e.g. inserting into a 'likes' table)
      await _supabase.from('post_likes').insert({
        'post_id': postId,
        'user_id': _supabase.auth.currentUser!.id,
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> bookmarkPost(String postId) async {
    try {
      await _supabase.from('post_bookmarks').insert({
        'post_id': postId,
        'user_id': _supabase.auth.currentUser!.id,
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Post>> createPost(
    String content, {
    List<String>? imageUrls,
    PostType type = PostType.text,
  }) async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      final response = await _supabase
          .from('posts')
          .insert({
            'author_id': userId,
            'content': content,
            'image_urls': imageUrls ?? [],
            'type': type.name,
          })
          .select('*, profiles(full_name, avatar_url, profession)')
          .single();

      final profile = response['profiles'];
      return Right(
        Post(
          id: response['id'],
          authorId: userId,
          authorName: profile['full_name'] ?? 'Me',
          authorAvatarUrl: profile['avatar_url'],
          authorProfession: profile['profession'],
          content: response['content'],
          imageUrls: List<String>.from(response['image_urls'] ?? []),
          type: type,
          createdAt: DateTime.parse(response['created_at']),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Story>>> getStories({String? userId}) async {
    try {
      final query = _supabase
          .from('stories')
          .select('*, profiles(full_name, avatar_url)');

      if (userId != null) {
        query.eq('user_id', userId);
      } else {
        // Get recent stories from users we follow or nearby users
        // For now, let's get recent stories from all users
        query.order('created_at', ascending: false);
      }

      final response = await query.limit(20);

      final List<dynamic> data = response as List<dynamic>;
      final stories = data.map((json) {
        final profile = json['profiles'];
        return Story(
          id: json['id'],
          userId: json['user_id'],
          userName: profile['full_name'] ?? 'Anonymous',
          userAvatarUrl: profile['avatar_url'],
          mediaUrl: json['media_url'],
          type: StoryType.values.firstWhere(
            (e) => e.name == (json['type'] ?? 'image'),
            orElse: () => StoryType.image,
          ),
          createdAt: DateTime.parse(json['created_at']),
          expiresAt: DateTime.parse(json['expires_at']),
          isViewed: json['is_viewed'] ?? false,
        );
      }).toList();

      return Right(stories);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Story>> createStory(
    String mediaUrl, {
    String? caption,
    StoryType type = StoryType.image,
  }) async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      final expiresAt = DateTime.now().add(
        Duration(hours: 24),
      ); // Stories expire in 24 hours

      final response = await _supabase
          .from('stories')
          .insert({
            'user_id': userId,
            'media_url': mediaUrl,
            'caption': caption,
            'type': type.name,
            'created_at': DateTime.now().toIso8601String(),
            'expires_at': expiresAt.toIso8601String(),
          })
          .select('*, profiles(full_name, avatar_url)')
          .single();

      final profile = response['profiles'];
      return Right(
        Story(
          id: response['id'],
          userId: userId,
          userName: profile['full_name'] ?? 'Me',
          userAvatarUrl: profile['avatar_url'],
          mediaUrl: response['media_url'],
          type: StoryType.values.firstWhere(
            (e) => e.name == (response['type'] ?? 'image'),
            orElse: () => StoryType.image,
          ),
          createdAt: DateTime.parse(response['created_at']),
          expiresAt: DateTime.parse(response['expires_at']),
          isViewed: false,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> viewStory(String storyId) async {
    try {
      await _supabase.from('story_views').insert({
        'story_id': storyId,
        'user_id': _supabase.auth.currentUser!.id,
        'viewed_at': DateTime.now().toIso8601String(),
      });

      // Also update the story to mark it as viewed by current user
      await _supabase
          .from('stories')
          .update({'is_viewed': true})
          .eq('id', storyId);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Business>>> getBusinesses({
    String? category,
    double? minRating,
  }) async {
    try {
      final query = _supabase.from('businesses').select('*, categories(name)');

      if (category != null && category.isNotEmpty) {
        query.eq('category', category);
      }

      if (minRating != null) {
        query.gte('rating', minRating);
      }

      final response = await query.limit(20);

      final List<dynamic> data = response as List<dynamic>;
      final businesses = data.map((json) {
        // Assuming categories is a separate table with a name field, we'll extract the category names
        final categoriesData = json['categories'] as List<dynamic>?;
        final List<String> categoryNames = categoriesData != null
            ? categoriesData.map((c) => c['name'] as String).toList()
            : [];

        return Business(
          id: json['id'],
          name: json['name'],
          description: json['description'] ?? '',
          category: json['category'] ?? '',
          address: json['address'] ?? '',
          phone: json['phone'] ?? '',
          website: json['website'] ?? '',
          imageUrl: json['image_url'] ?? '',
          coverImageUrl: json['cover_image_url'] ?? '',
          rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
          reviewCount: json['review_count'] as int? ?? 0,
          isOpen: json['is_open'] as bool? ?? false,
          isVerified: json['is_verified'] as bool? ?? false,
          categories: categoryNames,
          createdAt: DateTime.parse(json['created_at']),
        );
      }).toList();

      return Right(businesses);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Community>>> getCommunities({
    String? category,
    int? minMemberCount,
  }) async {
    try {
      final query = _supabase.from('communities').select('*');

      if (category != null && category.isNotEmpty) {
        query.eq('category', category);
      }

      if (minMemberCount != null) {
        query.gte('member_count', minMemberCount);
      }

      final response = await query.limit(20);

      final List<dynamic> data = response as List<dynamic>;
      final communities = data.map((json) {
        return Community(
          id: json['id'] as String,
          name: json['name'] as String,
          description: json['description'] as String,
          category: json['category'] as String,
          memberCount: json['member_count'] as int,
          isVerified: json['is_verified'] as bool,
          iconUrl: json['icon_url'] as String?,
          bannerUrl: json['banner_url'] as String?,
          createdAt: DateTime.parse(json['created_at']),
        );
      }).toList();

      return Right(communities);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Job>>> getJobs({
    String? category,
    double? minSalary,
  }) async {
    try {
      final query = _supabase.from('jobs').select('*');

      if (category != null && category.isNotEmpty) {
        // Assuming category is stored in a 'job_type' or similar field
        // Adjust based on your actual database schema
        query.eq('type', category);
      }

      if (minSalary != null) {
        // This is simplified - in reality you'd want to parse the salary string
        // For now we'll assume salary is stored as a numeric value or we'll filter in Dart
        query.gte('salary_min', minSalary.toString());
      }

      final response = await query.limit(20);

      final List<dynamic> data = response as List<dynamic>;
      final jobs = data.map((json) {
        return Job(
          id: json['id'] as String,
          title: json['title'] as String,
          companyName: json['company_name'] as String,
          companyLogoUrl: json['company_logo_url'] as String?,
          description: json['description'] as String,
          location: json['location'] as String,
          salary: json['salary'] as String,
          type: json['type'] as String,
          postedById: json['posted_by_id'] as String,
          status: JobStatus.fromString(json['status'] as String?),
          createdAt: DateTime.parse(json['created_at']),
        );
      }).toList();

      return Right(jobs);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LocalNews>>> getLocalNews({
    String? category,
    String? location,
  }) async {
    try {
      final query = _supabase.from('local_news').select('*');

      if (category != null && category.isNotEmpty) {
        query.eq('category', category);
      }

      if (location != null && location.isNotEmpty) {
        query.eq('location', location);
      }

      final response = await query
          .limit(20)
          .order('published_at', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      final newsItems = data.map((json) {
        return LocalNews(
          id: json['id'] as String,
          title: json['title'] as String,
          description: json['description'] ?? '',
          imageUrl: json['image_url'] as String?,
          source: json['source'] as String?,
          author: json['author'] as String?,
          category: json['category'] as String?,
          location: json['location'] as String?,
          publishedAt: DateTime.parse(json['published_at']),
          isTrending: json['is_trending'] as bool? ?? false,
        );
      }).toList();

      return Right(newsItems);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
