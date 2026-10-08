import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../models/user.dart';
import '../models/address.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Onboarding
  static bool isOnboardingCompleted() {
    return _prefs?.getBool(AppConstants.keyOnboardingCompleted) ?? false;
  }

  static Future<void> setOnboardingCompleted(bool value) async {
    await _prefs?.setBool(AppConstants.keyOnboardingCompleted, value);
  }

  // Auth & User
  static bool isLoggedIn() {
    return _prefs?.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    await _prefs?.setBool(AppConstants.keyIsLoggedIn, value);
  }

  static AppUser? getUser() {
    final userJson = _prefs?.getString(AppConstants.keyUserData);
    if (userJson != null) {
      try {
        return AppUser.fromMap(jsonDecode(userJson) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static Future<void> saveUser(AppUser user) async {
    await _prefs?.setString(AppConstants.keyUserData, jsonEncode(user.toMap()));
  }

  static Future<void> clearUser() async {
    await _prefs?.remove(AppConstants.keyUserData);
    await _prefs?.setBool(AppConstants.keyIsLoggedIn, false);
  }

  // Settings
  static bool isDarkMode() {
    return _prefs?.getBool(AppConstants.keyDarkMode) ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    await _prefs?.setBool(AppConstants.keyDarkMode, value);
  }

  static bool isNotificationsEnabled() {
    return _prefs?.getBool(AppConstants.keyNotifications) ?? true;
  }

  static Future<void> setNotificationsEnabled(bool value) async {
    await _prefs?.setBool(AppConstants.keyNotifications, value);
  }

  // Favorites
  static Set<String> getFavorites() {
    final list = _prefs?.getStringList(AppConstants.keyFavorites) ?? [];
    return list.toSet();
  }

  static Future<void> saveFavorites(Set<String> ids) async {
    await _prefs?.setStringList(AppConstants.keyFavorites, ids.toList());
  }

  // Addresses
  static List<Address>? getSavedAddresses() {
    final list = _prefs?.getStringList(AppConstants.keyAddresses);
    if (list != null) {
      try {
        return list
            .map((e) => Address.fromMap(jsonDecode(e) as Map<String, dynamic>))
            .toList();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static Future<void> saveAddresses(List<Address> addresses) async {
    final list = addresses.map((e) => jsonEncode(e.toMap())).toList();
    await _prefs?.setStringList(AppConstants.keyAddresses, list);
  }
}
