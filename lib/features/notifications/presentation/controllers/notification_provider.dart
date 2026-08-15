import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../data/datasources/notification_remote_data_source.dart';
import '../../data/repositories/notification_repository_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provider for Supabase client
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Remote data source provider
final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
      final supabase = ref.watch(supabaseProvider);
      return NotificationRemoteDataSource(supabase);
    });

// Repository provider
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final remoteDataSource = ref.watch(notificationRemoteDataSourceProvider);
  return NotificationRepositoryImpl(remoteDataSource);
});

// Notifier state
class NotificationsState {
  final List<Notification> notifications;
  final bool isLoading;
  final bool hasMore;
  final String? error;

  const NotificationsState({
    this.notifications = const [],
    this.isLoading = false,
    this.hasMore = false,
    this.error,
  });

  NotificationsState copyWith({
    List<Notification>? notifications,
    bool? isLoading,
    bool? hasMore,
    String? error,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
    );
  }
}

// Notifier class
class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final NotificationRepository _repository;
  int _offset = 0;
  static const int _limit = 20;
  bool _hasMore = true;
  bool _isLoading = false;

  NotificationsNotifier(this._repository) : super(const NotificationsState()) {
    loadNotifications();
  }

  Future<void> loadNotifications({bool refresh = false}) async {
    if (_isLoading || (!refresh && !_hasMore)) return;

    _isLoading = true;
    if (refresh) {
      _offset = 0;
      _hasMore = true;
    }

    try {
      final result = await _repository.getNotifications(
        limit: _limit,
        offset: _offset,
      );

      result.fold(
        (failure) {
          state = state.copyWith(isLoading: false, error: failure.message);
        },
        (notifications) {
          state = state.copyWith(
            isLoading: false,
            notifications: refresh
                ? notifications
                : [...state.notifications, ...notifications],
            hasMore: notifications.length == _limit,
          );

          _offset += notifications.length;
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    } finally {
      _isLoading = false;
    }
  }

  Future<void> refresh() async {
    await loadNotifications(refresh: true);
  }

  Future<void> loadMore() async {
    await loadNotifications(refresh: false);
  }

  Future<void> markAsRead(String notificationId) async {
    final result = await _repository.markAsRead(notificationId);
    result.fold(
      (failure) => null, // Handle error appropriately
      (_) {
        // Update state optimistically
        final updatedNotifications = state.notifications.map((notification) {
          if (notification.id == notificationId) {
            return notification.copyWith(isRead: true);
          }
          return notification;
        }).toList();

        state = state.copyWith(notifications: updatedNotifications);
      },
    );
  }

  Future<void> markAllAsRead() async {
    final result = await _repository.markAllAsRead();
    result.fold(
      (failure) => null, // Handle error appropriately
      (_) {
        // Update state optimistically
        final updatedNotifications = state.notifications
            .map((notification) => notification.copyWith(isRead: true))
            .toList();

        state = state.copyWith(notifications: updatedNotifications);
      },
    );
  }

  Future<void> deleteNotification(String notificationId) async {
    final result = await _repository.deleteNotification(notificationId);
    result.fold(
      (failure) => null, // Handle error appropriately
      (_) {
        // Update state optimistically
        final updatedNotifications = state.notifications
            .where((notification) => notification.id != notificationId)
            .toList();

        state = state.copyWith(notifications: updatedNotifications);
      },
    );
  }
}

// Provider for the notifier
final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
      final repository = ref.watch(notificationRepositoryProvider);
      return NotificationsNotifier(repository);
    });

// Provider for notifications list (for easy access)
final notificationsListProvider = Provider<List<Notification>>((ref) {
  final state = ref.watch(notificationsProvider);
  return state.notifications;
});

// Provider for loading state
final notificationsLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(notificationsProvider);
  return state.isLoading;
});

// Provider for error state
final notificationsErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(notificationsProvider);
  return state.error;
});

// Provider for has more state
final notificationsHasMoreProvider = Provider<bool>((ref) {
  final state = ref.watch(notificationsProvider);
  return state.hasMore;
});

// Provider for unread count
final unreadCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(notificationRepositoryProvider);
  final result = await repository.getUnreadCount();
  return result.fold((failure) => 0, (count) => count);
});
