import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../domain/entities/story.dart';
import '../../../domain/enums/story_type.dart';
import '../../controllers/stories_provider.dart';
import '../../data/repositories/feed_repository_impl.dart';
import '../../../auth/presentation/controllers/auth_provider.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/repositories/feed_repository.dart';

class StoriesSection extends ConsumerStatefulWidget {
  const StoriesSection({super.key});

  @override
  ConsumerState<StoriesSection> createState() => _StoriesSectionState();
}

class _StoriesSectionState extends ConsumerState<StoriesSection> {
  late final PageController _pageController;
  int _currentIndex = 0;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Reset play state when page changes
    _isPlaying = true;
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _nextStory() {
    if (_currentIndex < ref.read(storiesProvider).value?.length ?? 0 - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final storiesAsync = ref.watch(storiesProvider);

    return storiesAsync.when(
      data: (stories) {
        if (stories.isEmpty) {
          return _buildEmptyState(isDark);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stories',
                    style: AppTypography.section.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Navigate to create story screen
                    },
                    icon: const Icon(
                      LucideIcons.plus_circle,
                      size: 18,
                      color: AppColors.accent,
                    ),
                    label: Text(
                      'Add Story',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.accentDark
                            : AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: stories.length,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemBuilder: (context, index) {
                  final story = stories[index];
                  final isViewed = story.isViewed;
                  final isOwnStory = story.userId ==
                      ref.read(authControllerProvider).state.user?.id;

                  return GestureDetector(
                    onTap: () {
                      _pageController.jumpToPage(index);
                      // Mark story as viewed when tapped
                      ref
                          .read(feedRepositoryProvider)
                          .viewStory(story.id);
                    },
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: isOwnStory
                                        ? [
                                            AppColors.primary,
                                            AppColors.secondary
                                          ]
                                        : [
                                            AppColors.primary.withValues(alpha: 0.3),
                                            AppColors.secondary.withValues(alpha: 0.3)
                                          ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: isOwnStory
                                      ? Border.all(
                                          color: AppColors.primary,
                                          width: 2,
                                        )
                                      : null,
                                ),
                                child: CircleAvatar(
                                  radius: 26,
                                  backgroundImage:
                                      NetworkImage(story.userAvatarUrl),
                                  backgroundColor:
                                      isOwnStory ? null : Colors.transparent,
                                ),
                              ),
                              if (!isViewed && !isOwnStory)
                                Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            story.userName.length > 8
                                ? '${story.userName.substring(0, 8)}...'
                                : story.userName,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 2,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? (isDark
                              ? AppColors.primaryDark
                              : AppColors.primary)
                          : Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                },
              ),
            ),
          ],
        ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05, end: 0);
      },
      loading: () => _buildLoadingState(isDark),
      error: (error, stackTrace) => _buildErrorState(isDark, error.toString()),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return SizedBox(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Stories',
              style: AppTypography.section.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemBuilder: (context, index) => Container(
                width: 60,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppColors.cardDark.withValues(alpha: 0.3)
                            : AppColors.cardPrimary.withValues(alpha: 0.3),
                      ),
                      child: const Icon(
                        LucideIcons.user,
                        size: 24,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildErrorState(bool isDark, String error) {
    return SizedBox(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Stories',
              style: AppTypography.section.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  LucideIcons.cloud_off,
                  size: 24,
                  color: AppColors.error,
                ),
                const SizedBox(height: 8),
                Text(
                  'Failed to load stories',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.refresh(storiesProvider);
                  },
                  child: const Text(
                    'Retry',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return SizedBox(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Stories',
              style: AppTypography.section.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  LucideIcons.circle,
                  size: 24,
                  color: Colors.white54,
                ),
                const SizedBox(height: 8),
                Text(
                  'No stories yet',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to create story screen
                  },
                  child: const Text(
                    'Create Story',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Full-screen story viewer page
class StoryViewPage extends ConsumerStatefulWidget {
  final List<Story> stories;
  final int initialIndex;

  const StoryViewPage({
    super.key,
    required this.stories,
    required this.initialIndex,
  });

  @override
  ConsumerState<StoryViewPage> createState() => _StoryViewPageState();
}

class _StoryViewPageState extends ConsumerState<StoryViewPage> {
  late final PageController _pageController;
  int _currentIndex = 0;
  bool _isPlaying = true;
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _initializeVideoPlayer();
    _setupAnimation();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _initializeVideoPlayer() {
    if (mounted &&
        widget.stories[_currentIndex].type == StoryType.video) {
      _videoPlayerController = VideoPlayerController.network(
        widget.stories[_currentIndex].mediaUrl,
      );
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        mute: true,
      );
    }
  }

  void _setupAnimation() {
    // Animation for progress bar - 5 seconds per story
    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..forward(from: 0);

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    );

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;
        if (_currentIndex < widget.stories.length - 1) {
          // Move to next story
          _nextStory();
        } else {
          // Last story finished
          Navigator.of(context).pop();
        }
      }
    });
  }

  void _nextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
    } else {
      _videoPlayerController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final story = widget.stories[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) {
          // Tap on left third to go back, right third to go forward
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.localPosition.dx < screenWidth / 3) {
            _previousStory();
          } else if (details.localPosition.dx > 2 * screenWidth / 3) {
            _nextStory();
          } else {
            // Center tap toggles play/pause for videos
            if (story.type == StoryType.video) {
              _togglePlayPause();
            }
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Story media
            story.type == StoryType.video
                ? Positioned.fill(
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  )
                : Positioned.fill(
                    child: Image.network(
                      story.mediaUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Icon(
                          LucideIcons.image,
                          size: 64,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
            // Progress bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) => Container(
                  height: 4,
                  width: MediaQuery.of(context).size.width * _animation.value,
                  color: story.type == StoryType.video
                      ? Colors.red
                      : Colors.blue,
                ),
              ),
            ),
            // User info and controls
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        NetworkImage(story.userAvatarUrl ?? ''),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story.userName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (story.caption != null &&
                            story.caption!.isNotEmpty)
                          Text(
                            story.caption!,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      story.type == StoryType.video
                          ? (_isPlaying
                              ? LucideIcons.pauseCircle
                              : LucideIcons.playCircle)
                          : LucideIcons.playCircle,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                ],
              ),
            ),
            // Tap to advance hint
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _animation.value > 0.8 ? 0.0 : 0.6,
                duration: const Duration(milliseconds: 300),
                child: Text(
                  'Tap to advance',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            // Close button (top left)
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(
                icon: const Icon(
                  LucideIcons.x,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            // Share button (top right)
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(
                  LucideIcons.share_2,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  // TODO: Implement share functionality
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}