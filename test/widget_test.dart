import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:local_grocery/main.dart';
import 'package:local_grocery/models/address.dart';
import 'package:local_grocery/data/products.dart';
import 'package:local_grocery/providers/cart_provider.dart';
import 'package:local_grocery/providers/order_provider.dart';
import 'package:local_grocery/providers/products_provider.dart';
import 'package:local_grocery/providers/settings_provider.dart';
import 'package:local_grocery/providers/user_provider.dart';
import 'package:local_grocery/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Local Grocery app smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => ProductsProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => OrderProvider()),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ],
        child: const LocalGroceryApp(),
      ),
    );

    // Initial frame
    await tester.pump();
    expect(find.byType(LocalGroceryApp), findsOneWidget);

    // Allow splash timer to complete
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });

  test('Cart math and threshold tests', () {
    final cart = CartProvider();
    final p1 = mockProducts[0]; // Apples: price 149, original 179

    expect(cart.isEmpty, isTrue);
    expect(cart.deliveryFee, equals(0.0));

    cart.addItem(p1, quantity: 2);
    expect(cart.totalItemCount, equals(2));
    expect(cart.subtotal, equals(298.0));
    expect(cart.originalSubtotal, equals(358.0));
    expect(cart.discountAmount, equals(60.0));
    // Since 298 < 499 (freeDeliveryThreshold), delivery fee is AppConstants.defaultDeliveryFee (30.0)
    expect(cart.deliveryFee, equals(30.0));
    expect(cart.grandTotal, equals(328.0));

    // Grand total = (originalSubtotal - discountAmount) + deliveryFee
    expect(cart.grandTotal, equals(cart.originalSubtotal - cart.discountAmount + cart.deliveryFee));
  });

  test('SettingsProvider address logic ensures default address', () {
    final settings = SettingsProvider();
    final initialAddresses = settings.addresses;
    expect(initialAddresses, isNotEmpty);
    expect(settings.defaultAddress, isNotNull);

    const testAddr = Address(
      id: 'addr_unit_test',
      fullName: 'Test User',
      phone: '9999999999',
      houseNumber: '101',
      street: 'Main St',
      area: 'Hitech City',
      city: 'Hyderabad',
      state: 'Telangana',
      pincode: '500081',
      type: 'Office',
      isDefault: true,
    );

    settings.addAddress(testAddr);
    expect(settings.defaultAddress?.id, equals('addr_unit_test'));
  });
}
