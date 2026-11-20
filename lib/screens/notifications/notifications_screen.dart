import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/empty_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = context.watch<SettingsProvider>();
    final notifs = settings.notifications;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notifs.any((n) => !n.isRead))
            TextButton(
              onPressed: () {
                settings.markAllNotificationsAsRead();
              },
              child: const Text(
                'Mark All Read',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: notifs.isEmpty
            ? const Center(
                child: EmptyStateWidget(
                  icon: Icons.notifications_off_outlined,
                  title: 'No notifications',
                  description:
                      'You are completely caught up! We will notify you about your order updates here.',
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: notifs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final notif = notifs[index];
                  final timeAgo =
                      DateFormat('dd MMM, hh:mm a').format(notif.timestamp);

                  IconData notifIcon = Icons.notifications_rounded;
                  Color iconColor = AppColors.primary;

                  if (notif.type == 'order') {
                    notifIcon = Icons.local_shipping_rounded;
                    iconColor = AppColors.primary;
                  } else if (notif.type == 'promo') {
                    notifIcon = Icons.local_offer_rounded;
                    iconColor = const Color(0xFFD97706);
                  }

                  return InkWell(
                    onTap: () {
                      settings.markNotificationAsRead(notif.id);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: notif.isRead
                            ? (isDark ? AppColors.darkCard : Colors.white)
                            : (isDark
                                ? AppColors.secondary.withAlpha(30)
                                : const Color(0xFFF0FDF4)),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: notif.isRead
                              ? (isDark
                                  ? AppColors.darkDivider
                                  : AppColors.divider)
                              : AppColors.primary.withAlpha(60),
                          width: notif.isRead ? 0.8 : 1.2,
                        ),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurface
                                  : AppColors.lightGreen,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              notifIcon,
                              color: iconColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notif.title,
                                        style: TextStyle(
                                          fontWeight: notif.isRead
                                              ? FontWeight.w600
                                              : FontWeight.w800,
                                          fontSize: 14,
                                          color: isDark
                                              ? AppColors.darkTextPrimary
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    if (!notif.isRead)
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notif.message,
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.35,
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  timeAgo,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark
                                        ? AppColors.darkTextMuted
                                        : AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ),
        ),
      ),
    );
  }
}
