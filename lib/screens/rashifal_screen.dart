import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../services/rashifal_service.dart';

class RashifalScreen extends StatefulWidget {
  const RashifalScreen({Key? key}) : super(key: key);

  @override
  State<RashifalScreen> createState() => _RashifalScreenState();
}

class _RashifalScreenState extends State<RashifalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedRashi = 'Mesh'; // Default rashi

  final List<String> _rashis = [
    'Mesh',
    'Vrishabha',
    'Mithun',
    'Karka',
    'Simha',
    'Kanya',
    'Tula',
    'Vrishchika',
    'Dhanu',
    'Makar',
    'Kumbha',
    'Meen',
  ];

  final List<String> _nepaliRashis = [
    'मेष',
    'वृष',
    'मिथुन',
    'कर्कट',
    'सिंह',
    'कन्या',
    'तुला',
    'वृश्चिक',
    'धनु',
    'मकर',
    'कुम्भ',
    'मीन',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getText('राशिफल', 'Rashifal')),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: languageProvider.getText('दैनिक', 'Daily')),
            Tab(text: languageProvider.getText('साप्ताहिक', 'Weekly')),
            Tab(text: languageProvider.getText('मासिक', 'Monthly')),
          ],
        ),
      ),
      body: Column(
        children: [
          // Rashi Selection
          Container(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: languageProvider.getText(
                    'राशि छान्नुहोस्', 'Select Your Rashi'),
                border: const OutlineInputBorder(),
              ),
              value: _selectedRashi,
              items: List.generate(12, (index) {
                return DropdownMenuItem(
                  value: _rashis[index],
                  child: Text(
                    languageProvider.getText(
                        _nepaliRashis[index], _rashis[index]),
                  ),
                );
              }),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _selectedRashi = value;
                  });
                }
              },
            ),
          ),
          // Predictions
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Daily Predictions
                _buildPredictionView(
                  languageProvider,
                  languageProvider.getText('दैनिक राशिफल', 'Daily Prediction'),
                ),
                // Weekly Predictions
                _buildPredictionView(
                  languageProvider,
                  languageProvider.getText(
                      'साप्ताहिक राशिफल', 'Weekly Prediction'),
                ),
                // Monthly Predictions
                _buildPredictionView(
                  languageProvider,
                  languageProvider.getText(
                      'मासिक राशिफल', 'Monthly Prediction'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionView(LanguageProvider languageProvider, String title) {
    final predictionType = title.toLowerCase().contains('daily') ? 'daily' :
                          title.toLowerCase().contains('weekly') ? 'weekly' : 'monthly';
    final prediction = RashifalService.getPrediction(_selectedRashi, predictionType);
    final characteristics = RashifalService.getRashiCharacteristics(_selectedRashi);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        languageProvider.getText('भविष्यवाणी', 'Prediction'),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    languageProvider.isNepali
                        ? prediction['prediction']!
                        : 'Your ${characteristics['element']} element is strong today. Using ${prediction['lucky_colors']} colors will be beneficial.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  languageProvider,
                  Icons.format_list_numbered,
                  languageProvider.getText('भाग्यशाली अंक', 'Lucky Numbers'),
                  prediction['lucky_numbers']!,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  languageProvider,
                  Icons.palette,
                  languageProvider.getText('भाग्यशाली रंग', 'Lucky Colors'),
                  prediction['lucky_colors']!,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  languageProvider,
                  Icons.calendar_today,
                  languageProvider.getText('भाग्यशाली दिन', 'Lucky Days'),
                  prediction['lucky_days']!,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  languageProvider,
                  Icons.diamond,
                  languageProvider.getText('भाग्यशाली रत्न', 'Lucky Stones'),
                  prediction['lucky_stones']!,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(LanguageProvider languageProvider, IconData icon, String title, String content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
