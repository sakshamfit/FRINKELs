import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';

class NewsSection extends StatelessWidget {
  const NewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'News',
                  style: AppTypography.cardTitle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'See All',
                    style: TextStyle(color: Colors.cyanAccent, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                _NewsItem(
                  title: 'Tech Giants Announce Major AI Partnership',
                  source: 'TechCrunch',
                  time: '2h ago',
                  imageUrl:
                      'https://via.placeholder.com/120x80/FF6B6B/FFFFFF?text=AI',
                ),
                _NewsItem(
                  title: 'Local Farmers Market Expands to New Location',
                  source: 'Local News',
                  time: '5h ago',
                  imageUrl:
                      'https://via.placeholder.com/120x80/4ECDC4/FFFFFF?text=FM',
                ),
                _NewsItem(
                  title: 'New Public Transportation Initiative Launches',
                  source: 'City Gazette',
                  time: '1d ago',
                  imageUrl:
                      'https://via.placeholder.com/120x80/45B7D1/FFFFFF?text=PT',
                ),
                _NewsItem(
                  title: 'Startup Weekend Event Announces Winners',
                  source: 'Entrepreneur Mag',
                  time: '3h ago',
                  imageUrl:
                      'https://via.placeholder.com/120x80/96CEB4/FFFFFF?text=SW',
                ),
                _NewsItem(
                  title: 'Summer Concert Series Schedule Released',
                  source: 'Events Weekly',
                  time: '4h ago',
                  imageUrl:
                      'https://via.placeholder.com/120x80/FFEAA7/FFFFFF?text=SC',
                ),
                _NewsItem(
                  title: 'Breaking: Major Weather Update for Weekend',
                  source: 'Weather Channel',
                  time: '1h ago',
                  imageUrl:
                      'https://via.placeholder.com/120x80/DDA0DD/FFFFFF?text=MW',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsItem extends StatelessWidget {
  final String title;
  final String source;
  final String time;
  final String imageUrl;

  const _NewsItem({
    required this.title,
    required this.source,
    required this.time,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      source,
                      style: TextStyle(fontSize: 10, color: Colors.white70),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(fontSize: 10, color: Colors.cyanAccent),
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
