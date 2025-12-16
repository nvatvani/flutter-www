import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/pulse_grid_theme.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/blog_page.dart';
import 'pages/blog_post_page.dart';

/// Main app widget with routing configuration
class NirajPortfolioApp extends StatelessWidget {
  NirajPortfolioApp({super.key});

  late final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomePage(
          onNavigate: (route) => context.go(route),
        ),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => AboutPage(
          onNavigate: (route) => context.go(route),
        ),
      ),
      GoRoute(
        path: '/blog',
        builder: (context, state) => BlogPage(
          onNavigate: (route) => context.go(route),
        ),
      ),
      GoRoute(
        path: '/blog/:slug',
        builder: (context, state) => BlogPostPage(
          slug: state.pathParameters['slug'] ?? '',
          onNavigate: (route) => context.go(route),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Niraj Vatvani - CTO & Head of Product',
      debugShowCheckedModeBanner: false,
      theme: PulseGridTheme.darkTheme.copyWith(
        textTheme: GoogleFonts.interTextTheme(
          PulseGridTheme.darkTheme.textTheme,
        ),
      ),
      routerConfig: _router,
    );
  }
}
