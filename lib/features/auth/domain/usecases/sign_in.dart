import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class SignIn {
  final UserRepository repository;

  SignIn(this.repository);

  Future<Either<Failure, User>> call(SignInParams params) =>
      repository.signIn(params.email, params.password);
}

class SignInParams {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});
}
