import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/animations.dart';
import '../../../shared/widgets/app_search_bar.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/skeletons.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/controllers/auth_controller.dart';
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
          onRefresh: () async => ref.invalidate(featuredPropertiesProvider),
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
                    AppSpacing.vGapLg,
                    const _StatsCard(),
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

/// White trust-stats card with colored icon chips and dividers.
class _StatsCard extends StatelessWidget {
  const _StatsCard();

  static const _stats = <(IconData, Color, String, String)>[
    (Icons.home_rounded, AppColors.info, '60+', 'Properties'),
    (Icons.location_on_rounded, AppColors.primary, '30+', 'Cities'),
    (Icons.verified_rounded, AppColors.success, 'Verified', 'Listings'),
    (Icons.headset_mic_rounded, AppColors.warning, '24/7', 'Support'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: context.colors.outline),
        boxShadow: context.isDark ? null : AppShadows.soft,
      ),
      child: Row(
        children: [
          for (var i = 0; i < _stats.length; i++) ...[
            if (i > 0)
              Container(width: 1, height: 32, color: context.colors.outline),
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 34,
                    width: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _stats[i].$2.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_stats[i].$1, color: _stats[i].$2, size: 18),
                  ),
                  const SizedBox(height: 6),
                  Text(_stats[i].$3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleSm),
                  Text(_stats[i].$4,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textTertiary)),
                ],
              ),
            ),
          ],
        ],
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
                color: AppColors.navy,
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
