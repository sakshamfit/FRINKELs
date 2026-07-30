import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';

class TodaysSummary extends StatelessWidget {
  const TodaysSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withValues(alpha: 0.2),
            Colors.purple.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Summary",
            style: AppTypography.cardTitle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MetricCard(
                icon: Icons.people_alt,
                label: 'People Available',
                value: '342',
                color: Colors.blueAccent,
              ),
              _MetricCard(
                icon: Icons.event,
                label: 'Nearby Events',
                value: '18',
                color: Colors.orangeAccent,
              ),
              _MetricCard(
                icon: Icons.work,
                label: 'Active Jobs',
                value: '57',
                color: Colors.greenAccent,
              ),
              _MetricCard(
                icon: Icons.people,
                label: 'New Pals Nearby',
                value: '9',
                color: Colors.redAccent,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MetricCard(
                icon: Icons.trending_up,
                label: 'Trending Topics',
                value: '12+',
                color: Colors.purpleAccent,
              ),
              _MetricCard(
                icon: Icons.groups,
                label: 'Growing Communities',
                value: '23',
                color: Colors.tealAccent,
              ),
              _MetricCard(
                icon: Icons.star,
                label: 'Recommended Pros',
                value: '8',
                color: Colors.amberAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }
}
