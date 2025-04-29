import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final bool isHoliday;
  final String? location;
  final String? reminder;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.isHoliday = false,
    this.location,
    this.reminder,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
        'isHoliday': isHoliday,
        'location': location,
        'reminder': reminder,
      };

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        date: DateTime.parse(json['date']),
        isHoliday: json['isHoliday'] ?? false,
        location: json['location'],
        reminder: json['reminder'],
      );
}

class EventService {
  static const String _eventsKey = 'events';

  Future<List<Event>> getEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getString(_eventsKey);
    if (eventsJson != null) {
      final List<dynamic> events = json.decode(eventsJson);
      return events.map((e) => Event.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<Event>> getEventsByMonth(int year, int month) async {
    final events = await getEvents();
    return events.where((event) {
      return event.date.year == year && event.date.month == month;
    }).toList();
  }

  Future<List<Event>> getHolidays() async {
    final events = await getEvents();
    return events.where((event) => event.isHoliday).toList();
  }

  Future<void> addEvent(Event event) async {
    final prefs = await SharedPreferences.getInstance();
    final events = await getEvents();
    events.add(event);
    await prefs.setString(
        _eventsKey, json.encode(events.map((e) => e.toJson()).toList()));
  }

  Future<void> updateEvent(Event event) async {
    final prefs = await SharedPreferences.getInstance();
    final events = await getEvents();
    final index = events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      events[index] = event;
      await prefs.setString(
          _eventsKey, json.encode(events.map((e) => e.toJson()).toList()));
    }
  }

  Future<void> deleteEvent(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final events = await getEvents();
    events.removeWhere((e) => e.id == id);
    await prefs.setString(
        _eventsKey, json.encode(events.map((e) => e.toJson()).toList()));
  }

  Future<void> clearEvents() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_eventsKey);
  }
}
