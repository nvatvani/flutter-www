import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Profile photo with animated plasma ring
class PulsingPhoto extends StatefulWidget {
  final String? imagePath;
  final double size;

  const PulsingPhoto({super.key, this.imagePath, this.size = 200});

  @override
  State<PulsingPhoto> createState() => _PulsingPhotoState();
}

class _PulsingPhotoState extends State<PulsingPhoto>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size + 40,
      height: widget.size + 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer pulsing glow ring
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: widget.size + 30,
                height: widget.size + 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.cyan.withValues(
                        alpha: 0.3 * _pulseAnimation.value,
                      ),
                      blurRadius: 30 * _pulseAnimation.value,
                      spreadRadius: 5,
                    ),
                    BoxShadow(
                      color: AppTheme.purple.withValues(
                        alpha: 0.2 * _pulseAnimation.value,
                      ),
                      blurRadius: 40 * _pulseAnimation.value,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              );
            },
          ),

          // Rotating gradient ring
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * 3.14159,
                child: Container(
                  width: widget.size + 16,
                  height: widget.size + 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        AppTheme.cyan,
                        AppTheme.purple,
                        AppTheme.magenta,
                        AppTheme.cyan,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Inner dark circle
          Container(
            width: widget.size + 8,
            height: widget.size + 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.background,
            ),
          ),

          // Photo or placeholder
          ClipOval(
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                image:
                    widget.imagePath != null
                        ? DecorationImage(
                          image: AssetImage(widget.imagePath!),
                          fit: BoxFit.cover,
                        )
                        : null,
              ),
              child:
                  widget.imagePath == null
                      ? Icon(
                        Icons.person,
                        size: widget.size * 0.5,
                        color: AppTheme.textSecondary,
                      )
                      : null,
            ),
          ),
        ],
      ),
    );
  }
}
