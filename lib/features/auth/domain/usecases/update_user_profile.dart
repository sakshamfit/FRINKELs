import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class UpdateUserProfile {
  final UserRepository repository;

  UpdateUserProfile(this.repository);

  Future<Either<Failure, User>> call(UpdateUserProfileParams params) =>
      repository.updateUserProfile(params.displayName);
}

class UpdateUserProfileParams {
  final String displayName;

  const UpdateUserProfileParams({required this.displayName});
}
