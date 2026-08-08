import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Notification>>> getNotifications({
    int limit = 20,
    int offset = 0,
  }) async {
    return await _remoteDataSource.getNotifications(
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    return await _remoteDataSource.getUnreadCount();
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    return await _remoteDataSource.markAsRead(notificationId);
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    return await _remoteDataSource.markAllAsRead();
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String notificationId) async {
    return await _remoteDataSource.deleteNotification(notificationId);
  }
}