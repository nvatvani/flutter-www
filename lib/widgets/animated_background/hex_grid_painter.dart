import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/pulse_grid_theme.dart';

/// Custom painter for the animated hexagonal grid
/// Creates a mesh of hexagons that pulse with color transitions
class HexGridPainter extends CustomPainter {
  final double animationValue;
  final Color baseColor;
  final Color pulseColor1;
  final Color pulseColor2;

  HexGridPainter({
    required this.animationValue,
    this.baseColor = PulseGridColors.gridBase,
    this.pulseColor1 = PulseGridColors.gridPulse,
    this.pulseColor2 = PulseGridColors.gridPulseAlt,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final hexRadius = 40.0;
    final hexWidth = hexRadius * 2;
    final hexHeight = hexRadius * math.sqrt(3);

    // Calculate number of hexagons needed
    final cols = (size.width / (hexWidth * 0.75)).ceil() + 2;
    final rows = (size.height / hexHeight).ceil() + 2;

    for (int row = -1; row < rows; row++) {
      for (int col = -1; col < cols; col++) {
        // Calculate center position
        final offsetX = col * hexWidth * 0.75;
        final offsetY = row * hexHeight + (col.isOdd ? hexHeight / 2 : 0);
        final center = Offset(offsetX, offsetY);

        // Calculate pulse intensity based on position and time
        final distanceFromCenter =
            (center - Offset(size.width / 2, size.height / 2)).distance;
        final maxDistance =
            math.sqrt(size.width * size.width + size.height * size.height) / 2;
        final normalizedDistance = distanceFromCenter / maxDistance;

        // Wave animation - creates ripple effect from center
        final wavePhase =
            (animationValue * 2 * math.pi) - (normalizedDistance * 3);
        final pulseIntensity = (math.sin(wavePhase) + 1) / 2;

        // Color interpolation between cyan and purple
        final colorPhase = (normalizedDistance + animationValue) % 1.0;
        final pulseColor = Color.lerp(pulseColor1, pulseColor2, colorPhase)!;

        // Final color with pulse intensity
        final hexColor = Color.lerp(
          baseColor,
          pulseColor,
          pulseIntensity * 0.6,
        )!;

        _drawHexagon(canvas, center, hexRadius - 2, hexColor, pulseIntensity);
      }
    }
  }

  void _drawHexagon(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
    double intensity,
  ) {
    final path = Path();

    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * math.pi / 180;
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();

    // Draw hexagon stroke with glow effect
    final strokePaint = Paint()
      ..color = color.withValues(alpha: 0.3 + intensity * 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(path, strokePaint);

    // Draw node points at vertices with glow when pulsing
    if (intensity > 0.5) {
      final nodePaint = Paint()
        ..color = color.withValues(alpha: intensity * 0.8)
        ..style = PaintingStyle.fill;

      for (int i = 0; i < 6; i++) {
        final angle = (i * 60 - 30) * math.pi / 180;
        final point = Offset(
          center.dx + radius * math.cos(angle),
          center.dy + radius * math.sin(angle),
        );
        canvas.drawCircle(point, 1.5 * intensity, nodePaint);
      }
    }
  }

  @override
  bool shouldRepaint(HexGridPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
