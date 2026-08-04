import 'package:flutter/material.dart';

/// State management provider for Language preferences
class LanguageProvider extends ChangeNotifier {
  String _selectedLanguage = 'English';

  final List<Map<String, String>> _availableLanguages = [
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'hi', 'name': 'Hindi', 'native': 'हिंदी'},
    {'code': 'mr', 'name': 'Marathi', 'native': 'मराठी'},
    {'code': 'ta', 'name': 'Tamil', 'native': 'தமிழ்'},
    {'code': 'te', 'name': 'Telugu', 'native': 'తెలుగు'},
    {'code': 'gu', 'name': 'Gujarati', 'native': 'ગુજરાતી'},
    {'code': 'bn', 'name': 'Bengali', 'native': 'বাংলা'},
  ];

  String get selectedLanguage => _selectedLanguage;
  List<Map<String, String>> get availableLanguages => _availableLanguages;

  void setLanguage(String languageName) {
    _selectedLanguage = languageName;
    notifyListeners();
  }
}
