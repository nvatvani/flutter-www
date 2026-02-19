# flutter-www
During the creation of this Personal Website, the main challenge was to create a smoothly transitioning Veo video-file of myself that is based on my LinkedIn profile picture.

Veo allows the orginal MP4 to be converted to a 9.1MB GIF directly on their platform but it gets scaled down to 270p@16fps.

This quality can be improved using the MP4 file and ffmpeg as follows:
```bash
ffmpeg -i niraj-veo-original.mp4 -vf "fps=24,scale1280:-1:flags=lanczos" -c:v gif niraj-veo-improved.gif
```
or
```bash
ffmpeg -i niraj-veo-original.mp4 -y niraj-veo-improved.gif
```

The result is a 32MB GIF, which is on the heavy-side but with a decent quality.

The best achievable GIF quality using ffmpeg is:
```bash
ffmpeg -i niraj-veo-original.mp4 -y -vf 'fps=24,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse' -loop 0 niraj-veo-improved-720p-at-24fps.gif
```

But the result is a 99MB GIF which is just impractical to use in a website.

## Troubleshooting Skwasm Runtime Error

If you encounter `RuntimeError: function signature mismatch` with `skwasm`, try:

1.  **Running Integration Tests**:
    ```bash
    flutter drive \
      --driver=test_driver/integration_test.dart \
      --target=integration_test/app_test.dart \
      -d web-server \
      --web-renderer skwasm
    ```
    (Note: May need to create `test_driver/integration_test.dart` if it doesn't exist).

2.  **Fallback to CanvasKit**:
    If Skwasm remains unstable, build with CanvasKit:
    ```bash
    flutter build web --web-renderer canvaskit
    ```

3.  **Recent Fix**:
    Removed a redundant `SystemChrome.setApplicationSwitcherDescription` call in `lib/utils/page_utils.dart` which might have caused interop issues.
