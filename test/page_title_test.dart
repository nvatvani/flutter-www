import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niraj_portfolio/pages/home_page.dart';
import 'package:niraj_portfolio/pages/about_page.dart';
import 'package:niraj_portfolio/pages/blog_page.dart';
import 'package:niraj_portfolio/utils/page_utils.dart';
import 'package:niraj_portfolio/services/content_service.dart';

// Mock ContentService if needed, but for now we might rely on default behavior or mock it
// Since ContentService uses asset bundle, we might need to mock it or just test the structure

class MockAssetBundle extends Fake implements AssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (key.contains('home.md')) {
      return '# Home Content';
    } else if (key.contains('about.md')) {
      return '# About Content';
    } else if (key.contains('20251217-welcome.md')) {
      return '# Blog Post Content';
    }
    throw FlutterError('Asset not found: $key');
  }
}

void main() {
  setUp(() {
    ContentService.bundle = MockAssetBundle();
  });

  testWidgets('HomePage has correct title', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    // Pump to allow FutureBuilder to complete
    await tester.pump();

    // Check for PageMeta
    expect(find.byType(PageMeta), findsOneWidget);

    // Check key properties of PageMeta
    final pageMeta = tester.widget<PageMeta>(find.byType(PageMeta));
    expect(pageMeta.title, 'Niraj Vatvani | CTO & Product Leader');
    expect(pageMeta.isRoot, true);

    // Verify Title widget is present (PageMeta builds a Title)
    final titleFinder = find.descendant(
      of: find.byType(PageMeta),
      matching: find.byType(Title),
    );
    expect(titleFinder, findsOneWidget);
    final titleWidget = tester.widget<Title>(titleFinder);
    expect(titleWidget.title, 'Niraj Vatvani | CTO & Product Leader');
  });

  testWidgets('AboutPage has correct title', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutPage()));
    await tester.pump();

    expect(find.byType(PageMeta), findsOneWidget);
    final pageMeta = tester.widget<PageMeta>(find.byType(PageMeta));
    expect(pageMeta.title, 'About');
    expect(pageMeta.isRoot, false); // Default is false

    final titleFinder = find.descendant(
      of: find.byType(PageMeta),
      matching: find.byType(Title),
    );
    expect(titleFinder, findsOneWidget);
    final titleWidget = tester.widget<Title>(titleFinder);
    expect(titleWidget.title, 'About | Niraj Vatvani');
  });

  testWidgets('BlogPage (list) has correct title', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: BlogPage()));
    await tester.pump();

    expect(find.byType(PageMeta), findsOneWidget);
    final pageMeta = tester.widget<PageMeta>(find.byType(PageMeta));
    expect(pageMeta.title, 'Blog');

    final titleFinder = find.descendant(
      of: find.byType(PageMeta),
      matching: find.byType(Title),
    );
    expect(titleFinder, findsOneWidget);
    final titleWidget = tester.widget<Title>(titleFinder);
    expect(titleWidget.title, 'Blog | Niraj Vatvani');
  });
}
