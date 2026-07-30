import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../entities/job.dart';

abstract class JobRepository {
  Future<Either<Failure, List<Job>>> getJobs({int limit = 20, int offset = 0});
  Future<Either<Failure, Job>> postJob(Job job);
  Future<Either<Failure, void>> applyForJob(String jobId);
}
