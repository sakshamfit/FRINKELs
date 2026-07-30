import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/controllers/auth_provider.dart';
import '../../../home/domain/entities/post.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../jobs/domain/entities/job.dart';

class SearchResult {
  final List<User> users;
  final List<Post> posts;
  final List<Job> jobs;

  SearchResult({this.users = const [], this.posts = const [], this.jobs = const []});
}

final searchProvider = StateNotifierProvider<SearchNotifier, AsyncValue<SearchResult>>((ref) {
  return SearchNotifier(ref);
});

class SearchNotifier extends StateNotifier<AsyncValue<SearchResult>> {
  final Ref _ref;

  SearchNotifier(this._ref) : super(const AsyncValue.data(SearchResult())) {
    // Should be initialized with empty data or recent searches
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = AsyncValue.data(SearchResult());
      return;
    }

    state = const AsyncValue.loading();

    try {
      final supabase = _ref.read(supabaseProvider);
      
      // Parallel searches in Supabase
      final results = await Future.wait([
        supabase.from('profiles').select().ilike('full_name', '%$query%').limit(5),
        supabase.from('posts').select('*, profiles(full_name, avatar_url)').ilike('content', '%$query%').limit(5),
        supabase.from('jobs').select().ilike('title', '%$query%').limit(5),
      ]);

      final List<dynamic> usersData = results[0] as List<dynamic>;
      final List<dynamic> postsData = results[1] as List<dynamic>;
      final List<dynamic> jobsData = results[2] as List<dynamic>;

      state = AsyncValue.data(SearchResult(
        users: usersData.map((u) => User(
          id: u['id'],
          email: u['email'] ?? '',
          name: u['full_name'],
          username: u['username'],
          profession: u['profession'],
          avatarUrl: u['avatar_url'],
          isOnboarded: true,
          createdAt: DateTime.parse(u['created_at']),
        )).toList(),
        posts: postsData.map((p) {
          final profile = p['profiles'];
          return Post(
            id: p['id'],
            authorId: p['author_id'],
            authorName: profile['full_name'] ?? 'Anonymous',
            authorAvatarUrl: profile['avatar_url'],
            content: p['content'] ?? '',
            imageUrls: List<String>.from(p['image_urls'] ?? []),
            createdAt: DateTime.parse(p['created_at']),
          );
        }).toList(),
        jobs: jobsData.map((j) => Job(
          id: j['id'],
          title: j['title'],
          companyName: j['company_name'],
          description: j['description'],
          location: j['location'],
          salary: j['salary'],
          type: j['type'],
          postedById: j['posted_by_id'],
          createdAt: DateTime.parse(j['created_at']),
        )).toList(),
      ));
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
