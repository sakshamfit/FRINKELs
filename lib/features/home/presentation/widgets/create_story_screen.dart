import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/providers/supabase_provider.dart';

class CreateStoryScreen extends ConsumerStatefulWidget {
  const CreateStoryScreen({super.key});

  @override
  ConsumerState<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends ConsumerState<CreateStoryScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _mediaFile;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final supabase = ref.read(supabaseProvider);

    Future<void> _pickMedia(ImageSource source) async {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
        );
        if (pickedFile != null) {
          setState(() {
            _mediaFile = pickedFile;
            _isVideo = false; // For now, we're only handling images
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error picking media: $e')),
          );
        }
      }
    }

    Future<void> _uploadStory() async {
      if (_mediaFile == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select media first')),
          );
        }
        return;
      }

      setState(() => _isUploading = true);

      try {
        // Upload media to Supabase storage
        final String fileName = '${const Uuid().v4()}${_mediaFile!.extension}';
        final String storagePath = 'stories/$fileName';

        final File file = File(_mediaFile!.path);
        await supabase.storage.from('stories').upload(
          storagePath,
          file,
        );

        // Get public URL
        final String mediaUrl = supabase.storage.from('stories').getPublicUrl(storagePath);

        // TODO: Get current user from Clerk auth state
        // For now, we'll use a placeholder
        final String userId = 'current_user_id';
        final String userName = 'Current User';
        final String? userAvatarUrl = null;

        // Create story record in database
        await supabase.from('stories').insert({
          'id': const Uuid().v4(),
          'user_id': userId,
          'user_name': userName,
          'user_avatar_url': userAvatarUrl,
          'media_url': mediaUrl,
          'type': 'image',
          'created_at': DateTime.now().toIso8601String(),
          'expires_at': DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
          'is_viewed': false,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Story created successfully!')),
          );
          // Navigate back to home screen
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating story: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isUploading = false);
        }
      }
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      appBar: AppBar(
        title: const Text('Create Story'),
        backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.check_circle),
            onPressed: _isUploading ? null : _uploadStory,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GlassCard(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Create New Story',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                  // Media preview and picker
                  _mediaFile != null
                      ? Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.file(
                              File(_mediaFile!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(
                              LucideIcons.image,
                              size: 48,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      builder: (context) => SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(LucideIcons.image),
                              title: const Text('Choose from Gallery'),
                              onTap: () {
                                Navigator.of(context).pop();
                                _pickMedia(ImageSource.gallery);
                              },
                            ),
                            ListTile(
                              leading: const Icon(LucideIcons.camera),
                              title: const Text('Take Photo'),
                              onTap: () {
                                Navigator.of(context).pop();
                                _pickMedia(ImageSource.camera);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    icon: const Icon(LucideIcons.image),
                    label: const Text('Select Media'),
                  ),
                  const SizedBox(height: 16),
                  // Caption input
                  const Text(
                    'Caption (optional)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'What\'s happening?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? AppColors.cardDark
                          : AppColors.cardLight,
                    ),
                    onChanged: (value) {},
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}