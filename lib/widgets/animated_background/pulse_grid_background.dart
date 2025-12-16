import 'package:flutter/material.dart';
import 'hex_grid_painter.dart';

/// Animated background widget with pulsing hexagonal grid
/// Uses SingleTickerProviderStateMixin for continuous animation
class PulseGridBackground extends StatefulWidget {
  final Widget? child;
  final Duration animationDuration;

  const PulseGridBackground({
    super.key,
    this.child,
    this.animationDuration = const Duration(seconds: 6),
  });

  @override
  State<PulseGridBackground> createState() => _PulseGridBackgroundState();
}

class _PulseGridBackgroundState extends State<PulseGridBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated hexagonal grid
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: HexGridPainter(animationValue: _controller.value),
                size: Size.infinite,
              );
            },
          ),
        ),
        // Gradient overlay for depth
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Colors.transparent,
                  const Color(0xFF0A0E1A).withValues(alpha: 0.3),
                  const Color(0xFF0A0E1A).withValues(alpha: 0.7),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),
        ),
        // Child content
        if (widget.child != null) widget.child!,
      ],
    );
  }
}
