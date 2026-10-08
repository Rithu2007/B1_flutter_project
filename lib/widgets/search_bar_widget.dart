import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final bool readOnly;
  final bool autofocus;

  const SearchBarWidget({
    super.key,
    this.controller,
    this.hintText = 'Search for groceries, fruits, milk...',
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onClear,
    this.readOnly = false,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.divider,
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 25 : 8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        autofocus: autofocus,
        onTap: onTap,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: 22,
          ),
          suffixIcon: controller != null && controller!.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                  onPressed: () {
                    controller!.clear();
                    if (onClear != null) onClear!();
                  },
                )
              : Icon(
                  Icons.mic_none_rounded,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                  size: 20,
                ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
