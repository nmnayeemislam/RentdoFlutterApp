import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/animations.dart';
import '../../../shared/widgets/section_header.dart';
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

/// Home tab: hero search, categories, featured listings and trust highlights.
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
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async => ref.invalidate(featuredPropertiesProvider),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            HomeHero(
              userName: userName?.split(' ').first,
              onSearchTap: () => _goToList(ref, context),
            ),
            AppSpacing.vGapXl,
            const _StatsRow(),
            AppSpacing.vGapXxl,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SectionHeader(
                title: 'Categories',
                subtitle: 'Browse by property type',
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
            AppSpacing.vGapXxl,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SectionHeader(
                title: 'Property by Location',
                subtitle: 'Explore homes in top cities',
              ),
            ),
            AppSpacing.vGapMd,
            _LocationRail(onSelected: (city) => _goToLocation(ref, context, city)),
            AppSpacing.vGapXxl,
            const _WhyChoose(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  static const _stats = [
    ('60+', 'Properties'),
    ('30+', 'Cities'),
    ('Verified', 'Listings'),
    ('24/7', 'Support'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (final s in _stats)
            Expanded(
              child: Column(
                children: [
                  Text(s.$1,
                      style: AppTextStyles.headingMd
                          .copyWith(color: AppColors.primary)),
                  const SizedBox(height: 2),
                  Text(s.$2,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption),
                ],
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
      loading: () => const SizedBox(height: 300, child: LoadingWidget()),
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
                    gradient: AppColors.primaryGradient,
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

class _WhyChoose extends StatelessWidget {
  const _WhyChoose();

  static const _items = [
    (Icons.verified_outlined, 'Verified Listings',
        'All listings verified for your safety.'),
    (Icons.handshake_outlined, 'Trusted Agents',
        'Work with professional, trusted agents.'),
    (Icons.lock_outline_rounded, 'Secure Transactions',
        'Transparent and secure throughout.'),
    (Icons.event_available_outlined, 'Schedule Visits',
        'Book property visits online with ease.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Why choose Rentdo?', style: AppTextStyles.headingLg),
          AppSpacing.vGapLg,
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.35,
            children: [
              for (final item in _items)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: AppRadius.brMd,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.outline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.$1, color: AppColors.primary, size: 26),
                      const SizedBox(height: 8),
                      Text(item.$2, style: AppTextStyles.titleSm),
                      const SizedBox(height: 2),
                      Text(item.$3,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySm),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
