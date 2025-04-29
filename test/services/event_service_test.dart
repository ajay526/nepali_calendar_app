import 'package:flutter_test/flutter_test.dart';
import 'package:hawkeye_patro/services/event_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late EventService eventService;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    eventService = EventService();
  });

  group('EventService', () {
    test('should add and retrieve an event', () async {
      final event = Event(
        id: '1',
        title: 'Test Event',
        description: 'Test Description',
        date: DateTime.now(),
      );

      await eventService.addEvent(event);
      final events = await eventService.getEvents();

      expect(events.length, 1);
      expect(events.first.id, event.id);
      expect(events.first.title, event.title);
      expect(events.first.description, event.description);
    });

    test('should update an event', () async {
      final event = Event(
        id: '1',
        title: 'Test Event',
        description: 'Test Description',
        date: DateTime.now(),
      );

      await eventService.addEvent(event);

      final updatedEvent = Event(
        id: '1',
        title: 'Updated Event',
        description: 'Updated Description',
        date: DateTime.now(),
      );

      await eventService.updateEvent(updatedEvent);
      final events = await eventService.getEvents();

      expect(events.length, 1);
      expect(events.first.title, 'Updated Event');
      expect(events.first.description, 'Updated Description');
    });

    test('should delete an event', () async {
      final event = Event(
        id: '1',
        title: 'Test Event',
        description: 'Test Description',
        date: DateTime.now(),
      );

      await eventService.addEvent(event);
      await eventService.deleteEvent(event.id);
      final events = await eventService.getEvents();

      expect(events.isEmpty, true);
    });

    test('should get events by month', () async {
      final january2024 = DateTime(2024, 1, 15);
      final february2024 = DateTime(2024, 2, 15);

      final event1 = Event(
        id: '1',
        title: 'January Event',
        description: 'Test Description',
        date: january2024,
      );

      final event2 = Event(
        id: '2',
        title: 'February Event',
        description: 'Test Description',
        date: february2024,
      );

      await eventService.addEvent(event1);
      await eventService.addEvent(event2);

      final januaryEvents = await eventService.getEventsByMonth(2024, 1);
      final februaryEvents = await eventService.getEventsByMonth(2024, 2);

      expect(januaryEvents.length, 1);
      expect(januaryEvents.first.title, 'January Event');
      expect(februaryEvents.length, 1);
      expect(februaryEvents.first.title, 'February Event');
    });

    test('should get holidays', () async {
      final regularEvent = Event(
        id: '1',
        title: 'Regular Event',
        description: 'Test Description',
        date: DateTime.now(),
        isHoliday: false,
      );

      final holiday = Event(
        id: '2',
        title: 'Holiday',
        description: 'Test Description',
        date: DateTime.now(),
        isHoliday: true,
      );

      await eventService.addEvent(regularEvent);
      await eventService.addEvent(holiday);

      final holidays = await eventService.getHolidays();

      expect(holidays.length, 1);
      expect(holidays.first.title, 'Holiday');
      expect(holidays.first.isHoliday, true);
    });

    test('should clear all events', () async {
      final event1 = Event(
        id: '1',
        title: 'Event 1',
        description: 'Test Description',
        date: DateTime.now(),
      );

      final event2 = Event(
        id: '2',
        title: 'Event 2',
        description: 'Test Description',
        date: DateTime.now(),
      );

      await eventService.addEvent(event1);
      await eventService.addEvent(event2);
      await eventService.clearEvents();
      final events = await eventService.getEvents();

      expect(events.isEmpty, true);
    });
  });
}
