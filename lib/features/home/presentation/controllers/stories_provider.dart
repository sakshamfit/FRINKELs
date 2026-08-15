import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/story.dart';
import '../../domain/repositories/feed_repository.dart';
import 'home_provider.dart';

class StoriesState {
  final bool isLoading;
  final List<Story> stories;
  final String? error;

  const StoriesState({
    this.isLoading = false,
    this.stories = const [],
    this.error,
  });

  StoriesState copyWith({
    bool? isLoading,
    List<Story>? stories,
    String? error,
  }) {
    return StoriesState(
      isLoading: isLoading ?? this.isLoading,
      stories: stories ?? this.stories,
      error: error ?? this.error,
    );
  }
}

class StoriesNotifier extends StateNotifier<StoriesState> {
  final FeedRepository _repository;

  StoriesNotifier(this._repository) : super(const StoriesState()) {
    loadStories();
  }

  Future<void> loadStories({String? userId}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _repository.getStories(userId: userId);
      result.fold(
        (failure) =>
            state = state.copyWith(isLoading: false, error: failure.message),
        (stories) => state = state.copyWith(isLoading: false, stories: stories),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refreshStories() async {
    await loadStories();
  }
}

final storiesProvider = StateNotifierProvider<StoriesNotifier, StoriesState>((
  ref,
) {
  return StoriesNotifier(ref.read(feedRepositoryProvider));
});
