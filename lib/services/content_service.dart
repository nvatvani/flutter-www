import 'package:flutter/services.dart';

/// Service for loading and parsing Markdown content from assets
class ContentService {
  /// Load markdown content from an asset file
  static Future<String> loadMarkdown(String path) async {
    try {
      return await rootBundle.loadString(path);
    } catch (e) {
      return '# Content not found\n\nThe requested content could not be loaded.';
    }
  }

  /// Load home page content
  static Future<String> loadHome() =>
      loadMarkdown('assets/content/home/home.md');

  /// Load about page content
  static Future<String> loadAbout() =>
      loadMarkdown('assets/content/about/about.md');

  /// Load a specific blog post
  static Future<String> loadBlogPost(String slug) =>
      loadMarkdown('assets/content/blog/$slug/$slug.md');

  /// Get list of available blog posts (manually maintained for now)
  static List<BlogPostMeta> getBlogPosts() {
    return [
      BlogPostMeta(
        slug: '20251217-welcome',
        title: 'Welcome to My Blog',
        excerpt:
            'My first blog post where I share my journey and what to expect.',
        date: DateTime(2025, 12, 17),
      ),
      BlogPostMeta(
        slug: '20260205-imtgripe',
        title: 'The Major Gripe with International Money Transfers',
        excerpt:
            'Wise, Remitly, Revolut, etc. are all great, but they all have one major annoyance!',
        date: DateTime(2026, 2, 5),
      ),
    ];
  }
}

/// Blog post metadata
class BlogPostMeta {
  final String slug;
  final String title;
  final String excerpt;
  final DateTime date;

  BlogPostMeta({
    required this.slug,
    required this.title,
    required this.excerpt,
    required this.date,
  });

  String get formattedDate => '${date.day}/${date.month}/${date.year}';
}
