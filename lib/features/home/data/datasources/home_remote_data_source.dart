import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/post.dart';

abstract class HomeRemoteDataSource {
  Future<List<Post>> getFeed({int limit = 20, int offset = 0});
  Future<Post> createPost(String content, List<String> imageUrls);
  Future<void> likePost(String postId);
  Future<void> unlikePost(String postId);
  Future<void> bookmarkPost(String postId);
  
  // Profile methods
  Future<User> getProfile(String userId);
  Future<List<User>> getNearbyProfessionals({double? latitude, double? longitude, double radiusKm = 10});
  Future<List<User>> getTrendingProfessionals();
}

class SupabaseHomeRemoteDataSource implements HomeRemoteDataSource {
  final SupabaseClient supabaseClient;

  SupabaseHomeRemoteDataSource(this.supabaseClient);

  User _mapSbUserToUser(Map<String, dynamic> metadata, String id, String email, String createdAt, {DateTime? emailConfirmedAt}) {
    return User(
      id: id,
      email: email,
      name: metadata['full_name'] as String?,
      username: metadata['username'] as String?,
      profession: metadata['profession'] as String?,
      skills: (metadata['skills'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      interests: (metadata['interests'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      bio: metadata['bio'] as String?,
      location: metadata['location'] as String?,
      availability: metadata['availability'] as String?,
      avatarUrl: metadata['avatar_url'] as String?,
      coverUrl: metadata['cover_url'] as String?,
      emailVerified: emailConfirmedAt != null,
      isOnboarded: metadata['is_onboarded'] as bool? ?? false,
      createdAt: DateTime.parse(createdAt),
    );
  }

  @override
  Future<User> getProfile(String userId) async {
    final response = await supabaseClient
        .from('profiles')
        .select('*')
        .eq('id', userId)
        .single();
    
    // Profiles table might have different structure than auth metadata
    // but we aim to keep them in sync via triggers.
    return _mapSbUserToUser(response, response['id'], response['email'] ?? '', response['created_at']);
  }

  @override
  Future<List<User>> getNearbyProfessionals({double? latitude, double? longitude, double radiusKm = 10}) async {
    // This would ideally use a PostGIS RPC function in Supabase
    // For now, let's just fetch all onboarded professionals
    final response = await supabaseClient
        .from('profiles')
        .select('*')
        .eq('is_onboarded', true)
        .limit(10);
    
    final List<dynamic> data = response as List<dynamic>;
    return data.map((u) => _mapSbUserToUser(u, u['id'], u['email'] ?? '', u['created_at'])).toList();
  }

  @override
  Future<List<User>> getTrendingProfessionals() async {
    final response = await supabaseClient
        .from('profiles')
        .select('*')
        .eq('is_onboarded', true)
        .order('rating', ascending: false)
        .limit(10);
    
    final List<dynamic> data = response as List<dynamic>;
    return data.map((u) => _mapSbUserToUser(u, u['id'], u['email'] ?? '', u['created_at'])).toList();
  }

  @override
  Future<List<Post>> getFeed({int limit = 20, int offset = 0}) async {
    final response = await supabaseClient
        .from('posts')
        .select('*, profiles(full_name, avatar_url), likes:likes(count), bookmarks:bookmarks(count)')
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    final List<dynamic> data = response as List<dynamic>;
    return data.map((post) {
      final profile = post['profiles'] as Map<String, dynamic>;
      return Post(
        id: post['id'] as String,
        authorId: post['author_id'] as String,
        authorName: profile['full_name'] as String? ?? 'Anonymous',
        authorAvatarUrl: profile['avatar_url'] as String?,
        content: post['content'] as String,
        imageUrls: (post['image_urls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        likesCount: (post['likes'] as List<dynamic>).isNotEmpty ? post['likes'][0]['count'] as int : 0,
        commentsCount: post['comments_count'] as int? ?? 0,
        isLiked: false, // Would need a join with current user
        isBookmarked: false, // Would need a join with current user
        createdAt: DateTime.parse(post['created_at'] as String),
      );
    }).toList();
  }

  @override
  Future<Post> createPost(String content, List<String> imageUrls) async {
    final userId = supabaseClient.auth.currentUser!.id;
    final response = await supabaseClient
        .from('posts')
        .insert({
          'author_id': userId,
          'content': content,
          'image_urls': imageUrls,
        })
        .select('*, profiles(full_name, avatar_url)')
        .single();

    final profile = response['profiles'] as Map<String, dynamic>;
    return Post(
      id: response['id'] as String,
      authorId: response['author_id'] as String,
      authorName: profile['full_name'] as String? ?? 'Anonymous',
      authorAvatarUrl: profile['avatar_url'] as String?,
      content: response['content'] as String,
      imageUrls: (response['image_urls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: DateTime.parse(response['created_at'] as String),
    );
  }

  @override
  Future<void> likePost(String postId) async {
    final userId = supabaseClient.auth.currentUser!.id;
    await supabaseClient.from('likes').insert({
      'post_id': postId,
      'user_id': userId,
    });
  }

  @override
  Future<void> unlikePost(String postId) async {
    final userId = supabaseClient.auth.currentUser!.id;
    await supabaseClient.from('likes').delete().match({
      'post_id': postId,
      'user_id': userId,
    });
  }

  @override
  Future<void> bookmarkPost(String postId) async {
    final userId = supabaseClient.auth.currentUser!.id;
    await supabaseClient.from('bookmarks').upsert({
      'post_id': postId,
      'user_id': userId,
    });
  }
}
