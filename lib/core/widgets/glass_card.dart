import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';

class GlassCard extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final EdgeInsets padding;
  final bool interactive;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 28,
    this.blur = 12,
    this.padding = const EdgeInsets.all(24),
    this.interactive = true,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: widget.interactive ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.interactive ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: widget.interactive ? () => setState(() => _isPressed = false) : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 180),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: isDark ? AppShadows.premiumDark : AppShadows.premium,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
              child: Container(
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: isDark 
                    ? AppColors.cardDark.withValues(alpha: 0.8) 
                    : AppColors.cardLight.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: isDark ? AppShadows.glassInsetBorderDark : AppShadows.glassInsetBorder,
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
