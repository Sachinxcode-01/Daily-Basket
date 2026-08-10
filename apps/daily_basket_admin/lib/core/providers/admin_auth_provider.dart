import 'package:flutter/material.dart';

enum MfaType { totp, sms, biometric }

class AdminAuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _adminRole = 'SUPER_ADMIN';
  final String _adminName = 'Ananya R. (Senior Director)';
  String _adminEmail = 'admin@dailybasket.com';
  MfaType _selectedMfaType = MfaType.totp;
  bool _isMfaVerified = false;
  final bool _isDeviceTrusted = true;
  final String _deviceId = 'dev_macbook_pro_m3_01';
  final double _riskScore = 0.04;


  bool get isLoggedIn => _isLoggedIn;
  String get adminRole => _adminRole;
  String get adminName => _adminName;
  String get adminEmail => _adminEmail;
  MfaType get selectedMfaType => _selectedMfaType;
  bool get isMfaVerified => _isMfaVerified;
  bool get isDeviceTrusted => _isDeviceTrusted;
  String get deviceId => _deviceId;
  double get riskScore => _riskScore;

  void login(String email, String role) {
    _adminEmail = email;
    _adminRole = role;
    notifyListeners();
  }

  void selectMfaType(MfaType type) {
    _selectedMfaType = type;
    notifyListeners();
  }

  bool verifyOtp(String code) {
    if (code.length == 6) {
      _isMfaVerified = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void verifyBiometricSuccess() {
    _isMfaVerified = true;
    notifyListeners();
  }

  void completeAuthentication() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _isMfaVerified = false;
    notifyListeners();
  }
}

