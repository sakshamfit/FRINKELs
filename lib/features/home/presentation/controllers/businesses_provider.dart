import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/business.dart';
import '../../domain/repositories/feed_repository.dart';
import 'home_provider.dart';

final businessesProvider =
    StateNotifierProvider<BusinessesNotifier, AsyncValue<List<Business>>>((
      ref,
    ) {
      return BusinessesNotifier(ref.read(feedRepositoryProvider));
    });

class BusinessesNotifier extends StateNotifier<AsyncValue<List<Business>>> {
  final FeedRepository _repository;
  StreamSubscription? _subscription;

  BusinessesNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadBusinesses();
  }

  Future<void> loadBusinesses({String? category, double? minRating}) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.getBusinesses(
        category: category,
        minRating: minRating,
      );
      result.fold(
        (failure) =>
            state = AsyncValue.error(failure.message, StackTrace.current),
        (businesses) => state = AsyncValue.data(businesses),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e.toString(), stackTrace);
    }
  }

  Future<void> refreshBusinesses() async {
    await loadBusinesses();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
