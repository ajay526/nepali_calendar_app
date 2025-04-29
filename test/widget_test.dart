import 'package:flutter_test/flutter_test.dart';
import 'package:hawkeye_patro/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Ensure binding

  testWidgets('App loads and shows title', (WidgetTester tester) async {
    // Set mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Load and build the app
    await tester.pumpWidget(MyApp(prefs: prefs));

    // Let it fully render
    await tester.pumpAndSettle();

    // Check for title on home screen
    expect(find.text('Hawkeye Patro'), findsOneWidget);
  });
}
