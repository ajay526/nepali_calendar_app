import 'package:flutter/material.dart';

class ForexService {
  static Future<List<Map<String, dynamic>>> getExchangeRates() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Return sample exchange rates
      return [
        {
          'currency': 'USD',
          'country': 'United States',
          'flag': '🇺🇸',
          'buyRate': 132.45,
          'sellRate': 133.05,
          'change': '+0.15',
        },
        {
          'currency': 'EUR',
          'country': 'European Union',
          'flag': '🇪🇺',
          'buyRate': 142.80,
          'sellRate': 143.40,
          'change': '-0.20',
        },
        {
          'currency': 'GBP',
          'country': 'United Kingdom',
          'flag': '🇬🇧',
          'buyRate': 166.35,
          'sellRate': 167.15,
          'change': '+0.25',
        },
        {
          'currency': 'AUD',
          'country': 'Australia',
          'flag': '🇦🇺',
          'buyRate': 86.75,
          'sellRate': 87.25,
          'change': '-0.10',
        },
        {
          'currency': 'JPY',
          'country': 'Japan',
          'flag': '🇯🇵',
          'buyRate': 0.875,
          'sellRate': 0.885,
          'change': '+0.005',
        },
        {
          'currency': 'CNY',
          'country': 'China',
          'flag': '🇨🇳',
          'buyRate': 18.25,
          'sellRate': 18.45,
          'change': '-0.05',
        },
        {
          'currency': 'INR',
          'country': 'India',
          'flag': '🇮🇳',
          'buyRate': 1.60,
          'sellRate': 1.62,
          'change': '+0.01',
        },
      ];
    } catch (e) {
      throw Exception('Failed to load exchange rates: $e');
    }
  }

  static Color getChangeColor(String change) {
    if (change.startsWith('+')) {
      return Colors.green;
    } else if (change.startsWith('-')) {
      return Colors.red;
    }
    return Colors.grey;
  }

  static String formatRate(double rate) {
    return rate.toStringAsFixed(2);
  }
}
