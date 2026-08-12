import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../jobs/domain/entities/job.dart';
import '../../domain/repositories/feed_repository.dart';
import 'home_provider.dart';

final jobsProvider = StateNotifierProvider<JobsNotifier, AsyncValue<List<Job>>>(
  (ref) {
    return JobsNotifier(ref.read(feedRepositoryProvider));
  },
);

class JobsNotifier extends StateNotifier<AsyncValue<List<Job>>> {
  final FeedRepository _repository;
  StreamSubscription? _subscription;

  JobsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadJobs();
  }

  Future<void> loadJobs({String? category, double? minSalary}) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.getJobs(
        category: category,
        minSalary: minSalary,
      );
      result.fold(
        (failure) =>
            state = AsyncValue.error(failure.message, StackTrace.current),
        (jobs) => state = AsyncValue.data(jobs),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e.toString(), stackTrace);
    }
  }

  Future<void> refreshJobs() async {
    await loadJobs();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
