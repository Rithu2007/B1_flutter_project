import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NetworkOrPlaceholderImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final IconData fallbackIcon;

  const NetworkOrPlaceholderImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 12,
    this.fallbackIcon = Icons.shopping_basket_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: isDark ? AppColors.darkCard : AppColors.lightGreen,
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColors.darkCard, AppColors.darkSurface]
                    : [AppColors.lightGreen, const Color(0xFFD6EFE0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Icon(
                fallbackIcon,
                size: (height != null && height! < 60) ? 24 : 36,
                color: AppColors.primary,
              ),
            ),
          );
        },
      ),
    );
  }
}
