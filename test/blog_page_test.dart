import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niraj_portfolio/pages/blog_page.dart';
import 'package:niraj_portfolio/services/content_service.dart';
import 'package:niraj_portfolio/theme/app_theme.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:niraj_portfolio/utils/responsive.dart';

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

class TestWrapper extends StatefulWidget {
  const TestWrapper({super.key});

  @override
  State<TestWrapper> createState() => _TestWrapperState();
}

class _TestWrapperState extends State<TestWrapper> {
  bool _isLoading = true;
  String _content = '';

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final content = await ContentService.loadBlogPost('20260205-imtgripe');
    if (mounted) {
      setState(() {
        _content = content;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final padding = Responsive.horizontalPadding(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.maxContentWidth(context),
            ),
            child: Column(
              children: [GlassContainer(child: MarkdownBody(data: _content))],
            ),
          ),
        ),
      ),
    );
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
