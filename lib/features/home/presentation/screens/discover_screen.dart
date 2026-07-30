import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundPrimary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: Text('Discover', style: AppTypography.section.copyWith(fontSize: 24)),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final labels = ['Design', 'Tech', 'Music', 'Business'];
                  return GlassCard(
                    padding: EdgeInsets.zero,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          'https://picsum.photos/400/400?sig=$index',
                          fit: BoxFit.cover,
                        ),
                        Container(color: Colors.black38),
                        Center(
                          child: Text(
                            labels[index % labels.length],
                            style: AppTypography.cardTitle.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
