import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../home/domain/entities/post.dart';
import '../../../jobs/domain/entities/job.dart';
import '../../domain/repositories/search_repository.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../data/datasources/search_remote_data_source.dart';
import '../../../auth/presentation/controllers/auth_provider.dart';

// Provider for the search repository
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return SearchRepositoryImpl(
    SupabaseSearchRemoteDataSource(supabase),
  );
});

// Provider for the search notifier
final searchProvider = StateNotifierProvider<SearchNotifier, AsyncValue<SearchResult>>((ref) {
  return SearchNotifier(ref.watch(searchRepositoryProvider));
});

class SearchResult {
  final List<User> users;
  final List<Post> posts;
  final List<Job> jobs;

  const SearchResult({
    this.users = const [],
    this.posts = const [],
    this.jobs = const [],
  });

  SearchResult copyWith({
    List<User>? users,
    List<Post>? posts,
    List<Job>? jobs,
  }) {
    return SearchResult(
      users: users ?? this.users,
      posts: posts ?? this.posts,
      jobs: jobs ?? this.jobs,
    );
  }
}

class SearchNotifier extends StateNotifier<AsyncValue<SearchResult>> {
  final SearchRepository _searchRepository;

  SearchNotifier(this._searchRepository) : super(const AsyncValue.data(SearchResult())) {
    // Could load recent searches here if needed
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data(SearchResult());
      return;
    }

    state = const AsyncValue.loading();

    try {
      // Execute searches in parallel
      final results = await Future.wait([
        _searchRepository.searchUsers(query),
        _searchRepository.searchPosts(query),
        _searchRepository.searchJobs(query),
      ]);

      final users = results[0].fold((l) => <User>[], (r) => r as List<User>);
      final posts = results[1].fold((l) => <Post>[], (r) => r as List<Post>);
      final jobs = results[2].fold((l) => <Job>[], (r) => r as List<Job>);

      state = AsyncValue.data(SearchResult(
        users: users,
        posts: posts,
        jobs: jobs,
      ));
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  // Additional search methods
  Future<void> searchProfessionals(String query) async {
    // Implementation would go here
  }

  Future<void> searchNearbyProfessionals({
    required String query,
    double? latitude,
    double? longitude,
    double radiusKm = 10,
  }) async {
    // Implementation would go here
  }

  Future<List<String>> getRecentSearches(String userId) async {
    // Implementation would go here
    return [];
  }

  Future<void> saveSearch(String userId, String query) async {
    // Implementation would go here
  }

  Future<void> clearSearchHistory(String userId) async {
    // Implementation would go here
  }
}
