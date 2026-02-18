/// Stub for opening HTML content on non-web platforms.
void openHtmlContent(String htmlContent) {
  // No-op or throw UnimplementedError on non-web platforms.
  // Since this is only called from UI interaction which likely won't happen
  // in VM tests that trigger this path, a simple print or throw is fine.
  throw UnimplementedError('openHtmlContent is only supported on web.');
}
