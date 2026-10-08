import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../utils/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('About Local Grocery'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // App Logo
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(50),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.shopping_basket_rounded,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Title & Tagline
              Text(
                AppConstants.appName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppConstants.appTagline,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Version ${AppConstants.appVersion}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Description Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
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
                    Text(
                      'Our Mission',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Local Grocery connects customers with neighborhood grocery stores and brings farm-fresh fruits, vegetables, dairy, and household essentials straight to their kitchen in 30–45 minutes.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Project & Tech Stack Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkDivider : AppColors.divider,
                  ),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Developer', 'Thanuj Allam', isDark),
                    const Divider(height: 20),
                    _buildInfoRow(
                        'Project Type', 'Hyperlocal Delivery App', isDark),
                    const Divider(height: 20),
                    _buildInfoRow('Framework', 'Flutter & Dart (M3)', isDark),
                    const Divider(height: 20),
                    _buildInfoRow(
                        'Architecture', 'Clean Provider Pattern', isDark),
                    const Divider(height: 20),
                    _buildInfoRow('City Service', 'Hyderabad, India', isDark),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Legal / Terms links
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Displaying Terms of Service'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    child: const Text('Terms of Service'),
                  ),
                  const Text('•'),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Displaying Privacy Policy'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    child: const Text('Privacy Policy'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
