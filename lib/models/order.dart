import 'cart_item.dart';
import 'address.dart';

enum OrderStatus {
  preparing,
  outForDelivery,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class OrderModel {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final Address deliveryAddress;
  final String paymentMethod;
  OrderStatus status;
  final String estimatedDeliveryTime;

  OrderModel({
    required this.id,
    required this.date,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.status = OrderStatus.preparing,
    this.estimatedDeliveryTime = '30–45 mins',
  });

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'items': items.map((e) => e.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'total': total,
      'deliveryAddress': deliveryAddress.toMap(),
      'paymentMethod': paymentMethod,
      'status': status.name,
      'estimatedDeliveryTime': estimatedDeliveryTime,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      items: (map['items'] as List<dynamic>)
          .map((e) => CartItem.fromMap(e as Map<String, dynamic>))
          .toList(),
      subtotal: (map['subtotal'] as num).toDouble(),
      deliveryFee: (map['deliveryFee'] as num).toDouble(),
      discount: (map['discount'] as num).toDouble(),
      total: (map['total'] as num).toDouble(),
      deliveryAddress:
          Address.fromMap(map['deliveryAddress'] as Map<String, dynamic>),
      paymentMethod: map['paymentMethod'] as String,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => OrderStatus.preparing,
      ),
      estimatedDeliveryTime: map['estimatedDeliveryTime'] as String? ?? '30–45 mins',
    );
  }
}
