import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

/// Blog feed: a category filter bar and a scrollable list of post cards.
class BlogListScreen extends ConsumerWidget {
  const BlogListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feed = ref.watch(blogFeedProvider);
    final categories = ref.watch(blogCategoriesProvider);
    final active = ref.watch(blogCategoryFilterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Blog')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(blogFeedProvider);
            ref.invalidate(blogCategoriesProvider);
            await ref.read(blogFeedProvider.future);
          },
          child: Column(
            children: [
              // ── Category filter bar ─────────────────────────────────────────
              categories.maybeWhen(
                data: (cats) => cats.isEmpty
                    ? const SizedBox.shrink()
                    : SizedBox(
                        height: 48,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg, vertical: 8),
                          children: [
                            _CategoryChip(
                              label: 'All',
                              selected: active == null,
                              onTap: () => ref
                                  .read(blogCategoryFilterProvider.notifier)
                                  .state = null,
                            ),
                            for (final c in cats)
                              _CategoryChip(
                                label: c.name,
                                selected: active == c.slug,
                                onTap: () => ref
                                    .read(blogCategoryFilterProvider.notifier)
                                    .state = c.slug,
                              ),
                          ],
                        ),
                      ),
                orElse: () => const SizedBox.shrink(),
              ),
              Expanded(
                child: feed.when(
                  loading: () => const LoadingWidget(),
                  error: (_, _) => AppErrorWidget(
                    message: 'Couldn\'t load posts.',
                    onRetry: () => ref.invalidate(blogFeedProvider),
                  ),
                  data: (posts) => posts.isEmpty
                      ? const EmptyState(title: 'No posts yet')
                      : ListView.separated(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          itemCount: posts.length,
                          separatorBuilder: (_, _) => AppSpacing.vGapLg,
                          itemBuilder: (_, i) => _BlogCard(post: posts[i]),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        labelStyle: AppTextStyles.titleSm.copyWith(
          color: selected ? Colors.white : context.colors.onSurface,
        ),
        selectedColor: AppColors.primary,
      ),
    );
  }
}

class _BlogCard extends StatelessWidget {
  const _BlogCard({required this.post});

  final BlogPost post;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.brLg,
      onTap: () => context.push(AppRoutes.blogDetailPath(post.slug)),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: AppRadius.brLg,
          border: Border.all(color: context.colors.outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: NetworkImageWidget(url: post.featuredImage),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (post.categoryName != null)
                        Text(
                          post.categoryName!.toUpperCase(),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                      const Spacer(),
                      Text(
                        '${post.readMinutes} min read',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMd,
                  ),
                  if (post.excerpt.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      post.excerpt,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySm
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
