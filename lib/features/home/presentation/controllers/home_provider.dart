import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/controllers/auth_provider.dart';
import '../../../auth/domain/entities/user.dart';
import '../../data/repositories/feed_repository_impl.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/feed_repository.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  final supabase = ref.read(supabaseProvider);
  return FeedRepositoryImpl(supabase);
});

final feedProvider = StateNotifierProvider<FeedNotifier, AsyncValue<List<Post>>>((ref) {
  return FeedNotifier(ref.read(feedRepositoryProvider));
});

class FeedNotifier extends StateNotifier<AsyncValue<List<Post>>> {
  final FeedRepository _repository;

  FeedNotifier(this._repository) : super(const AsyncValue.loading()) {
    getFeed();
  }

  Future<void> getFeed() async {
    state = const AsyncValue.loading();
    final result = await _repository.getFeed();
    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (posts) => state = AsyncValue.data(posts),
    );
  }

  Future<void> likePost(String postId) async {
    final result = await _repository.likePost(postId);
    result.fold(
      (failure) => null, // Show error snackbar
      (_) {
        // Optimistic update or refresh
        getFeed();
      },
    );
  }
}

final nearbyProfessionalsProvider = FutureProvider<List<User>>((ref) async {
  final repository = ref.read(feedRepositoryProvider);
  final result = await repository.getNearbyProfessionals();
  return result.fold(
    (failure) => throw failure.message,
    (users) => users,
  );
});
