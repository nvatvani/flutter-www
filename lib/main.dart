import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';

void main() {
  // Use path URL strategy (clean URLs without hash)
  usePathUrlStrategy();
  runApp(const NirajPortfolioApp());
}

class NirajPortfolioApp extends StatelessWidget {
  const NirajPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Niraj Vatvani | CTO & Product Leader',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: appRouter,
    );
  }
}
