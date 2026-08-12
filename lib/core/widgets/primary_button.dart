import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_shadows.dart';

enum ButtonVariant { filled, ghost, outline }

class FrinkelsButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final ButtonVariant variant;
  final double height;
  final double? width;

  const FrinkelsButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = ButtonVariant.filled,
    this.height = 56,
    this.width,
  });

  const FrinkelsButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.height = 56,
    this.width,
  }) : variant = ButtonVariant.filled;

  const FrinkelsButton.ghost({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.height = 56,
    this.width,
  }) : variant = ButtonVariant.ghost;

  const FrinkelsButton.outline({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.height = 56,
    this.width,
  }) : variant = ButtonVariant.outline;

  @override
  State<FrinkelsButton> createState() => _FrinkelsButtonState();
}

class _FrinkelsButtonState extends State<FrinkelsButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bgColor;
    Color textColor;
    List<BoxShadow>? shadows;
    Border? border;

    switch (widget.variant) {
      case ButtonVariant.filled:
        bgColor = isDark ? Colors.white : AppColors.textPrimary;
        textColor = isDark ? Colors.black : Colors.white;
        shadows = isDark ? AppShadows.premiumDark : AppShadows.premium;
        break;
      case ButtonVariant.ghost:
        bgColor = Colors.transparent;
        textColor = isDark ? Colors.white : AppColors.textPrimary;
        shadows = null;
        break;
      case ButtonVariant.outline:
        bgColor = Colors.transparent;
        textColor = isDark ? Colors.white : AppColors.textPrimary;
        shadows = null;
        border = Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.black.withValues(alpha: 0.06),
          width: 1,
        );
        break;
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: shadows,
            border: border,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isLoading)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        textColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                )
              else if (widget.icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: IconTheme(
                    data: IconThemeData(color: textColor, size: 20),
                    child: widget.icon!,
                  ),
                ),
              Text(
                widget.text,
                style: AppTypography.body.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
