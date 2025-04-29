import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/icons/logo.png',
                                  height: 160,
                                  width: 160,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Hawkeye Patro Logo',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Material(
                      elevation: 4,
                      shape: const CircleBorder(),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 40,
                          child: Image.asset(
                            'assets/icons/logo.png',
                            height: 64,
                            width: 64,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    languageProvider.getText('हकआइ पात्रो', 'Hawkeye Patro'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(languageProvider.getText('पात्रो', 'Calendar')),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/calendar');
            },
          ),
          ExpansionTile(
            leading: const Icon(Icons.stars),
            title: Text(languageProvider.getText('ज्योतिष', 'Jyotish')),
            initiallyExpanded: true,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(languageProvider.getText('ज्योतिष प्रोफाइल', 'Jyotish Profile')),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/jyotish');
                },
              ),
              ListTile(
                leading: const Icon(Icons.auto_graph),
                title: Text(languageProvider.getText('कुण्डली', 'Kundali')),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/kundali');
                },
              ),
              ListTile(
                leading: const Icon(Icons.auto_awesome),
                title: Text(languageProvider.getText('राशिफल', 'Rashifal')),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/rashifal');
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.date_range),
            title: Text(
                languageProvider.getText('मिति रूपान्तरण', 'Date Converter')),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/date-converter');
            },
          ),
          ListTile(
            leading: const Icon(Icons.agriculture),
            title: Text(
                languageProvider.getText('कृषि पात्रो', 'Farming Calendar')),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/farming');
            },
          ),
          ListTile(
            leading: const Icon(Icons.newspaper),
            title: Text(languageProvider.getText('समाचार', 'News')),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/news');
            },
          ),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: Text(languageProvider.getText('विनिमय दर', 'Forex')),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/forex');
            },
          ),
          ListTile(
            leading: const Icon(Icons.radio),
            title: Text(languageProvider.getText('रेडियो', 'Radio')),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/radio');
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            title: Text(
              themeProvider.themeMode == ThemeMode.dark
                  ? languageProvider.getText('उज्यालो मोड', 'Light Mode')
                  : languageProvider.getText('अँध्यारो मोड', 'Dark Mode'),
            ),
            onTap: () {
              themeProvider.setTheme(
                themeProvider.themeMode == ThemeMode.dark ? 'light' : 'dark',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(languageProvider.getText('भाषा', 'Language')),
            trailing: Text(
              languageProvider.isNepali ? 'नेपाली' : 'English',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              languageProvider.toggleLanguage();
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(languageProvider.getText('सेटिङ्स', 'Settings')),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: Text(languageProvider.getText('प्रतिक्रिया', 'Feedback')),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/feedback');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(languageProvider.getText('हाम्रो बारेमा', 'About Us')),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/about');
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: Text(languageProvider.getText('गोपनीयता नीति', 'Privacy Policy')),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/privacy-policy');
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_support),
            title: Text(languageProvider.getText('सम्पर्क', 'Contact')),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/contact');
            },
          ),
        ],
      ),
    );
  }
}
