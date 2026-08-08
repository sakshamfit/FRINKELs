import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/profile.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../../auth/presentation/controllers/auth_provider.dart';

// Remote data source provider
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return ProfileRemoteDataSource(supabase);
});

// State provider for the profile repository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remoteDataSource = ref.watch(profileRemoteDataSourceProvider);
  return ProfileRepositoryImpl(remoteDataSource);
});

// State provider for user profile data
final userProfileProvider =
    StateNotifierProviderFamily<UserProfileNotifier, AsyncValue<UserProfile?>, String>(
  (ref, userId) {
    final repository = ref.watch(profileRepositoryProvider);
    return UserProfileNotifier(repository, userId);
  },
);

// State provider for profile list (for search, suggestions, etc.)
final profilesProvider =
    StateNotifierProvider<ProfilesNotifier, AsyncValue<List<Profile>>>(
  (ref) {
    final repository = ref.watch(profileRepositoryProvider);
    return ProfilesNotifier(repository);
  },
);

// State provider for follow/unfollow actions
final followProvider =
    StateNotifierProviderFamily<FollowNotifier, AsyncValue<bool>, String>((ref, userId) {
  final repository = ref.watch(profileRepositoryProvider);
  return FollowNotifier(repository, userId);
});

// State provider for follower/following lists
final followersProvider =
    StateNotifierProviderFamily<FollowersNotifier, AsyncValue<List<Profile>>, String>(
  (ref, userId) {
    final repository = ref.watch(profileRepositoryProvider);
    return FollowersNotifier(repository, userId);
  },
);

final followingProvider =
    StateNotifierProviderFamily<FollowingNotifier, AsyncValue<List<Profile>>, String>(
  (ref, userId) {
    final repository = ref.watch(profileRepositoryProvider);
    return FollowingNotifier(repository, userId);
  },
);

// StateNotifier for user profile data
class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final ProfileRepository _repository;
  final String _userId;

  UserProfileNotifier(this._repository, this._userId) : super(const AsyncLoading()) {
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    state = const AsyncLoading();
    final result = await _repository.getUserProfile(_userId);
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (profile) => state = AsyncData(profile),
    );
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    state = const AsyncLoading();
    final result = await _repository.updateUserProfile(profile);
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (_) => state = AsyncData(profile),
    );
  }

  void refresh() {
    loadUserProfile();
  }
}

// StateNotifier for list of profiles (search, suggestions, etc.)
class ProfilesNotifier extends StateNotifier<AsyncValue<List<Profile>>> {
  final ProfileRepository _repository;

  ProfilesNotifier(this._repository) : super(const AsyncData([]));

  Future<void> searchProfiles(String query) async {
    if (query.isEmpty) {
      state = const AsyncData([]);
      return;
    }

    state = const AsyncLoading();
    final result = await _repository.searchProfiles(query);
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (profiles) => state = AsyncData(profiles),
    );
  }

  Future<void> loadSuggestedProfiles({int limit = 10}) async {
    state = const AsyncLoading();
    final result = await _repository.getSuggestedProfiles(limit: limit);
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (profiles) => state = AsyncData(profiles),
    );
  }

  Future<void> loadNearbyProfiles({
    double? latitude,
    double? longitude,
    double radiusKm = 10,
    int limit = 20,
  }) async {
    state = const AsyncLoading();
    final result = await _repository.getNearbyProfiles(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
      limit: limit,
    );
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (profiles) => state = AsyncData(profiles),
    );
  }

  void clear() {
    state = const AsyncData([]);
  }
}

// StateNotifier for follow/unfollow actions
class FollowNotifier extends StateNotifier<AsyncValue<bool>> {
  final ProfileRepository _repository;
  final String _targetUserId;

  FollowNotifier(this._repository, this._targetUserId) : super(const AsyncLoading()) {
    checkFollowStatus();
  }

  Future<void> followUser() async {
    state = const AsyncLoading();
    final result = await _repository.followUser(_targetUserId);
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (_) => state = const AsyncData(true),
    );
  }

  Future<void> unfollowUser() async {
    state = const AsyncLoading();
    final result = await _repository.unfollowUser(_targetUserId);
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (_) => state = const AsyncData(false),
    );
  }

  Future<void> checkFollowStatus() async {
    state = const AsyncLoading();
    final result = await _repository.isFollowing(_targetUserId);
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (isFollowing) => state = AsyncData(isFollowing),
    );
  }
}

// StateNotifier for followers list
class FollowersNotifier extends StateNotifier<AsyncValue<List<Profile>>> {
  final ProfileRepository _repository;
  final String _userId;

  FollowersNotifier(this._repository, this._userId) : super(const AsyncLoading()) {
    loadFollowers();
  }

  Future<void> loadFollowers({int limit = 20, int offset = 0}) async {
    state = const AsyncLoading();
    final result = await _repository.getFollowers(_userId, limit: limit, offset: offset);
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (followers) => state = AsyncData(followers),
    );
  }

  Future<void> loadMoreFollowers({int limit = 20}) async {
    if (state.value == null || state.isLoading) return;

    final currentState = state.value!;
    final currentOffset = currentState.length;
    
    final result = await _repository.getFollowers(_userId, limit: limit, offset: currentOffset);
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (moreFollowers) => state = AsyncData([...currentState, ...moreFollowers]),
    );
  }

  void refresh() {
    loadFollowers();
  }
}

// StateNotifier for following list
class FollowingNotifier extends StateNotifier<AsyncValue<List<Profile>>> {
  final ProfileRepository _repository;
  final String _userId;

  FollowingNotifier(this._repository, this._userId) : super(const AsyncLoading()) {
    loadFollowing();
  }

  Future<void> loadFollowing({int limit = 20, int offset = 0}) async {
    state = const AsyncLoading();
    final result = await _repository.getFollowing(_userId, limit: limit, offset: offset);
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (following) => state = AsyncData(following),
    );
  }

  Future<void> loadMoreFollowing({int limit = 20}) async {
    if (state.value == null || state.isLoading) return;

    final currentState = state.value!;
    final currentOffset = currentState.length;

    final result = await _repository.getFollowing(_userId, limit: limit, offset: currentOffset);
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (moreFollowing) => state = AsyncData([...currentState, ...moreFollowing]),
    );
  }

  void refresh() {
    loadFollowing();
  }
}
