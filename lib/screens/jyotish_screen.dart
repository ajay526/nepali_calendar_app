import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../config/app_config.dart';

class JyotishScreen extends StatelessWidget {
  const JyotishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final profiles = AppConfig.jyotishProfiles;

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getText(
            'ज्योतिष प्रोफाइलहरू', 'Jyotish Profiles')),
      ),
      body: ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return Card(
            child: ListTile(
              leading: Image.asset(profile.imageUrl, width: 50),
              title: Text(languageProvider.isNepali
                  ? profile.name
                  : profile.englishName),
              subtitle: Text(profile.description),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final uri = Uri.parse(profile.contactUrl);
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
            ),
          );
        },
      ),
    );
  }
}
