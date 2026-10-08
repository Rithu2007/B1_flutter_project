import 'package:flutter/material.dart';
import '../models/category.dart';
import '../theme/app_colors.dart';

class CategoryCard extends StatelessWidget {
  final ProductCategory category;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isHorizontal;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    this.isSelected = false,
    this.isHorizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isHorizontal) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 76,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isDark
                      ? (isSelected
                          ? AppColors.secondary.withAlpha(80)
                          : AppColors.darkCard)
                      : (isSelected
                          ? AppColors.lightGreen
                          : category.bgColor),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? AppColors.darkDivider : Colors.transparent),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDark ? 20 : 8),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    category.icon,
                    size: 28,
                    color: isDark ? AppColors.secondary : category.color,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                category.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? (isDark ? AppColors.secondary : AppColors.primary)
                      : (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Grid presentation
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkDivider : AppColors.divider,
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 25 : 8),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurface
                    : category.bgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  category.icon,
                  size: 26,
                  color: isDark ? AppColors.secondary : category.color,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
