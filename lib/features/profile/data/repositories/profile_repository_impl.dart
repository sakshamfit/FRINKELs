import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../../domain/entities/profile.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Profile>> getProfile(String userId) async {
    try {
      final profile = await _remoteDataSource.getProfile(userId);
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getUserProfile(String userId) async {
    try {
      final userProfile = await _remoteDataSource.getUserProfile(userId);
      return Right(userProfile);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(Profile profile) async {
    try {
      await _remoteDataSource.updateProfile(profile);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile(
    UserProfile userProfile,
  ) async {
    try {
      await _remoteDataSource.updateUserProfile(userProfile);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfilePicture(String filePath) async {
    try {
      await _remoteDataSource.updateProfilePicture(filePath);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCoverPhoto(String filePath) async {
    try {
      await _remoteDataSource.updateCoverPhoto(filePath);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> followUser(String userId) async {
    try {
      await _remoteDataSource.followUser(userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unfollowUser(String userId) async {
    try {
      await _remoteDataSource.unfollowUser(userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isFollowing(String userId) async {
    try {
      final isFollowing = await _remoteDataSource.isFollowing(userId);
      return Right(isFollowing);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getFollowersCount(String userId) async {
    try {
      final count = await _remoteDataSource.getFollowersCount(userId);
      return Right(count);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getFollowingCount(String userId) async {
    try {
      final count = await _remoteDataSource.getFollowingCount(userId);
      return Right(count);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Profile>>> getFollowers(
    String userId, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final followers = await _remoteDataSource.getFollowers(
        userId,
        limit: limit,
        offset: offset,
      );
      return Right(followers);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Profile>>> getFollowing(
    String userId, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final following = await _remoteDataSource.getFollowing(
        userId,
        limit: limit,
        offset: offset,
      );
      return Right(following);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Profile>>> searchProfiles(String query) async {
    try {
      final profiles = await _remoteDataSource.searchProfiles(query);
      return Right(profiles);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Profile>>> getSuggestedProfiles({
    int limit = 10,
  }) async {
    try {
      final profiles = await _remoteDataSource.getSuggestedProfiles(
        limit: limit,
      );
      return Right(profiles);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Profile>>> getNearbyProfiles({
    double? latitude,
    double? longitude,
    double radiusKm = 10,
    int limit = 20,
  }) async {
    try {
      final profiles = await _remoteDataSource.getNearbyProfiles(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
        limit: limit,
      );
      return Right(profiles);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
