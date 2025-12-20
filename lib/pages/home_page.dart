import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/typing_text.dart';
import '../widgets/pulsing_photo.dart';
import '../services/content_service.dart';

/// Home/Landing Page
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _content = '';

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final content = await ContentService.loadHome();
    if (mounted) setState(() => _content = content);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final padding = Responsive.horizontalPadding(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.maxContentWidth(context),
            ),
            child: Column(
              children: [
                SizedBox(height: isMobile ? 40 : 80),
                _buildHeroSection(context, isMobile),
                const SizedBox(height: 60),
                _buildIntroSection(context),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isMobile) {
    // GIF path for controlled animation
    const gifPath = 'assets/content/shared/niraj-veo.gif';

    final heroContent = isMobile
        ? Column(
            children: [
              const PulsingPhoto(
                size: 160,
                gifPath: gifPath,
                pauseDuration: Duration(seconds: 10),
              ),
              const SizedBox(height: 40),
              _buildHeroText(context, isMobile),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: _buildHeroText(context, isMobile)),
              const SizedBox(width: 60),
              const PulsingPhoto(
                size: 220,
                gifPath: gifPath,
                pauseDuration: Duration(seconds: 10),
              ),
            ],
          );

    return heroContent;
  }

  Widget _buildHeroText(BuildContext context, bool isMobile) {
    final titleStyle = isMobile
        ? Theme.of(context).textTheme.displaySmall
        : Theme.of(context).textTheme.displayLarge;

    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          "Hi, I'm",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        TypingText(
          texts: const ['Niraj Vatvani', 'a CTO', 'a Builder', 'an Innovator'],
          style: titleStyle,
        ),
        const SizedBox(height: 24),
        Text(
          'Chief Technology Officer | Energy Tech | Product Leader',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),
      ],
    );
  }

  Widget _buildIntroSection(BuildContext context) {
    return GlassContainer(
      child: _content.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppTheme.cyan))
          : MarkdownBody(data: _content, styleSheet: _markdownStyle(context)),
    );
  }

  MarkdownStyleSheet _markdownStyle(BuildContext context) {
    return MarkdownStyleSheet(
      p: Theme.of(context).textTheme.bodyLarge,
      h1: Theme.of(context).textTheme.displaySmall,
      h2: Theme.of(
        context,
      ).textTheme.headlineMedium?.copyWith(color: AppTheme.cyan),
      h3: Theme.of(context).textTheme.headlineMedium,
      listBullet: Theme.of(context).textTheme.bodyLarge,
      blockquoteDecoration: BoxDecoration(
        border: Border(left: BorderSide(color: AppTheme.cyan, width: 4)),
      ),
    );
  }
}
