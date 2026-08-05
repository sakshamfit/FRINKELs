import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class UpdateUserProfile {
  final UserRepository repository;

  UpdateUserProfile(this.repository);

  Future<Either<Failure, User>> call(UpdateUserProfileParams params) =>
      repository.updateUserProfile(params.data);
}

class UpdateUserProfileParams {
  final Map<String, dynamic> data;

  const UpdateUserProfileParams({required this.data});
}
