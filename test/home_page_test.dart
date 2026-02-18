// import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niraj_portfolio/pages/home_page.dart';
import 'package:niraj_portfolio/services/content_service.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class MockAssetBundle extends CachingAssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (key == 'assets/content/home/home.md') {
      return '# Welcome to my Portfolio\nThis is a mock home page.';
    }
    return '';
  }

  @override
  Future<ByteData> load(String key) async {
    return ByteData(0);
  }
}

void main() {
  testWidgets('HomePage loads and displays markdown content', (
    WidgetTester tester,
  ) async {
    // Inject mock bundle
    ContentService.bundle = MockAssetBundle();

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: HomePage())),
    );

    // Pump to trigger FutureBuilder/async load
    await tester.pump();
    // Wait for the async content load to complete.
    // We cannot use pumpAndSettle because of infinite animations (TypingText, PulsingPhoto).
    // We pump for a specific duration to allow the future to complete and rebuild.
    await tester.pump(const Duration(milliseconds: 100));

    // Verify Markdown content is present
    expect(find.byType(MarkdownBody), findsOneWidget);
    expect(
      find.text('Welcome to my Portfolio'),
      findsOneWidget,
    ); // Markdown parsing usually keeps text

    // Verify static parts
    expect(find.text("Hi, I'm"), findsOneWidget);
    expect(
      find.text('Chief Technology Officer | Energy Tech | Product Leader'),
      findsOneWidget,
    );

    // Dispose the widget tree to stop infinite animations (TypingText, PulsingPhoto)
    await tester.pumpWidget(const SizedBox());
    // Pump enough time for any pending timers (e.g. TypingText's Future.delayed) to fire and complete.
    // Since the widget is disposed, they will check !mounted and stop the loop.
    await tester.pump(const Duration(seconds: 5));
  });
}
