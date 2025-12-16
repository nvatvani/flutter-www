import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/pulse_grid_theme.dart';
import '../widgets/animated_background/pulse_grid_background.dart';
import '../widgets/glassmorphism_nav.dart';
import '../services/markdown_service.dart';
import '../models/blog_post.dart';

/// Blog listing page showing all posts
class BlogPage extends StatefulWidget {
  final int navIndex;
  final Function(String) onNavigate;

  const BlogPage({super.key, this.navIndex = 2, required this.onNavigate});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final MarkdownService _markdownService = MarkdownService();
  List<BlogPost> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final posts = await _markdownService.loadBlogPosts();
    setState(() {
      _posts = posts;
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
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page title
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [PulseGridColors.primary, PulseGridColors.secondary],
                ).createShader(bounds),
                child: Text(
                  'Blog',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Thoughts on technology, energy, and leadership',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              // Posts grid
              _posts.isEmpty ? _buildEmptyState() : _buildPostsGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: PulseGridColors.glassBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PulseGridColors.glassBorder, width: 1),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: PulseGridColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              'Coming Soon',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: PulseGridColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Blog posts will appear here. Stay tuned!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 700 ? 2 : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.3,
          ),
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            return _buildPostCard(_posts[index]);
          },
        );
      },
    );
  }

  Widget _buildPostCard(BlogPost post) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onNavigate('/blog/${post.slug}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: PulseGridColors.glassBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: PulseGridColors.glassBorder, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tags
              if (post.tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: post.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: PulseGridColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: PulseGridColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 16),
              // Title
              Text(
                post.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: PulseGridColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // Date
              Text(
                post.formattedDate,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              // Summary
              Expanded(
                child: Text(
                  post.summary,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Read more link
              Row(
                children: [
                  Text(
                    'Read more',
                    style: TextStyle(
                      color: PulseGridColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: PulseGridColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
