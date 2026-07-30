import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class CompleteOnboarding {
  final UserRepository repository;

  CompleteOnboarding(this.repository);

  Future<Either<Failure, User>> call(Map<String, dynamic> params) =>
      repository.completeOnboarding(params);
}
