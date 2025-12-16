import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/pulse_grid_theme.dart';
import '../widgets/animated_background/pulse_grid_background.dart';
import '../widgets/glassmorphism_nav.dart';
import '../widgets/orbiting_avatar.dart';
import '../widgets/typing_text.dart';

/// Home/Landing page with hero section
class HomePage extends StatelessWidget {
  final int navIndex;
  final Function(String) onNavigate;

  const HomePage({
    super.key,
    this.navIndex = 0,
    required this.onNavigate,
  });

  Future<void> _launchLinkedIn() async {
    final uri = Uri.parse('https://www.linkedin.com/in/nvatvani');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: PulseGridColors.background,
      body: PulseGridBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Navigation bar
              Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: GlassmorphismNav(
                    currentIndex: navIndex,
                    onNavigate: onNavigate,
                    onLinkedInTap: _launchLinkedIn,
                  ),
                ),
              ),
              // Hero section
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: isDesktop
                        ? _buildDesktopHero(context)
                        : _buildMobileHero(context),
                  ),
                ),
              ),
              // Scroll indicator
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: _buildScrollIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopHero(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Avatar with orbiting dots
        const OrbitingAvatar(
          imagePath: 'assets/images/niraj.png',
          size: 200,
        ),
        const SizedBox(width: 80),
        // Text content
        Flexible(
          child: _buildHeroText(context),
        ),
      ],
    );
  }

  Widget _buildMobileHero(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const OrbitingAvatar(
          imagePath: 'assets/images/niraj.png',
          size: 160,
        ),
        const SizedBox(height: 48),
        _buildHeroText(context, centered: true),
      ],
    );
  }

  Widget _buildHeroText(BuildContext context, {bool centered = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'Hi, I\'m',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: PulseGridColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [PulseGridColors.primary, PulseGridColors.secondary],
          ).createShader(bounds),
          child: Text(
            'Niraj Vatvani',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TypingText(
          texts: const [
            'CTO & Head of Product',
            'Driving Energy Transition',
            'Building Smart Energy Solutions',
            'Global Tech Leader',
          ],
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: PulseGridColors.primary,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: centered ? 300 : 400,
          child: Text(
            'Seeking opportunities to lead and learn, leveraging technology '
            'and contributing to the community while driving the Energy Transition.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: centered ? TextAlign.center : TextAlign.left,
          ),
        ),
      ],
    );
  }

  Widget _buildScrollIndicator() {
    return Column(
      children: [
        Text(
          'Scroll to explore',
          style: TextStyle(
            color: PulseGridColors.textMuted,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Icon(
          Icons.keyboard_arrow_down,
          color: PulseGridColors.textMuted,
          size: 24,
        ),
      ],
    );
  }
}
