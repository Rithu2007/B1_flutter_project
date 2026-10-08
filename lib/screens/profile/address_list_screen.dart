import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/address_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/empty_state.dart';
import '../checkout/add_address_screen.dart';

class AddressListScreen extends StatelessWidget {
  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = context.watch<SettingsProvider>();
    final addresses = settings.addresses;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('My Addresses'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: addresses.isEmpty
                  ? Center(
                      child: EmptyStateWidget(
                        icon: Icons.location_off_outlined,
                        title: 'No addresses saved',
                        description:
                            'Add a delivery address to ensure fast delivery to your door.',
                        buttonText: 'Add Address',
                        onButtonPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AddAddressScreen(),
                            ),
                          );
                        },
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        final address = addresses[index];
                        return AddressCard(
                          address: address,
                          isSelected: address.isDefault,
                          onSelect: () {
                            settings.setDefaultAddress(address.id);
                          },
                          onDelete: addresses.length > 1
                              ? () {
                                  settings.deleteAddress(address.id);
                                }
                              : null,
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomButton(
                text: 'Add New Address',
                icon: Icons.add_location_alt_outlined,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AddAddressScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
