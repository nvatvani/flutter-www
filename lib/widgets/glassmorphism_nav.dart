import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/pulse_grid_theme.dart';
import 'glow_button.dart';

/// Glassmorphism navigation bar with blur effect and gradient border
class GlassmorphismNav extends StatelessWidget {
  final int currentIndex;
  final Function(String) onNavigate;
  final VoidCallback onLinkedInTap;

  const GlassmorphismNav({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
    required this.onLinkedInTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: PulseGridColors.glassBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: PulseGridColors.glassBorder,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo/Name
              _buildLogo(context),
              const SizedBox(width: 48),
              // Navigation items
              _buildNavItem(context, 'Home', '/', 0),
              const SizedBox(width: 8),
              _buildNavItem(context, 'About', '/about', 1),
              const SizedBox(width: 8),
              _buildNavItem(context, 'Blog', '/blog', 2),
              const SizedBox(width: 16),
              // LinkedIn button
              _buildLinkedInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [PulseGridColors.primary, PulseGridColors.secondary],
      ).createShader(bounds),
      child: Text(
        'NV',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String label, String route, int index) {
    final isActive = currentIndex == index;
    
    return GlowButton(
      onPressed: () => onNavigate(route),
      isActive: isActive,
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? PulseGridColors.primary : PulseGridColors.textSecondary,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildLinkedInButton() {
    return GlowButton(
      onPressed: onLinkedInTap,
      gradient: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [PulseGridColors.primary, PulseGridColors.secondary],
            ).createShader(bounds),
            child: const Icon(
              Icons.link,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [PulseGridColors.primary, PulseGridColors.secondary],
            ).createShader(bounds),
            child: const Text(
              'LinkedIn',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
