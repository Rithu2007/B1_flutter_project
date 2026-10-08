import 'package:flutter/material.dart';
import '../models/address.dart';
import '../theme/app_colors.dart';

class AddressCard extends StatelessWidget {
  final Address address;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback? onDelete;

  const AddressCard({
    super.key,
    required this.address,
    required this.isSelected,
    required this.onSelect,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    IconData typeIcon = Icons.home_outlined;
    if (address.type.toLowerCase() == 'office') {
      typeIcon = Icons.work_outline;
    } else if (address.type.toLowerCase() == 'other') {
      typeIcon = Icons.location_on_outlined;
    }

    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.secondary : AppColors.primary)
                : (isDark ? AppColors.darkDivider : AppColors.divider),
            width: isSelected ? 1.8 : 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 20 : 6),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radio / Check Indicator
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected
                    ? (isDark ? AppColors.secondary : AppColors.primary)
                    : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurface
                              : AppColors.lightGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              typeIcon,
                              size: 13,
                              color: isDark
                                  ? AppColors.secondary
                                  : AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              address.type.toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.secondary
                                    : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (address.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'DEFAULT',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB45309),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    address.fullName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    address.formattedAddress,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.3,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Phone: ${address.phone}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                color: AppColors.error,
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
