import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Animated plasma stream background with diagonal flowing gradients
class PlasmaBackground extends StatefulWidget {
  final Widget child;

  const PlasmaBackground({super.key, required this.child});

  @override
  State<PlasmaBackground> createState() => _PlasmaBackgroundState();
}

class _PlasmaBackgroundState extends State<PlasmaBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _particleController = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base background
        Container(color: AppTheme.background),

        // Plasma streams
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: PlasmaStreamPainter(animationValue: _controller.value),
                size: Size.infinite,
              );
            },
          ),
        ),

        // Floating particles
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(
                  animationValue: _particleController.value,
                ),
                size: Size.infinite,
              );
            },
          ),
        ),

        // Content
        widget.child,
      ],
    );
  }
}

class PlasmaStreamPainter extends CustomPainter {
  final double animationValue;

  PlasmaStreamPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    // Draw multiple plasma streams
    for (int i = 0; i < 5; i++) {
      _drawPlasmaStream(canvas, size, i, paint);
    }
  }

  void _drawPlasmaStream(Canvas canvas, Size size, int index, Paint paint) {
    final path = Path();
    final offset = index * 0.2;
    final phase = (animationValue + offset) % 1.0;

    // Stream parameters
    final startY = size.height * (0.1 + index * 0.18);
    final amplitude = 30.0 + index * 15;
    final frequency = 0.003 + index * 0.001;

    // Create flowing wave path
    path.moveTo(-100, startY);

    for (double x = -100; x <= size.width + 100; x += 5) {
      final waveOffset = sin((x * frequency) + (phase * pi * 2)) * amplitude;
      final y = startY + waveOffset + (x * 0.15); // Diagonal flow
      path.lineTo(x, y);
    }

    // Gradient colors for this stream
    final colors = [
      AppTheme.cyan.withValues(alpha: 0.0),
      AppTheme.cyan.withValues(alpha: 0.3 - index * 0.04),
      AppTheme.purple.withValues(alpha: 0.4 - index * 0.05),
      AppTheme.magenta.withValues(alpha: 0.2 - index * 0.03),
      AppTheme.purple.withValues(alpha: 0.0),
    ];

    paint.shader = LinearGradient(
      colors: colors,
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Add glow effect
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawPath(path, paint);

    // Draw core line (brighter)
    paint.strokeWidth = 1;
    paint.maskFilter = null;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(PlasmaStreamPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class ParticlePainter extends CustomPainter {
  final double animationValue;
  final Random _random = Random(42); // Fixed seed for consistent particles

  ParticlePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw particles following the plasma streams
    for (int i = 0; i < 30; i++) {
      _drawParticle(canvas, size, i, paint);
    }
  }

  void _drawParticle(Canvas canvas, Size size, int index, Paint paint) {
    final baseX = _random.nextDouble();
    final baseY = _random.nextDouble() * 0.8 + 0.1;
    final particleSize = _random.nextDouble() * 3 + 1;
    final speed = _random.nextDouble() * 0.5 + 0.5;
    final phase = (animationValue * speed + baseX) % 1.0;

    // Position along diagonal path
    final x = phase * (size.width + 200) - 100;
    final waveY = sin(phase * pi * 4) * 20;
    final y = baseY * size.height + waveY + (x * 0.15);

    // Color based on position
    final colorPhase = (x / size.width).clamp(0.0, 1.0);
    final color =
        Color.lerp(
          AppTheme.cyan.withValues(alpha: 0.6),
          AppTheme.purple.withValues(alpha: 0.4),
          colorPhase,
        )!;

    paint.color = color;
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, particleSize);

    canvas.drawCircle(Offset(x, y), particleSize, paint);
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
