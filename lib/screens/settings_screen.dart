import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getText('सेटिङ्स', 'Settings')),
      ),
      body: ListView(
        children: [
          // Theme Settings
          Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    languageProvider.getText('थिम सेटिङ्स', 'Theme Settings'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                RadioListTile<ThemeMode>(
                  title: Text(languageProvider.getText('सिस्टम', 'System')),
                  value: ThemeMode.system,
                  groupValue: themeProvider.themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeProvider.setTheme('system');
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: Text(languageProvider.getText('लाइट', 'Light')),
                  value: ThemeMode.light,
                  groupValue: themeProvider.themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeProvider.setTheme('light');
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: Text(languageProvider.getText('डार्क', 'Dark')),
                  value: ThemeMode.dark,
                  groupValue: themeProvider.themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeProvider.setTheme('dark');
                    }
                  },
                ),
              ],
            ),
          ),
          // Language Settings
          Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    languageProvider.getText(
                        'भाषा सेटिङ्स', 'Language Settings'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                RadioListTile<String>(
                  title: const Text('नेपाली'),
                  value: 'ne',
                  groupValue: languageProvider.currentLanguage,
                  onChanged: (String? value) {
                    if (value != null) {
                      languageProvider.setLanguage(value);
                    }
                  },
                ),
                RadioListTile<String>(
                  title: const Text('English'),
                  value: 'en',
                  groupValue: languageProvider.currentLanguage,
                  onChanged: (String? value) {
                    if (value != null) {
                      languageProvider.setLanguage(value);
                    }
                  },
                ),
              ],
            ),
          ),
          // About Section
          Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    languageProvider.getText('एप बारे', 'About App'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ListTile(
                  title: Text(languageProvider.getText('भर्सन', 'Version')),
                  subtitle: const Text('1.0.0'),
                ),
                ListTile(
                  title: Text(languageProvider.getText('डेभलपर', 'Developer')),
                  subtitle: const Text('Hawkeye Team'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
