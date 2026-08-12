import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../domain/repositories/user_repository.dart';
import '../../../../core/failures/failure.dart';

class AuthRepositoryImpl implements UserRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> signIn(String email, String password) async {
    try {
      final user = await remoteDataSource.signInWithEmailPassword(
        email,
        password,
      );
      return Right(user);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final user = await remoteDataSource.signInWithGoogle();
      return Right(user);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final user = await remoteDataSource.signUpWithEmailPassword(
        email,
        password,
        name,
      );
      return Right(user);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to sign out: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to send reset email: $e'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get current user: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final user = await remoteDataSource.updateUserProfile(data);
      return Right(user);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update profile: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> completeOnboarding(
    Map<String, dynamic> data,
  ) async {
    try {
      final user = await remoteDataSource.completeOnboarding(data);
      return Right(user);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to complete onboarding: $e'));
    }
  }
}
