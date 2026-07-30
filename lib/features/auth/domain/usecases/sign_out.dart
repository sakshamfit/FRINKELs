import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../repositories/user_repository.dart';
import 'no_params.dart';

class SignOut {
  final UserRepository repository;

  SignOut(this.repository);

  Future<Either<Failure, void>> call(NoParams params) => repository.signOut();
}
