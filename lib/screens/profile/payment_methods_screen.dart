import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_button.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String _selectedPaymentMethod = 'UPI';

  final List<Map<String, dynamic>> _methods = [
    {
      'id': 'UPI',
      'title': 'UPI (Google Pay, PhonePe, Paytm)',
      'subtitle': 'Instant bank-to-bank zero-fee transfers',
      'icon': Icons.account_balance_wallet_outlined,
      'isPopular': true,
    },
    {
      'id': 'COD',
      'title': 'Cash on Delivery (COD)',
      'subtitle': 'Pay at your doorstep with cash or QR code',
      'icon': Icons.payments_outlined,
      'isPopular': false,
    },
    {
      'id': 'CARD',
      'title': 'Debit / Credit Card',
      'subtitle': 'Visa, Mastercard, RuPay & American Express',
      'icon': Icons.credit_card_outlined,
      'isPopular': false,
    },
    {
      'id': 'NETBANKING',
      'title': 'Net Banking',
      'subtitle': 'All major Indian banks supported',
      'icon': Icons.account_balance_outlined,
      'isPopular': false,
    },
  ];

  void _showAddCardModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Payment Card',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_outlined,
                        color: AppColors.primary, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Gateway Integration Ready: Razorpay / Stripe SDKs can be plugged into this module.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                  prefixIcon: Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Expiry Date',
                        hintText: 'MM/YY',
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        hintText: '123',
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Cardholder Name',
                  hintText: 'Thanuj Allam',
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Save Card',
                onPressed: () {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Card added to your payment methods!'),
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
        title: const Text('Payment Methods'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Preferred Payment Method',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Select your default mode for quick 1-click checkout.',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),

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
                  itemCount: _methods.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: isDark ? AppColors.darkDivider : AppColors.divider,
                  ),
                  itemBuilder: (context, index) {
                    final item = _methods[index];
                    final isSelected = _selectedPaymentMethod == item['id'];

                    return ListTile(
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = item['id'] as String;
                        });
                      },
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark
                                  ? AppColors.darkSurface
                                  : AppColors.lightGreen)
                              : (isDark
                                  ? AppColors.darkSurface
                                  : const Color(0xFFF3F4F6)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                      title: Row(
                        children: [
                          Flexible(
                            child: Text(
                              item['title'] as String,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (item['isPopular'] == true) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.lightGreen,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'RECOMMENDED',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Text(
                        item['subtitle'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                      trailing: Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Add Card Button
              CustomButton(
                text: 'Add New Card',
                type: ButtonType.outlined,
                icon: Icons.add_card_rounded,
                onPressed: _showAddCardModal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
