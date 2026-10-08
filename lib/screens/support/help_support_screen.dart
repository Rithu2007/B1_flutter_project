import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  final List<Map<String, String>> _faqs = const [
    {
      'question': 'How do I place an order?',
      'answer':
          'Browse our categories or use search to find groceries. Tap "Add to Cart", review your items in the Cart tab, proceed to Checkout, select your address and payment method, then tap "Place Order".',
    },
    {
      'question': 'How can I track my order?',
      'answer':
          'Go to the "Orders" tab, select your active order, and tap "Track Order". You will see a live status timeline from preparation to doorstep delivery.',
    },
    {
      'question': 'How do I cancel an order?',
      'answer':
          'Orders can be cancelled before they leave the store for delivery. Go to your Order Details screen and tap "Cancel Order" or contact our instant customer support.',
    },
    {
      'question': 'What payment methods are available?',
      'answer':
          'We accept Cash on Delivery (COD), UPI (Google Pay, PhonePe, Paytm), and Credit/Debit cards (Visa, MasterCard, RuPay).',
    },
    {
      'question': 'How long does delivery take?',
      'answer':
          'Our hyperlocal riders deliver within 30 to 45 minutes from your nearest verified partner grocery store.',
    },
    {
      'question': 'How do I change my address?',
      'answer':
          'Navigate to Profile > My Addresses to add, edit, or set default delivery addresses. You can also change the address directly during checkout.',
    },
  ];

  void _showContactSupportSheet(BuildContext context) {
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
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Contact Customer Support',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'We are here to assist you 7 days a week, 7 AM to 11 PM.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.lightGreen,
                  child: Icon(Icons.phone, color: AppColors.primary),
                ),
                title: const Text('Call Us'),
                subtitle: const Text(AppConstants.supportPhone),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Calling customer support helpline...'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.lightGreen,
                  child: Icon(Icons.email_outlined, color: AppColors.primary),
                ),
                title: const Text('Email Support'),
                subtitle: const Text(AppConstants.supportEmail),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening email app...'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.lightGreen,
                  child: Icon(Icons.chat_bubble_outline,
                      color: AppColors.primary),
                ),
                title: const Text('WhatsApp Chat'),
                subtitle: const Text('Instant chat assistance'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Starting WhatsApp chat session...'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Support Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF0F5E34), const Color(0xFF16864A)]
                        : [AppColors.primary, AppColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How can we help you?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Find quick answers to common questions or reach out to our team.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFE8F5EC),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.headset_mic_rounded, size: 18),
                      label: const Text('Contact Support'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () => _showContactSupportSheet(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkDivider : AppColors.divider,
                  ),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _faqs.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: isDark ? AppColors.darkDivider : AppColors.divider,
                  ),
                  itemBuilder: (context, index) {
                    final faq = _faqs[index];
                    return Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        iconColor: AppColors.primary,
                        collapsedIconColor: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                        title: Text(
                          faq['question']!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Text(
                              faq['answer']!,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.45,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Bottom direct contact button
              CustomButton(
                text: 'Chat with Us',
                type: ButtonType.outlined,
                icon: Icons.chat_bubble_outline_rounded,
                onPressed: () => _showContactSupportSheet(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
