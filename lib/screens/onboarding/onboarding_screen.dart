import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/storage_service.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Groceries at your doorstep',
      'subtitle':
          'Shop your daily essentials, farm-fresh vegetables, and fruits from trusted nearby stores.',
      'icon': Icons.storefront_rounded,
      'color': AppColors.primary,
      'badge': 'HYPERLOCAL',
    },
    {
      'title': 'Fresh products. Great prices.',
      'subtitle':
          'Find highest quality groceries at prices you love, with exclusive daily discounts and offers.',
      'icon': Icons.local_offer_rounded,
      'color': const Color(0xFF2E7D32),
      'badge': 'BEST SAVINGS',
    },
    {
      'title': 'Fast local delivery',
      'subtitle':
          'Get your groceries delivered in 30–45 minutes straight to your kitchen counter.',
      'icon': Icons.electric_moped_rounded,
      'color': const Color(0xFF00897B),
      'badge': 'EXPRESS',
    },
  ];

  Future<void> _completeOnboarding() async {
    await StorageService.setOnboardingCompleted(true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_currentIndex < _pages.length - 1)
            TextButton(
              onPressed: _completeOnboarding,
              child: Text(
                'Skip',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon Illustration Container
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkCard
                                : AppColors.lightGreen,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (page['color'] as Color).withAlpha(40),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              page['icon'] as IconData,
                              size: 88,
                              color: page['color'] as Color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurface
                                : AppColors.lightGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            page['badge'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              color: page['color'] as Color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Title
                        Text(
                          page['title'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Subtitle
                        Text(
                          page['subtitle'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.45,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation & Indicators
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                children: [
                  // Dot Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.darkDivider
                                  : AppColors.divider),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentIndex < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _completeOnboarding();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        _currentIndex == _pages.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
