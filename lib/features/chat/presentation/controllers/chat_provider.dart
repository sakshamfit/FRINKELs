import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/controllers/auth_provider.dart';
import '../../data/datasources/chat_remote_data_source.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/entities/message.dart';

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  final supabase = ref.read(supabaseProvider);
  return SupabaseChatRemoteDataSource(supabase);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final remoteDataSource = ref.read(chatRemoteDataSourceProvider);
  return ChatRepositoryImpl(remoteDataSource);
});

// State management for chat messages
class ChatMessagesState {
  final List<Message> messages;
  final bool hasMore;
  final bool isLoadingMore;
  final String? lastMessageId;
  final bool isTyping;
  final String? otherUserStatus;
  final DateTime? otherUserLastSeen;
  final Map<String, List<Map<String, dynamic>>>
  reactions; // messageId -> list of reactions

  const ChatMessagesState({
    required this.messages,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.lastMessageId,
    this.isTyping = false,
    this.otherUserStatus,
    this.otherUserLastSeen,
    this.reactions = const {},
  });

  ChatMessagesState copyWith({
    List<Message>? messages,
    bool? hasMore,
    bool? isLoadingMore,
    String? lastMessageId,
    bool? isTyping,
    String? otherUserStatus,
    DateTime? otherUserLastSeen,
    Map<String, List<Map<String, dynamic>>>? reactions,
  }) {
    return ChatMessagesState(
      messages: messages ?? this.messages,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      isTyping: isTyping ?? this.isTyping,
      otherUserStatus: otherUserStatus ?? this.otherUserStatus,
      otherUserLastSeen: otherUserLastSeen ?? this.otherUserLastSeen,
      reactions: reactions ?? this.reactions,
    );
  }
}

final chatMessagesProvider =
    StateNotifierProvider.family<
      ChatMessagesNotifier,
      ChatMessagesState,
      String
    >((ref, otherUserId) {
      final currentUserId =
          ref.read(authControllerProvider).state.user?.id ?? '';
      return ChatMessagesNotifier(
        ref.read(chatRepositoryProvider),
        otherUserId,
        currentUserId,
      );
    });

class ChatMessagesNotifier extends StateNotifier<ChatMessagesState> {
  final ChatRepository _repository;
  final String _otherUserId;
  final String _currentUserId;
  StreamSubscription<List<Message>>? _messageSubscription;
  StreamSubscription<List<String>>? _typingSubscription;
  StreamSubscription<String?>? _presenceSubscription;
  StreamSubscription<List<Map<String, dynamic>>>? _reactionsSubscription;
  Timer? _typingTimer;

  ChatMessagesNotifier(this._repository, this._otherUserId, this._currentUserId)
    : super(const ChatMessagesState(messages: [])) {
    _loadInitialMessages();
    _subscribeToTypingIndicators();
    _subscribeToPresence();
    _setupTypingDebounce();
  }

  void _loadInitialMessages() {
    _messageSubscription?.cancel();

    final messagesStream = _repository.getMessages(_otherUserId, limit: 50);

    _messageSubscription = messagesStream.listen(
      (messages) {
        if (messages.isNotEmpty) {
          state = state.copyWith(
            messages: messages,
            hasMore: messages.length == 50,
            isLoadingMore: false,
            lastMessageId: messages.last.id,
          );
          _fetchReactionsForMessages(messages);
        }
      },
      onError: (error) {
        // Handle error
      },
    );
  }

  void _subscribeToTypingIndicators() {
    _typingSubscription?.cancel();
    _typingSubscription = _repository
        .getTypingIndicators(_getConversationId())
        .listen((typingUsers) {
          final isTyping = typingUsers.any((userId) => userId == _otherUserId);
          state = state.copyWith(isTyping: isTyping);
        });
  }

  void _subscribeToPresence() {
    _presenceSubscription?.cancel();
    _presenceSubscription = _repository.getPresence(_otherUserId).listen((
      presenceData,
    ) {
      if (presenceData != null) {
        state = state.copyWith(
          otherUserStatus: presenceData,
          otherUserLastSeen:
              null, // String status doesn't provide last seen timestamp
        );
      }
    });
  }

  void _setupTypingDebounce() {
    // We'll handle typing debounce in the UI layer
  }

  String _getConversationId() {
    final uid1 = _currentUserId;
    final uid2 = _otherUserId;
    return uid1.compareTo(uid2) < 0 ? '$uid1-$uid2' : '$uid2-$uid1';
  }

  Future<void> loadMoreMessages() async {
    if (!state.hasMore || state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final moreMessages = await _repository
          .getMessages(
            _otherUserId,
            limit: 50,
            beforeMessageId: state.lastMessageId,
          )
          .first;

      if (moreMessages.isNotEmpty) {
        final newMessages = [...moreMessages, ...state.messages];
        state = state.copyWith(
          messages: newMessages,
          hasMore: moreMessages.length == 50,
          isLoadingMore: false,
          lastMessageId: moreMessages.last.id,
        );
        _fetchReactionsForMessages(moreMessages);
      } else {
        state = state.copyWith(hasMore: false, isLoadingMore: false);
      }
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  Future<void> sendMessage(
    String receiverId,
    String content, {
    String? imageUrl,
    String? videoUrl,
    String? voiceUrl,
    String? fileUrl,
    String? stickerPackId,
    String? stickerId,
  }) async {
    try {
      await _repository.sendMessage(
        receiverId,
        content,
        imageUrl: imageUrl,
        videoUrl: videoUrl,
        voiceUrl: voiceUrl,
        fileUrl: fileUrl,
        stickerPackId: stickerPackId,
        stickerId: stickerId,
      );
      stopTyping();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _fetchReactionsForMessages(List<Message> messages) async {
    final reactionsMap = <String, List<Map<String, dynamic>>>{};
    for (final message in messages) {
      try {
        final reactions = await _repository.getReactions(message.id).first;
        reactionsMap[message.id] = reactions;
      } catch (e) {
        // Ignore individual errors
      }
    }
    state = state.copyWith(reactions: {...state.reactions, ...reactionsMap});
  }

  void startTyping() {
    if (_typingTimer?.isActive ?? false) {
      _typingTimer?.cancel();
    }

    _repository.sendTypingIndicator(_getConversationId(), true);

    _typingTimer = Timer(const Duration(seconds: 3), () {
      stopTyping();
    });
  }

  void stopTyping() {
    _typingTimer?.cancel();
    _repository.sendTypingIndicator(_getConversationId(), false);
  }

  Future<void> reactToMessage(String messageId, String emoji) async {
    await _repository.reactToMessage(messageId, emoji);
  }

  Future<void> removeReaction(String messageId, String emoji) async {
    await _repository.removeReaction(messageId, emoji);
  }

  Future<void> editMessage(String messageId, String newContent) async {
    await _repository.editMessage(messageId, newContent);
  }

  Future<void> deleteMessage(String messageId, bool forEveryone) async {
    await _repository.deleteMessage(messageId, forEveryone);
  }

  Future<void> pinMessage(String messageId, bool pin) async {
    await _repository.pinMessage(messageId, pin);
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _typingSubscription?.cancel();
    _presenceSubscription?.cancel();
    _reactionsSubscription?.cancel();
    _typingTimer?.cancel();
    super.dispose();
  }
}

final typingIndicatorProvider = StateProvider<bool>((ref) => false);
final presenceProvider = StateProvider<Map<String, dynamic>?>((ref) => null);
