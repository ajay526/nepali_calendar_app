import 'package:nepali_utils/nepali_utils.dart';
import 'package:ml_algo/ml_algo.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
import '../models/smart_event.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';

class SmartEventService {
  static const String _boxName = 'smart_events';
  late Box<Map<String, dynamic>> _eventsBox;
  LogisticRegressor? _eventPredictor;

  Future<void> initialize() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _eventsBox = await Hive.openBox<Map<String, dynamic>>(_boxName);
    } else {
      _eventsBox = Hive.box<Map<String, dynamic>>(_boxName);
    }
    await _initializeMLModel();
  }

  Future<void> _initializeMLModel() async {
    try {
      await _updatePredictions();
    } catch (e) {
      debugPrint('Error initializing ML model: $e');
      _eventPredictor = null;
    }
  }

  Future<void> addEvent(SmartEvent event) async {
    try {
      await _eventsBox.put(event.date.toString(), event.toJson());
      await _updatePredictions();
    } catch (e) {
      debugPrint('Error adding event: $e');
      rethrow;
    }
  }

  Future<List<SmartEvent>> getPredictedEvents(
      NepaliDateTime startDate, NepaliDateTime endDate) async {
    List<SmartEvent> predictions = [];

    final historicalEvents = _eventsBox.values
        .map((e) => SmartEvent.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    for (var event in historicalEvents) {
      if (event.isRecurring == true) {
        var nextOccurrence = _predictNextOccurrence(event);
        if (nextOccurrence != null &&
            nextOccurrence.isAfter(startDate) &&
            nextOccurrence.isBefore(endDate)) {
          predictions.add(SmartEvent(
            title: event.title,
            description: event.description,
            date: nextOccurrence,
            importance: event.importance,
            category: event.category,
            culturalContext: event.culturalContext,
            type: event.type, // ✅ MISSING TYPE FIXED HERE
            isRecurring: true,
            recurrencePattern: event.recurrencePattern,
          ));
        }
      }
    }

    return predictions;
  }

  NepaliDateTime? _predictNextOccurrence(SmartEvent event) {
    if (!event.isRecurring) return null;

    final now = NepaliDateTime.now();

    switch (event.recurrencePattern) {
      case 'yearly':
        return NepaliDateTime(now.year + 1, event.date.month, event.date.day);
      case 'monthly':
        var nextMonth = now.month + 1;
        var year = now.year;
        if (nextMonth > 12) {
          nextMonth = 1;
          year++;
        }
        return NepaliDateTime(year, nextMonth, event.date.day);
      case 'weekly':
        var daysUntilNext = (event.date.weekday - now.weekday + 7) % 7;
        return now.add(Duration(days: daysUntilNext));
      default:
        return null;
    }
  }

  Future<void> _updatePredictions() async {
    final events = _eventsBox.values
        .map((e) => SmartEvent.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    if (events.isEmpty) return;

    final rows = events
        .map((e) => [
              e.date.month.toDouble(),
              e.date.day.toDouble(),
              e.importance,
              e.category == 'Festival' ? 1.0 : 0.0,
            ])
        .toList();

    final header = ['month', 'day', 'importance', 'label'];
    final dataFrame = DataFrame(rows, header: header);

    try {
      _eventPredictor = LogisticRegressor(
        dataFrame,
        'label',
        iterationsLimit: 100,
        initialLearningRate: 0.01,
        fitIntercept: true,
        interceptScale: 1.0,
        learningRateType: LearningRateType.constant,
      );
    } catch (e) {
      debugPrint('Error training ML model: $e');
      _eventPredictor = null;
    }
  }

  double predictEventImportance(NepaliDateTime date, String category) {
    if (_eventPredictor == null) return 0.0;

    try {
      final sample = DataFrame([
        [date.month.toDouble(), date.day.toDouble(), 1.0]
      ], header: [
        'month',
        'day',
        'importance'
      ]);

      final predictionDf = _eventPredictor!.predict(sample);
      final prediction =
          (predictionDf.rows.elementAt(0) as Map<String, dynamic>)['label'];

      return (prediction is num) ? prediction.toDouble() : 0.0;
    } catch (e) {
      debugPrint('Prediction error: $e');
      return 0.0;
    }
  }
}
