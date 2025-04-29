import 'package:nepali_utils/nepali_utils.dart';
import 'package:weather/weather.dart';

class FarmingCalendar {
  final NepaliDateTime date;
  final String season;
  final List<String> recommendedCrops;
  final List<String> farmingActivities;
  final WeatherData? weatherForecast;
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
          ? WeatherSerialization.fromJson(json['weatherForecast'])
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
      'weatherForecast': weatherForecast != null
          ? WeatherSerialization.toJson(weatherForecast!)
          : null,
    };
  }

  static const List<String> nepaliSeasons = [
    'Basanta',
    'Grishma',
    'Barsha',
    'Sharad',
    'Hemanta',
    'Shishir'
  ];

  bool isGoodTimeForPlanting() {
    if (weatherForecast == null) return true;

    try {
      final temp = weatherForecast!.temperature?.celsius;
      final humidity = weatherForecast!.humidity;
      final precipitation = weatherForecast!.rainLastHour ?? 0;

      return temp != null &&
          humidity != null &&
          temp > 15 &&
          temp < 30 &&
          humidity > 60 &&
          humidity < 90 &&
          precipitation < 5;
    } catch (e) {
      return true;
    }
  }

  String getPlantingRecommendation() {
    final canPlant = isGoodTimeForPlanting();
    final currentMonth = date.month;

    if (!canPlant) {
      return "Not recommended to plant today due to weather conditions.";
    }

    switch (currentMonth) {
      case 1:
        return "Ideal time for planting rice and maize.";
      case 2:
        return "Plant millet and vegetables.";
      case 3:
        return "Start planting paddy in lowlands.";
      case 4:
        return "Main paddy planting season.";
      case 5:
        return "Plant buckwheat and amaranth.";
      case 8:
        return "Winter crops: wheat, barley, mustard.";
      case 9:
        return "Plant garlic and onions.";
      default:
        return traditionalGuidelines['$currentMonth'] ??
            "Check traditional guidelines for planting advice.";
    }
  }
}

/// Helper wrapper for Weather serialization
class WeatherSerialization {
  static Map<String, dynamic> toJson(WeatherData weather) {
    return {
      'temperature': weather.temperature?.celsius,
      'humidity': weather.humidity,
      'precipitation': weather.rainLastHour,
      'windSpeed': weather.windSpeed,
      'cloudiness': weather.cloudiness,
      'sunrise': weather.sunrise?.toIso8601String(),
      'sunset': weather.sunset?.toIso8601String(),
    };
  }

  static WeatherData fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature:
          json['temperature'] != null ? Temperature(json['temperature']) : null,
      humidity: json['humidity'],
      rainLastHour: json['precipitation'],
      windSpeed: json['windSpeed'],
      cloudiness: json['cloudiness'],
      sunrise: json['sunrise'] != null ? DateTime.parse(json['sunrise']) : null,
      sunset: json['sunset'] != null ? DateTime.parse(json['sunset']) : null,
    );
  }
}

/// Custom WeatherData class to mirror values from the `weather` package
class WeatherData {
  final Temperature? temperature;
  final int? humidity;
  final double? rainLastHour;
  final double? windSpeed;
  final int? cloudiness;
  final DateTime? sunrise;
  final DateTime? sunset;

  WeatherData({
    this.temperature,
    this.humidity,
    this.rainLastHour,
    this.windSpeed,
    this.cloudiness,
    this.sunrise,
    this.sunset,
  });
}
