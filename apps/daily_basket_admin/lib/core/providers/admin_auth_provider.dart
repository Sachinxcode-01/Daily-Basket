import 'package:flutter/material.dart';

class AdminAuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _adminRole = 'SUPER_ADMIN';
  final String _adminName = 'Ananya R. (Senior Director)';
  String _adminEmail = 'admin@dailybasket.com';


  bool get isLoggedIn => _isLoggedIn;
  String get adminRole => _adminRole;
  String get adminName => _adminName;
  String get adminEmail => _adminEmail;

  void login(String email, String role) {
    _isLoggedIn = true;
    _adminEmail = email;
    _adminRole = role;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
