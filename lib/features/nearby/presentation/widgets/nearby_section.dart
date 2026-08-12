import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../nearby/presentation/widgets/nearby_place_card.dart';

class NearbySection extends StatelessWidget {
  const NearbySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nearby Places',
                style: AppTypography.cardTitle.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to full nearby screen
                },
                child: Text(
                  'See All',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Horizontal scrollable list of nearby places
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 180,
                margin: const EdgeInsets.only(right: 16),
                child: const NearbyPlaceCard(),
              );
            },
          ),
        ),
      ],
    );
  }
}
