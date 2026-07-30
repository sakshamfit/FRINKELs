import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class JobsSection extends StatelessWidget {
  const JobsSection({super.key});

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
                  'Jobs',
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
                _JobItem(
                  title: 'Senior Flutter Developer',
                  company: 'TechInnovate Inc.',
                  location: 'Remote',
                  salary: '\$120K-150K',
                  tags: ['Flutter', 'Dart', 'Remote'],
                ),
                _JobItem(
                  title: 'UI/UX Designer',
                  company: 'DesignCraft Studio',
                  location: 'San Francisco, CA',
                  salary: '\$90K-110K',
                  tags: ['UI/UX', 'Figma', 'Prototyping'],
                ),
                _JobItem(
                  title: 'Backend Engineer',
                  company: 'CloudScale Solutions',
                  location: 'New York, NY',
                  salary: '\$110K-140K',
                  tags: ['Node.js', 'AWS', 'SQL'],
                ),
                _JobItem(
                  title: 'Product Manager',
                  company: 'StartupLaunch Partners',
                  location: 'Austin, TX',
                  salary: '\$100K-130K',
                  tags: ['Product', 'Strategy', 'Analytics'],
                ),
                _JobItem(
                  title: 'DevOps Engineer',
                  company: 'InfraTech Systems',
                  location: 'Seattle, WA',
                  salary: '\$115K-145K',
                  tags: ['DevOps', 'Kubernetes', 'AWS'],
                ),
                _JobItem(
                  title: 'Data Scientist',
                  company: 'AI Innovations Lab',
                  location: 'Boston, MA',
                  salary: '\$130K-160K',
                  tags: ['Python', 'Machine Learning', 'Statistics'],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JobItem extends StatelessWidget {
  final String title;
  final String company;
  final String location;
  final String salary;
  final List<String> tags;

  const _JobItem({
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  company,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.white60),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: TextStyle(fontSize: 12, color: Colors.white60),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.attach_money,
                      size: 14,
                      color: Colors.greenAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      salary,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}