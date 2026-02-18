import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niraj_portfolio/pages/about_page.dart';
import 'package:niraj_portfolio/services/content_service.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter/services.dart';

// Mock AssetBundle to avoid actual file I/O
class MockAssetBundle extends CachingAssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (key.endsWith('about.md')) {
      return '# About Me\n\nProfessional Journey...';
    }
    throw FlutterError('Asset not found: $key');
  }

  @override
  Future<ByteData> load(String key) async {
    throw FlutterError('Asset not found: $key');
  }
}

void main() {
  testWidgets('AboutPage loads and displays markdown content', (
    WidgetTester tester,
  ) async {
    // Inject mock bundle
    ContentService.bundle = MockAssetBundle();

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AboutPage())),
    );

    // Initial pump
    await tester.pump();

    // Pump to allow FutureBuilder/setState to render
    await tester.pump(const Duration(milliseconds: 100));

    // Verify MarkdownBody is present
    expect(find.byType(MarkdownBody), findsOneWidget);

    // Verify specific text from mock
    expect(find.textContaining('Professional Journey'), findsOneWidget);
  });
}
