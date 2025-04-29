class AppConstants {
  // API Endpoints
  static const String apiBaseUrl = 'https://api.hawkeyepatro.com';
  static const String newsEndpoint = '/news';
  static const String forexEndpoint = '/forex';
  static const String calendarEndpoint = '/calendar';
  static const String kundaliEndpoint = '/kundali';
  static const String rashifalEndpoint = '/rashifal';

  // App Settings
  static const String appName = 'Hawkeye Patro';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Your Daily Companion for News, Forex, and More';
  static const String appWebsite = 'https://hawkeyepatro.com';
  static const String appEmail = 'support@hawkeyepatro.com';
  static const String appPhone = '+977-1-1234567';

  // Cache Settings
  static const int cacheDuration = 3600; // 1 hour in seconds
  static const int maxCacheSize = 100 * 1024 * 1024; // 100 MB

  // Notification Settings
  static const String notificationChannelId = 'hawkeye_patro_channel';
  static const String notificationChannelName = 'Hawkeye Patro Notifications';
  static const String notificationChannelDescription =
      'Notifications from Hawkeye Patro';

  // Theme Settings
  static const double defaultBorderRadius = 12.0;
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double defaultIconSize = 24.0;

  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);

  // Error Messages
  static const String networkError =
      'Network error occurred. Please check your internet connection.';
  static const String serverError =
      'Server error occurred. Please try again later.';
  static const String unknownError =
      'An unknown error occurred. Please try again.';

  // Success Messages
  static const String dataUpdated = 'Data updated successfully.';
  static const String settingsSaved = 'Settings saved successfully.';

  // Validation Messages
  static const String requiredField = 'This field is required.';
  static const String invalidEmail = 'Please enter a valid email address.';
  static const String invalidPhone = 'Please enter a valid phone number.';
  static const String invalidPassword =
      'Password must be at least 6 characters long.';

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';

  // Currency Settings
  static const String defaultCurrency = 'NPR';
  static const List<String> supportedCurrencies = [
    'NPR',
    'USD',
    'EUR',
    'GBP',
    'AUD',
    'CAD'
  ];
}
