import 'package:flutter/material.dart';

/// A widget that sets the browser page title.
///
/// This wraps the [Title] widget and automatically appends the site name
/// unless [isRoot] is true.
class PageMeta extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isRoot;
  final Color? color;

  const PageMeta({
    super.key,
    required this.title,
    required this.child,
    this.isRoot = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final String fullTitle = isRoot ? title : '$title | Niraj Vatvani';

    return Title(
      title: fullTitle,
      color: color ?? const Color(0xFF000000),
      child: child,
    );
  }
}
