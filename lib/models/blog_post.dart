import 'page_content.dart';

/// Model for a blog post with metadata
class BlogPost {
  final String title;
  final String slug;
  final DateTime date;
  final String summary;
  final List<String> tags;
  final String body;

  BlogPost({
    required this.title,
    required this.slug,
    required this.date,
    required this.summary,
    required this.body,
    this.tags = const [],
  });

  /// Create from PageContent
  factory BlogPost.fromPageContent(PageContent content) {
    final slug = content.path.split('/').last.replaceAll('.md', '');
    
    return BlogPost(
      title: content.title,
      slug: slug,
      date: _parseDate(content.getMeta<String>('date')),
      summary: content.getMeta<String>('summary') ?? '',
      tags: content.getMetaList('tags'),
      body: content.body,
    );
  }

  static DateTime _parseDate(String? dateStr) {
    if (dateStr == null) return DateTime.now();
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Format date for display
  String get formattedDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
