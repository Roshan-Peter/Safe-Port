// lib/auth/auth_notifier.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthNotifier extends ChangeNotifier {
  AuthStatus _status   = AuthStatus.unknown;


  bool       get isAuthenticated => _status == AuthStatus.authenticated;

  static const _keyLoggedIn = 'is_logged_in';

  AuthNotifier() { _init(); }

  Future<void> _init() async {
    final prefs     = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyLoggedIn) ?? false;

    if (isLoggedIn) {
      _status   = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }


  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _status   = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void updateUsername(String newUsername) {
    notifyListeners();
    // Persist to SharedPreferences
    // SharedPreferences.getInstance().then(
    //       (prefs) => prefs.setString(_keyUsername, newUsername),
    // );
  }
}