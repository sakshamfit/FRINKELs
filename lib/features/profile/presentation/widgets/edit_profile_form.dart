import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/user_profile.dart';

class EditProfileForm extends StatefulWidget {
  final UserProfile userProfile;
  final Function(UserProfile) onSave;
  final Function() onCancel;

  const EditProfileForm({
    super.key,
    required this.userProfile,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _bioController;
  late final TextEditingController _professionController;
  bool _isLoading = false;
  bool _isEmailVerified = false;
  bool _isOnboarded = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userProfile.name);
    _usernameController = TextEditingController(
      text: widget.userProfile.username,
    );
    _bioController = TextEditingController(text: widget.userProfile.bio);
    _professionController = TextEditingController(
      text: widget.userProfile.profession,
    );
    _isEmailVerified = widget.userProfile.emailVerified;
    _isOnboarded = widget.userProfile.isOnboarded;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _professionController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final updatedProfile = widget.userProfile.copyWith(
      name: _nameController.text.trim(),
      username: _usernameController.text.trim(),
      bio: _bioController.text.trim(),
      profession: _professionController.text.trim(),
      emailVerified: _isEmailVerified,
      isOnboarded: _isOnboarded,
    );

    widget.onSave(updatedProfile);
  }

  void _onCancel() {
    widget.onCancel();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      blur: 20,
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Profile',
              style: AppTypography.section.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              label: 'Name',
              controller: _nameController,
              icon: LucideIcons.user,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Username',
              controller: _usernameController,
              icon: LucideIcons.user_plus,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Profession',
              controller: _professionController,
              icon: LucideIcons.briefcase,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Bio',
              controller: _bioController,
              icon: LucideIcons.message_circle,
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            _buildToggleSwitch(
              label: 'Email Verified',
              value: _isEmailVerified,
              onChanged: (value) => setState(() => _isEmailVerified = value),
              icon: LucideIcons.circle_check,
            ),
            const SizedBox(height: 16),
            _buildToggleSwitch(
              label: 'Onboarded Completed',
              value: _isOnboarded,
              onChanged: (value) => setState(() => _isOnboarded = value),
              icon: LucideIcons.circle_check,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _onCancel,
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDark ? Colors.white70 : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: 'Enter $label...',
            hintStyle: TextStyle(
              color: isDark ? Colors.white38 : Colors.grey[400],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.accent, width: 2),
            ),
            filled: true,
            fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
      ],
    );
  }

  Widget _buildToggleSwitch({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(label)),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
