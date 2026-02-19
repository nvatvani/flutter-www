import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:niraj_portfolio/pages/blog_page.dart';
import 'package:niraj_portfolio/services/content_service.dart';
// import 'package:niraj_portfolio/utils/page_utils.dart'; // Unused

// Mock ContentService to avoid asset loading issues
class MockContentService {
  static void injectMockData() {
    // We can't easily mock static methods without a wrapper or extensive changes.
    // However, ContentService.loadBlogPost uses rootBundle.loadString.
    // We can mock the AssetBundle like in page_title_test.dart.
  }
}

class MockAssetBundle extends Fake implements AssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (key.contains('20260205-imtgripe')) {
      return '''
# Test Post

Some content here.

![Image](test.png)

## Section 2

More content...

[Link](https://example.com)

---

End of post.
''';
    }
    return '# Other Post';
  }
}

void main() {
  setUp(() {
    ContentService.bundle = MockAssetBundle();
  });

  testWidgets('BlogPage scrolls to bottom without error', (
    WidgetTester tester,
  ) async {
    // Resize to a small height to ensure scrolling is needed
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      const MaterialApp(home: BlogPage(initialPostSlug: '20260205-imtgripe')),
    );

    // Initial pump
    await tester.pump();
    // Wait for FutureBuilder/loading
    await tester.pump(const Duration(milliseconds: 500));

    // Verify post content is loaded
    expect(find.text('Test Post'), findsOneWidget);

    // Scroll to bottom
    final scrollable = find.byType(Scrollable).first;
    await tester.drag(scrollable, const Offset(0, -1000));
    await tester.pumpAndSettle();

    // Verify we reached the bottom or at least scrolled
    // Use a generic find to ensure no exceptions were thrown during scroll
    expect(find.byType(MarkdownBody), findsOneWidget);
  });
}
