import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_shadows.dart';

class GlassTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Widget? prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const GlassTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
  });

  @override
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField> {
  bool _obscureText = true;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              ...(isDark ? AppShadows.premiumDark : AppShadows.premium),
              if (_isFocused)
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.08),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
            ],
            // Inset glass effect via border
            border: isDark ? AppShadows.glassInsetBorderDark : AppShadows.glassInsetBorder,
          ),
          child: Focus(
            onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.isPassword && _obscureText,
              keyboardType: widget.keyboardType,
              onChanged: widget.onChanged,
              validator: widget.validator,
              style: AppTypography.body.copyWith(
                color: isDark ? Colors.white : AppColors.textPrimary,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                labelText: widget.labelText,
                hintText: widget.hintText,
                prefixIcon: widget.prefixIcon != null 
                  ? Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: IconTheme(
                        data: IconThemeData(
                          color: _isFocused 
                            ? AppColors.accent 
                            : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
                          size: 20,
                        ),
                        child: widget.prefixIcon!,
                      ),
                    )
                  : null,
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscureText = !_obscureText),
                      )
                    : null,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                hintStyle: AppTypography.body.copyWith(
                  color: isDark ? AppColors.textSecondaryDark.withValues(alpha: 0.4) : AppColors.textSecondary.withValues(alpha: 0.4),
                  fontSize: 16
                ),
                labelStyle: AppTypography.body.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary, 
                  fontSize: 16
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
