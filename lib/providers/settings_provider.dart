import 'package:flutter/material.dart';
import '../models/address.dart';
import '../models/notification_item.dart';
import '../data/mock_addresses.dart';
import '../data/mock_notifications.dart';
import '../services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  final List<Address> _addresses = [];
  final List<NotificationItem> _notifications = [];

  SettingsProvider() {
    _loadSettings();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get notificationsEnabled => _notificationsEnabled;
  String get selectedLanguage => _selectedLanguage;
  List<Address> get addresses => List.unmodifiable(_addresses);
  List<NotificationItem> get notifications =>
      List.unmodifiable(_notifications);

  int get unreadNotificationsCount =>
      _notifications.where((n) => !n.isRead).length;

  Address? get defaultAddress {
    try {
      return _addresses.firstWhere((a) => a.isDefault,
          orElse: () => _addresses.isNotEmpty
              ? _addresses.first
              : mockAddresses.first);
    } catch (_) {
      return mockAddresses.first;
    }
  }

  void _loadSettings() {
    final dark = StorageService.isDarkMode();
    _themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    _notificationsEnabled = StorageService.isNotificationsEnabled();

    final saved = StorageService.getSavedAddresses();
    if (saved != null && saved.isNotEmpty) {
      _addresses.addAll(saved);
    } else {
      _addresses.addAll(mockAddresses);
    }

    _notifications.addAll(mockNotifications);
    notifyListeners();
  }

  void toggleDarkMode(bool enabled) {
    _themeMode = enabled ? ThemeMode.dark : ThemeMode.light;
    StorageService.setDarkMode(enabled);
    notifyListeners();
  }

  void toggleNotifications(bool enabled) {
    _notificationsEnabled = enabled;
    StorageService.setNotificationsEnabled(enabled);
    notifyListeners();
  }

  void setLanguage(String lang) {
    _selectedLanguage = lang;
    notifyListeners();
  }

  void addAddress(Address address) {
    final shouldBeDefault = address.isDefault || _addresses.isEmpty;
    if (shouldBeDefault) {
      for (int i = 0; i < _addresses.length; i++) {
        _addresses[i] = _addresses[i].copyWith(isDefault: false);
      }
    }
    _addresses.add(shouldBeDefault ? address.copyWith(isDefault: true) : address);
    StorageService.saveAddresses(_addresses);
    notifyListeners();
  }

  void setDefaultAddress(String addressId) {
    for (int i = 0; i < _addresses.length; i++) {
      final isDef = _addresses[i].id == addressId;
      _addresses[i] = _addresses[i].copyWith(isDefault: isDef);
    }
    StorageService.saveAddresses(_addresses);
    notifyListeners();
  }

  void deleteAddress(String addressId) {
    _addresses.removeWhere((a) => a.id == addressId);
    if (_addresses.isNotEmpty && !_addresses.any((a) => a.isDefault)) {
      _addresses[0] = _addresses[0].copyWith(isDefault: true);
    }
    StorageService.saveAddresses(_addresses);
    notifyListeners();
  }

  void markNotificationAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }
}
