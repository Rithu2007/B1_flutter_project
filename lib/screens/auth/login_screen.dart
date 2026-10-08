import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../main_navigation_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'demo@localgrocery.app');
  final _passwordController = TextEditingController(text: 'password123');
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final userProvider = context.read<UserProvider>();
    final success = await userProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    }
  }

  Future<void> _handleDemoLogin() async {
    final userProvider = context.read<UserProvider>();
    final success = await userProvider.loginDemo();
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    }
  }

  void _showForgotPasswordDialog() {
    final emailCtrl = TextEditingController(text: _emailController.text);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your registered email and we\'ll send you a password reset link.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: emailCtrl,
              hintText: 'Enter your email',
              prefixIcon: Icons.email_outlined,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password reset link sent to your email.'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: const Text('Send Link'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightGreen,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.shopping_basket_rounded,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Header
                  Text(
                    'Welcome back! 👋',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Login to continue shopping fresh groceries.',
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Demo Account Quick Login Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkCard
                          : const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? AppColors.secondary.withAlpha(80)
                            : AppColors.mintGreen,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.bolt_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Demo Account (1-Click)',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AppColors.primary,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(20),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'PRESENTATION READY',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Name: Thanuj Allam • demo@localgrocery.app',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        CustomButton(
                          text: 'Use Demo Account',
                          type: ButtonType.primary,
                          height: 44,
                          icon: Icons.login_rounded,
                          isLoading: userProvider.isLoading,
                          onPressed: _handleDemoLogin,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Divider with OR
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: isDark
                              ? AppColors.darkDivider
                              : AppColors.divider,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'OR LOGIN WITH CREDENTIALS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.textMuted,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: isDark
                              ? AppColors.darkDivider
                              : AppColors.divider,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Email
                  CustomTextField(
                    label: 'Email Address',
                    hintText: 'name@example.com',
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: 18),

                  // Password
                  CustomTextField(
                    label: 'Password',
                    hintText: 'Enter your password',
                    controller: _passwordController,
                    isPassword: true,
                    prefixIcon: Icons.lock_outline,
                    validator: Validators.validatePassword,
                  ),
                  const SizedBox(height: 8),

                  // Remember Me & Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _rememberMe = val ?? true;
                              });
                            },
                          ),
                          Text(
                            'Remember me',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _showForgotPasswordDialog,
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  CustomButton(
                    text: 'Login',
                    isLoading: userProvider.isLoading,
                    onPressed: _handleLogin,
                  ),
                  const SizedBox(height: 16),

                  // Continue with Google UI
                  CustomButton(
                    text: 'Continue with Google',
                    type: ButtonType.outlined,
                    icon: Icons.g_mobiledata_rounded,
                    onPressed: () {
                      _handleDemoLogin();
                    },
                  ),
                  const SizedBox(height: 28),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
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
