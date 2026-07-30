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

final messagesProvider = StreamProvider.family<List<Message>, String>((ref, otherUserId) {
  final repository = ref.read(chatRepositoryProvider);
  return repository.getMessages(otherUserId);
});
