import '../models/order.dart';
import '../models/cart_item.dart';
import 'products.dart';
import 'mock_addresses.dart';

final List<OrderModel> mockOrders = [
  OrderModel(
    id: 'LG10245',
    date: DateTime.now().subtract(const Duration(minutes: 25)),
    items: [
      CartItem(product: mockProducts[0], quantity: 2), // Fresh Apples
      CartItem(product: mockProducts[2], quantity: 2), // Fresh Milk
      CartItem(product: mockProducts[4], quantity: 1), // Tomatoes
    ],
    subtotal: 477.0,
    deliveryFee: 30.0,
    discount: 50.0,
    total: 457.0,
    deliveryAddress: mockAddresses[0],
    paymentMethod: 'UPI (Google Pay)',
    status: OrderStatus.outForDelivery,
    estimatedDeliveryTime: '15–20 mins',
  ),
  OrderModel(
    id: 'LG10198',
    date: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
    items: [
      CartItem(product: mockProducts[6], quantity: 1), // Basmati Rice
      CartItem(product: mockProducts[11], quantity: 2), // Paneer
      CartItem(product: mockProducts[7], quantity: 1), // Eggs
    ],
    subtotal: 831.0,
    deliveryFee: 0.0, // Free delivery above 499
    discount: 80.0,
    total: 751.0,
    deliveryAddress: mockAddresses[0],
    paymentMethod: 'Cash on Delivery',
    status: OrderStatus.delivered,
    estimatedDeliveryTime: 'Delivered',
  ),
  OrderModel(
    id: 'LG10052',
    date: DateTime.now().subtract(const Duration(days: 6)),
    items: [
      CartItem(product: mockProducts[15], quantity: 1), // Tea
      CartItem(product: mockProducts[3], quantity: 2), // Brown Bread
      CartItem(product: mockProducts[1], quantity: 1), // Bananas
    ],
    subtotal: 369.0,
    deliveryFee: 30.0,
    discount: 30.0,
    total: 369.0,
    deliveryAddress: mockAddresses[1],
    paymentMethod: 'Credit/Debit Card',
    status: OrderStatus.delivered,
    estimatedDeliveryTime: 'Delivered',
  ),
];
