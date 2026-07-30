import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundPrimary,
      appBar: AppBar(
        title: Text('New Post', style: AppTypography.cardTitle),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(LucideIcons.x),
          onPressed: () => context.pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FrinkelsButton.primary(
              text: 'Post',
              height: 36,
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: TextField(
          maxLines: null,
          decoration: InputDecoration(
            hintText: "What's on your mind?",
            border: InputBorder.none,
          ),
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
