import 'package:flutter/material.dart';

/// State management provider for Customer User Profile details
class UserProvider extends ChangeNotifier {
  String _name = 'Aarav Sharma';
  String _phone = '+91 98765 43210';
  String _email = 'aarav.sharma@example.in';
  String _profileImageUrl =
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80';

  final List<String> _presetAvatars = [
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&q=80',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=300&q=80',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300&q=80',
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=300&q=80',
    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=300&q=80',
  ];

  String get name => _name;
  String get phone => _phone;
  String get email => _email;
  String get profileImageUrl => _profileImageUrl;
  List<String> get presetAvatars => _presetAvatars;

  void updatePersonalInfo({
    required String name,
    required String phone,
    required String email,
  }) {
    _name = name;
    _phone = phone;
    _email = email;
    notifyListeners();
  }

  void updateProfileImage(String newUrl) {
    _profileImageUrl = newUrl;
    notifyListeners();
  }
}
