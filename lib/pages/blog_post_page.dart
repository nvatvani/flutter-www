import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/pulse_grid_theme.dart';
import '../widgets/animated_background/pulse_grid_background.dart';
import '../widgets/glassmorphism_nav.dart';
import '../services/markdown_service.dart';
import '../models/page_content.dart';

/// Individual blog post page
class BlogPostPage extends StatefulWidget {
  final String slug;
  final Function(String) onNavigate;

  const BlogPostPage({super.key, required this.slug, required this.onNavigate});

  @override
  State<BlogPostPage> createState() => _BlogPostPageState();
}

class _BlogPostPageState extends State<BlogPostPage> {
  final MarkdownService _markdownService = MarkdownService();
  PageContent? _content;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final content = await _markdownService.loadPage(
      'assets/content/blog/${widget.slug}.md',
    );
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
                    currentIndex: 2, // Blog is active
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
    final date = _content?.getMeta<String>('date');
    final tags = _content?.getMetaList('tags') ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              TextButton.icon(
                onPressed: () => widget.onNavigate('/blog'),
                icon: const Icon(
                  Icons.arrow_back,
                  size: 16,
                  color: PulseGridColors.primary,
                ),
                label: const Text(
                  'Back to Blog',
                  style: TextStyle(color: PulseGridColors.primary),
                ),
              ),
              const SizedBox(height: 24),
              // Tags
              if (tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: PulseGridColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: PulseGridColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              if (tags.isNotEmpty) const SizedBox(height: 16),
              // Title
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [PulseGridColors.primary, PulseGridColors.secondary],
                ).createShader(bounds),
                child: Text(
                  _content?.title ?? 'Untitled',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (date != null) ...[
                const SizedBox(height: 12),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: PulseGridColors.textMuted,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              // Content card
              Container(
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
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
