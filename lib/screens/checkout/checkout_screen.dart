import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/address.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import 'add_address_screen.dart';
import 'order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'UPI';
  Address? _selectedAddress;
  bool _isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>();
    _selectedAddress = settings.defaultAddress;
  }

  void _showAddressSelectionModal(BuildContext context) {
    final settings = context.read<SettingsProvider>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final addresses = settings.addresses;
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Delivery Address',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add New'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddAddressScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...addresses.map(
                (addr) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    _selectedAddress?.id == addr.id
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    '${addr.fullName} (${addr.type})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(addr.shortAddress),
                  onTap: () {
                    setState(() {
                      _selectedAddress = addr;
                    });
                    Navigator.of(ctx).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handlePlaceOrder() async {
    final cart = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();

    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty!'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select or add a delivery address'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isPlacingOrder = true;
    });

    await Future.delayed(const Duration(milliseconds: 800)); // Smooth processing

    final order = orderProvider.placeOrder(
      items: cart.cartItemList,
      subtotal: cart.subtotal,
      deliveryFee: cart.deliveryFee,
      discount: cart.discountAmount,
      total: cart.grandTotal,
      deliveryAddress: _selectedAddress!,
      paymentMethod: _selectedPaymentMethod,
    );

    cart.clearCart();

    if (mounted) {
      setState(() {
        _isPlacingOrder = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OrderConfirmationScreen(order: order),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cart = context.watch<CartProvider>();
    final settings = context.watch<SettingsProvider>();
    final activeAddress = _selectedAddress ?? settings.defaultAddress;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Delivery Address
                    _buildSectionHeader('1. Delivery Address', isDark),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkDivider
                              : AppColors.divider,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (activeAddress != null) ...[
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.darkSurface
                                        : AppColors.lightGreen,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    activeAddress.type.toUpperCase(),
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () =>
                                      _showAddressSelectionModal(context),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Change',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              activeAddress.fullName,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              activeAddress.formattedAddress,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.3,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Phone: ${activeAddress.phone}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.textMuted,
                              ),
                            ),
                          ] else ...[
                            const Text('No address available.'),
                          ],
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.add_location_alt_outlined,
                                size: 18),
                            label: const Text('Add New Address'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const AddAddressScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section 2: Delivery Time
                    _buildSectionHeader('2. Delivery Slot', isDark),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkDivider
                              : AppColors.divider,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurface
                                  : AppColors.lightGreen,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.electric_moped_rounded,
                              color: AppColors.primary,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Express Delivery',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.accentLight,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'FASTEST',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFB45309),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Guaranteed within 30–45 minutes',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section 3: Payment Method
                    _buildSectionHeader('3. Payment Method', isDark),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkDivider
                              : AppColors.divider,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildPaymentTile(
                            title: 'UPI (Google Pay, PhonePe, Paytm)',
                            subtitle: 'Instant & recommended for faster delivery',
                            icon: Icons.account_balance_wallet_outlined,
                            value: 'UPI',
                            isDark: isDark,
                          ),
                          Divider(
                            height: 1,
                            color: isDark
                                ? AppColors.darkDivider
                                : AppColors.divider,
                          ),
                          _buildPaymentTile(
                            title: 'Cash on Delivery (COD)',
                            subtitle: 'Pay cash or UPI at the doorstep',
                            icon: Icons.payments_outlined,
                            value: 'Cash on Delivery',
                            isDark: isDark,
                          ),
                          Divider(
                            height: 1,
                            color: isDark
                                ? AppColors.darkDivider
                                : AppColors.divider,
                          ),
                          _buildPaymentTile(
                            title: 'Credit / Debit Card',
                            subtitle: 'Visa, MasterCard, RuPay cards supported',
                            icon: Icons.credit_card_outlined,
                            value: 'Credit/Debit Card',
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section 4: Order Summary
                    _buildSectionHeader('4. Order Summary', isDark),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkDivider
                              : AppColors.divider,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...cart.cartItemList.map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${item.quantity}x ${item.product.name}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '${AppConstants.currency}${item.totalPrice.toInt()}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '${AppConstants.currency}${cart.subtotal.toInt()}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery Fee',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                cart.deliveryFee == 0
                                    ? 'FREE'
                                    : '${AppConstants.currency}${cart.deliveryFee.toInt()}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: cart.deliveryFee == 0
                                      ? AppColors.primary
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          if (cart.discountAmount > 0) ...[
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Discount',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '-${AppConstants.currency}${cart.discountAmount.toInt()}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Grand Total',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                '${AppConstants.currency}${cart.grandTotal.toInt()}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: isDark
                                      ? AppColors.secondary
                                      : AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Place Order Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 40 : 15),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: CustomButton(
                text:
                    'Place Order • ${AppConstants.currency}${cart.grandTotal.toInt()}',
                isLoading: _isPlacingOrder,
                icon: Icons.check_circle_rounded,
                onPressed: _handlePlaceOrder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildPaymentTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required bool isDark,
  }) {
    final isSelected = _selectedPaymentMethod == value;

    return ListTile(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.darkSurface : AppColors.lightGreen)
              : (isDark ? AppColors.darkSurface : const Color(0xFFF3F4F6)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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
        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: isSelected
            ? AppColors.primary
            : (isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary),
      ),
    );
  }
}
