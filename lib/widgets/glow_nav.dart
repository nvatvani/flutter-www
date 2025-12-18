import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'linkedin_button.dart';

/// Navigation bar with glow effects on hover
class GlowNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isMobile;
  final VoidCallback? onMenuTap;

  const GlowNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isMobile = false,
    this.onMenuTap,
  });

  static const List<String> items = ['Home', 'About', 'Blog'];

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return _buildMobileNav(context);
    }
    return _buildDesktopNav(context);
  }

  Widget _buildDesktopNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          _LogoWidget(),

          // Nav items + LinkedIn
          Row(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                _NavItem(
                  label: items[i],
                  isActive: currentIndex == i,
                  onTap: () => onTap(i),
                ),
                const SizedBox(width: 32),
              ],
              // LinkedIn button in header
              const LinkedInButton(size: 40),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _LogoWidget(size: 32),
          Row(
            children: [
              const LinkedInButton(size: 36),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.menu, color: AppTheme.textPrimary),
                onPressed: onMenuTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LogoWidget extends StatelessWidget {
  final double size;

  const _LogoWidget({this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.cyan.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(color: AppTheme.cyan.withValues(alpha: 0.3), blurRadius: 8),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/content/shared/niraj.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppTheme.surface,
              child: Center(
                child: Text(
                  'NV',
                  style: TextStyle(
                    color: AppTheme.cyan,
                    fontWeight: FontWeight.bold,
                    fontSize: size * 0.4,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final showGlow = widget.isActive || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow:
                showGlow
                    ? [
                      BoxShadow(
                        color: AppTheme.cyan.withValues(alpha: 0.4),
                        blurRadius: 16,
                        spreadRadius: -2,
                      ),
                    ]
                    : null,
          ),
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: showGlow ? AppTheme.cyan : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Mobile navigation drawer
class MobileNavDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MobileNavDrawer({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: AppTheme.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(24),
              child: _LogoWidget(size: 48),
            ),
            const Divider(color: AppTheme.textSecondary, height: 1),
            const SizedBox(height: 16),
            for (int i = 0; i < GlowNav.items.length; i++)
              _MobileNavItem(
                label: GlowNav.items[i],
                isActive: currentIndex == i,
                onTap: () {
                  Navigator.pop(context);
                  onTap(i);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _MobileNavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontSize: 20,
          color: isActive ? AppTheme.cyan : AppTheme.textPrimary,
        ),
      ),
      leading: Container(
        width: 4,
        height: 24,
        decoration: BoxDecoration(
          color: isActive ? AppTheme.cyan : Colors.transparent,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      onTap: onTap,
    );
  }
}
