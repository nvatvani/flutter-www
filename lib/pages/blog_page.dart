import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../services/content_service.dart';
import '../utils/web_helper_stub.dart'
    if (dart.library.js_interop) '../utils/web_helper.dart';

import '../utils/page_utils.dart'; // Add import

/// Blog Page - List and Detail Views
class BlogPage extends StatefulWidget {
  final String? initialPostSlug;

  const BlogPage({super.key, this.initialPostSlug});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  String? _selectedPostSlug;
  String _postContent = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load initial post if slug provided via URL
    if (widget.initialPostSlug != null && widget.initialPostSlug!.isNotEmpty) {
      _selectedPostSlug = widget.initialPostSlug;
      _isLoading = true;
      _loadPostContent(widget.initialPostSlug!);
    }
  }

  @override
  void didUpdateWidget(BlogPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle URL changes
    if (widget.initialPostSlug != oldWidget.initialPostSlug) {
      if (widget.initialPostSlug != null &&
          widget.initialPostSlug!.isNotEmpty) {
        _selectPost(widget.initialPostSlug!);
      } else {
        setState(() {
          _selectedPostSlug = null;
          _postContent = '';
        });
      }
    }
  }

  void _selectPost(String slug) {
    setState(() {
      _selectedPostSlug = slug;
      _isLoading = true;
    });
    _loadPostContent(slug);
  }

  Future<void> _loadPostContent(String slug) async {
    final content = await ContentService.loadBlogPost(slug);
    if (mounted) {
      setState(() {
        _postContent = content;
        _isLoading = false;
      });
    }
  }

  void _goBack() {
    context.go('/blog');
  }

  void _navigateToPost(String slug) {
    context.go('/blog/$slug');
  }

  String _getPageTitle() {
    if (_selectedPostSlug == null) return 'Blog';

    // Find post title
    final posts = ContentService.getBlogPosts();
    final post = posts.where((p) => p.slug == _selectedPostSlug).firstOrNull;
    return post?.title ?? 'Blog Post';
  }

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.horizontalPadding(context);
    final isMobile = Responsive.isMobile(context);

    return PageMeta(
      title: _getPageTitle(),
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
                  if (_selectedPostSlug != null)
                    _buildPostDetail(context)
                  else
                    _buildPostList(context, isMobile),
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
    return Row(
      children: [
        if (_selectedPostSlug != null)
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.cyan),
            onPressed: _goBack,
          ),
        Text(
          _selectedPostSlug != null ? 'Back to Blog' : 'Blog',
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(color: AppTheme.cyan),
        ),
      ],
    );
  }

  Widget _buildPostList(BuildContext context, bool isMobile) {
    final posts = ContentService.getBlogPosts();

    if (posts.isEmpty) {
      return GlassContainer(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Text(
              'Blog posts coming soon...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children:
          posts
              .map(
                (post) => _BlogPostCard(
                  post: post,
                  onTap: () => _navigateToPost(post.slug),
                  isMobile: isMobile,
                ),
              )
              .toList(),
    );
  }

  Widget _buildPostDetail(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(60),
          child: CircularProgressIndicator(color: AppTheme.cyan),
        ),
      );
    }

    return GlassContainer(
      child: MarkdownBody(
        data: _postContent,
        styleSheet: _markdownStyle(context),
        builders: {'img': _ImageBuilder(_selectedPostSlug)},
        onTapLink: (text, href, title) async {
          if (href == null || href.isEmpty) return;

          if (href.startsWith('http://') || href.startsWith('https://')) {
            // External URL — open with url_launcher
            final uri = Uri.parse(href);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          } else if (href.endsWith('.html')) {
            // Relative HTML file — load from assets and open in new tab
            final assetPath = 'assets/content/blog/$_selectedPostSlug/$href';
            final messenger = ScaffoldMessenger.of(context);
            try {
              // Use ContentService to ensure bundle is used
              final htmlContent = await ContentService.loadMarkdown(assetPath);
              openHtmlContent(htmlContent);
            } catch (e) {
              if (!mounted) return;
              messenger.showSnackBar(
                SnackBar(content: Text('Could not load: $href')),
              );
            }
          }
        },
      ),
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
      code: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontFamily: 'monospace',
        backgroundColor: AppTheme.surface,
      ),
      codeblockDecoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      horizontalRuleDecoration: BoxDecoration(
        color: AppTheme.cyan.withOpacity(0.3), // Using color instead of border
      ),
    );
  }
}

class _BlogPostCard extends StatefulWidget {
  final BlogPostMeta post;
  final VoidCallback onTap;
  final bool isMobile;

  const _BlogPostCard({
    required this.post,
    required this.onTap,
    required this.isMobile,
  });

  @override
  State<_BlogPostCard> createState() => _BlogPostCardState();
}

class _BlogPostCardState extends State<_BlogPostCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.isMobile ? double.infinity : 350,
          child: GlassContainer(
            borderColor: _isHovered ? AppTheme.cyan : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.cyan.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.post.formattedDate,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.cyan,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.post.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: _isHovered ? AppTheme.cyan : AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.post.excerpt,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Read more',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: AppTheme.cyan),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: AppTheme.cyan,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageBuilder extends MarkdownElementBuilder {
  final String? postSlug;

  _ImageBuilder(this.postSlug);

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    if (element.tag != 'img') return null;

    final uri = element.attributes['src'];
    if (uri == null) return null;

    final imagePath = uri.toString();
    final fullPath =
        imagePath.startsWith('http') || imagePath.startsWith('/')
            ? imagePath
            : 'assets/content/blog/$postSlug/$imagePath';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Image.asset(
          fullPath,
          fit: BoxFit.contain,
          errorBuilder:
              (context, error, stackTrace) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Image not found: $imagePath'),
              ),
        ),
      ),
    );
  }
}
