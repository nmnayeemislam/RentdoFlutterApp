import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/services/location_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/animations.dart';
import '../../../shared/widgets/app_search_bar.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/skeletons.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../blog/models/blog_post.dart';
import '../../blog/providers/blog_providers.dart';
import '../../properties/controllers/property_list_controller.dart';
import '../../properties/controllers/property_providers.dart';
import '../../properties/models/property_filter.dart';
import '../../properties/models/property_model.dart';
import '../../properties/widgets/property_card.dart';
import '../../zones/models/zone_model.dart';
import '../../zones/providers/zone_providers.dart';
import '../widgets/category_grid.dart';
import '../widgets/home_hero.dart';

/// Home tab: light header, search, trust stats, categories, featured listings.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _goToList(WidgetRef ref, BuildContext context, {ListingType? type}) {
    if (type != null) {
      ref
          .read(propertyListControllerProvider.notifier)
          .applyFilter(PropertyFilter(type: type));
    }
    context.go(AppRoutes.properties);
  }

  void _goToLocation(WidgetRef ref, BuildContext context, ZoneModel city) {
    ref.read(propertyListControllerProvider.notifier).applyFilter(
          PropertyFilter(zoneId: city.id, zoneName: city.displayName),
        );
    context.go(AppRoutes.properties);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName =
        ref.watch(authControllerProvider.select((s) => s.user?.name));
    final featured = ref.watch(featuredPropertiesProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(featuredPropertiesProvider);
            ref.invalidate(blogFeedProvider);
          },
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  children: [
                    HomeHeader(userName: userName?.split(' ').first),
                    AppSpacing.vGapLg,
                    AppSearchBar(
                      readOnly: true,
                      onTap: () => _goToList(ref, context),
                      onFilterTap: () => _goToList(ref, context),
                    ),
                    AppSpacing.vGapMd,
                    const _UseMyLocationTile(),
                  ],
                ),
              ),
              AppSpacing.vGapXxl,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SectionHeader(
                  title: 'Categories',
                  actionLabel: 'View all',
                  onAction: () => _goToList(ref, context),
                ),
              ),
              AppSpacing.vGapMd,
              CategoryRail(
                onSelected: (type) => _goToList(ref, context, type: type),
              ),
              AppSpacing.vGapXxl,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SectionHeader(
                  title: 'Featured Properties',
                  subtitle: 'Hand-picked listings for you',
                  actionLabel: 'View all',
                  onAction: () => _goToList(ref, context),
                ),
              ),
              AppSpacing.vGapMd,
              _FeaturedRail(async: featured),
              AppSpacing.vGapXl,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _CtaBanner(onTap: () => _goToList(ref, context)),
              ),
              AppSpacing.vGapXxl,
              const _BlogSection(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SectionHeader(
                  title: 'Property by Location',
                  subtitle: 'Explore homes in top cities',
                ),
              ),
              AppSpacing.vGapMd,
              _LocationRail(
                  onSelected: (city) => _goToLocation(ref, context, city)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Use my current location" — resolves GPS → nearest city, then opens the
/// property list filtered to that zone. Also seeds [userLocationProvider] so
/// listings can show a "· X km away" label.
class _UseMyLocationTile extends ConsumerStatefulWidget {
  const _UseMyLocationTile();

  @override
  ConsumerState<_UseMyLocationTile> createState() =>
      _UseMyLocationTileState();
}

class _UseMyLocationTileState extends ConsumerState<_UseMyLocationTile> {
  bool _busy = false;

  Future<void> _run() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final coords = await ref.read(locationServiceProvider).current();
      ref.read(userLocationProvider.notifier).state = coords;

      final zone = await ref
          .read(zoneRepositoryProvider)
          .resolve(lat: coords.lat, lng: coords.lng);

      if (!mounted) return;
      if (zone != null) {
        unawaited(
          ref.read(propertyListControllerProvider.notifier).applyFilter(
                PropertyFilter(zoneId: zone.id, zoneName: zone.displayName),
              ),
        );
        context.showSnack('Showing properties near ${zone.name}');
      } else {
        context.showSnack('Showing properties near you');
      }
      context.go(AppRoutes.properties);
    } on LocationException catch (e) {
      if (mounted) context.showSnack(e.message, error: true);
    } catch (_) {
      if (mounted) {
        context.showSnack('Could not get your location.', error: true);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _run,
        borderRadius: AppRadius.brMd,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: AppRadius.brMd,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              SizedBox(
                height: 18,
                width: 18,
                child: _busy
                    ? const CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.primary)
                    : const Icon(Icons.my_location_rounded,
                        size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _busy ? 'Finding properties near you…' : 'Use my current location',
                  style: AppTextStyles.titleSm
                      .copyWith(color: AppColors.primary),
                ),
              ),
              if (!_busy)
                const Icon(Icons.chevron_right_rounded,
                    size: 20, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Not sure where to start?" prompt banner.
class _CtaBanner extends StatelessWidget {
  const _CtaBanner({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.isDark
            ? AppColors.surfaceAltDark
            : AppColors.surfaceAltLight,
        borderRadius: AppRadius.brLg,
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.navy,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.travel_explore_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Not sure where to start?',
                    style: AppTextStyles.titleSm),
                const SizedBox(height: 2),
                Text('Let us help you find the perfect place.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySm
                        .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppRadius.brMd,
              ),
              child: Text('Explore Now',
                  style: AppTextStyles.titleSm.copyWith(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedRail extends ConsumerWidget {
  const _FeaturedRail({required this.async});
  final AsyncValue<List<PropertyModel>> async;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return async.when(
      loading: () => const PropertyRailSkeleton(),
      error: (e, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _InlineRetry(
          message: e is ApiException ? e.message : 'Couldn\'t load listings.',
          onRetry: () => ref.invalidate(featuredPropertiesProvider),
        ),
      ),
      data: (items) {
        if (items.isEmpty) {
          return const SizedBox(
            height: 220,
            child: EmptyState(title: 'No featured listings yet'),
          );
        }
        return SizedBox(
          height: 320,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, i) {
              final property = items[i];
              return FadeSlideIn(
                delay: Duration(milliseconds: (i * 70).clamp(0, 500)),
                child: PropertyCard(
                  width: 280,
                  property: property,
                  onTap: () => context.pushNamed(
                    AppRoutes.propertyDetailName,
                    pathParameters: {'id': '${property.id}'},
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// "Property by Location" — a rail of city cards that filter the list by zone.
class _LocationRail extends ConsumerWidget {
  const _LocationRail({required this.onSelected});
  final ValueChanged<ZoneModel> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cities = ref.watch(citiesProvider);
    return SizedBox(
      height: 116,
      child: cities.maybeWhen(
        data: (list) {
          if (list.isEmpty) return const SizedBox.shrink();
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final city = list[i];
              return Pressable(
                onTap: () => onSelected(city),
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                    gradient: AppColors.heroGradient,
                    borderRadius: AppRadius.brLg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.location_city_rounded,
                          color: Colors.white, size: 26),
                      Text(
                        city.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleMd
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }
}

/// "From the Blog" — a rail of the latest posts. Rendered only once posts have
/// loaded so a slow/empty blog never leaves a dangling header on the home feed.
class _BlogSection extends ConsumerWidget {
  const _BlogSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(blogFeedProvider).valueOrNull ?? const <BlogPost>[];
    if (posts.isEmpty) return const SizedBox.shrink();

    final items = posts.take(6).toList(growable: false);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionHeader(
            title: 'From the Blog',
            subtitle: 'Tips & guides for renters and owners',
            actionLabel: 'View all',
            onAction: () => context.push(AppRoutes.blog),
          ),
        ),
        AppSpacing.vGapMd,
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, i) {
              final post = items[i];
              return FadeSlideIn(
                delay: Duration(milliseconds: (i * 70).clamp(0, 500)),
                child: _BlogRailCard(post: post),
              );
            },
          ),
        ),
        AppSpacing.vGapXxl,
      ],
    );
  }
}

class _BlogRailCard extends StatelessWidget {
  const _BlogRailCard({required this.post});

  final BlogPost post;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.brLg,
      onTap: () => context.push(AppRoutes.blogDetailPath(post.slug)),
      child: Container(
        width: 260,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (post.categoryName != null)
                      Text(
                        post.categoryName!.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleSm,
                    ),
                    const Spacer(),
                    Text(
                      '${post.readMinutes} min read',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact inline error used inside the home feed so a failed section doesn't
/// blank the whole page.
class _InlineRetry extends StatelessWidget {
  const _InlineRetry({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: context.colors.outline),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded,
              size: 22, color: AppColors.textTertiary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySm),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
