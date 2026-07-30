import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';
import 'no_params.dart';

class SignInWithGoogle {
  final UserRepository repository;

  SignInWithGoogle(this.repository);

  Future<Either<Failure, User>> call(NoParams params) =>
      repository.signInWithGoogle();
}
