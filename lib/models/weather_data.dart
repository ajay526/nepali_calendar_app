class WeatherData {
  final double? temperature;
  final int? humidity;
  final double? precipitation;
  final double? windSpeed;
  final int? cloudiness;
  final DateTime? sunrise;
  final DateTime? sunset;

  WeatherData({
    this.temperature,
    this.humidity,
    this.precipitation,
    this.windSpeed,
    this.cloudiness,
    this.sunrise,
    this.sunset,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: (json['temperature'] as num?)?.toDouble(),
      humidity: json['humidity'] as int?,
      precipitation: (json['precipitation'] as num?)?.toDouble(),
      windSpeed: (json['windSpeed'] as num?)?.toDouble(),
      cloudiness: json['cloudiness'] as int?,
      sunrise: json['sunrise'] != null ? DateTime.parse(json['sunrise']) : null,
      sunset: json['sunset'] != null ? DateTime.parse(json['sunset']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'humidity': humidity,
      'precipitation': precipitation,
      'windSpeed': windSpeed,
      'cloudiness': cloudiness,
      'sunrise': sunrise?.toIso8601String(),
      'sunset': sunset?.toIso8601String(),
    };
  }
}
