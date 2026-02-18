import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../services/content_service.dart';

/// About Me Page - Professional Journey
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _content = '';

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final content = await ContentService.loadAbout();
    if (mounted) setState(() => _content = content);
  }

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.horizontalPadding(context);
    final isMobile = Responsive.isMobile(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.maxContentWidth(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: isMobile ? 30 : 60),
                _buildHeader(context),
                const SizedBox(height: 40),
                _buildContent(context),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ShaderMask(
      shaderCallback:
          (bounds) => const LinearGradient(
            colors: [AppTheme.cyan, AppTheme.purple],
          ).createShader(bounds),
      child: Text(
        'About Me',
        style: Theme.of(
          context,
        ).textTheme.displayMedium?.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_content.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(60),
          child: CircularProgressIndicator(color: AppTheme.cyan),
        ),
      );
    }

    return GlassContainer(
      child: MarkdownBody(data: _content, styleSheet: _markdownStyle(context)),
    );
  }

  MarkdownStyleSheet _markdownStyle(BuildContext context) {
    return MarkdownStyleSheet(
      p: Theme.of(context).textTheme.bodyLarge,
      h1: Theme.of(
        context,
      ).textTheme.displaySmall?.copyWith(color: AppTheme.cyan),
      h2: Theme.of(
        context,
      ).textTheme.headlineMedium?.copyWith(color: AppTheme.purple),
      h3: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
      listBullet: Theme.of(context).textTheme.bodyLarge,
      strong: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: AppTheme.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      blockquoteDecoration: BoxDecoration(
        border: Border(left: BorderSide(color: AppTheme.purple, width: 4)),
      ),
      blockquotePadding: const EdgeInsets.only(left: 16),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.cyan.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
    );
  }
}
