import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niraj_portfolio/pages/home_page.dart';
import 'package:niraj_portfolio/pages/about_page.dart';
import 'package:niraj_portfolio/pages/blog_page.dart';
import 'package:niraj_portfolio/utils/page_utils.dart';

// Mock ContentService if needed, but for now we might rely on default behavior or mock it
// Since ContentService uses asset bundle, we might need to mock it or just test the structure

void main() {
  testWidgets('HomePage has correct title', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    // Check for PageMeta
    expect(find.byType(PageMeta), findsOneWidget);

    // Check key properties of PageMeta
    final pageMeta = tester.widget<PageMeta>(find.byType(PageMeta));
    expect(pageMeta.title, 'Niraj Vatvani | CTO & Product Leader');
    expect(pageMeta.isRoot, true);

    // Verify Title widget is present (PageMeta builds a Title)
    // Note: Title widget key might be null, so we look by type
    // We use descendant to find the Title widget created by PageMeta, ignoring the one from MaterialApp
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

  // Note: Testing BlogPage details might require mocking ContentService which loads assets.
  // For this MVP verification, checking the structure and basic pages is a good start.
}
