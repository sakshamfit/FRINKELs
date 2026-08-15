import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/home_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final HomeRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> getProfile(String userId) async {
    try {
      final user = await remoteDataSource.getProfile(userId);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getNearbyProfessionals({
    double? latitude,
    double? longitude,
    double radiusKm = 10,
  }) async {
    try {
      final users = await remoteDataSource.getNearbyProfessionals(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
      );
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getTrendingProfessionals() async {
    try {
      final users = await remoteDataSource.getTrendingProfessionals();
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
