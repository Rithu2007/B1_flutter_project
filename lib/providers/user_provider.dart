import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/mock_auth_service.dart';
import '../services/storage_service.dart';

class UserProvider extends ChangeNotifier {
  final MockAuthService _authService = MockAuthService();
  AppUser? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  UserProvider() {
    _loadUserFromStorage();
  }

  void _loadUserFromStorage() {
    _isLoggedIn = StorageService.isLoggedIn();
    if (_isLoggedIn) {
      _currentUser = StorageService.getUser() ?? AppUser.demoUser;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _authService.login(email, password);
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginDemo() async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _authService.loginWithDemo();
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _authService.signUp(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      name: name,
      email: email,
      phone: phone,
    );
    await StorageService.saveUser(_currentUser!);
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
