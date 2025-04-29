import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/calendar_provider.dart';

class FarmingCalendarScreen extends StatelessWidget {
  const FarmingCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final calendarProvider = Provider.of<CalendarProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title:
            Text(languageProvider.getText('कृषि पात्रो', 'Farming Calendar')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildWeatherCard(context, languageProvider),
          const SizedBox(height: 16),
          _buildSeasonalCropsCard(context, languageProvider, calendarProvider),
          const SizedBox(height: 16),
          _buildFarmingTipsCard(context, languageProvider),
          const SizedBox(height: 16),
          _buildMoonPhaseCard(context, languageProvider, calendarProvider),
        ],
      ),
    );
  }

  Widget _buildWeatherCard(
      BuildContext context, LanguageProvider languageProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(languageProvider.getText('मौसम', 'Weather'),
                    style: Theme.of(context).textTheme.titleLarge),
                const Icon(Icons.cloud, size: 32),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherInfo(context, Icons.thermostat, '25°C',
                    languageProvider.getText('तापक्रम', 'Temperature')),
                _buildWeatherInfo(context, Icons.water_drop, '75%',
                    languageProvider.getText('आर्द्रता', 'Humidity')),
                _buildWeatherInfo(context, Icons.air, '10 km/h',
                    languageProvider.getText('हावा', 'Wind')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(
      BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildSeasonalCropsCard(BuildContext context,
      LanguageProvider languageProvider, CalendarProvider calendarProvider) {
    final currentSeason = calendarProvider.getCurrentSeason();
    final seasonalCrops = calendarProvider.getSeasonalCrops(currentSeason);

    final allCrops = seasonalCrops.map((e) => e['recommendedCrops']).toSet();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(languageProvider.getText('मौसमी बाली', 'Seasonal Crops'),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Text(
              languageProvider.getText('वर्तमान ऋतु: $currentSeason',
                  'Current Season: $currentSeason'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allCrops.map((crop) {
                return Chip(
                  avatar: const Icon(Icons.grass),
                  label: Text(crop),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmingTipsCard(
      BuildContext context, LanguageProvider languageProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(languageProvider.getText('कृषि सुझाव', 'Farming Tips'),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildTipItem(
                context,
                Icons.water,
                languageProvider.getText('बिहान वा बेलुकी सिंचाई गर्नुहोस्',
                    'Water plants in the morning or evening')),
            const Divider(),
            _buildTipItem(
                context,
                Icons.compost,
                languageProvider.getText(
                    'जैविक मल प्रयोग गर्नुहोस्', 'Use organic fertilizers')),
            const Divider(),
            _buildTipItem(
                context,
                Icons.pest_control,
                languageProvider.getText(
                    'कीरा नियन्त्रणको लागि नीम प्रयोग गर्नुहोस्',
                    'Use neem for pest control')),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, IconData icon, String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Expanded(child: Text(tip)),
        ],
      ),
    );
  }

  Widget _buildMoonPhaseCard(BuildContext context,
      LanguageProvider languageProvider, CalendarProvider calendarProvider) {
    final moonPhase = calendarProvider.getCurrentMoonPhase();
    final moonPhaseIcon = _getMoonPhaseIcon(moonPhase);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(languageProvider.getText('चन्द्रमाको कला', 'Moon Phase'),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(moonPhaseIcon, size: 48),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(moonPhase,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(_getMoonPhaseTip(moonPhase, languageProvider),
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMoonPhaseIcon(String phase) {
    switch (phase.toLowerCase()) {
      case 'new moon':
        return Icons.circle_outlined;
      case 'waxing crescent':
        return Icons.brightness_2_outlined;
      case 'first quarter':
        return Icons.brightness_3_outlined;
      case 'waxing gibbous':
        return Icons.brightness_4_outlined;
      case 'full moon':
        return Icons.brightness_5_outlined;
      case 'waning gibbous':
        return Icons.brightness_6_outlined;
      case 'last quarter':
        return Icons.brightness_3_outlined;
      case 'waning crescent':
        return Icons.brightness_2_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  String _getMoonPhaseTip(String phase, LanguageProvider languageProvider) {
    switch (phase.toLowerCase()) {
      case 'new moon':
        return languageProvider.getText(
            'बीउ रोप्नको लागि उत्तम समय', 'Ideal time for planting seeds');
      case 'waxing crescent':
        return languageProvider.getText(
            'फलफूल र तरकारी रोप्नको लागि राम्रो समय',
            'Good time for planting fruits and vegetables');
      case 'full moon':
        return languageProvider.getText(
            'बाली टिप्नको लागि उत्तम समय', 'Best time for harvesting');
      default:
        return languageProvider.getText(
            'नियमित बगैंचा हेरचाह गर्नुहोस्', 'Maintain regular garden care');
    }
  }
}
