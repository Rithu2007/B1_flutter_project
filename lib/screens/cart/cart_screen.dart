import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/network_or_placeholder_image.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback onStartShopping;

  const CartScreen({
    super.key,
    required this.onStartShopping,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cart = context.watch<CartProvider>();
    final items = cart.cartItemList;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('My Cart'),
        automaticallyImplyLeading: false,
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text('Clear Cart?'),
                    content: const Text(
                      'Are you sure you want to remove all items from your cart?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          cart.clearCart();
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                'Clear',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: cart.isEmpty
                ? Center(
                    child: EmptyStateWidget(
                      icon: Icons.shopping_basket_outlined,
                      title: 'Your cart is empty',
                      description:
                          'Start adding your favorite groceries, fruits, and dairy to get lightning fast delivery.',
                      buttonText: 'Start Shopping',
                      onButtonPressed: onStartShopping,
                    ),
                  )
                : Column(
                    children: [
                      // Free delivery banner if under threshold
                      if (cart.subtotal < AppConstants.freeDeliveryThreshold)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          color: isDark
                              ? AppColors.secondary.withAlpha(40)
                              : const Color(0xFFFEF3C7),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.electric_moped_rounded,
                                size: 20,
                                color: Color(0xFFD97706),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Add ${AppConstants.currency}${(AppConstants.freeDeliveryThreshold - cart.subtotal).ceil()} more to get FREE Delivery!',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF92400E),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      color: isDark
                          ? AppColors.primary.withAlpha(40)
                          : AppColors.lightGreen,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '🎉 Congratulations! You unlocked FREE Express Delivery.',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Cart Items List
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final product = item.product;

                        return Container(
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkDivider
                                  : AppColors.divider,
                              width: 0.8,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(isDark ? 20 : 6),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: NetworkOrPlaceholderImage(
                                  imageUrl: product.image,
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
                                      product.unit,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${AppConstants.currency}${product.price.toInt()}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: isDark
                                            ? AppColors.secondary
                                            : AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Stepper & Delete
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      size: 18,
                                      color: AppColors.error,
                                    ),
                                    onPressed: () {
                                      cart.removeItem(product.id);
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.darkSurface
                                          : AppColors.lightGreen,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () =>
                                              cart.decreaseQuantity(product.id),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            child: Icon(
                                              Icons.remove,
                                              size: 15,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${item.quantity}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => cart.addItem(product),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 15,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Bill Details Summary Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(isDark ? 40 : 15),
                          blurRadius: 10,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bill Summary',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Subtotal
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subtotal',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              '${AppConstants.currency}${(cart.discountAmount > 0 ? cart.originalSubtotal : cart.subtotal).toInt()}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Delivery Fee
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delivery Fee',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              cart.deliveryFee == 0
                                  ? 'FREE'
                                  : '${AppConstants.currency}${cart.deliveryFee.toInt()}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: cart.deliveryFee == 0
                                    ? AppColors.primary
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        if (cart.discountAmount > 0) ...[
                          const SizedBox(height: 8),
                          // Discount Savings
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Discount Savings',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '-${AppConstants.currency}${cart.discountAmount.toInt()}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(),
                        ),
                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '${AppConstants.currency}${cart.grandTotal.toInt()}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: isDark
                                    ? AppColors.secondary
                                    : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Checkout Button
                        CustomButton(
                          text: 'Proceed to Checkout',
                          icon: Icons.arrow_forward_rounded,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const CheckoutScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ),
        ),
      ),
    );
  }
}
