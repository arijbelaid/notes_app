import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  User? get user => _user;

  bool _loading = true;
  bool get loading => _loading;

  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    try {
      _user = await _authService.getCurrentUser();
    } catch (e) {
      _user = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      await _authService.createAccount(email, password, name);
      _user = await _authService.getCurrentUser();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      await _authService.login(email, password);
      _user = await _authService.getCurrentUser();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await _authService.logout();
      _user = null;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
