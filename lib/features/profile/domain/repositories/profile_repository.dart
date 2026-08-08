import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../entities/profile.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  // Basic profile operations
  Future<Either<Failure, Profile>> getProfile(String userId);
  Future<Either<Failure, UserProfile>> getUserProfile(String userId);

  // Profile updates
  Future<Either<Failure, void>> updateProfile(Profile profile);
  Future<Either<Failure, void>> updateUserProfile(UserProfile userProfile);
  Future<Either<Failure, void>> updateProfilePicture(String filePath);
  Future<Either<Failure, void>> updateCoverPhoto(String filePath);

  // Social features
  Future<Either<Failure, void>> followUser(String userId);
  Future<Either<Failure, void>> unfollowUser(String userId);
  Future<Either<Failure, bool>> isFollowing(String userId);
  Future<Either<Failure, int>> getFollowersCount(String userId);
  Future<Either<Failure, int>> getFollowingCount(String userId);
  Future<Either<Failure, List<Profile>>> getFollowers(
    String userId, {
    int limit = 20,
    int offset = 0,
  });
  Future<Either<Failure, List<Profile>>> getFollowing(
    String userId, {
    int limit = 20,
    int offset = 0,
  });

  // Discovery
  Future<Either<Failure, List<Profile>>> searchProfiles(String query);
  Future<Either<Failure, List<Profile>>> getSuggestedProfiles({int limit = 10});
  Future<Either<Failure, List<Profile>>> getNearbyProfiles({
    double? latitude,
    double? longitude,
    double radiusKm = 10,
    int limit = 20,
  });
}