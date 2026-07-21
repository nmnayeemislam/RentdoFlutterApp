import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../../shared/widgets/state_views.dart';
import '../models/blog_post.dart';
import '../providers/blog_providers.dart';

/// A single blog post: hero image, meta, HTML body, and related posts.
class BlogDetailScreen extends ConsumerWidget {
  const BlogDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(blogPostProvider(slug));

    return Scaffold(
      appBar: AppBar(title: const Text('Article')),
      body: SafeArea(
        child: post.when(
          loading: () => const LoadingWidget(),
          error: (_, _) => AppErrorWidget(
            message: 'Couldn\'t load this article.',
            onRetry: () => ref.invalidate(blogPostProvider(slug)),
          ),
          data: (p) => ListView(
            padding: EdgeInsets.zero,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(AppRadius.lg)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: NetworkImageWidget(url: p.featuredImage),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (p.categoryName != null)
                          Text(
                            p.categoryName!.toUpperCase(),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),
                        const Spacer(),
                        Text(
                          '${p.readMinutes} min read',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                    AppSpacing.vGapSm,
                    Text(p.title, style: AppTextStyles.headingMd),
                    const SizedBox(height: 6),
                    Text(
                      [
                        if (p.authorName != null) 'By ${p.authorName}',
                        if (p.publishedAt != null) _formatDate(p.publishedAt!),
                      ].join('  ·  '),
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textTertiary),
                    ),
                    AppSpacing.vGapLg,
                    HtmlWidget(
                      p.content ?? '',
                      textStyle: AppTextStyles.bodyMd.copyWith(
                          color: context.colors.onSurface, height: 1.55),
                      onTapUrl: (url) async {
                        final uri = Uri.tryParse(url);
                        if (uri == null) return false;
                        return launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      },
                    ),
                    if (p.related.isNotEmpty) ...[
                      AppSpacing.vGapXl,
                      const Divider(),
                      AppSpacing.vGapMd,
                      const Text('Related articles',
                          style: AppTextStyles.titleMd),
                      AppSpacing.vGapMd,
                      for (final r in p.related) _RelatedTile(post: r),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}

class _RelatedTile extends StatelessWidget {
  const _RelatedTile({required this.post});

  final BlogPost post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        borderRadius: AppRadius.brMd,
        onTap: () => context.pushReplacement(AppRoutes.blogDetailPath(post.slug)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: AppRadius.brSm,
              child: NetworkImageWidget(
                url: post.featuredImage,
                width: 84,
                height: 64,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleSm,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${post.readMinutes} min read',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
