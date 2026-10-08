import '../models/notification_item.dart';

final List<NotificationItem> mockNotifications = [
  NotificationItem(
    id: 'notif_01',
    title: 'Order Out for Delivery! 🛵',
    message: 'Your order #LG10245 is out for delivery with our delivery partner Ramesh. Arriving in 15 mins.',
    timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    isRead: false,
    type: 'order',
  ),
  NotificationItem(
    id: 'notif_02',
    title: 'Order Preparing 🥗',
    message: 'Your order #LG10245 has been confirmed and is being packed with fresh groceries.',
    timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
    isRead: false,
    type: 'order',
  ),
  NotificationItem(
    id: 'notif_03',
    title: 'Today\'s Special: 20% OFF! 🎉',
    message: 'Get flat 20% OFF on all fresh farm vegetables in Hyderabad today. Use code FRESH20.',
    timestamp: DateTime.now().subtract(const Duration(hours: 4)),
    isRead: true,
    type: 'promo',
  ),
  NotificationItem(
    id: 'notif_04',
    title: 'Order Delivered Successfully ✅',
    message: 'Order #LG10198 was delivered. We hope you love your fresh groceries!',
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
    isRead: true,
    type: 'order',
  ),
  NotificationItem(
    id: 'notif_05',
    title: 'Welcome to Local Grocery! 🛒',
    message: 'Welcome Thanuj! Enjoy lightning-fast delivery of fresh essentials to your doorstep.',
    timestamp: DateTime.now().subtract(const Duration(days: 5)),
    isRead: true,
    type: 'general',
  ),
];
