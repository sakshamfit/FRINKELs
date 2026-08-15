import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../home/domain/entities/local_news.dart';
import '../../domain/repositories/feed_repository.dart';
import 'home_provider.dart';

final localNewsProvider =
    StateNotifierProvider<LocalNewsNotifier, AsyncValue<List<LocalNews>>>((
      ref,
    ) {
      return LocalNewsNotifier(ref.read(feedRepositoryProvider));
    });

class LocalNewsNotifier extends StateNotifier<AsyncValue<List<LocalNews>>> {
  final FeedRepository _repository;
  StreamSubscription? _subscription;

  LocalNewsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadLocalNews();
  }

  Future<void> loadLocalNews({String? category, String? location}) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.getLocalNews(
        category: category,
        location: location,
      );
      result.fold(
        (failure) =>
            state = AsyncValue.error(failure.message, StackTrace.current),
        (localNews) => state = AsyncValue.data(localNews),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e.toString(), stackTrace);
    }
  }

  Future<void> refreshLocalNews() async {
    await loadLocalNews();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
