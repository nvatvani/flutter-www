# flutter-www
## MP4 to GIF
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

## MP4 to WebP
An alternative approach than relying on heavy GIFs is to use WebP animation which is lossless and can be compressed to a much smaller size than the GIF.

The best achievable WebP quality using ffmpeg is:
```bash
ffmpeg -i niraj-veo-original.mp4 -vcodec libwebp -filter:v fps=fps=24 -lossless 1 -loop 1 -preset default -an -vsync 0 niraj-veo.webp
```

Even though the result is a lossless WebP animation that is just under 10MB, WebP has a deficiency in that there is no way to animate it in reverse / individual frame control as there is with GIFs achieved using `gif_viewer`.

So what I tried to do was leverage ffmpeg to create a second WebP animation that is the reverse of the first one as follows:
```bash
ffmpeg -i niraj-veo-original.mp4 -vcodec libwebp -filter:v fps=fps=24 -lossless 1 -vf reverse -loop 1 -preset default -an -vsync 0 niraj-veo-reverse.webp
```

But now with 2 WebP animations, we now have to manage the tranistions using the 1st frame of the MP4:
```bash
ffmpeg -ss 0 -i niraj-veo-original.mp4 -frames:v 1 niraj-veo-start.png
```

And the last frame of the MP4:
```bash
ffmpeg -sseof -0.042 -i niraj-veo-original.mp4 -vframes 1 niraj-veo-end.png
```

With these 4 new assets, a combination of PNG and WebP, the resulting transitions are not as smooth as the GIFs.