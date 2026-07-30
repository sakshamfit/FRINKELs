import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/controllers/auth_provider.dart';
import '../../data/datasources/job_remote_data_source.dart';
import '../../data/repositories/job_repository_impl.dart';
import '../../domain/repositories/job_repository.dart';
import '../../domain/entities/job.dart';

final jobRemoteDataSourceProvider = Provider<JobRemoteDataSource>((ref) {
  final supabase = ref.read(supabaseProvider);
  return SupabaseJobRemoteDataSource(supabase);
});

final jobRepositoryProvider = Provider<JobRepository>((ref) {
  final remoteDataSource = ref.read(jobRemoteDataSourceProvider);
  return JobRepositoryImpl(remoteDataSource);
});

final jobsProvider = FutureProvider<List<Job>>((ref) async {
  final repository = ref.read(jobRepositoryProvider);
  final result = await repository.getJobs();
  return result.fold((l) => throw l.message, (r) => r);
});
