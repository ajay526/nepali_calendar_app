import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../services/radio_service.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  final _radioService = RadioService();
  final List<Map<String, String>> _stations = [
    {
      'name': 'Radio Nepal',
      'url': 'https://example.com/radio-nepal',
      'image': 'assets/images/radio-nepal.png',
    },
    {
      'name': 'Kantipur FM',
      'url': 'https://example.com/kantipur-fm',
      'image': 'assets/images/kantipur-fm.png',
    },
    {
      'name': 'Hits FM',
      'url': 'https://example.com/hits-fm',
      'image': 'assets/images/hits-fm.png',
    },
  ];

  @override
  void dispose() {
    _radioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getText('रेडियो', 'Radio')),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _stations.length,
        itemBuilder: (context, index) {
          final station = _stations[index];
          final isCurrentStation =
              _radioService.currentStation == station['url'];
          final isPlaying = _radioService.isPlaying && isCurrentStation;

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(station['image']!),
              ),
              title: Text(station['name']!),
              trailing: IconButton(
                icon: Icon(
                  isPlaying ? Icons.stop : Icons.play_arrow,
                  color:
                      isCurrentStation ? Theme.of(context).primaryColor : null,
                ),
                onPressed: () async {
                  if (isPlaying) {
                    await _radioService.stop();
                  } else {
                    await _radioService.playStation(station['url']!);
                  }
                  setState(() {});
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
