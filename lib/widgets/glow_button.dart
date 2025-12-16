import 'package:flutter/material.dart';
import '../theme/pulse_grid_theme.dart';

/// Button with hover glow effect
/// Shows gradient glow animation on hover
class GlowButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final bool isActive;
  final bool gradient;

  const GlowButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.isActive = false,
    this.gradient = false,
  });

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _isHovered || widget.isActive
                ? PulseGridColors.surfaceLight.withValues(alpha: 0.5)
                : Colors.transparent,
            border: widget.gradient && _isHovered
                ? Border.all(
                    color: PulseGridColors.primary.withValues(alpha: 0.5),
                    width: 1,
                  )
                : null,
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.gradient
                          ? PulseGridColors.primary.withValues(alpha: 0.3)
                          : PulseGridColors.primary.withValues(alpha: 0.15),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
