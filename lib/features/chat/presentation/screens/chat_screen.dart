import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../auth/domain/entities/user.dart';
import '../controllers/chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final User otherUser;
  const ChatScreen({super.key, required this.otherUser});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final messagesAsync = ref.watch(messagesProvider(widget.otherUser.id));

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: (isDark ? AppColors.backgroundDark : AppColors.backgroundPrimary).withOpacity(0.9),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: widget.otherUser.avatarUrl != null 
                ? NetworkImage(widget.otherUser.avatarUrl!) 
                : null,
              child: widget.otherUser.avatarUrl == null ? const Icon(LucideIcons.user, size: 18) : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.otherUser.name ?? 'User', style: AppTypography.body.copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
                Text('Online', style: AppTypography.tiny.copyWith(color: AppColors.success)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(LucideIcons.phone, size: 20), onPressed: () {}),
          IconButton(icon: const Icon(LucideIcons.video, size: 20), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) => ListView.builder(
                padding: const EdgeInsets.all(24),
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[messages.length - 1 - index];
                  final isMe = message.senderId != widget.otherUser.id;
                  return _buildMessageBubble(message, isMe, isDark);
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
          _buildInputArea(isDark),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(dynamic message, bool isMe, bool isDark) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? AppColors.accent : (isDark ? AppColors.cardDark : Colors.white),
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(20),
            bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(4),
          ),
          boxShadow: isMe ? null : AppShadows.premium,
          border: isMe ? null : (isDark ? AppShadows.glassInsetBorderDark : AppShadows.glassInsetBorder),
        ),
        child: Text(
          message.content,
          style: AppTypography.body.copyWith(
            color: isMe ? Colors.white : (isDark ? Colors.white : AppColors.textPrimary),
            fontSize: 15,
          ),
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildInputArea(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.backgroundPrimary,
        border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black10)),
      ),
      child: Row(
        children: [
          IconButton(icon: const Icon(LucideIcons.plus_circle), onPressed: () {}),
          Expanded(
            child: GlassTextField(
              controller: _messageController,
              labelText: '',
              hintText: 'Type a message...',
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              if (_messageController.text.isNotEmpty) {
                ref.read(chatRepositoryProvider).sendMessage(widget.otherUser.id, _messageController.text);
                _messageController.clear();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
              child: const Icon(LucideIcons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
