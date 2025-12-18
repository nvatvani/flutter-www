import 'package:flutter/material.dart';

/// Responsive utilities for desktop/mobile layouts
class Responsive {
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1280;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < desktopBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopBreakpoint;

  /// Returns value based on screen size
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet ?? desktop;
    return desktop;
  }

  /// Horizontal padding based on screen size
  static double horizontalPadding(BuildContext context) {
    return value(context, mobile: 20, tablet: 40, desktop: 80);
  }

  /// Max content width
  static double maxContentWidth(BuildContext context) {
    return value(context, mobile: double.infinity, desktop: 1200);
  }
}

/// Responsive layout builder
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < Responsive.mobileBreakpoint) {
          return mobile;
        } else if (constraints.maxWidth < Responsive.desktopBreakpoint) {
          return tablet ?? desktop;
        }
        return desktop;
      },
    );
  }
}
