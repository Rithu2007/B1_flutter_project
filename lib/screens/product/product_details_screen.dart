import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/network_or_placeholder_image.dart';
import '../checkout/checkout_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final product = widget.product;
    final productsProvider = context.watch<ProductsProvider>();
    final cart = context.watch<CartProvider>();
    final isFav = productsProvider.isFavorite(product.id);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? AppColors.error : null,
            ),
            onPressed: () {
              productsProvider.toggleFavorite(product.id);
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sharing "${product.name}" link copied!'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Large Image Display
                    Hero(
                      tag: 'product_img_${product.id}',
                      child: Container(
                        width: double.infinity,
                        height: 280,
                        color: isDark ? AppColors.darkCard : Colors.white,
                        child: NetworkOrPlaceholderImage(
                          imageUrl: product.image,
                          width: double.infinity,
                          height: 280,
                          borderRadius: 0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category & Unit Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkSurface
                                      : AppColors.lightGreen,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  product.category.toUpperCase(),
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                'Unit: ${product.unit}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Name
                          Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Rating and Reviews
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      size: 16,
                                      color: Color(0xFFD97706),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      product.rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF92400E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${product.reviewCount} customer reviews',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                                ),
                              ),
                              const Spacer(),
                              // Stock Availability Badge
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'In stock',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // Price Row & Quantity Stepper
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        '${AppConstants.currency}${product.price.toInt()}',
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w900,
                                          color: isDark
                                              ? AppColors.secondary
                                              : AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (product.originalPrice > product.price)
                                        Text(
                                          '${AppConstants.currency}${product.originalPrice.toInt()}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: isDark
                                                ? AppColors.darkTextMuted
                                                : AppColors.textMuted,
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (product.discount > 0)
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.accent,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '${product.discount}% OFF',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              // Quantity Selector
                              Container(
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkCard
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.darkDivider
                                        : AppColors.divider,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, size: 18),
                                      onPressed: _selectedQuantity > 1
                                          ? () {
                                              setState(() {
                                                _selectedQuantity--;
                                              });
                                            }
                                          : null,
                                    ),
                                    Text(
                                      '$_selectedQuantity',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: isDark
                                            ? AppColors.darkTextPrimary
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add, size: 18),
                                      onPressed: () {
                                        setState(() {
                                          _selectedQuantity++;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Delivery Info Card
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkCard
                                  : AppColors.lightGreen,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.electric_moped_rounded,
                                  color: AppColors.primary,
                                  size: 26,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Delivery in 30–45 minutes',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Order above ₹499 for FREE delivery',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Description
                          Text(
                            'Product Description',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Highlights
                          Text(
                            'Why choose Local Grocery',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...product.highlights.map(
                            (h) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    h,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Buttons Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 40 : 15),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Add to Cart Button
                  Expanded(
                    child: CustomButton(
                      text: 'Add to Cart',
                      type: ButtonType.secondary,
                      icon: Icons.add_shopping_cart_rounded,
                      onPressed: () {
                        cart.addItem(product, quantity: _selectedQuantity);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Added $_selectedQuantity x ${product.name} to cart!',
                            ),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Buy Now Button
                  Expanded(
                    child: CustomButton(
                      text: 'Buy Now',
                      type: ButtonType.primary,
                      icon: Icons.bolt_rounded,
                      onPressed: () {
                        cart.addItem(product, quantity: _selectedQuantity);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CheckoutScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
