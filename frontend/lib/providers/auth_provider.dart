import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService = AuthService();

  bool isLoggedIn = false;
  bool isLoading = false;
  String? errorMessage;

  // called from login_screen.dart when Login button is tapped
  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await authService.login(email, password);
      isLoggedIn = true;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoggedIn = false;
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // called from register_screen.dart when Create Account button is tapped
  Future<bool> register(String fullName, String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      UserModel newUser = UserModel(uid: '', email: email, username: fullName);
      await authService.register(newUser, password);
      isLoggedIn = true;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoggedIn = false;
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // called from profile_screen.dart later
  Future<void> logout() async {
    await authService.logout();
    isLoggedIn = false;
    notifyListeners();
  }
}
