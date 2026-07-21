import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/location_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/geo.dart';
import '../../../shared/widgets/animations.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../saved/widgets/favorite_button.dart';
import '../models/property_model.dart';
import 'property_feature_row.dart';

/// Full-width property card used in the list and Home featured rail.
class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.property,
    this.onTap,
    this.width,
  });

  final PropertyModel property;
  final VoidCallback? onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Each card paints into its own layer so scrolling a long list — and the
    // favorite-toggle animation on one card — doesn't repaint its neighbours.
    return RepaintBoundary(
      child: Pressable(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.brLg,
          border: Border.all(color: theme.colorScheme.outline),
          boxShadow:
              theme.brightness == Brightness.light ? AppShadows.soft : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ImageHeader(property: property),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PriceRow(property: property),
                  AppSpacing.vGapSm,
                  Text(
                    property.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMd,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 15, color: AppColors.textTertiary),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          property.location ?? property.zoneName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySm,
                        ),
                      ),
                      _DistanceLabel(property: property),
                    ],
                  ),
                  AppSpacing.vGapMd,
                  const Divider(height: 1),
                  AppSpacing.vGapMd,
                  PropertyFeatureRow(property: property),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _ImageHeader extends StatelessWidget {
  const _ImageHeader({required this.property});
  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'listing-img-${property.id}',
            child: NetworkImageWidget(url: property.imageUrl),
          ),
          // Subtle top scrim so white badges stay legible over bright photos.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x4D000000), Colors.transparent],
                stops: [0, 0.4],
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Row(
              children: [
                AppBadge(label: property.type.label),
                if (property.isVerified) ...[
                  const SizedBox(width: 6),
                  const AppBadge.verified(),
                ],
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: FavoriteButton(
              listingId: property.id,
              initialIsFavorite: property.isFavorite,
            ),
          ),
          if (property.isFeatured)
            const Positioned(bottom: 10, left: 10, child: AppBadge.featured()),
        ],
      ),
    );
  }
}

/// "· 2.3 km" shown next to the location once the user shares their position
/// (via Home → "Use my current location"). Renders nothing otherwise.
class _DistanceLabel extends ConsumerWidget {
  const _DistanceLabel({required this.property});
  final PropertyModel property;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(userLocationProvider);
    final lat = property.latitude;
    final lng = property.longitude;
    if (me == null || lat == null || lng == null) return const SizedBox.shrink();

    final km = Geo.distanceKm(me.lat, me.lng, lat, lng);
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 6),
      child: Text(
        '· ${Geo.label(km)}',
        style: AppTextStyles.bodySm.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.property});
  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    final period = property.type.pricePeriod;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Flexible(
          child: Text(
            property.priceDisplay ?? Formatters.price(property.price),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.price,
          ),
        ),
        if (period.isNotEmpty)
          Text(' /$period', style: AppTextStyles.bodySm),
      ],
    );
  }
}
