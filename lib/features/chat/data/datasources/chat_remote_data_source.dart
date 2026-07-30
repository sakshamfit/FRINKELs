import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/message.dart';

abstract class ChatRemoteDataSource {
  Stream<List<Message>> getMessages(String otherUserId);
  Future<void> sendMessage(String receiverId, String content, {String? imageUrl, String? voiceUrl});
  Future<void> markAsRead(String messageId);
}

class SupabaseChatRemoteDataSource implements ChatRemoteDataSource {
  final SupabaseClient supabaseClient;

  SupabaseChatRemoteDataSource(this.supabaseClient);

  @override
  Stream<List<Message>> getMessages(String otherUserId) {
    final myId = supabaseClient.auth.currentUser!.id;
    
    return supabaseClient
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((data) {
          return data
              .where((m) => (m['sender_id'] == myId && m['receiver_id'] == otherUserId) || 
                            (m['sender_id'] == otherUserId && m['receiver_id'] == myId))
              .map((m) => Message(
                id: m['id'] as String,
                senderId: m['sender_id'] as String,
                receiverId: m['receiver_id'] as String,
                content: m['content'] as String,
                imageUrl: m['image_url'] as String?,
                voiceUrl: m['voice_url'] as String?,
                isRead: m['is_read'] as bool? ?? false,
                createdAt: DateTime.parse(m['created_at'] as String),
              ))
              .toList();
        });
  }

  @override
  Future<void> sendMessage(String receiverId, String content, {String? imageUrl, String? voiceUrl}) async {
    final myId = supabaseClient.auth.currentUser!.id;
    await supabaseClient.from('messages').insert({
      'sender_id': myId,
      'receiver_id': receiverId,
      'content': content,
      'image_url': imageUrl,
      'voice_url': voiceUrl,
    });
  }

  @override
  Future<void> markAsRead(String messageId) async {
    await supabaseClient.from('messages').update({'is_read': true}).eq('id', messageId);
  }
}
