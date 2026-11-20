import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/constants.dart';
import '../about/about_screen.dart';
import '../profile/address_list_screen.dart';
import '../profile/edit_profile_screen.dart';
import '../support/help_support_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showChangePasswordDialog(BuildContext context) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(Icons.lock_reset),
              ),
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
                  content: Text('Password updated successfully!'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    ).then((_) {
      oldPasswordController.dispose();
      newPasswordController.dispose();
    });
  }

  void _showDeliveryInstructionsDialog(BuildContext context) {
    final instructionsController = TextEditingController(
      text: 'Leave with security guard if not available at door.',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delivery Instructions'),
        content: TextField(
          controller: instructionsController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'e.g. Ring the bell twice, don\'t call before 9 AM',
          ),
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
                  content: Text('Delivery instructions saved!'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ).then((_) {
      instructionsController.dispose();
    });
  }

  void _showLanguageSelector(BuildContext context) {
    final settings = context.read<SettingsProvider>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Application Language',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...['English', 'Telugu (తెలుగు)', 'Hindi (हिंदी)'].map((lang) {
                final isSelected = settings.selectedLanguage == lang;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    lang,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    settings.setLanguage(lang);
                    Navigator.of(ctx).pop();
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ACCOUNT Section
              _buildSectionTitle('ACCOUNT', isDark),
              Container(
                decoration: _cardDecoration(isDark),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      subtitle: 'Update your name, email and phone',
                      isDark: isDark,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(isDark),
                    _buildSettingsTile(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      subtitle: 'Update your account login password',
                      isDark: isDark,
                      onTap: () => _showChangePasswordDialog(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // PREFERENCES Section
              _buildSectionTitle('PREFERENCES', isDark),
              Container(
                decoration: _cardDecoration(isDark),
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurface
                              : AppColors.lightGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.notifications_active_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      title: const Text(
                        'Push Notifications',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        'Get delivery updates & daily discount deals',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      value: settings.notificationsEnabled,
                      activeTrackColor: AppColors.primary,
                      onChanged: (val) {
                        settings.toggleNotifications(val);
                      },
                    ),
                    _buildDivider(isDark),
                    SwitchListTile(
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurface
                              : AppColors.lightGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isDark
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      title: const Text(
                        'Dark Mode',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        isDark ? 'Dark theme active' : 'Light theme active',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      value: settings.isDarkMode,
                      activeTrackColor: AppColors.primary,
                      onChanged: (val) {
                        settings.toggleDarkMode(val);
                      },
                    ),
                    _buildDivider(isDark),
                    _buildSettingsTile(
                      icon: Icons.language_rounded,
                      title: 'App Language',
                      subtitle: settings.selectedLanguage,
                      isDark: isDark,
                      onTap: () => _showLanguageSelector(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // DELIVERY Section
              _buildSectionTitle('DELIVERY', isDark),
              Container(
                decoration: _cardDecoration(isDark),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.location_on_outlined,
                      title: 'Default Address',
                      subtitle: settings.defaultAddress?.shortAddress ??
                          'Hyderabad, Telangana',
                      isDark: isDark,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AddressListScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(isDark),
                    _buildSettingsTile(
                      icon: Icons.note_alt_outlined,
                      title: 'Delivery Instructions',
                      subtitle: 'Add gate notes or preferences',
                      isDark: isDark,
                      onTap: () => _showDeliveryInstructionsDialog(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // SUPPORT & LEGAL Section
              _buildSectionTitle('SUPPORT & LEGAL', isDark),
              Container(
                decoration: _cardDecoration(isDark),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.help_outline_rounded,
                      title: 'Help Center & FAQs',
                      subtitle: 'Find answers and tutorials',
                      isDark: isDark,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const HelpSupportScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(isDark),
                    _buildSettingsTile(
                      icon: Icons.description_outlined,
                      title: 'Terms & Conditions',
                      subtitle: 'Usage guidelines and policies',
                      isDark: isDark,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Displaying Terms & Conditions'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                    ),
                    _buildDivider(isDark),
                    _buildSettingsTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      subtitle: 'How we protect your data',
                      isDark: isDark,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Displaying Privacy Policy'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ABOUT Section
              _buildSectionTitle('ABOUT', isDark),
              Container(
                decoration: _cardDecoration(isDark),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.info_outline_rounded,
                      title: 'About Local Grocery',
                      subtitle: 'Version ${AppConstants.appVersion}',
                      isDark: isDark,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AboutScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  ),
);
  }

  BoxDecoration _cardDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? AppColors.darkCard : Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isDark ? AppColors.darkDivider : AppColors.divider,
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark ? AppColors.darkDivider : AppColors.divider,
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
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
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
      ),
    );
  }
}
