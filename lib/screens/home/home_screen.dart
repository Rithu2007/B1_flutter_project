import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/categories.dart';
import '../../providers/products_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/badge_icon.dart';
import '../../widgets/category_card.dart';
import '../../widgets/product_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../categories/category_products_screen.dart';
import '../notifications/notifications_screen.dart';
import '../product/product_details_screen.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToCategories;

  const HomeScreen({
    super.key,
    required this.onNavigateToCategories,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProvider = context.watch<UserProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final productsProvider = context.watch<ProductsProvider>();

    final userName = userProvider.currentUser?.name.split(' ').first ?? 'Thanuj';
    final popularProducts = productsProvider.popularProducts;
    final dealProducts = productsProvider.dealsProducts;
    final unreadNotifs = settingsProvider.unreadNotificationsCount;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header (Location, Greeting, Actions)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      // Location Pin and text
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCard
                              : AppColors.lightGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Deliver to',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    '30-45 MINS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    settingsProvider.defaultAddress?.shortAddress ??
                                        'Hyderabad, Telangana',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Notification Bell
                      BadgeIcon(
                        icon: Icons.notifications_none_rounded,
                        count: unreadNotifs,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const NotificationsScreen(),
                            ),
                          );
                        },
                      ),
                      // Avatar
                      CircleAvatar(
                        radius: 19,
                        backgroundColor: isDark
                            ? AppColors.secondary.withAlpha(50)
                            : AppColors.lightGreen,
                        child: Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : 'T',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Greeting line
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    '${_getGreeting()}, $userName! 🛒',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Search Bar (Tap opens dedicated Search Screen)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: SearchBarWidget(
                    readOnly: true,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SearchScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),

                // Promotional Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                                const Color(0xFF0F5E34),
                                const Color(0xFF16864A),
                              ]
                            : [
                                const Color(0xFF16864A),
                                const Color(0xFF2EAD67),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(50),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'LIMITED TIME OFFER',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Fresh groceries\ndelivered to your door',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Get up to 25% OFF',
                                style: TextStyle(
                                  color: Color(0xFFE8F5EC),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 14),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const CategoryProductsScreen(
                                        categoryId: 'fruits',
                                        categoryName: 'Fresh Fruits & Deals',
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  minimumSize: Size.zero,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Shop Now',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Grocery Graphic Illustration Container
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(35),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.local_shipping_rounded,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Categories Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Shop by Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: onNavigateToCategories,
                        child: const Row(
                          children: [
                            Text(
                              'See All',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Horizontal Categories
                SizedBox(
                  height: 98,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    itemCount: 8, // First 8 core categories
                    itemBuilder: (context, index) {
                      final category = mockCategories[index];
                      return CategoryCard(
                        category: category,
                        isHorizontal: true,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CategoryProductsScreen(
                                categoryId: category.id,
                                categoryName: category.name,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Today's Deals Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.accentLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.local_fire_department_rounded,
                              color: AppColors.accent,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Today\'s Deals',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Up to 25% OFF',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.secondary
                              : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Deals Horizontal Scroll
                SizedBox(
                  height: 236,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    itemCount: dealProducts.length,
                    itemBuilder: (context, index) {
                      final product = dealProducts[index];
                      return Container(
                        width: 165,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        child: ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailsScreen(product: product),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Popular Near You Section (2-Column Grid)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular Near You',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Hyderabad Favorites',
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
                const SizedBox(height: 12),

                // Popular Products Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: popularProducts.length,
                    itemBuilder: (context, index) {
                      final product = popularProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
