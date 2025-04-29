import 'package:nepali_utils/nepali_utils.dart';

class SmartEvent {
  final String title;
  final String description;
  final NepaliDateTime date;
  final double importance;
  final String category;
  final String culturalContext;
  final String type; // Required parameter
  final bool isRecurring; // Added field
  final String recurrencePattern; // Added field: 'yearly', 'monthly', 'weekly'

  SmartEvent({
    required this.title,
    required this.description,
    required this.date,
    required this.importance,
    required this.category,
    required this.culturalContext,
    required this.type,
    this.isRecurring = false,
    this.recurrencePattern = '',
  });

  factory SmartEvent.fromJson(Map<String, dynamic> json) {
    return SmartEvent(
      title: json['title'],
      description: json['description'],
      date: NepaliDateTime.parse(json['date']),
      importance: (json['importance'] as num).toDouble(),
      category: json['category'],
      culturalContext: json['culturalContext'],
      type: json['type'] ?? 'general',
      isRecurring: json['isRecurring'] ?? false,
      recurrencePattern: json['recurrencePattern'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'importance': importance,
      'category': category,
      'culturalContext': culturalContext,
      'type': type,
      'isRecurring': isRecurring,
      'recurrencePattern': recurrencePattern,
    };
  }
}
