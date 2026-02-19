import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../services/content_service.dart';

import '../utils/page_utils.dart';

/// About Me Page - Professional Journey
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late final Future<String> _contentFuture;

  @override
  void initState() {
    super.initState();
    _contentFuture = ContentService.loadAbout();
  }

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.horizontalPadding(context);
    final isMobile = Responsive.isMobile(context);

    return PageMeta(
      title: 'About',
      child: SingleChildScrollView(
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
    return FutureBuilder<String>(
      future: _contentFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GlassContainer(
            child: MarkdownBody(
              data: snapshot.data!,
              styleSheet: _markdownStyle(context),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(60),
            child: CircularProgressIndicator(color: AppTheme.cyan),
          ),
        );
      },
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
          top: BorderSide(color: AppTheme.cyan.withOpacity(0.3), width: 1),
        ),
      ),
    );
  }
}
