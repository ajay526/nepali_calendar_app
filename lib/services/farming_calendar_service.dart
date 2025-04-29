import 'package:nepali_utils/nepali_utils.dart';
import '../models/weather_data.dart' as model;

class FarmingCalendar {
  final NepaliDateTime date;
  final String season;
  final List<String> recommendedCrops;
  final List<String> farmingActivities;
  final model.WeatherData? weatherForecast;
  final Map<String, String> traditionalGuidelines;

  FarmingCalendar({
    required this.date,
    required this.season,
    required this.recommendedCrops,
    required this.farmingActivities,
    this.weatherForecast,
    required this.traditionalGuidelines,
  });

  factory FarmingCalendar.fromJson(Map<String, dynamic> json) {
    return FarmingCalendar(
      date: NepaliDateTime.parse(json['date']),
      season: json['season'],
      recommendedCrops: List<String>.from(json['recommendedCrops']),
      farmingActivities: List<String>.from(json['farmingActivities']),
      traditionalGuidelines:
          Map<String, String>.from(json['traditionalGuidelines']),
      weatherForecast: json['weatherForecast'] != null
          ? model.WeatherData.fromJson(json['weatherForecast'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toString(),
      'season': season,
      'recommendedCrops': recommendedCrops,
      'farmingActivities': farmingActivities,
      'traditionalGuidelines': traditionalGuidelines,
      'weatherForecast': weatherForecast?.toJson(),
    };
  }
}
