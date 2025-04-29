import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _key = 'theme_mode';
  final SharedPreferences _prefs;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider(this._prefs) {
    final str = _prefs.getString(_key);
    if (str != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == str,
        orElse: () => ThemeMode.system,
      );
    }
  }

  ThemeMode get themeMode => _themeMode;

  ThemeData get lightTheme => ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        useMaterial3: true,
      );

  ThemeData get darkTheme => ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        useMaterial3: true,
      );

  Future<void> setTheme(String theme) async {
    switch (theme) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
    await _prefs.setString(_key, _themeMode.toString());
    notifyListeners();
  }
}
