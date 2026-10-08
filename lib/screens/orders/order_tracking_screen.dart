import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../theme/app_colors.dart';
import '../../utils/constants.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderModel order;

  const OrderTrackingScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final steps = [
      {
        'title': 'Order Confirmed',
        'desc': 'Your order has been received by the store',
        'isDone': true,
      },
      {
        'title': 'Order Preparing',
        'desc': 'Fresh groceries are being picked & packed',
        'isDone': order.status != OrderStatus.cancelled,
      },
      {
        'title': 'Out for Delivery',
        'desc': 'Delivery executive is on the way to your door',
        'isDone': order.status == OrderStatus.outForDelivery ||
            order.status == OrderStatus.delivered,
      },
      {
        'title': 'Delivered',
        'desc': 'Package safely delivered at your doorstep',
        'isDone': order.status == OrderStatus.delivered,
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('Track Order'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF0F5E34), const Color(0xFF16864A)]
                        : [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order #${order.id}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(50),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            order.status.displayName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'ESTIMATED ARRIVAL',
                      style: TextStyle(
                        color: Color(0xFFC7EBD4),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.status == OrderStatus.delivered
                          ? 'Package Delivered'
                          : 'Arriving in ${order.estimatedDeliveryTime}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Simulated Map Card (Hyperlocal Route Visualization)
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : const Color(0xFFE2EBE5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.darkDivider : AppColors.divider,
                  ),
                ),
                child: Stack(
                  children: [
                    // Grid / Map background lines pattern
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _MapRoutePainter(isDark: isDark),
                      ),
                    ),
                    // Delivery Partner Info Floating Card
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(isDark ? 50 : 20),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.lightGreen,
                              child: const Icon(
                                Icons.delivery_dining_rounded,
                                color: AppColors.primary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Ramesh (Delivery Hero)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'Vaccinated • 4.9 ★ Rating',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.phone,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Calling delivery partner...'),
                                    backgroundColor: AppColors.primary,
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Status Timeline
              Text(
                'Live Order Timeline',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? AppColors.darkDivider : AppColors.divider,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  children: List.generate(steps.length, (index) {
                    final step = steps[index];
                    final isDone = step['isDone'] as bool;
                    final isLast = index == steps.length - 1;

                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Step Indicator
                          Column(
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: isDone
                                      ? AppColors.primary
                                      : (isDark
                                          ? AppColors.darkSurface
                                          : const Color(0xFFE5E7EB)),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: isDone
                                      ? const Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? AppColors.darkTextMuted
                                                : Colors.grey,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                ),
                              ),
                              if (!isLast)
                                Expanded(
                                  child: Container(
                                    width: 2,
                                    color: isDone
                                        ? AppColors.primary
                                        : (isDark
                                            ? AppColors.darkDivider
                                            : AppColors.divider),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          // Step Content
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    step['title'] as String,
                                    style: TextStyle(
                                      fontWeight: isDone
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      fontSize: 14,
                                      color: isDone
                                          ? (isDark
                                              ? AppColors.darkTextPrimary
                                              : AppColors.textPrimary)
                                          : (isDark
                                              ? AppColors.darkTextMuted
                                              : AppColors.textMuted),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    step['desc'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),

              // Delivery Address Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkDivider : AppColors.divider,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      order.deliveryAddress.fullName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      order.deliveryAddress.formattedAddress,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Items summary card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkDivider : AppColors.divider,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Order Total',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${AppConstants.currency}${order.total.toInt()}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: isDark
                                ? AppColors.secondary
                                : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${order.totalItemCount} items (${order.paymentMethod})',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapRoutePainter extends CustomPainter {
  final bool isDark;

  _MapRoutePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paintRoad = Paint()
      ..color = isDark ? const Color(0xFF283830) : const Color(0xFFCBD5E1)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final paintRoute = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    // Road 1
    final road1 = Path()
      ..moveTo(0, size.height * 0.4)
      ..lineTo(size.width, size.height * 0.4);
    canvas.drawPath(road1, paintRoad);

    // Route curve
    final route = Path()
      ..moveTo(20, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.2,
        size.width - 30,
        size.height * 0.4,
      );
    canvas.drawPath(route, paintRoute);

    // Origin dot
    final originPaint = Paint()..color = AppColors.primary;
    canvas.drawCircle(Offset(20, size.height * 0.7), 6, originPaint);

    // Destination dot
    final destPaint = Paint()..color = const Color(0xFFE53935);
    canvas.drawCircle(Offset(size.width - 30, size.height * 0.4), 7, destPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
