import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.lightBlue.withValues(alpha: 0.3),
            Colors.lightBlueAccent.withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Weather Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.wb_sunny_outlined,
              color: Colors.yellowAccent,
              size: 40,
            ),
          ),
          const SizedBox(width: 20),
          // Weather Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'San Francisco, CA',
                  style: AppTypography.cardTitle.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '72°F • Sunny',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _WeatherDetail(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '65%',
                    ),
                    const SizedBox(width: 16),
                    _WeatherDetail(
                      icon: Icons.air,
                      label: 'Wind',
                      value: '8 mph',
                    ),
                    const SizedBox(width: 16),
                    _WeatherDetail(
                      icon: Icons.access_time,
                      label: 'Updated',
                      value: '2 min ago',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.white70)),
      ],
    );
  }
}
