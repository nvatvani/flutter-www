import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'utils/responsive.dart';
import 'widgets/plasma_background.dart';
import 'widgets/glow_nav.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/blog_page.dart';

void main() {
  runApp(const NirajPortfolioApp());
}

class NirajPortfolioApp extends StatelessWidget {
  const NirajPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Niraj Vatvani | CTO & Product Leader',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = const [HomePage(), AboutPage(), BlogPage()];

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
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
                  currentIndex: _currentIndex,
                  onTap: _onNavTap,
                ),
              )
              : null,
      body: PlasmaBackground(
        child: Column(
          children: [
            // Navigation
            GlowNav(
              currentIndex: _currentIndex,
              onTap: _onNavTap,
              isMobile: isMobile,
              onMenuTap: _openDrawer,
            ),

            // Page content
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _pages[_currentIndex],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
