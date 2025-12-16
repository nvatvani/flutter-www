import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/pulse_grid_theme.dart';
import '../widgets/animated_background/pulse_grid_background.dart';
import '../widgets/glassmorphism_nav.dart';
import '../services/markdown_service.dart';
import '../models/page_content.dart';

/// About Me page showing professional journey
class AboutPage extends StatefulWidget {
  final int navIndex;
  final Function(String) onNavigate;

  const AboutPage({
    super.key,
    this.navIndex = 1,
    required this.onNavigate,
  });

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final MarkdownService _markdownService = MarkdownService();
  PageContent? _content;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final content = await _markdownService.loadPage('assets/content/about.md');
    setState(() {
      _content = content;
      _isLoading = false;
    });
  }

  Future<void> _launchLinkedIn() async {
    final uri = Uri.parse('https://www.linkedin.com/in/nvatvani');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    currentIndex: widget.navIndex,
                    onNavigate: widget.onNavigate,
                    onLinkedInTap: _launchLinkedIn,
                  ),
                ),
              ),
              // Content
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: PulseGridColors.primary,
                        ),
                      )
                    : _buildContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page title
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [PulseGridColors.primary, PulseGridColors.secondary],
                ).createShader(bounds),
                child: Text(
                  _content?.title ?? 'About Me',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Markdown content
              _buildMarkdownCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarkdownCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: PulseGridColors.glassBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: PulseGridColors.glassBorder,
          width: 1,
        ),
      ),
      child: MarkdownBody(
        data: _content?.body ?? '',
        styleSheet: MarkdownStyleSheet(
          h1: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: PulseGridColors.primary,
          ),
          h2: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: PulseGridColors.textPrimary,
          ),
          h3: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: PulseGridColors.textPrimary,
          ),
          p: Theme.of(context).textTheme.bodyLarge,
          listBullet: Theme.of(context).textTheme.bodyLarge,
          strong: const TextStyle(
            fontWeight: FontWeight.w600,
            color: PulseGridColors.primary,
          ),
          em: TextStyle(
            fontStyle: FontStyle.italic,
            color: PulseGridColors.textSecondary,
          ),
          blockquote: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: PulseGridColors.textMuted,
            fontStyle: FontStyle.italic,
          ),
          blockquoteDecoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: PulseGridColors.primary,
                width: 4,
              ),
            ),
          ),
          code: TextStyle(
            backgroundColor: PulseGridColors.surfaceLight,
            color: PulseGridColors.primary,
            fontFamily: 'JetBrains Mono',
          ),
          codeblockDecoration: BoxDecoration(
            color: PulseGridColors.surfaceLight,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onTapLink: (text, href, title) {
          if (href != null) {
            launchUrl(Uri.parse(href));
          }
        },
      ),
    );
  }
}
