import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum ButtonType { primary, secondary, outlined, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 52,
    this.borderRadius = 14,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget content = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == ButtonType.outlined || type == ButtonType.text
                    ? (textColor ?? AppColors.primary)
                    : Colors.white,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _getTextColor(isDark),
                ),
              ),
            ],
          );

    return SizedBox(
      width: width,
      height: height,
      child: _buildButtonChild(context, content, isDark),
    );
  }

  Color _getTextColor(bool isDark) {
    if (textColor != null) return textColor!;
    switch (type) {
      case ButtonType.primary:
      case ButtonType.secondary:
        return Colors.white;
      case ButtonType.outlined:
      case ButtonType.text:
        return isDark ? AppColors.secondary : AppColors.primary;
    }
  }

  Widget _buildButtonChild(BuildContext context, Widget content, bool isDark) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );

    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ??
                (isDark ? AppColors.secondary : AppColors.primary),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: shape,
          ),
          onPressed: isLoading ? null : onPressed,
          child: content,
        );
      case ButtonType.secondary:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ??
                (isDark ? AppColors.darkSurface : AppColors.lightGreen),
            foregroundColor: isDark ? Colors.white : AppColors.primary,
            elevation: 0,
            shape: shape,
          ),
          onPressed: isLoading ? null : onPressed,
          child: content,
        );
      case ButtonType.outlined:
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: backgroundColor ??
                  (isDark ? AppColors.secondary : AppColors.primary),
              width: 1.5,
            ),
            shape: shape,
          ),
          onPressed: isLoading ? null : onPressed,
          child: content,
        );
      case ButtonType.text:
        return TextButton(
          style: TextButton.styleFrom(shape: shape),
          onPressed: isLoading ? null : onPressed,
          child: content,
        );
    }
  }
}
