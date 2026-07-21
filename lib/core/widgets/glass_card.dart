import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// GlassCard provides a modern 2026 frosted glass container with optional gradient borders & blur.
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 20.0,
    this.blur = 16.0,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.glassBackground,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? AppColors.glassBorder,
              width: borderWidth,
            ),
          ),
          child: child,
        ),
      ),
    );

    if (margin != null) {
      cardContent = Padding(padding: margin!, child: cardContent);
    }

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: AppColors.glassBackgroundHover,
        highlightColor: Colors.transparent,
        child: cardContent,
      );
    }

    return cardContent;
  }
}
