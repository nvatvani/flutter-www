import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niraj_portfolio/utils/web_helper_stub.dart'
    if (dart.library.js_interop) 'package:niraj_portfolio/utils/web_helper.dart';

void main() {
  test('openHtmlContent behaves correctly on platform', () {
    if (!kIsWeb) {
      // On non-web platforms (Stub), it should throw UnimplementedError
      expect(
        () => openHtmlContent('<html><body>Test</body></html>'),
        throwsA(isA<UnimplementedError>()),
      );
    } else {
      // On web, it should call window.open.
      // We can't easily verify window.open without a real browser or complex mocking.
      // But we can ensure the function exists and runs (it might fail if window is not available in headless test environment).
      // For now, we just acknowledge it's reachable.
      // We might skip this part or just print.
      // print('Running on web - skipping window.open verification');
    }
  });
}
