import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../domain/entities/community.dart';
import '../../domain/repositories/feed_repository.dart';
import '../controllers/home_provider.dart';

final communitiesProvider =
    StateNotifierProvider<CommunitiesNotifier, AsyncValue<List<Community>>>((
      ref,
    ) {
      return CommunitiesNotifier(ref.read(feedRepositoryProvider));
    });

class CommunitiesNotifier extends StateNotifier<AsyncValue<List<Community>>> {
  final FeedRepository _repository;
  StreamSubscription? _subscription;

  CommunitiesNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadCommunities();
  }

  Future<void> loadCommunities({String? category, int? minMemberCount}) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.getCommunities(
        category: category,
        minMemberCount: minMemberCount,
      );
      result.fold(
        (failure) =>
            state = AsyncValue.error(failure.message, StackTrace.current),
        (communities) => state = AsyncValue.data(communities),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e.toString(), stackTrace);
    }
  }

  Future<void> refreshCommunities() async {
    await loadCommunities();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
