import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../utils/constants.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  List<CartItem> get cartItemList => _items.values.toList();

  int get totalItemCount =>
      _items.values.fold(0, (total, item) => total + item.quantity);

  int get distinctCount => _items.length;

  bool get isEmpty => _items.isEmpty;

  double get subtotal =>
      _items.values.fold(0.0, (total, item) => total + item.totalPrice);

  double get originalSubtotal =>
      _items.values.fold(0.0, (total, item) => total + item.originalTotalPrice);

  double get totalSavings =>
      _items.values.fold(0.0, (total, item) => total + item.savings);

  double get deliveryFee {
    if (isEmpty) return 0.0;
    return subtotal >= AppConstants.freeDeliveryThreshold
        ? 0.0
        : AppConstants.defaultDeliveryFee;
  }

  double get discountAmount => totalSavings;

  double get grandTotal => subtotal + deliveryFee;

  int getItemQuantity(String productId) {
    return _items[productId]?.quantity ?? 0;
  }

  void addItem(Product product, {int quantity = 1}) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += quantity;
    } else {
      _items[product.id] = CartItem(product: product, quantity: quantity);
    }
    notifyListeners();
  }

  void decreaseQuantity(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity -= 1;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    if (_items.containsKey(productId)) {
      _items.remove(productId);
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void addMultipleItems(List<CartItem> newItems) {
    for (var item in newItems) {
      if (_items.containsKey(item.product.id)) {
        _items[item.product.id]!.quantity += item.quantity;
      } else {
        _items[item.product.id] =
            CartItem(product: item.product, quantity: item.quantity);
      }
    }
    notifyListeners();
  }
}
