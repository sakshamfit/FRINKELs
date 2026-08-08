import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../../../../core/error/failures.dart';
import '../../../../core/models/search_result.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../home/domain/entities/post.dart';
import '../../../jobs/domain/entities/job.dart';

abstract class SearchRemoteDataSource {
  Future<List<User>> searchUsers(String query);
  Future<List<Post>> searchPosts(String query);
  Future<List<Job>> searchJobs(String query);
  Future<List<User>> searchProfessionals(String query);
  Future<List<User>> searchNearbyProfessionals({
    required String query,
    double? latitude,
    double? longitude,
    double radiusKm = 10,
  });
  Future<List<SearchResult>> getTrendingSearches();
  Future<List<String>> getRecentSearches(String userId);
  Future<void> saveSearch(String userId, String query);
  Future<void> clearSearchHistory(String userId);
}

class SupabaseSearchRemoteDataSource implements SearchRemoteDataSource {
  final SupabaseClient supabaseClient;

  SupabaseSearchRemoteDataSource(this.supabaseClient);

  User _mapSbUserToUser(Map<String, dynamic> data) {
    return User(
      id: data['id'],
      email: data['email'] ?? '',
      name: data['full_name'],
      username: data['username'],
      profession: data['profession'],
      avatarUrl: data['avatar_url'],
      isOnboarded: data['is_onboarded'] ?? false,
      createdAt: DateTime.parse(data['created_at']),
    );
  }

  Post _mapSbPostToPost(Map<String, dynamic> data) {
    final profile = data['profiles'] as Map<String, dynamic>?;
    return Post(
      id: data['id'],
      authorId: data['author_id'],
      authorName: profile?['full_name'] ?? 'Anonymous',
      authorAvatarUrl: profile?['avatar_url'],
      content: data['content'] ?? '',
      imageUrls: List<String>.from(data['image_urls'] ?? []),
      createdAt: DateTime.parse(data['created_at']),
    );
  }

  Job _mapSbJobToJob(Map<String, dynamic> data) {
    return Job(
      id: data['id'],
      title: data['title'],
      companyName: data['company_name'],
      description: data['description'],
      location: data['location'],
      salary: data['salary'],
      type: data['type'],
      postedById: data['posted_by_id'],
      createdAt: DateTime.parse(data['created_at']),
    );
  }

  @override
  Future<List<User>> searchUsers(String query) async {
    try {
      final response = await supabaseClient
          .from('profiles')
          .select('*')
          .ilike('full_name', '%$query%')
          .limit(20);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((u) => _mapSbUserToUser(u)).toList();
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<List<Post>> searchPosts(String query) async {
    try {
      final response = await supabaseClient
          .from('posts')
          .select('*, profiles(full_name, avatar_url)')
          .ilike('content', '%$query%')
          .limit(20);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((p) => _mapSbPostToPost(p)).toList();
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<List<Job>> searchJobs(String query) async {
    try {
      final response = await supabaseClient
          .from('jobs')
          .select('*')
          .ilike('title', '%$query%')
          .limit(20);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((j) => _mapSbJobToJob(j)).toList();
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<List<User>> searchProfessionals(String query) async {
    try {
      final response = await supabaseClient
          .from('profiles')
          .select('*')
          .ilike('profession', '%$query%')
          .limit(20);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((u) => _mapSbUserToUser(u)).toList();
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<List<User>> searchNearbyProfessionals({
    required String query,
    double? latitude,
    double? longitude,
    double radiusKm = 10,
  }) async {
    try {
      // For now, we'll do a simple text search and filter by proximity later
      // In a production app, we'd use PostGIS or similar for proper geo queries
      final response = await supabaseClient
          .from('profiles')
          .select('*')
          .ilike('profession', '%$query%')
          .limit(20);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((u) => _mapSbUserToUser(u)).toList();
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<List<SearchResult>> getTrendingSearches() async {
    try {
      // Get trending searches - for now, return empty list or recent popular searches
      // This would ideally query a search_analytics table
      final response = await supabaseClient
          .from('search_trending')
          .select('*')
          .limit(10);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((item) => SearchResult.fromJson(item)).toList();
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<List<String>> getRecentSearches(String userId) async {
    try {
      // This would query a user_searches table in a real implementation
      final response = await supabaseClient
          .from('user_searches')
          .select('query')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(10);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((item) => item['query'] as String).toList();
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<void> saveSearch(String userId, String query) async {
    try {
      // This would insert into a user_searches table in a real implementation
      await supabaseClient.from('user_searches').insert({
        'user_id': userId,
        'query': query,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<void> clearSearchHistory(String userId) async {
    try {
      // This would delete from a user_searches table in a real implementation
      await supabaseClient.from('user_searches').delete().eq('user_id', userId);
    } catch (e) {
      throw ServerFailure();
    }
  }
}
