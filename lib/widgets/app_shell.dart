import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/responsive.dart';
import 'plasma_background.dart';
import 'glow_nav.dart';

/// App shell that wraps all pages with common layout elements
class AppShell extends StatefulWidget {
  final String currentPath;
  final Widget child;

  const AppShell({super.key, required this.currentPath, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _getNavIndex() {
    if (widget.currentPath.startsWith('/blog')) return 2;
    if (widget.currentPath == '/about') return 1;
    return 0;
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _navigate(int index) {
    // Close drawer first if open
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }

    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/about');
        break;
      case 2:
        context.go('/blog');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer:
          isMobile
              ? Drawer(
                child: MobileNavDrawer(
                  currentIndex: _getNavIndex(),
                  onTap: _navigate,
                ),
              )
              : null,
      body: PlasmaBackground(
        child: Column(
          children: [
            // Navigation
            GlowNav(
              currentIndex: _getNavIndex(),
              onTap: _navigate,
              isMobile: isMobile,
              onMenuTap: _openDrawer,
            ),

            // Page content
            Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }
}
