import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
  static const String _notificationKey = 'daily_notification_enabled';
  final SharedPreferences _prefs;

  bool _isDailyNotificationEnabled = false;
  bool _hasPermission = true; // Always true in stub version

  NotificationProvider(this._prefs) {
    _isDailyNotificationEnabled = _prefs.getBool(_notificationKey) ?? false;
  }

  bool get isDailyNotificationEnabled => _isDailyNotificationEnabled;
  bool get hasPermission => _hasPermission;

  Future<void> toggleDailyNotification(bool value) async {
    if (!_hasPermission) {
      // Normally check for permissions here
      _hasPermission = true;
    }

    _isDailyNotificationEnabled = value;
    await _prefs.setBool(_notificationKey, value);

    try {
      if (value) {
        await _scheduleDailyNotification();
      } else {
        await _cancelDailyNotification();
      }
    } catch (e) {
      debugPrint('Failed to toggle notifications: $e');
      // Rollback
      _isDailyNotificationEnabled = !value;
      await _prefs.setBool(_notificationKey, !value);
      rethrow;
    }

    notifyListeners();
  }

  Future<void> _scheduleDailyNotification() async {
    // Stub logic for enabling notification
    debugPrint('Stub: Daily notification scheduled');
  }

  Future<void> _cancelDailyNotification() async {
    // Stub logic for disabling notification
    debugPrint('Stub: Daily notification canceled');
  }
}
