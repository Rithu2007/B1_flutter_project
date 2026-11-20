import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../about/about_screen.dart';
import '../auth/login_screen.dart';
import '../main_navigation_screen.dart';
import '../notifications/notifications_screen.dart';
import '../settings/settings_screen.dart';
import '../support/help_support_screen.dart';
import 'address_list_screen.dart';
import 'edit_profile_screen.dart';
import 'payment_methods_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Logout'),
        content: const Text(
          'Are you sure you want to log out of Local Grocery?',
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
            onPressed: () async {
              Navigator.of(ctx).pop();
              await context.read<UserProvider>().logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProvider = context.watch<UserProvider>();
    final settings = context.watch<SettingsProvider>();
    final user = userProvider.currentUser;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              // User Profile Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.darkDivider : AppColors.divider,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDark ? 30 : 10),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: isDark
                          ? AppColors.secondary.withAlpha(60)
                          : AppColors.lightGreen,
                      child: Text(
                        (user?.name.isNotEmpty ?? false)
                            ? user!.name[0].toUpperCase()
                            : 'T',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Name, Email, Phone
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Thanuj Allam',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            user?.email ?? 'demo@localgrocery.app',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.phone ?? '+91 98765 43210',
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
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Navigation Options List
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.darkDivider : AppColors.divider,
                  ),
                ),
                child: Column(
                  children: [
                    _buildTile(
                      context,
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        );
                      },
                      isDark: isDark,
                    ),
                    _buildDivider(isDark),
                    _buildTile(
                      context,
                      icon: Icons.receipt_long_outlined,
                      title: 'My Orders',
                      onTap: () {
                        MainNavigationScreen.of(context)?.switchTab(3);
                      },
                      isDark: isDark,
                    ),
                    _buildDivider(isDark),
                    _buildTile(
                      context,
                      icon: Icons.location_on_outlined,
                      title: 'My Addresses',
                      trailingText: '${settings.addresses.length} saved',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AddressListScreen(),
                          ),
                        );
                      },
                      isDark: isDark,
                    ),
                    _buildDivider(isDark),
                    _buildTile(
                      context,
                      icon: Icons.credit_card_outlined,
                      title: 'Payment Methods',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PaymentMethodsScreen(),
                          ),
                        );
                      },
                      isDark: isDark,
                    ),
                    _buildDivider(isDark),
                    _buildTile(
                      context,
                      icon: Icons.notifications_none_rounded,
                      title: 'Notifications',
                      trailingText: settings.unreadNotificationsCount > 0
                          ? '${settings.unreadNotificationsCount} new'
                          : null,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const NotificationsScreen(),
                          ),
                        );
                      },
                      isDark: isDark,
                    ),
                    _buildDivider(isDark),
                    _buildTile(
                      context,
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                      isDark: isDark,
                    ),
                    _buildDivider(isDark),
                    _buildTile(
                      context,
                      icon: Icons.headset_mic_outlined,
                      title: 'Help & Support',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const HelpSupportScreen(),
                          ),
                        );
                      },
                      isDark: isDark,
                    ),
                    _buildDivider(isDark),
                    _buildTile(
                      context,
                      icon: Icons.info_outline_rounded,
                      title: 'About Local Grocery',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AboutScreen(),
                          ),
                        );
                      },
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Logout Button Tile
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkDivider : AppColors.divider,
                  ),
                ),
                child: ListTile(
                  onTap: () => _showLogoutDialog(context),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: AppColors.error,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.error,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ),
  ),
);
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark ? AppColors.darkDivider : AppColors.divider,
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightGreen,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) ...[
            Text(
              trailingText,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
          ],
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
