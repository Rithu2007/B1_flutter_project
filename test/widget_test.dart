import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:local_grocery/main.dart';
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
}
