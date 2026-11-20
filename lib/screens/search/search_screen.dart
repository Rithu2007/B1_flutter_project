import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/products_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/product_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../product/product_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    final productsProvider = context.read<ProductsProvider>();
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      setState(() {
        _hasSearched = false;
        _searchResults = [];
      });
      return;
    }

    productsProvider.addRecentSearch(trimmed);
    setState(() {
      _hasSearched = true;
      _searchResults = productsProvider.searchProducts(trimmed);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productsProvider = context.watch<ProductsProvider>();
    final recentSearches = productsProvider.recentSearches;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: SearchBarWidget(
            controller: _searchController,
            autofocus: true,
            hintText: 'Search milk, apples, rice, oil...',
            onChanged: (query) {
              _performSearch(query);
            },
            onSubmitted: (query) {
              _performSearch(query);
            },
            onClear: () {
              setState(() {
                _hasSearched = false;
                _searchResults = [];
              });
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: _hasSearched
                ? _searchResults.isEmpty
                    ? Center(
                        child: EmptyStateWidget(
                          icon: Icons.search_off_rounded,
                          title: 'No products found',
                          description:
                              'We couldn\'t find any grocery items matching "${_searchController.text}". Try searching for milk, bread, or apples.',
                          buttonText: 'Clear Search',
                          onButtonPressed: () {
                            _searchController.clear();
                            setState(() {
                              _hasSearched = false;
                              _searchResults = [];
                            });
                          },
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                            child: Text(
                              'Found ${_searchResults.length} results for "${_searchController.text}"',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 220,
                                childAspectRatio: 0.66,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 14,
                              ),
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final product = _searchResults[index];
                                return ProductCard(
                                  product: product,
                                  heroTag: 'search_prod_${product.id}',
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ProductDetailsScreen(
                                          product: product,
                                          heroTag: 'search_prod_${product.id}',
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      )
                : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (recentSearches.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Searches',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              productsProvider.clearRecentSearches();
                            },
                            child: const Text(
                              'Clear All',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: recentSearches.map((keyword) {
                          return ActionChip(
                            avatar: const Icon(
                              Icons.history_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            label: Text(keyword),
                            backgroundColor: isDark
                                ? AppColors.darkCard
                                : Colors.white,
                            side: BorderSide(
                              color: isDark
                                  ? AppColors.darkDivider
                                  : AppColors.divider,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onPressed: () {
                              _searchController.text = keyword;
                              _performSearch(keyword);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 28),
                    ],

                    Text(
                      'Trending Searches',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Fresh Milk',
                        'Basmati Rice',
                        'Robusta Bananas',
                        'Shimla Apples',
                        'Pure Sunflower Oil',
                        'Paneer',
                        'Tomatoes',
                        'Assam Tea',
                      ].map((item) {
                        return ActionChip(
                          avatar: const Icon(
                            Icons.trending_up_rounded,
                            size: 16,
                            color: Color(0xFFD97706),
                          ),
                          label: Text(item),
                          backgroundColor: isDark
                              ? AppColors.darkCard
                              : AppColors.lightGreen,
                          side: BorderSide(
                            color: isDark
                                ? AppColors.darkDivider
                                : Colors.transparent,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () {
                            _searchController.text = item;
                            _performSearch(item);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
          ),
        ),
      ),
    );
  }
}
