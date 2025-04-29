import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/app_config.dart';

import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/calendar_provider.dart';

import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/jyotish_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/kundali_screen.dart';
import 'screens/rashifal_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/news_screen.dart';
import 'screens/forex_screen.dart';
import 'screens/radio_screen.dart';
import 'screens/date_converter_screen.dart';
import 'screens/farming_calendar_screen.dart';
import 'screens/about_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/privacy_policy_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  try {
    await AppConfig.initialize();
  } catch (e) {
    debugPrint('WARNING: Could not load .env file: $e');
  }

  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => LanguageProvider(prefs)),
        ChangeNotifierProvider(create: (_) => NotificationProvider(prefs)),
        ChangeNotifierProvider(create: (_) => CalendarProvider()), // ✅ FIXED
      ],
      child: Consumer3<ThemeProvider, LanguageProvider, NotificationProvider>(
        builder: (context, themeProvider, languageProvider, _, __) {
          return MaterialApp(
            title: languageProvider.getText('हकआइ पात्रो', 'Hawkeye Patro'),
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/': (context) => const HomeScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/jyotish': (context) => const JyotishScreen(),
              '/calendar': (context) => const CalendarScreen(),
              '/kundali': (context) => const KundaliScreen(),
              '/rashifal': (context) => const RashifalScreen(),
              '/contact': (context) => const ContactScreen(),
              '/news': (context) => const NewsScreen(),
              '/forex': (context) => const ForexScreen(),
              '/radio': (context) => const RadioScreen(),
              '/date-converter': (context) => const DateConverterScreen(),
              '/farming': (context) => const FarmingCalendarScreen(),
              '/about': (context) => const AboutScreen(),
              '/feedback': (context) => const FeedbackScreen(),
              '/privacy-policy': (context) => const PrivacyPolicyScreen(),
            },
          );
        },
      ),
    );
  }
}
