import 'package:flutter/material.dart';
import '../../data/categories.dart';
import '../../theme/app_colors.dart';
import '../../widgets/category_card.dart';
import 'category_products_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('All Categories'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.85,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: mockCategories.length,
          itemBuilder: (context, index) {
            final category = mockCategories[index];
            return CategoryCard(
              category: category,
              isHorizontal: false,
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
    );
  }
}
