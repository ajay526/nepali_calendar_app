import 'dart:convert';
import 'package:flutter/services.dart';

class LocalCalendarService {
  static Future<List<Map<String, dynamic>>> getEventsForMonth(
      int year, int month) async {
    final String data = await rootBundle.loadString('assets/data/events.json');
    final List<dynamic> jsonResult = json.decode(data);
    return jsonResult
        .where((event) {
          final parts = event['date'].split('-');
          return int.parse(parts[0]) == year && int.parse(parts[1]) == month;
        })
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }
}
