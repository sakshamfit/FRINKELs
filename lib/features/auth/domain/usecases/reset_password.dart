import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../repositories/user_repository.dart';

class ResetPassword {
  final UserRepository repository;

  ResetPassword(this.repository);

  Future<Either<Failure, void>> call(ResetPasswordParams params) =>
      repository.resetPassword(params.email);
}

class ResetPasswordParams {
  final String email;

  const ResetPasswordParams({required this.email});
}
