import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'language';
  String _currentLanguage = 'ne'; // Default to Nepali
  final SharedPreferences _prefs;

  LanguageProvider(this._prefs) {
    // Initialize from shared preferences
    _currentLanguage = _prefs.getString(_languageKey) ?? 'ne';
  }

  String get currentLanguage => _currentLanguage;

  bool get isNepali => _currentLanguage == 'ne';

  Future<void> setLanguage(String language) async {
    _currentLanguage = language;
    await _prefs.setString(_languageKey, language);
    notifyListeners();
  }

  void toggleLanguage() {
    _currentLanguage = _currentLanguage == 'ne' ? 'en' : 'ne';
    _prefs.setString(_languageKey, _currentLanguage);
    notifyListeners();
  }

  String getText(String nepaliText, String englishText) {
    return _currentLanguage == 'ne' ? nepaliText : englishText;
  }

  List<String> getWeekDayNames() {
    return _currentLanguage == 'ne'
        ? ['आइत', 'सोम', 'मंगल', 'बुध', 'बिही', 'शुक्र', 'शनि']
        : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  }
}
