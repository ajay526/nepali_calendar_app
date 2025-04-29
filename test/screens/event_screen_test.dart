import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:hawkeye_patro/providers/language_provider.dart';
import 'package:hawkeye_patro/screens/event_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late Widget testWidget;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    testWidget = MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => LanguageProvider(prefs),
        child: const EventScreen(),
      ),
    );
  });

  group('EventScreen Widget Tests', () {
    testWidgets('should display loading indicator initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display tabs for Events and Holidays',
        (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.text('Events'), findsOneWidget);
      expect(find.text('Holidays'), findsOneWidget);
    });

    testWidgets('should show add event dialog when FAB is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Add Event'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
    });

    testWidgets('should switch between Events and Holidays tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Initially on Events tab
      expect(find.text('No events'), findsOneWidget);

      // Switch to Holidays tab
      await tester.tap(find.text('Holidays'));
      await tester.pumpAndSettle();

      expect(find.text('No holidays'), findsOneWidget);
    });

    testWidgets('should validate form fields in add event dialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Try to save without entering data
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter title'), findsOneWidget);
      expect(find.text('Please enter description'), findsOneWidget);
    });

    testWidgets('should add new event when form is valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Fill in the form
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Title'), 'Test Event');
      await tester.enterText(find.widgetWithText(TextFormField, 'Description'),
          'Test Description');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Location'), 'Test Location');

      // Save the event
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify event is added
      expect(find.text('Test Event'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('Test Location'), findsOneWidget);
    });

    testWidgets('should delete event when delete icon is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Add an event first
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Title'), 'Test Event');
      await tester.enterText(find.widgetWithText(TextFormField, 'Description'),
          'Test Description');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Delete the event
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.text('Test Event'), findsNothing);
      expect(find.text('No events'), findsOneWidget);
    });
  });
}
