class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;
  final String type; // order, promo, general

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.type = 'order',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'type': type,
    };
  }

  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    return NotificationItem(
      id: map['id'] as String,
      title: map['title'] as String,
      message: map['message'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      isRead: map['isRead'] as bool? ?? false,
      type: map['type'] as String? ?? 'order',
    );
  }
}
