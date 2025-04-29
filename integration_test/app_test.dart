import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hawkeye_patro/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:hawkeye_patro/screens/splash_screen.dart';
import 'package:hawkeye_patro/screens/home_screen.dart';
import 'package:hawkeye_patro/screens/calendar_screen.dart';
import 'package:hawkeye_patro/screens/event_screen.dart';
import 'package:hawkeye_patro/screens/news_screen.dart';
import 'package:hawkeye_patro/screens/forex_screen.dart';
import 'package:hawkeye_patro/screens/radio_screen.dart';
import 'package:hawkeye_patro/screens/contact_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('Complete app flow test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify splash screen is shown and animates
      expect(find.byType(SplashScreen), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));

      // Verify navigation to home screen
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);

      // Test calendar navigation
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();
      expect(find.byType(CalendarScreen), findsOneWidget);

      // Test events feature
      await tester.tap(find.byIcon(Icons.event));
      await tester.pumpAndSettle();
      expect(find.byType(EventScreen), findsOneWidget);

      // Add a new event
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'Title'),
          'Integration Test Event');
      await tester.enterText(find.widgetWithText(TextFormField, 'Description'),
          'Testing the complete flow');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Location'), 'Test Location');

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Integration Test Event'), findsOneWidget);

      // Test news feature
      await tester.tap(find.byIcon(Icons.newspaper));
      await tester.pumpAndSettle();
      expect(find.byType(NewsScreen), findsOneWidget);

      // Test forex feature
      await tester.tap(find.byIcon(Icons.currency_exchange));
      await tester.pumpAndSettle();
      expect(find.byType(ForexScreen), findsOneWidget);

      // Test radio feature
      await tester.tap(find.byIcon(Icons.radio));
      await tester.pumpAndSettle();
      expect(find.byType(RadioScreen), findsOneWidget);

      // Test contacts feature
      await tester.tap(find.byIcon(Icons.contacts));
      await tester.pumpAndSettle();
      expect(find.byType(ContactScreen), findsOneWidget);

      // Add a new contact
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Name'), 'Test Contact');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Phone'), '1234567890');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'test@example.com');

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Test Contact'), findsOneWidget);

      // Test language switching
      await tester.tap(find.byIcon(Icons.language));
      await tester.pumpAndSettle();

      // Verify both language options are available
      expect(find.text('English'), findsOneWidget);
      expect(find.text('नेपाली'), findsOneWidget);

      // Switch to Nepali
      await tester.tap(find.text('नेपाली'));
      await tester.pumpAndSettle();

      // Verify UI is in Nepali
      expect(find.text('सम्पर्कहरू'), findsOneWidget);
    });
  });
}
