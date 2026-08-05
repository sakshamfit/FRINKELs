import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/message.dart';

abstract class ChatRemoteDataSource {
  Stream<List<Message>> getMessages(String otherUserId, {int limit = 50, String? beforeMessageId});
  Stream<List<Message>> getMessagesAfter(String otherUserId, {int limit = 50, String? afterMessageId});
  Future<void> sendMessage(String receiverId, String content,
      {String? imageUrl, String? videoUrl, String? voiceUrl, String? fileUrl, String? stickerPackId, String? stickerId});
  Future<void> markAsDelivered(String messageId);
  Future<void> markAsRead(String messageId);

  // Typing indicators
  Stream<List<String>> getTypingIndicators(String conversationId);
  Future<void> sendTypingIndicator(String conversationId, bool isTyping);

  // Presence
  Stream<String?> getPresence(String userId);
  Future<void> updatePresence(bool isOnline);

  // Message reactions
  Future<void> reactToMessage(String messageId, String emoji);
  Future<void> removeReaction(String messageId, String emoji);
  Stream<List<Map<String, dynamic>>> getReactions(String messageId);
  Stream<List<Map<String, dynamic>>> getReactionsForConversation(String conversationId);

  // Message editing
  Future<void> editMessage(String messageId, String newContent);

  // Message deletion
  Future<void> deleteMessage(String messageId, bool forEveryone);

  // Message pinning
  Future<void> pinMessage(String messageId, bool pin);
}

class SupabaseChatRemoteDataSource implements ChatRemoteDataSource {
  final SupabaseClient _supabase;

  SupabaseChatRemoteDataSource(this._supabase);

  @override
  Stream<List<Message>> getMessages(String otherUserId, {int limit = 50, String? beforeMessageId}) async* {
    final myId = _supabase.auth.currentUser?.id;
    if (myId == null) {
      throw Exception('User not authenticated');
    }

    // Find or create a conversation between the current user and the other user
    final conversationId = await _getOrCreateConversation(myId, otherUserId);

    // Build the stream with only the conversation_id filter.
    // Note: Due to Supabase SDK limitations, we can only apply one filter in the stream.
    // We are applying the conversation_id filter here and will handle pagination in memory.
    var stream = _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId);

    // Listen to messages in this conversation
    await for (final data in stream) {
      // Convert raw data to Message entities, filtering out deleted messages
      List<Message> messages = data
          .where((m) => m['deleted_at'] == null)
          .map((m) => Message(
                id: m['id'] as String,
                conversationId: m['conversation_id'] as String,
                senderId: m['sender_id'] as String,
                type: _parseMessageType(m['type'] as String?),
                content: m['content'] as String,
                imageUrls: List<String>.from(m['image_urls'] ?? []),
                videoUrl: m['video_url'] as String?,
                voiceUrl: m['voice_url'] as String?,
                fileUrl: m['file_url'] as String?,
                gifUrl: m['gif_url'] as String?,
                duration: m['duration'] as int?,
                latitude: m['latitude'] as double?,
                longitude: m['longitude'] as double?,
                locationTitle: m['location_title'] as String?,
                contactData: m['contact_data'] != null ? Map<String, dynamic>.from(m['contact_data']) : null,
                isGif: m['is_gif'] as bool?,
                replyToMessageId: m['reply_to_message_id'] as String?,
                forwardedFromMessageId: m['forwarded_from_message_id'] as String?,
                editedAt: m['edited_at'] != null ? DateTime.parse(m['edited_at'] as String) : null,
                editedBy: m['edited_by'] as String?,
                stickerPackId: m['sticker_pack_id'] as String?,
                stickerId: m['sticker_id'] as String?,
                createdAt: DateTime.parse(m['created_at'] as String),
                updatedAt: DateTime.parse(m['updated_at'] as String),
              ))
          .toList();

      // Filter by beforeMessageId: get messages with id < beforeMessageId (lexicographically)
      if (beforeMessageId != null) {
        messages.removeWhere((m) => m.id.compareTo(beforeMessageId) >= 0);
      }

      // Sort messages by created_at descending (newest first)
      messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Apply pagination: take first 'limit' messages (most recent after filtering)
      if (messages.length > limit) {
        messages = messages.sublist(0, limit);
      }

      yield messages;
    }
  }

  @override
  Stream<List<Message>> getMessagesAfter(String otherUserId, {int limit = 50, String? afterMessageId}) async* {
    final myId = _supabase.auth.currentUser?.id;
    if (myId == null) {
      throw Exception('User not authenticated');
    }

    // Find or create a conversation between the current user and the other user
    final conversationId = await _getOrCreateConversation(myId, otherUserId);

    // Build the stream with only the conversation_id filter.
    // Note: Due to Supabase SDK limitations, we can only apply one filter in the stream.
    // We are applying the conversation_id filter here and will handle pagination in memory.
    var stream = _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId);

    // Listen to messages in this conversation
    await for (final data in stream) {
      // Convert raw data to Message entities, filtering out deleted messages
      List<Message> messages = data
          .where((m) => m['deleted_at'] == null)
          .map((m) => Message(
                id: m['id'] as String,
                conversationId: m['conversation_id'] as String,
                senderId: m['sender_id'] as String,
                type: _parseMessageType(m['type'] as String?),
                content: m['content'] as String,
                imageUrls: List<String>.from(m['image_urls'] ?? []),
                videoUrl: m['video_url'] as String?,
                voiceUrl: m['voice_url'] as String?,
                fileUrl: m['file_url'] as String?,
                gifUrl: m['gif_url'] as String?,
                duration: m['duration'] as int?,
                latitude: m['latitude'] as double?,
                longitude: m['longitude'] as double?,
                locationTitle: m['location_title'] as String?,
                contactData: m['contact_data'] != null ? Map<String, dynamic>.from(m['contact_data']) : null,
                isGif: m['is_gif'] as bool?,
                replyToMessageId: m['reply_to_message_id'] as String?,
                forwardedFromMessageId: m['forwarded_from_message_id'] as String?,
                editedAt: m['edited_at'] != null ? DateTime.parse(m['edited_at'] as String) : null,
                editedBy: m['edited_by'] as String?,
                stickerPackId: m['sticker_pack_id'] as String?,
                stickerId: m['sticker_id'] as String?,
                createdAt: DateTime.parse(m['created_at'] as String),
                updatedAt: DateTime.parse(m['updated_at'] as String),
              ))
          .toList();

      // Sort messages by created_at descending (newest first)
      messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Filter by afterMessageId: get messages with id > afterMessageId (lexicographically)
      if (afterMessageId != null) {
        messages.removeWhere((m) => m.id.compareTo(afterMessageId) <= 0);
      }

      // Take the most recent 'limit' messages
      if (messages.length > limit) {
        messages = messages.sublist(0, limit);
      }

      yield messages;
    }
  }

  MessageType _parseMessageType(String? type) {
    switch (type) {
      case 'image':
        return MessageType.image;
      case 'video':
        return MessageType.video;
      case 'voice':
        return MessageType.voice;
      case 'file':
        return MessageType.file;
      case 'location':
        return MessageType.location;
      case 'contact':
        return MessageType.contact;
      case 'sticker':
        return MessageType.sticker;
      default:
        return MessageType.text;
    }
  }

  Future<String> _getOrCreateConversation(String userId1, String userId2) async {
    // Ensure userId1 < userId2 for consistent lookup
    final uid1 = userId1.compareTo(userId2) < 0 ? userId1 : userId2;
    final uid2 = userId1.compareTo(userId2) < 0 ? userId2 : userId1;

    // Check if a conversation already exists
    try {
      final response = await _supabase
          .from('conversations')
          .select('id')
          .eq('type', 'individual')
          .filter('participants', 'cs', '{"$uid1", "$uid2"}'); // Example of filtering by array

      if (response.isNotEmpty) {
        return response[0]['id'] as String;
      }
    } catch (e) {
      // No existing conversation found
    }

    // Create a new conversation
    final conversationResponse = await _supabase
        .from('conversations')
        .insert({
          'type': 'individual',
          'participants': [uid1, uid2],
        })
        .select()
        .single();

    return conversationResponse['id'] as String;
  }

  @override
  Future<void> sendMessage(String receiverId, String content,
      {String? imageUrl, String? videoUrl, String? voiceUrl, String? fileUrl, String? stickerPackId, String? stickerId}) async {
    final myId = _supabase.auth.currentUser?.id;
    if (myId == null) {
      throw Exception('User not authenticated');
    }

    final conversationId = await _getOrCreateConversation(myId, receiverId);

    // Determine message type based on content and attachments
    MessageType type = MessageType.text;
    bool isGif = false;
    if (imageUrl != null) {
      isGif = imageUrl.toLowerCase().endsWith('.gif') ||
          content.toLowerCase().contains('.gif');
      type = MessageType.image;
    } else if (videoUrl != null) {
      type = MessageType.video;
    } else if (voiceUrl != null) {
      type = MessageType.voice;
    } else if (fileUrl != null) {
      type = MessageType.file;
    } else if (stickerPackId != null && stickerId != null) {
      type = MessageType.sticker;
    }

    await _supabase.from('messages').insert({
      'conversation_id': conversationId,
      'sender_id': myId,
      'type': type.toString().split('.').last,
      'content': content,
      'image_urls': imageUrl != null ? [imageUrl] : [],
      'video_url': videoUrl,
      'voice_url': voiceUrl,
      'file_url': fileUrl,
      'gif_url': isGif ? imageUrl : null,
      'is_gif': isGif,
      'sticker_pack_id': stickerPackId,
      'sticker_id': stickerId,
    });
  }

  @override
  Future<void> markAsDelivered(String messageId) async {
    final myId = _supabase.auth.currentUser?.id;
    if (myId == null) {
      throw Exception('User not authenticated');
    }

    await _supabase.from('message_receipts').upsert({
      'message_id': messageId,
      'user_id': myId,
      'status': 'delivered',
    });
  }

  @override
  Future<void> markAsRead(String messageId) async {
    final myId = _supabase.auth.currentUser?.id;
    if (myId == null) {
      throw Exception('User not authenticated');
    }

    await _supabase.from('message_receipts').upsert({
      'message_id': messageId,
      'user_id': myId,
      'status': 'read',
    });
  }

  @override
  Stream<List<String>> getTypingIndicators(String conversationId) {
    return _supabase
        .from('typing_indicators')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .map((List<Map<String, dynamic>> rows) => rows
            .where((row) => row['is_typing'] == true)
            .map((row) => row['user_id'] as String)
            .toList());
  }

  @override
  Future<void> sendTypingIndicator(String conversationId, bool isTyping) async {
    final myId = _supabase.auth.currentUser?.id;
    if (myId == null) {
      throw Exception('User not authenticated');
    }

    final now = DateTime.now();
    await _supabase.from('typing_indicators').upsert({
      'conversation_id': conversationId,
      'user_id': myId,
      'is_typing': isTyping,
      'updated_at': now.toIso8601String(),
    });
  }

  @override
  Stream<String?> getPresence(String userId) {
    return _supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((List<Map<String, dynamic>> rows) =>
            rows.isNotEmpty
                ? (rows[0]['is_online'] == true ? 'online' : 'offline')
                : null);
  }

  @override
  Future<void> updatePresence(bool isOnline) async {
    final myId = _supabase.auth.currentUser?.id;
    if (myId == null) {
      throw Exception('User not authenticated');
    }

    await _supabase.from('profiles').update({
      'is_online': isOnline,
      'last_seen_at': isOnline ? null : DateTime.now().toIso8601String(),
    }).eq('id', myId);
  }

  @override
  Future<void> reactToMessage(String messageId, String emoji) async {
    final myId = _supabase.auth.currentUser?.id;
    if (myId == null) {
      throw Exception('User not authenticated');
    }

    await _supabase.from('message_reactions').upsert({
      'message_id': messageId,
      'user_id': myId,
      'emoji': emoji,
    });
  }

  @override
  Future<void> removeReaction(String messageId, String emoji) async {
    final myId = _supabase.auth.currentUser?.id;
    if (myId == null) {
      throw Exception('User not authenticated');
    }

    await _supabase
        .from('message_reactions')
        .delete()
        .eq('message_id', messageId)
        .eq('user_id', myId)
        .eq('emoji', emoji);
  }

  @override
  Stream<List<Map<String, dynamic>>> getReactions(String messageId) {
    return _supabase
        .from('message_reactions')
        .stream(primaryKey: ['id'])
        .eq('message_id', messageId);
  }

  @override
  Stream<List<Map<String, dynamic>>> getReactionsForConversation(String conversationId) {
    return _supabase
        .from('message_reactions')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId);
  }

  @override
  Future<void> editMessage(String messageId, String newContent) async {
    final myId = _supabase.auth.currentUser?.id;
    if (myId == null) {
      throw Exception('User not authenticated');
    }

    await _supabase.from('messages').update({
      'content': newContent,
      'edited_at': DateTime.now().toIso8601String(),
      'edited_by': myId,
    }).eq('id', messageId);
  }

  @override
  Future<void> deleteMessage(String messageId, bool forEveryone) async {
    final myId = _supabase.auth.currentUser?.id;
    if (myId == null) {
      throw Exception('User not authenticated');
    }

    if (forEveryone) {
      await _supabase.from('messages').update({
        'deleted_at': DateTime.now().toIso8601String(),
        'deleted_by_user_id': myId,
      }).eq('id', messageId);
    } else {
      // Deleting for self is usually handled by a separate table or a list of user IDs who deleted it
      // For simplicity, we'll just ignore it or mark it in a simplified way
    }
  }

  @override
  Future<void> pinMessage(String messageId, bool pin) async {
    final myId = _supabase.auth.currentUser?.id;
    if (myId == null) {
      throw Exception('User not authenticated');
    }

    await _supabase.from('messages').update({
      'is_pinned': pin,
      'pinned_by': pin ? myId : null,
      'pinned_at': pin ? DateTime.now().toIso8601String() : null,
    }).eq('id', messageId);
  }
}
