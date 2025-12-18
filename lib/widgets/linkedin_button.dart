import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Circular LinkedIn button with pulsing glow
class LinkedInButton extends StatefulWidget {
  final String url;
  final double size;

  const LinkedInButton({
    super.key,
    this.url = 'https://www.linkedin.com/in/nvatvani',
    this.size = 56,
  });

  @override
  State<LinkedInButton> createState() => _LinkedInButtonState();
}

class _LinkedInButtonState extends State<LinkedInButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchLinkedIn() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _launchLinkedIn,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF0077B5), Color(0xFF0a66c2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0077B5).withValues(
                      alpha: _isHovered ? 0.8 : _pulseAnimation.value * 0.5,
                    ),
                    blurRadius: _isHovered ? 24 : 16 * _pulseAnimation.value,
                    spreadRadius: _isHovered ? 4 : 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'in',
                  style: TextStyle(
                    fontSize: widget.size * 0.45,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'serif',
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
