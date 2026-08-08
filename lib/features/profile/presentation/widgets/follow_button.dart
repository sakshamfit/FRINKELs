import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class FollowButton extends StatefulWidget {
  final String userId;
  final bool isSmall;

  const FollowButton({
    super.key,
    required this.userId,
    this.isSmall = false,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool _isFollowing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFollowStatus();
  }

  Future<void> _checkFollowStatus() async {
    // This would be implemented using the follow provider
    // For now, we'll simulate with a default value
    setState(() {
      _isFollowing = false; // Default value
    });
  }

  Future<void> _followUser() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      // This would call the follow provider
      // For now, we'll just toggle the state
      setState(() {
        _isFollowing = true;
      });
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _unfollowUser() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      // This would call the unfollow provider
      // For now, we'll just toggle the state
      setState(() {
        _isFollowing = false;
      });
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return SizedBox(
        width: widget.isSmall ? 24 : 32,
        height: widget.isSmall ? 24 : 32,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      );
    }

    return SizedBox(
      width: widget.isSmall ? 24 : 96,
      height: widget.isSmall ? 24 : 32,
      child: ElevatedButton(
        onPressed: _isFollowing ? _unfollowUser : _followUser,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFollowing
              ? (isDark ? Colors.grey[800] : Colors.grey[200])
              : (isDark ? Colors.grey[800] : Colors.blue[400]),
          foregroundColor: _isFollowing
              ? (isDark ? Colors.white : Colors.black87)
              : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.isSmall ? 12 : 16),
            side: _isFollowing
                ? BorderSide(
                    color: isDark ? Colors.grey[600]! : Colors.grey[400]!,
                    width: 1,
                  )
                : BorderSide.none,
          ),
          padding: EdgeInsets.zero,
        ),
        child: widget.isSmall
            ? Icon(
                _isFollowing ? LucideIcons.user_minus : LucideIcons.user_plus,
                size: 16,
                color: _isFollowing
                    ? (isDark ? Colors.white : Colors.black87)
                    : Colors.white,
              )
            : Text(
                _isFollowing ? 'Unfollow' : 'Follow',
                style: TextStyle(
                  fontSize: widget.isSmall ? 10 : 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}