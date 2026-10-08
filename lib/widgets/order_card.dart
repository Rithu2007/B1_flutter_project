import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../theme/app_colors.dart';
import '../utils/constants.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onViewDetails;

  const OrderCard({
    super.key,
    required this.order,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orderProvider = context.read<OrderProvider>();
    final cart = context.read<CartProvider>();

    Color statusColor;
    Color statusBgColor;

    switch (order.status) {
      case OrderStatus.preparing:
        statusColor = const Color(0xFFD97706);
        statusBgColor = const Color(0xFFFEF3C7);
        break;
      case OrderStatus.outForDelivery:
        statusColor = const Color(0xFF2563EB);
        statusBgColor = const Color(0xFFEFF6FF);
        break;
      case OrderStatus.delivered:
        statusColor = AppColors.primary;
        statusBgColor = AppColors.lightGreen;
        break;
      case OrderStatus.cancelled:
        statusColor = AppColors.error;
        statusBgColor = AppColors.errorLight;
        break;
    }

    final dateFormatted = DateFormat('dd MMM yyyy, hh:mm a').format(order.date);
    final itemsSummary = order.items
        .map((i) => '${i.quantity}x ${i.product.name}')
        .take(2)
        .join(', ');
    final remainingCount = order.items.length - 2;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Order ID & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 18,
                    color: isDark ? AppColors.secondary : AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '#${order.id}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? statusColor.withAlpha(50) : statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.status.displayName,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Date
          Text(
            dateFormatted,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),
          // Items summary
          Text(
            remainingCount > 0
                ? '$itemsSummary, +$remainingCount more items'
                : itemsSummary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          // Total & Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${order.totalItemCount} items',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.textMuted,
                    ),
                  ),
                  Text(
                    '${AppConstants.currency}${order.total.toInt()}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.secondary
                          : AppColors.primary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: onViewDetails,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Details',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      orderProvider.reorder(order.id, cart);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Items added back to your cart!'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.primary,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDark ? AppColors.secondary : AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh, size: 15),
                        SizedBox(width: 4),
                        Text(
                          'Reorder',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
