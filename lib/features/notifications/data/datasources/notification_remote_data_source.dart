import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../../domain/entities/notification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationRemoteDataSource {
  final SupabaseClient _supabase;

  NotificationRemoteDataSource(this._supabase);

  Future<Either<Failure, List<Notification>>> getNotifications({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return const Left(
          AuthenticationFailure(message: 'User not authenticated'),
        );
      }

      final response = await _supabase
          .from('notifications')
          .select('*, sender:profiles(full_name, avatar_url)')
          .eq('recipient_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      final List<dynamic> data = response as List<dynamic>;
      final notifications = data.map((json) {
        final sender = json['sender'] as Map<String, dynamic>?;
        return Notification(
          id: json['id'],
          recipientId: json['recipient_id'],
          senderId: json['sender_id'],
          senderName: sender?['full_name'] ?? '',
          senderAvatarUrl: sender?['avatar_url'],
          type: NotificationType.fromDbValue(json['type']),
          entityId: json['entity_id'],
          entityType: json['entity_type'],
          isRead: json['is_read'] ?? false,
          createdAt: DateTime.parse(json['created_at']),
        );
      }).toList();

      return Right(notifications);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return const Left(
          AuthenticationFailure(message: 'User not authenticated'),
        );
      }

      final response = await _supabase
          .from('notifications')
          .select('*')
          .eq('recipient_id', userId)
          .eq('is_read', false);

      final List<dynamic> data = response as List<dynamic>;
      return Right(data.length);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return const Left(
          AuthenticationFailure(message: 'User not authenticated'),
        );
      }

      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('recipient_id', userId)
          .eq('is_read', false);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteNotification(
    String notificationId,
  ) async {
    try {
      await _supabase.from('notifications').delete().eq('id', notificationId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
