import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../../../auth/domain/entities/user.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> getProfile(String userId);
  Future<Either<Failure, List<User>>> getNearbyProfessionals({double? latitude, double? longitude, double radiusKm = 10});
  Future<Either<Failure, List<User>>> getTrendingProfessionals();
}
