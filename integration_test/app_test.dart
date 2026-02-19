import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:niraj_portfolio/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App navigation smoke test', (WidgetTester tester) async {
    // Start app
    app.main();
    await tester.pumpAndSettle();

    // Verify Home Page loads
    expect(find.text('Niraj Vatvani'), findsOneWidget);

    // Tap About in nav (assuming GlowNav has keys or text)
    // Finding by text for now as it's visible
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    // Verify About Page loads
    expect(find.text('About Me'), findsOneWidget);

    // Tap Blog in nav
    await tester.tap(find.text('Blog'));
    await tester.pumpAndSettle();

    // Verify Blog Page loads
    expect(find.text('Blog'), findsOneWidget);

    // Optional: Tap back to Home
    await tester.tap(
      find.text('Home').first,
    ); // Might be multiple 'Home' texts? GlowNav has strictly one 'Home' item usually
    await tester.pumpAndSettle();

    expect(find.text('Niraj Vatvani'), findsOneWidget);
  });
}
