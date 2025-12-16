import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';
import '../models/blog_post.dart';
import '../models/page_content.dart';

/// Service for loading and parsing markdown content from assets
class MarkdownService {
  /// Load a single page content with frontmatter
  Future<PageContent> loadPage(String path) async {
    try {
      final content = await rootBundle.loadString(path);
      return _parseContent(content, path);
    } catch (e) {
      return PageContent(
        title: 'Page Not Found',
        body: 'The requested content could not be loaded.',
        path: path,
      );
    }
  }

  /// Load all blog posts from the blog directory
  Future<List<BlogPost>> loadBlogPosts() async {
    final posts = <BlogPost>[];
    
    // Load the blog index to get list of posts
    try {
      final indexContent = await rootBundle.loadString('assets/content/blog/_index.md');
      final indexData = _parseContent(indexContent, 'assets/content/blog/_index.md');
      
      // Get list of post files from frontmatter
      final postFiles = indexData.metadata['posts'] as List<dynamic>? ?? [];
      
      for (final file in postFiles) {
        try {
          final postContent = await rootBundle.loadString('assets/content/blog/$file');
          final pageContent = _parseContent(postContent, 'assets/content/blog/$file');
          posts.add(BlogPost.fromPageContent(pageContent));
        } catch (e) {
          // Skip posts that fail to load
        }
      }
    } catch (e) {
      // Return empty list if blog index doesn't exist
    }
    
    // Sort by date, newest first
    posts.sort((a, b) => b.date.compareTo(a.date));
    
    return posts;
  }

  /// Parse markdown content with YAML frontmatter
  PageContent _parseContent(String content, String path) {
    final frontmatterRegex = RegExp(r'^---\n([\s\S]*?)\n---\n([\s\S]*)$');
    final match = frontmatterRegex.firstMatch(content);

    if (match != null) {
      final yamlContent = match.group(1)!;
      final markdownBody = match.group(2)!;
      
      try {
        final yaml = loadYaml(yamlContent) as YamlMap;
        final metadata = Map<String, dynamic>.from(yaml);
        
        return PageContent(
          title: metadata['title'] as String? ?? 'Untitled',
          body: markdownBody.trim(),
          path: path,
          metadata: metadata,
        );
      } catch (e) {
        return PageContent(
          title: 'Untitled',
          body: content,
          path: path,
        );
      }
    }

    return PageContent(
      title: 'Untitled',
      body: content,
      path: path,
    );
  }
}
