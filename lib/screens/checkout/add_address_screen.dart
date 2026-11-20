import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/address.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Thanuj Allam');
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  final _houseController = TextEditingController();
  final _streetController = TextEditingController();
  final _areaController = TextEditingController();
  final _cityController = TextEditingController(text: 'Hyderabad');
  final _stateController = TextEditingController(text: 'Telangana');
  final _pincodeController = TextEditingController(text: '500081');
  String _selectedType = 'Home';
  bool _isDefault = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _houseController.dispose();
    _streetController.dispose();
    _areaController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (!_formKey.currentState!.validate()) return;

    final newAddress = Address(
      id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      houseNumber: _houseController.text.trim(),
      street: _streetController.text.trim(),
      area: _areaController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      pincode: _pincodeController.text.trim(),
      type: _selectedType,
      isDefault: _isDefault,
    );

    context.read<SettingsProvider>().addAddress(newAddress);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Address saved successfully!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('Add Delivery Address'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type selector
                Text(
                  'Address Type',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: ['Home', 'Office', 'Other'].map((type) {
                    final isSelected = _selectedType == type;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(type),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: isDark
                            ? AppColors.darkCard
                            : AppColors.lightGreen,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              _selectedType = type;
                            });
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Contact Details
                CustomTextField(
                  label: 'Full Name',
                  hintText: 'Receiver\'s Name',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                  validator: (v) => Validators.validateRequired(v, 'Name'),
                ),
                const SizedBox(height: 14),

                CustomTextField(
                  label: 'Phone Number',
                  hintText: '10-digit mobile number',
                  controller: _phoneController,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: Validators.validatePhone,
                ),
                const SizedBox(height: 14),

                // Address Details
                CustomTextField(
                  label: 'House / Flat / Block No.',
                  hintText: 'e.g. Flat 304, Green Heights',
                  controller: _houseController,
                  prefixIcon: Icons.home_outlined,
                  validator: (v) =>
                      Validators.validateRequired(v, 'House / Flat number'),
                ),
                const SizedBox(height: 14),

                CustomTextField(
                  label: 'Street / Landmark',
                  hintText: 'e.g. Near Metro Station, Road 36',
                  controller: _streetController,
                  prefixIcon: Icons.signpost_outlined,
                  validator: (v) => Validators.validateRequired(v, 'Street'),
                ),
                const SizedBox(height: 14),

                CustomTextField(
                  label: 'Area / Colony',
                  hintText: 'e.g. Madhapur / Jubilee Hills',
                  controller: _areaController,
                  prefixIcon: Icons.location_on_outlined,
                  validator: (v) => Validators.validateRequired(v, 'Area'),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'City',
                        hintText: 'Hyderabad',
                        controller: _cityController,
                        validator: (v) =>
                            Validators.validateRequired(v, 'City'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        label: 'State',
                        hintText: 'Telangana',
                        controller: _stateController,
                        validator: (v) =>
                            Validators.validateRequired(v, 'State'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                CustomTextField(
                  label: 'Pincode',
                  hintText: 'e.g. 500081',
                  controller: _pincodeController,
                  keyboardType: TextInputType.number,
                  validator: Validators.validatePincode,
                ),
                const SizedBox(height: 16),

                // Make default checkbox
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Make this my default delivery address',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  value: _isDefault,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    setState(() {
                      _isDefault = val ?? false;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Save button
                CustomButton(
                  text: 'Save Address',
                  icon: Icons.check_circle_outline,
                  onPressed: _saveAddress,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ),
);
  }
}
