import 'package:flutter/material.dart';
import '../providers/language_provider.dart';
import 'package:provider/provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getText('हाम्रो बारेमा', 'About Us')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/icons/logo.png',
                      width: 90,
                      height: 90,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Hawkeye Patro',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languageProvider.getText(
                        'हाम्रो एपको उद्देश्य नेपाली समुदायलाई डिजिटल पात्रो, राशिफल, कृषि जानकारी, समाचार, रेडियो, र अन्य उपयोगी सेवाहरू प्रदान गर्नु हो।',
                        'Our app aims to empower the Nepali community with a digital calendar, horoscope, farming tips, news, radio, and other useful services.'
                      ),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.group, color: Colors.blueAccent),
                      title: Text(languageProvider.getText('डेभलपर टिम', 'Development Team')),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Hawkeye Team'),
                          SizedBox(height: 4),
                          Text('Developer: Ajay Bhandari'),
                          Text('Contact: +9779865502029'),
                          Text('Email: ajay911526@gmail.com'),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.redAccent),
                      title: Text(languageProvider.getText('सम्पर्क', 'Contact')),
                      subtitle: const Text('info@hawkeye_patro.com'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '© 2025 Hawkeye Patro. All rights reserved.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
