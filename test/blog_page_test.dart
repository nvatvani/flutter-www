import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niraj_portfolio/pages/blog_page.dart';
import 'package:niraj_portfolio/services/content_service.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MockAssetBundle extends CachingAssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (key.endsWith('20260205-imtgripe.md')) {
      return '# The Major Gripe with International Money Transfer Apps\n\nTest Content';
    }
    throw FlutterError('Asset not found: $key');
  }

  @override
  Future<ByteData> load(String key) async {
    throw FlutterError('Asset not found: $key');
  }
}

void main() {
  testWidgets('BlogPage loads specific post without error', (
    WidgetTester tester,
  ) async {
    // Inject mock bundle
    ContentService.bundle = MockAssetBundle();

    // Determine the slug that caused the error
    const slug = '20260205-imtgripe';

    // Build the BlogPage with the specific slug and mocked assets
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: BlogPage(initialPostSlug: slug))),
    );

    // Initial state (loading)
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for async loading to complete
    await tester.pumpAndSettle();

    // Verify content is loaded and no error occurred
    expect(find.byType(MarkdownBody), findsOneWidget);
  });
}
