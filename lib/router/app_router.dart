import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/home_page.dart';
import '../pages/about_page.dart';
import '../pages/blog_page.dart';
import '../widgets/app_shell.dart';

/// App router configuration with permalink support
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Shell route wraps all pages with common layout (nav, background, etc.)
    ShellRoute(
      builder: (context, state, child) {
        return AppShell(currentPath: state.uri.path, child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder:
              (context, state) => const NoTransitionPage(child: HomePage()),
        ),
        GoRoute(
          path: '/about',
          name: 'about',
          pageBuilder:
              (context, state) => const NoTransitionPage(child: AboutPage()),
        ),
        GoRoute(
          path: '/blog',
          name: 'blog',
          pageBuilder:
              (context, state) => const NoTransitionPage(child: BlogPage()),
          routes: [
            // Individual blog post route
            GoRoute(
              path: ':slug',
              name: 'blog-post',
              pageBuilder: (context, state) {
                final slug = state.pathParameters['slug'] ?? '';
                return NoTransitionPage(child: BlogPage(initialPostSlug: slug));
              },
            ),
          ],
        ),
      ],
    ),
  ],

  // Error page for unknown routes
  errorBuilder:
      (context, state) => Scaffold(
        backgroundColor: const Color(0xFF030308),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '404',
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  foreground:
                      Paint()
                        ..shader = const LinearGradient(
                          colors: [Color(0xFF00e5ff), Color(0xFFa855f7)],
                        ).createShader(const Rect.fromLTWH(0, 0, 100, 70)),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Page not found',
                style: TextStyle(color: Color(0xFFa0a0b0), fontSize: 18),
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text(
                  '← Back to Home',
                  style: TextStyle(color: Color(0xFF00e5ff)),
                ),
              ),
            ],
          ),
        ),
      ),
);
