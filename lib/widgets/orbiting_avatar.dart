import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/pulse_grid_theme.dart';

/// Profile avatar with orbiting dots representing global regions
/// Creates orbital animation around the circular avatar
class OrbitingAvatar extends StatefulWidget {
  final String? imagePath;
  final double size;
  final Duration orbitDuration;

  const OrbitingAvatar({
    super.key,
    this.imagePath,
    this.size = 180,
    this.orbitDuration = const Duration(seconds: 8),
  });

  @override
  State<OrbitingAvatar> createState() => _OrbitingAvatarState();
}

class _OrbitingAvatarState extends State<OrbitingAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Orbital dots representing regions
  final List<_OrbitDot> _orbitDots = [
    _OrbitDot(
      label: 'APAC',
      color: PulseGridColors.primary,
      orbitRadius: 1.15,
      startAngle: 0,
    ),
    _OrbitDot(
      label: 'EMEA',
      color: PulseGridColors.secondary,
      orbitRadius: 1.25,
      startAngle: 2.09, // 120 degrees
    ),
    _OrbitDot(
      label: 'Americas',
      color: PulseGridColors.tertiary,
      orbitRadius: 1.20,
      startAngle: 4.19, // 240 degrees
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.orbitDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatarRadius = widget.size / 2;

    return SizedBox(
      width: widget.size * 1.5,
      height: widget.size * 1.5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Gradient border ring
          Container(
            width: widget.size + 8,
            height: widget.size + 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const SweepGradient(
                colors: [
                  PulseGridColors.primary,
                  PulseGridColors.secondary,
                  PulseGridColors.tertiary,
                  PulseGridColors.primary,
                ],
              ),
            ),
          ),
          // Avatar container
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: PulseGridColors.surface,
              border: Border.all(color: PulseGridColors.glassBorder, width: 2),
            ),
            child: ClipOval(
              child: widget.imagePath != null
                  ? Image.asset(
                      widget.imagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholder();
                      },
                    )
                  : _buildPlaceholder(),
            ),
          ),
          // Orbiting dots
          ..._orbitDots.map((dot) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final angle =
                    dot.startAngle + (_controller.value * 2 * math.pi);
                final orbitDistance = avatarRadius * dot.orbitRadius;

                return Positioned(
                  left:
                      (widget.size * 1.5 / 2) +
                      (orbitDistance * math.cos(angle)) -
                      6,
                  top:
                      (widget.size * 1.5 / 2) +
                      (orbitDistance * math.sin(angle)) -
                      6,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dot.color,
                      boxShadow: [
                        BoxShadow(
                          color: dot.color.withValues(alpha: 0.6),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: PulseGridColors.surfaceLight,
      child: const Icon(
        Icons.person,
        size: 80,
        color: PulseGridColors.textMuted,
      ),
    );
  }
}

class _OrbitDot {
  final String label;
  final Color color;
  final double orbitRadius; // Multiplier of avatar radius
  final double startAngle; // In radians

  _OrbitDot({
    required this.label,
    required this.color,
    required this.orbitRadius,
    required this.startAngle,
  });
}
