/// Generic model for page content with frontmatter
class PageContent {
  final String title;
  final String body;
  final String path;
  final Map<String, dynamic> metadata;

  PageContent({
    required this.title,
    required this.body,
    required this.path,
    this.metadata = const {},
  });

  /// Get a typed value from metadata
  T? getMeta<T>(String key) {
    final value = metadata[key];
    if (value is T) return value;
    return null;
  }

  /// Get a list from metadata
  List<String> getMetaList(String key) {
    final value = metadata[key];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }
}
