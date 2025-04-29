import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../config/app_config.dart';
import '../widgets/app_drawer.dart';
import '../widgets/nepali_calendar_view.dart';
import '../widgets/home_quick_actions.dart';
import '../widgets/home_highlights.dart';
import '../widgets/home_weather.dart';
import '../widgets/home_quote.dart';
import '../utils/date_converter.dart';
import 'calendar_screen.dart';
import 'news_screen.dart';
import 'forex_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset bottom nav to Home when returning to HomeScreen
    final ModalRoute? route = ModalRoute.of(context);
    if (route != null && route.isCurrent && _selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
    }
  }
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    
    setState(() {
      _selectedIndex = index;
    });

    Widget? nextScreen;
    switch (index) {
      case 1:
        nextScreen = const CalendarScreen();
        break;
      case 2:
        nextScreen = const NewsScreen();
        break;
      case 3:
        nextScreen = const ForexScreen();
        break;
      case 4:
        nextScreen = const SettingsScreen();
        break;
    }

    if (nextScreen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => nextScreen!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    final ad = AppConfig.ads.isNotEmpty ? AppConfig.ads.first : null;
    final contact = AppConfig.contactInfo;

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getText('हकआइ पात्रो', 'Hawkeye Patro')),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () {
              themeProvider.setTheme(
                  themeProvider.themeMode == ThemeMode.dark ? 'light' : 'dark');
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Show current Nepali date in preview
            (() {
              final now = DateTime.now();
              final bs = DateConverter.convertADToBS(now);
              return NepaliCalendarView(
                year: bs['year']!,
                month: bs['month']!,
                selectedDay: bs['day']!,
              );
            })(),
            const HomeHighlights(),
            const HomeWeather(),
            HomeQuickActions(onActionTap: _onItemTapped),
            const HomeQuote(),
            if (ad != null && ad.isActive)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black12, // fallback background
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.asset(
                            ad.imageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover, // Ensures best aspect ratio and cropping
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ad.title,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              ad.description,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                // In a real app, use url_launcher to open ad.linkUrl
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(languageProvider.getText('थप जानकारी', 'Learn More')),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward, size: 16),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.contact_page,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  languageProvider.getText('सम्पर्क', 'Contact'),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${contact.phone} | ${contact.email}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: languageProvider.getText('गृह', 'Home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: languageProvider.getText('पात्रो', 'Calendar'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.newspaper),
            label: languageProvider.getText('समाचार', 'News'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.currency_exchange),
            label: languageProvider.getText('विनिमय दर', 'Forex'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: languageProvider.getText('सेटिङ', 'Settings'),
          ),
        ],
      ),
    );
  }
}
