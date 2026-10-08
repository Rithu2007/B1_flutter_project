import 'dart:math';
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/address.dart';
import '../data/mock_orders.dart';
import 'cart_provider.dart';

class OrderProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];

  OrderProvider() {
    _orders.addAll(mockOrders);
  }

  List<OrderModel> get allOrders => List.unmodifiable(_orders);

  List<OrderModel> get activeOrders => _orders
      .where((o) =>
          o.status == OrderStatus.preparing ||
          o.status == OrderStatus.outForDelivery)
      .toList();

  List<OrderModel> get completedOrders => _orders
      .where((o) =>
          o.status == OrderStatus.delivered ||
          o.status == OrderStatus.cancelled)
      .toList();

  OrderModel placeOrder({
    required List<CartItem> items,
    required double subtotal,
    required double deliveryFee,
    required double discount,
    required double total,
    required Address deliveryAddress,
    required String paymentMethod,
  }) {
    final randomNum = 10000 + Random().nextInt(89999);
    final orderId = 'LG$randomNum';

    final newOrder = OrderModel(
      id: orderId,
      date: DateTime.now(),
      items: List.from(items),
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      discount: discount,
      total: total,
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
      status: OrderStatus.preparing,
      estimatedDeliveryTime: '30–45 mins',
    );

    _orders.insert(0, newOrder);
    notifyListeners();
    return newOrder;
  }

  OrderModel? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  void reorder(String orderId, CartProvider cart) {
    final order = getOrderById(orderId);
    if (order != null) {
      cart.addMultipleItems(order.items);
    }
  }
}
