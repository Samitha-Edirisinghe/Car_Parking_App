// services/auth_service.dart
import 'package:flutter/foundation.dart';

class AuthService with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String email, String password) async {
    // Implement actual login logic
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    // Implement registration logic
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
