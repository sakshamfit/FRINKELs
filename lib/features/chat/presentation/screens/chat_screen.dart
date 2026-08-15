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
import '../../domain/entities/message.dart';
import '../widgets/media_drawer.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_compress/video_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

class ChatScreen extends ConsumerStatefulWidget {
  final User otherUser;
  const ChatScreen({super.key, required this.otherUser});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  bool _isTypingInternally = false;

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final Duration duration = difference;

    if (duration.inSeconds < 60) {
      return '${duration.inSeconds}s ago';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m ago';
    } else if (duration.inHours < 24) {
      return '${duration.inHours}h ago';
    } else if (duration.inDays < 7) {
      return '${duration.inDays}d ago';
    } else {
      return '${(duration.inDays / 7).floor()}w ago';
    }
  }

  void _onMessageChanged() {
    if (_messageController.text.isNotEmpty && !_isTypingInternally) {
      _isTypingInternally = true;
      ref
          .read(chatMessagesProvider(widget.otherUser.id).notifier)
          .startTyping();
    } else if (_messageController.text.isEmpty && _isTypingInternally) {
      _isTypingInternally = false;
      ref.read(chatMessagesProvider(widget.otherUser.id).notifier).stopTyping();
    }
  }

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onMessageChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onMessageChanged);
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chatState = ref.watch(chatMessagesProvider(widget.otherUser.id));

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor:
            (isDark ? AppColors.backgroundDark : AppColors.backgroundPrimary)
                .withValues(alpha: 0.9),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: widget.otherUser.avatarUrl != null
                  ? NetworkImage(widget.otherUser.avatarUrl!)
                  : null,
              child: widget.otherUser.avatarUrl == null
                  ? const Icon(LucideIcons.user, size: 18)
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.otherUser.name ?? 'User',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: chatState.isTyping
                      ? Text(
                          'typing...',
                          key: const ValueKey('typing'),
                          style: AppTypography.tiny.copyWith(
                            color: AppColors.accent,
                          ),
                        )
                      : chatState.otherUserStatus == 'online'
                      ? Text(
                          'Online',
                          key: const ValueKey('online'),
                          style: AppTypography.tiny.copyWith(
                            color: AppColors.success,
                          ),
                        )
                      : chatState.otherUserLastSeen != null
                      ? Text(
                          'Last seen ${_formatTimeAgo(chatState.otherUserLastSeen!)}',
                          key: const ValueKey('lastSeen'),
                          style: AppTypography.tiny.copyWith(
                            color: Colors.grey,
                          ),
                        )
                      : Text(
                          'Offline',
                          key: const ValueKey('offline'),
                          style: AppTypography.tiny.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.phone, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(LucideIcons.video, size: 20),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              reverse: true,
              itemCount: chatState.messages.length,
              itemBuilder: (context, index) {
                final message =
                    chatState.messages[chatState.messages.length - 1 - index];
                final isMe = message.senderId != widget.otherUser.id;
                return _buildMessageBubble(message, isMe, isDark);
              },
            ),
          ),
          _buildInputArea(isDark),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isMe, bool isDark) {
    return GestureDetector(
      onLongPress: () {
        _showMessageOptions(context, message, isMe);
      },
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isMe
                ? AppColors.accent
                : (isDark ? AppColors.cardDark : Colors.white),
            borderRadius: BorderRadius.circular(20).copyWith(
              bottomRight: isMe
                  ? const Radius.circular(4)
                  : const Radius.circular(20),
              bottomLeft: isMe
                  ? const Radius.circular(20)
                  : const Radius.circular(4),
            ),
            boxShadow: isMe ? null : AppShadows.premium,
            border: isMe
                ? null
                : (isDark
                      ? AppShadows.glassInsetBorderDark
                      : AppShadows.glassInsetBorder),
          ),
          child: Text(
            message.content,
            style: AppTypography.body.copyWith(
              color: isMe
                  ? Colors.white
                  : (isDark ? Colors.white : AppColors.textPrimary),
              fontSize: 15,
            ),
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
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showMediaDrawer(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.cardDark.withValues(alpha: 0.8)
                    : AppColors.cardLight.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                LucideIcons.plus,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
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
                ref
                    .read(chatMessagesProvider(widget.otherUser.id).notifier)
                    .sendMessage(widget.otherUser.id, _messageController.text);
                _messageController.clear();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMediaDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MediaDrawer(
        onMediaSelected: (filePath) => _sendMediaFile(filePath),
        onCameraPressed: _pickImageFromCamera,
        onGalleryPressed: _pickImageFromGallery,
        onVideoPressed: _pickVideo,
        onDocumentPressed: _pickDocument,
        onLocationPressed: _shareLocation,
        onVoicePressed: _startVoiceRecording,
        onGifSelected: (gifUrl) => _sendGifMessage(gifUrl),
        onStickerSelected: (stickerPath) => _sendStickerMessage(stickerPath),
        onAiStickerGenerated: (stickerUrl) => _sendStickerMessage(stickerUrl),
      ),
    );
  }

  Future<void> _sendMediaFile(String filePath) async {
    final extension = filePath.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
      await ref
          .read(chatMessagesProvider(widget.otherUser.id).notifier)
          .sendMessage(widget.otherUser.id, '', imageUrl: filePath);
    } else if (['mp4', 'mov', 'avi'].contains(extension)) {
      await ref
          .read(chatMessagesProvider(widget.otherUser.id).notifier)
          .sendMessage(widget.otherUser.id, '', videoUrl: filePath);
    } else {
      await ref
          .read(chatMessagesProvider(widget.otherUser.id).notifier)
          .sendMessage(widget.otherUser.id, '', fileUrl: filePath);
    }
  }

  Future<void> _pickImageFromCamera() async {
    if (mounted) Navigator.of(context).pop();

    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      final compressed = await _compressImage(File(pickedFile.path));
      if (mounted) {
        final filePath = compressed?.path ?? pickedFile.path;
        await ref
            .read(chatMessagesProvider(widget.otherUser.id).notifier)
            .sendMessage(widget.otherUser.id, '', imageUrl: filePath);
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    if (mounted) Navigator.of(context).pop();

    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      final compressed = await _compressImage(File(pickedFile.path));
      if (mounted) {
        final filePath = compressed?.path ?? pickedFile.path;
        await ref
            .read(chatMessagesProvider(widget.otherUser.id).notifier)
            .sendMessage(widget.otherUser.id, '', imageUrl: filePath);
      }
    }
  }

  Future<void> _pickVideo() async {
    if (mounted) Navigator.of(context).pop();

    final XFile? pickedFile = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final compressed = await _compressVideo(File(pickedFile.path));
      if (mounted) {
        final filePath = compressed?.path ?? pickedFile.path;
        await ref
            .read(chatMessagesProvider(widget.otherUser.id).notifier)
            .sendMessage(widget.otherUser.id, '', videoUrl: filePath);
      }
    }
  }

  Future<void> _pickDocument() async {
    if (mounted) Navigator.of(context).pop();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document picker coming soon')),
      );
    }
  }

  Future<void> _shareLocation() async {
    if (mounted) Navigator.of(context).pop();

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permission denied')),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permissions are permanently denied'),
            ),
          );
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await ref
          .read(chatMessagesProvider(widget.otherUser.id).notifier)
          .sendMessage(
            widget.otherUser.id,
            'Shared location: ${position.latitude}, ${position.longitude}',
          );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Location shared')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
      }
    }
  }

  Future<void> _startVoiceRecording() async {
    if (mounted) Navigator.of(context).pop();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voice recording coming soon')),
      );
    }
  }

  Future<XFile?> _compressImage(File image) async {
    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path,
        '${(await getTemporaryDirectory()).path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
        quality: 85,
        minWidth: 800,
        minHeight: 800,
      );
      return result;
    } catch (e) {
      return null;
    }
  }

  Future<File?> _compressVideo(File video) async {
    try {
      MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        video.absolute.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: true,
      );
      return mediaInfo != null ? File(mediaInfo.path!) : null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _sendGifMessage(String gifUrl) async {
    await ref
        .read(chatMessagesProvider(widget.otherUser.id).notifier)
        .sendMessage(widget.otherUser.id, gifUrl, imageUrl: gifUrl);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _sendStickerMessage(String stickerPath) async {
    await ref
        .read(chatMessagesProvider(widget.otherUser.id).notifier)
        .sendMessage(
          widget.otherUser.id,
          '',
          stickerPackId: 'custom',
          stickerId: stickerPath.split('/').last.split('.').first,
        );
    if (mounted) Navigator.of(context).pop();
  }

  void _showMessageOptions(BuildContext context, Message message, bool isMe) {
    final bool isPinned = message.pinned ?? false;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(LucideIcons.reply, size: 20),
              title: const Text('Reply'),
              onTap: () {
                if (mounted) Navigator.pop(context);
                _replyToMessage(message);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.share_2, size: 20),
              title: const Text('Forward'),
              onTap: () {
                if (mounted) Navigator.pop(context);
                _forwardMessage(message);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.copy, size: 20),
              title: const Text('Copy'),
              onTap: () {
                if (mounted) Navigator.pop(context);
                _copyMessage(message);
              },
            ),
            if (isMe)
              ListTile(
                leading: const Icon(LucideIcons.pencil, size: 20),
                title: const Text('Edit'),
                onTap: () {
                  if (mounted) Navigator.pop(context);
                  _editMessage(message);
                },
              ),
            if (isMe)
              ListTile(
                leading: const Icon(LucideIcons.trash_2, size: 20),
                title: const Text('Delete'),
                onTap: () {
                  if (mounted) Navigator.pop(context);
                  _showDeleteConfirmationDialog(message);
                },
              ),
            ListTile(
              leading: Icon(
                isPinned ? LucideIcons.pin_off : LucideIcons.pin,
                size: 20,
              ),
              title: Text(isPinned ? 'Unpin' : 'Pin'),
              onTap: () {
                if (mounted) Navigator.pop(context);
                _pinMessage(message, !isPinned);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _replyToMessage(Message message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reply feature coming soon')),
      );
    }
  }

  void _forwardMessage(Message message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Forward feature coming soon')),
      );
    }
  }

  void _copyMessage(Message message) {
    Clipboard.setData(ClipboardData(text: message.content)).then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message copied to clipboard')),
        );
      }
    });
  }

  Future<void> _editMessage(Message message) async {
    final TextEditingController controller = TextEditingController(
      text: message.content,
    );
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Message'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Edit your message'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final String newContent = controller.text.trim();
              if (newContent.isNotEmpty) {
                ref
                    .read(chatMessagesProvider(widget.otherUser.id).notifier)
                    .editMessage(message.id, newContent);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteMessage(Message message, bool forEveryone) async {
    await ref
        .read(chatMessagesProvider(widget.otherUser.id).notifier)
        .deleteMessage(message.id, forEveryone);
  }

  void _showDeleteConfirmationDialog(Message message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Do you want to delete this message for everyone?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteMessage(message, true);
            },
            child: const Text(
              'Delete for Everyone',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteMessage(message, false);
            },
            child: const Text('Delete for Me'),
          ),
        ],
      ),
    );
  }

  Future<void> _pinMessage(Message message, bool pin) async {
    await ref
        .read(chatMessagesProvider(widget.otherUser.id).notifier)
        .pinMessage(message.id, pin);
  }
}
