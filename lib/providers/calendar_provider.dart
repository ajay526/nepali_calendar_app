import 'package:flutter/material.dart';
import '../utils/nepali_date_time.dart';
import '../services/local_calendar_service.dart';

class CalendarProvider extends ChangeNotifier {
  NepaliDateTime _selectedDate = NepaliDateTime.now();
  List<Map<String, dynamic>> _events = [];

  NepaliDateTime get selectedDate => _selectedDate;
  List<Map<String, dynamic>> get events => _events;

  CalendarProvider() {
    _loadEventsForMonth(_selectedDate.year, _selectedDate.month);
  }

  void selectDate(NepaliDateTime date) {
    _selectedDate = date;
    _loadEventsForMonth(date.year, date.month);
    notifyListeners();
  }

  Future<void> _loadEventsForMonth(int year, int month) async {
    _events = await LocalCalendarService.getEventsForMonth(year, month);
    notifyListeners();
  }

  List<Map<String, dynamic>> getEventsForDate(NepaliDateTime date) {
    return _events.where((event) {
      final parts = event['date'].split('-');
      return int.parse(parts[0]) == date.year &&
          int.parse(parts[1]) == date.month &&
          int.parse(parts[2]) == date.day;
    }).toList();
  }

  void goToNextMonth() {
    final next = NepaliDateTime(_selectedDate.year, _selectedDate.month + 1, 1);
    selectDate(next);
  }

  void goToPreviousMonth() {
    final prev = NepaliDateTime(_selectedDate.year, _selectedDate.month - 1, 1);
    selectDate(prev);
  }

  void goToNextYear() {
    final next = NepaliDateTime(_selectedDate.year + 1, _selectedDate.month, 1);
    selectDate(next);
  }

  void goToPreviousYear() {
    final prev = NepaliDateTime(_selectedDate.year - 1, _selectedDate.month, 1);
    selectDate(prev);
  }

  // ✅ Farming Support Methods
  String getCurrentSeason() {
    final month = _selectedDate.month;
    if (month == 1 || month == 2) return 'Winter';
    if (month == 3 || month == 4) return 'Spring';
    if (month == 5 || month == 6) return 'Summer';
    if (month == 7 || month == 8) return 'Monsoon';
    if (month == 9 || month == 10) return 'Autumn';
    return 'Pre-winter';
  }

  List<Map<String, dynamic>> getSeasonalCrops(String season) {
    final seasonalData = {
      'Winter': ['Cauliflower', 'Peas'],
      'Spring': ['Tomatoes', 'Cucumber'],
      'Summer': ['Maize', 'Millet'],
      'Monsoon': ['Paddy', 'Corn'],
      'Autumn': ['Wheat', 'Barley'],
      'Pre-winter': ['Mustard', 'Spinach'],
    };

    return seasonalData[season]!
        .map((crop) => {'season': season, 'recommendedCrops': crop})
        .toList();
  }

  String getCurrentMoonPhase() {
    final day = _selectedDate.day;
    if (day <= 3) return 'New Moon';
    if (day <= 7) return 'Waxing Crescent';
    if (day <= 10) return 'First Quarter';
    if (day <= 14) return 'Waxing Gibbous';
    if (day == 15) return 'Full Moon';
    if (day <= 21) return 'Waning Gibbous';
    if (day <= 25) return 'Last Quarter';
    return 'Waning Crescent';
  }
}
