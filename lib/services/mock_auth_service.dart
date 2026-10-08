import '../models/user.dart';
import 'storage_service.dart';

class MockAuthService {
  // Ready to be replaced with FirebaseAuth.instance.signInWithEmailAndPassword
  Future<AppUser> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network
    final user = AppUser(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: email.split('@').first.toUpperCase(),
      email: email,
      phone: '+91 98765 43210',
    );
    await StorageService.saveUser(user);
    await StorageService.setLoggedIn(true);
    return user;
  }

  Future<AppUser> loginWithDemo() async {
    await Future.delayed(const Duration(milliseconds: 400));
    const user = AppUser.demoUser;
    await StorageService.saveUser(user);
    await StorageService.setLoggedIn(true);
    return user;
  }

  // Ready to be replaced with FirebaseAuth.instance.createUserWithEmailAndPassword
  Future<AppUser> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final user = AppUser(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
    );
    await StorageService.saveUser(user);
    await StorageService.setLoggedIn(true);
    return user;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await StorageService.clearUser();
  }
}
