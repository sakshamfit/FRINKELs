import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class PostsFeedSection extends StatelessWidget {
  const PostsFeedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discover',
                style: AppTypography.cardTitle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  'Trending',
                  style: TextStyle(color: Colors.cyanAccent, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        const PostsTabBar(),
        const Expanded(child: PostsTabBarView()),
      ],
    );
  }
}

class PostsTabBar extends StatelessWidget {
  const PostsTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        children: [
          _TabButton(label: 'All', isSelected: true),
          _TabButton(label: 'Posts', isSelected: false),
          _TabButton(label: 'Reels', isSelected: false),
          _TabButton(label: 'Blogs', isSelected: false),
          _TabButton(label: 'Memes', isSelected: false),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _TabButton({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.accent : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class PostsTabBarView extends StatelessWidget {
  const PostsTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0.0),
      children: [
        _PostCard(
          type: 'post',
          title: 'Excited to announce our new community garden initiative!',
          content:
              'Join us this Saturday at 10 AM to help plant vegetables and flowers in the downtown area. All ages welcome!',
          author: 'Community Gardens SF',
          time: '2h ago',
          likes: 124,
          comments: 18,
          imageUrl:
              'https://via.placeholder.com/400x300/4ECDC4/FFFFFF?text=Garden+Event',
        ),
        _PostCard(
          type: 'reel',
          title: 'Quick tutorial: How to make the perfect latte art',
          content:
              'Watch as I create a beautiful rosette pattern in just 60 seconds!',
          author: 'CoffeeArtMaster',
          time: '5h ago',
          likes: 856,
          comments: 42,
          videoDuration: '0:60',
        ),
        _PostCard(
          type: 'blog',
          title: 'The Future of Remote Work: Trends and Predictions',
          content:
              'As we move into 2025, remote work continues to evolve. Here are the key trends shaping the future...',
          author: 'TechForward Blog',
          time: '1d ago',
          likes: 432,
          comments: 67,
          readTime: '5 min read',
        ),
        _PostCard(
          type: 'meme',
          title: 'When you finally fix that bug after 3 hours',
          content: [
            'https://via.placeholder.com/200x200/FF6B6B/FFFFFF?text=Me',
            'https://via.placeholder.com/200x200/4ECDC4/FFFFFF?text=Computer',
            'https://via.placeholder.com/200x200/45B7D1/FFFFFF?text=Fixed!',
          ],
          author: 'DevHumor',
          time: '30m ago',
          likes: 2100,
          comments: 89,
        ),
      ],
    );
  }
}

class _PostCard extends StatelessWidget {
  final String type;
  final String title;
  final dynamic content;
  final String author;
  final String time;
  final int likes;
  final int comments;
  final String? imageUrl;
  final String? videoDuration;
  final String? readTime;

  const _PostCard({
    required this.type,
    required this.title,
    required this.content,
    required this.author,
    required this.time,
    required this.likes,
    required this.comments,
    this.imageUrl,
    this.videoDuration,
    this.readTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.withValues(alpha: 0.3),
                  child: Text(
                    author.substring(0, 2).toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        author,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(fontSize: 12, color: Colors.white60),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.white60),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Post Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                const SizedBox(height: 12),
                if (content is List<String> &&
                    (content as List<String>).isNotEmpty)
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      enlargeCenterPage: true,
                    ),
                    items: (content as List<String>).map((url) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(url),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  )
                else if (imageUrl != null)
                  Container(
                    height: 200,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else if (videoDuration != null)
                  Container(
                    height: 200,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        const Icon(
                          Icons.play_circle_fill,
                          color: Colors.red,
                          size: 60,
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              videoDuration!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    content is String ? content : '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                if (readTime != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      readTime!,
                      style: TextStyle(fontSize: 12, color: Colors.cyanAccent),
                    ),
                  ),
              ],
            ),
          ),

          // Post Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite_border,
                        color: Colors.white60,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$likes',
                      style: TextStyle(color: Colors.white60, fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.comment_outlined,
                        color: Colors.white60,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$comments',
                      style: TextStyle(color: Colors.white60, fontSize: 14),
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
