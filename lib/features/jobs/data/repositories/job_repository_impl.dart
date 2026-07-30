import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../../domain/entities/job.dart';
import '../../domain/repositories/job_repository.dart';
import '../datasources/job_remote_data_source.dart';

class JobRepositoryImpl implements JobRepository {
  final JobRemoteDataSource remoteDataSource;

  JobRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Job>>> getJobs({int limit = 20, int offset = 0}) async {
    try {
      final jobs = await remoteDataSource.getJobs(limit: limit, offset: offset);
      return Right(jobs);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Job>> postJob(Job job) async {
    try {
      final postedJob = await remoteDataSource.postJob(job);
      return Right(postedJob);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> applyForJob(String jobId) async {
    try {
      await remoteDataSource.applyForJob(jobId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
