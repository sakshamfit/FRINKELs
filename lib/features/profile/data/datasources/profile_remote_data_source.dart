import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/profile.dart';
import '../../domain/entities/user_profile.dart';

class ProfileRemoteDataSource {
  final SupabaseClient _supabase;

  ProfileRemoteDataSource(this._supabase);

  Future<Profile> getProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('*')
          .eq('id', userId)
          .single();

      final Map<String, dynamic> data = response;
      return Profile.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  Future<UserProfile> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('*, followers_count, following_count, posts_count')
          .eq('id', userId)
          .single();

      final Map<String, dynamic> data = response;
      return UserProfile.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load user profile: $e');
    }
  }

  Future<void> updateProfile(Profile profile) async {
    try {
      await _supabase
          .from('profiles')
          .update(profile.toJson())
          .eq('id', profile.id);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> updateUserProfile(UserProfile userProfile) async {
    try {
      await _supabase
          .from('profiles')
          .update(userProfile.toJson())
          .eq('id', userProfile.id);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  Future<void> updateProfilePicture(String filePath) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final fileName = 'profile_pics/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await _supabase.storage.from('profile_photos').upload(fileName, File(filePath));

      final publicUrl = _supabase.storage.from('profile_photos').getPublicUrl(fileName);

      await _supabase
          .from('profiles')
          .update({'avatar_url': publicUrl})
          .eq('id', userId);
    } catch (e) {
      throw Exception('Failed to update profile picture: $e');
    }
  }

  Future<void> updateCoverPhoto(String filePath) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final fileName = 'cover_photos/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await _supabase.storage.from('cover_photos').upload(fileName, File(filePath));

      final publicUrl = _supabase.storage.from('cover_photos').getPublicUrl(fileName);

      await _supabase
          .from('profiles')
          .update({'cover_url': publicUrl})
          .eq('id', userId);
    } catch (e) {
      throw Exception('Failed to update cover photo: $e');
    }
  }

  Future<void> followUser(String userId) async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      await _supabase.from('follows').insert({
        'follower_id': currentUserId,
        'followed_id': userId,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to follow user: $e');
    }
  }

  Future<void> unfollowUser(String userId) async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      await _supabase
          .from('follows')
          .delete()
          .eq('follower_id', currentUserId)
          .eq('followed_id', userId);
    } catch (e) {
      throw Exception('Failed to unfollow user: $e');
    }
  }

  Future<bool> isFollowing(String userId) async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('follows')
          .select('*')
          .eq('follower_id', currentUserId)
          .eq('followed_id', userId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw Exception('Failed to check follow status: $e');
    }
  }

  Future<int> getFollowersCount(String userId) async {
    try {
      final response = await _supabase
          .from('follows')
          .select('*')
          .eq('followed_id', userId)
          .count(CountOption.exact);

      return response.count;
    } catch (e) {
      throw Exception('Failed to get followers count: $e');
    }
  }

  Future<int> getFollowingCount(String userId) async {
    try {
      final response = await _supabase
          .from('follows')
          .select('*')
          .eq('follower_id', userId)
          .count(CountOption.exact);

      return response.count;
    } catch (e) {
      throw Exception('Failed to get following count: $e');
    }
  }

  Future<List<Profile>> getFollowers(
      String userId, {
      int limit = 20,
      int offset = 0,
    }) async {
    try {
      final response = await _supabase
          .from('follows')
          .select('follower:profiles(*)')
          .eq('followed_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      final List<dynamic> data = response;
      return data
          .map((follow) => Profile.fromJson(follow['follower']))
          .toList();
    } catch (e) {
      throw Exception('Failed to get followers: $e');
    }
  }

  Future<List<Profile>> getFollowing(
      String userId, {
      int limit = 20,
      int offset = 0,
    }) async {
    try {
      final response = await _supabase
          .from('follows')
          .select('followed:profiles(*)')
          .eq('follower_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      final List<dynamic> data = response;
      return data
          .map((follow) => Profile.fromJson(follow['followed']))
          .toList();
    } catch (e) {
      throw Exception('Failed to get following: $e');
    }
  }

  Future<List<Profile>> searchProfiles(String query) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('*')
          .ilike('name', '%$query%')
          .or('username.ilike.%$query%,bio.ilike.%$query%')
          .limit(20);

      final List<dynamic> data = response;
      return data.map((profile) => Profile.fromJson(profile)).toList();
    } catch (e) {
      throw Exception('Failed to search profiles: $e');
    }
  }

  Future<List<Profile>> getSuggestedProfiles({int limit = 10}) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        final response = await _supabase
            .from('profiles')
            .select('*')
            .order('followers_count', ascending: false)
            .limit(limit);

        final List<dynamic> data = response;
        return data.map((profile) => Profile.fromJson(profile)).toList();
      }

      final response = await _supabase.rpc('get_suggested_profiles', params: {
        'user_id': userId,
        'limit': limit,
      });

      final List<dynamic> data = response;
      return data.map((profile) => Profile.fromJson(profile)).toList();
    } catch (e) {
      throw Exception('Failed to get suggested profiles: $e');
    }
  }

  Future<List<Profile>> getNearbyProfiles({
    double? latitude,
    double? longitude,
    double radiusKm = 10,
    int limit = 20,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.rpc('get_nearby_profiles', params: {
        'user_id': userId,
        'latitude': latitude,
        'longitude': longitude,
        'radius_km': radiusKm,
        'limit': limit,
      });

      final List<dynamic> data = response;
      return data.map((profile) => Profile.fromJson(profile)).toList();
    } catch (e) {
      throw Exception('Failed to get nearby profiles: $e');
    }
  }
}
