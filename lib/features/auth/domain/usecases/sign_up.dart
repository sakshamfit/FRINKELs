import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class SignUp {
  final UserRepository repository;

  SignUp(this.repository);

  Future<Either<Failure, User>> call(SignUpParams params) => repository.signUp(
    email: params.email,
    password: params.password,
    name: params.name,
  );
}

class SignUpParams {
  final String email;
  final String password;
  final String name;

  const SignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
