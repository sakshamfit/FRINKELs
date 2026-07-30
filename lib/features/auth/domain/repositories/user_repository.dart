import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> signIn(String email, String password);
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String name,
  });
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, User>> updateUserProfile(Map<String, dynamic> data);
  Future<Either<Failure, User>> completeOnboarding(Map<String, dynamic> data);
}
