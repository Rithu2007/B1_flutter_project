import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BadgeIcon extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback? onTap;
  final Color? color;

  const BadgeIcon({
    super.key,
    required this.icon,
    required this.count,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(icon, color: color),
          onPressed: onTap,
        ),
        if (count > 0)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
