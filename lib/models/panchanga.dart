import 'package:nepali_utils/nepali_utils.dart';

class Panchanga {
  final NepaliDateTime date;
  final String tithi;
  final String nakshatra;
  final String yoga;
  final String karana;
  final List<String> shubhaSait;
  final List<String> ashubhaSait;
  final String moonPhase;
  final bool isAuspiciousYoga;

  Panchanga({
    required this.date,
    required this.tithi,
    required this.nakshatra,
    required this.yoga,
    required this.karana,
    required this.shubhaSait,
    required this.ashubhaSait,
    required this.moonPhase,
    required this.isAuspiciousYoga,
  });

  factory Panchanga.fromJson(Map<String, dynamic> json) {
    return Panchanga(
      date: NepaliDateTime.parse(json['date']),
      tithi: json['tithi'],
      nakshatra: json['nakshatra'],
      yoga: json['yoga'],
      karana: json['karana'],
      shubhaSait: List<String>.from(json['shubhaSait']),
      ashubhaSait: List<String>.from(json['ashubhaSait']),
      moonPhase: json['moonPhase'],
      isAuspiciousYoga: json['isAuspiciousYoga'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toString(),
      'tithi': tithi,
      'nakshatra': nakshatra,
      'yoga': yoga,
      'karana': karana,
      'shubhaSait': shubhaSait,
      'ashubhaSait': ashubhaSait,
      'moonPhase': moonPhase,
      'isAuspiciousYoga': isAuspiciousYoga,
    };
  }
}
