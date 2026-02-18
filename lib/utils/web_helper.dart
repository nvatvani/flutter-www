import 'dart:js_interop';
import 'package:web/web.dart' as web;

/// Opens the provided HTML content in a new browser tab.
void openHtmlContent(String htmlContent) {
  final blob = web.Blob(
    [htmlContent.toJS].toJS,
    web.BlobPropertyBag(type: 'text/html'),
  );
  final blobUrl = web.URL.createObjectURL(blob);
  web.window.open(blobUrl, '_blank');
}
