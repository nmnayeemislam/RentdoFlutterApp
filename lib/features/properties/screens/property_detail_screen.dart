import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/animations.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../bookings/widgets/book_now_sheet.dart';
import '../../chat/widgets/start_conversation_sheet.dart';
import '../../community/controllers/community_controller.dart';
import '../../community/widgets/report_sheet.dart';
import '../../compare/widgets/compare_button.dart';
import '../../reviews/controllers/reviews_controller.dart';
import '../../reviews/widgets/write_review_sheet.dart';
import '../../saved/widgets/favorite_button.dart';
import '../../technicians/controllers/technician_controller.dart';
import '../../visits/widgets/schedule_visit_sheet.dart';
import '../controllers/property_providers.dart';
import '../models/property_model.dart';
import '../widgets/property_card.dart';
import '../widgets/property_feature_row.dart';

/// Full-screen property detail. Consumes [propertyDetailProvider] keyed by id.
class PropertyDetailScreen extends ConsumerWidget {
  const PropertyDetailScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(propertyDetailProvider(id));

    return Scaffold(
      body: async.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.invalidate(propertyDetailProvider(id)),
        ),
        data: (property) => _DetailBody(property: property),
      ),
      bottomNavigationBar: async.maybeWhen(
        data: (property) => _ContactBar(property: property),
        orElse: () => null,
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.property});
  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 320,
          pinned: true,
          backgroundColor: context.colors.surface,
          leading: const _CircleAction(icon: Icons.arrow_back_rounded),
          actions: [
            Padding(
              padding: const EdgeInsets.all(6),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: _ShareButton(property: property),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: CompareButton(property: property),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: FavoriteButton(
                  listingId: property.id,
                  initialIsFavorite: property.isFavorite,
                  filledBackground: false,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: _MoreMenu(property: property),
              ),
            ),
            const SizedBox(width: 8),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: _Gallery(property: property),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppBadge(label: property.type.label),
                    if (property.isVerified) ...[
                      const SizedBox(width: 6),
                      const AppBadge.verified(),
                    ],
                    const Spacer(),
                    Text(
                      property.priceDisplay ??
                          Formatters.price(property.price,
                              period: property.type.pricePeriod.isEmpty
                                  ? null
                                  : property.type.pricePeriod),
                      style: AppTextStyles.headingMd
                          .copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
                AppSpacing.vGapLg,
                Text(property.title, style: AppTextStyles.headingXl),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 18, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        [property.address, property.zoneName]
                            .where((e) => e != null && e.isNotEmpty)
                            .join(', '),
                        style: AppTextStyles.bodyMd,
                      ),
                    ),
                  ],
                ),
                AppSpacing.vGapXl,
                _FeatureCards(property: property),
                if (property.description != null) ...[
                  AppSpacing.vGapXxl,
                  const Text('Description', style: AppTextStyles.headingMd),
                  AppSpacing.vGapMd,
                  Text(property.description!,
                      style: AppTextStyles.bodyLg),
                ],
                AppSpacing.vGapXxl,
                const Text('Property details', style: AppTextStyles.headingMd),
                AppSpacing.vGapMd,
                _SpecTable(property: property),
                if (property.type == ListingType.hotel ||
                    property.type == ListingType.vacation) ...[
                  AppSpacing.vGapXxl,
                  const Text('Availability', style: AppTextStyles.headingMd),
                  AppSpacing.vGapMd,
                  _AvailabilityStrip(listingId: property.id),
                ],
                if (property.amenities.isNotEmpty) ...[
                  AppSpacing.vGapXxl,
                  const Text('Amenities', style: AppTextStyles.headingMd),
                  AppSpacing.vGapMd,
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final a in property.amenities) _AmenityChip(label: a),
                    ],
                  ),
                ],
                if (property.address != null || property.zoneName != null) ...[
                  AppSpacing.vGapXxl,
                  const Text('Location', style: AppTextStyles.headingMd),
                  AppSpacing.vGapMd,
                  _LocationCard(property: property),
                ],
                AppSpacing.vGapXxl,
                if (property.ownerName != null) _AgentCard(property: property),
                AppSpacing.vGapXxl,
                _ReviewsSection(listingId: property.id),
                _SuggestedTechnicians(listingId: property.id),
                _SimilarSection(property: property),
                const SizedBox(height: 90),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({required this.property});
  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    final images = property.gallery.isNotEmpty
        ? property.gallery
        : [if (property.imageUrl != null) property.imageUrl!];
    if (images.isEmpty) {
      return const NetworkImageWidget(url: null);
    }
    return PageView.builder(
      itemCount: images.length,
      itemBuilder: (_, i) {
        final image = NetworkImageWidget(url: images[i]);
        // Only the first image participates in the shared-element transition.
        return i == 0
            ? Hero(tag: 'listing-img-${property.id}', child: image)
            : image;
      },
    );
  }
}

class _FeatureCards extends StatelessWidget {
  const _FeatureCards({required this.property});
  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, String)>[
      if (property.beds != null)
        (Icons.king_bed_outlined, '${property.beds}', 'Bedrooms'),
      if (property.baths != null)
        (Icons.bathtub_outlined, '${property.baths}', 'Bathrooms'),
      if (property.sizeSqft != null)
        (Icons.square_foot_rounded, Formatters.compact(property.sizeSqft),
            'Sq ft'),
    ];
    if (items.isEmpty) return PropertyFeatureRow(property: property);

    return Row(
      children: [
        for (final item in items)
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: AppRadius.brMd,
                border: Border.all(color: context.colors.outline),
              ),
              child: Column(
                children: [
                  Icon(item.$1, color: AppColors.primary),
                  const SizedBox(height: 6),
                  Text(item.$2, style: AppTextStyles.titleMd),
                  Text(item.$3, style: AppTextStyles.caption),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SpecTable extends StatelessWidget {
  const _SpecTable({required this.property});
  final PropertyModel property;

  static String _cap(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    final p = property;
    final rows = <(String, String)>[
      ('Type', p.type.label),
      if (p.beds != null) ('Bedrooms', '${p.beds}'),
      if (p.baths != null) ('Bathrooms', '${p.baths}'),
      if (p.sizeSqft != null) ('Area', '${Formatters.compact(p.sizeSqft)} sqft'),
      if (p.floor != null)
        ('Floor',
            '${p.floor}${p.totalFloors != null ? ' of ${p.totalFloors}' : ''}'),
      ('Furnished', p.furnished ? 'Yes' : 'No'),
      ('Parking', p.parking ? 'Yes' : 'No'),
      if (p.allowedFor != null) ('Allowed for', _cap(p.allowedFor!)),
      if (p.serviceCharge != null && p.serviceCharge! > 0)
        ('Service charge', Formatters.money(p.serviceCharge, currency: p.currency)),
      if (p.advanceMonths != null && p.advanceMonths! > 0)
        ('Advance', '${p.advanceMonths} month(s)'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: context.colors.outline),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Text(rows[i].$1,
                      style: AppTextStyles.bodyMd
                          .copyWith(color: AppColors.textSecondary)),
                  const Spacer(),
                  Text(rows[i].$2, style: AppTextStyles.titleSm),
                ],
              ),
            ),
            if (i != rows.length - 1) const Divider(height: 1, indent: 14, endIndent: 14),
          ],
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.property});
  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    final address = [property.address, property.zoneName]
        .where((e) => e != null && e.isNotEmpty)
        .join(', ');
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: context.colors.outline),
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: const BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: AppRadius.brMd,
            ),
            child: const Icon(Icons.map_outlined, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(address.isEmpty ? 'Location' : address,
                    style: AppTextStyles.titleSm),
                if (property.latitude != null && property.longitude != null)
                  Text(
                    '${property.latitude!.toStringAsFixed(4)}, ${property.longitude!.toStringAsFixed(4)}',
                    style: AppTextStyles.caption,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Next-60-days availability for hotel/vacation listings.
class _AvailabilityStrip extends ConsumerWidget {
  const _AvailabilityStrip({required this.listingId});
  final int listingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = ref.watch(listingAvailabilityProvider(listingId));
    return days.when(
      loading: () => const SizedBox(
        height: 74,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2.4)),
      ),
      error: (e, _) => Text(
        e is ApiException ? e.message : 'Availability unavailable.',
        style: AppTextStyles.bodySm,
      ),
      data: (list) {
        if (list.isEmpty) {
          return Text('No availability published yet.',
              style: AppTextStyles.bodyMd
                  .copyWith(color: AppColors.textSecondary));
        }
        return SizedBox(
          height: 74,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final day = list[i];
              final free = day.isAvailable;
              return Container(
                width: 58,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: free
                      ? AppColors.primarySurface
                      : context.colors.surface,
                  borderRadius: AppRadius.brSm,
                  border: Border.all(
                    color: free ? AppColors.primary : context.colors.outline,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${day.date.day}/${day.date.month}',
                        style: AppTextStyles.caption),
                    const SizedBox(height: 2),
                    Icon(
                      free ? Icons.check_rounded : Icons.close_rounded,
                      size: 16,
                      color: free ? AppColors.primary : AppColors.textTertiary,
                    ),
                    if (day.price != null)
                      Text(Formatters.compact(day.price),
                          style: AppTextStyles.caption),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// Technicians the backend suggests for this property (zone/category aware).
class _SuggestedTechnicians extends ConsumerWidget {
  const _SuggestedTechnicians({required this.listingId});
  final int listingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(listingTechniciansProvider(listingId)).maybeWhen(
          data: (items) {
            if (items.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.vGapXxl,
                const Text('Services nearby', style: AppTextStyles.headingMd),
                AppSpacing.vGapMd,
                SizedBox(
                  height: 96,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, i) {
                      final tech = items[i];
                      return Pressable(
                        onTap: () => context.pushNamed(
                          AppRoutes.technicianDetailName,
                          pathParameters: {'id': '${tech.id}'},
                        ),
                        child: Container(
                          width: 168,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: context.colors.surface,
                            borderRadius: AppRadius.brMd,
                            border: Border.all(color: context.colors.outline),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(tech.name ?? 'Technician',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.titleSm),
                              if (tech.categoryName != null)
                                Text(tech.categoryName!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.bodySm),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded,
                                      size: 14, color: AppColors.rating),
                                  const SizedBox(width: 2),
                                  Text(tech.rating.toStringAsFixed(1),
                                      style: AppTextStyles.caption),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
  }
}

class _SimilarSection extends ConsumerWidget {
  const _SimilarSection({required this.property});
  final PropertyModel property;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final similar = ref.watch(similarPropertiesProvider(
        (excludeId: property.id, type: property.type)));
    return similar.maybeWhen(
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.vGapXxl,
            const Text('Similar properties', style: AppTextStyles.headingMd),
            AppSpacing.vGapMd,
            SizedBox(
              height: 320,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (context, i) {
                  final item = items[i];
                  return PropertyCard(
                    width: 260,
                    property: item,
                    onTap: () => context.pushNamed(
                      AppRoutes.propertyDetailName,
                      pathParameters: {'id': '${item.id}'},
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _AmenityChip extends StatelessWidget {
  const _AmenityChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: const BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppRadius.brSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(label,
              style: AppTextStyles.bodySm.copyWith(color: AppColors.primaryDark)),
        ],
      ),
    );
  }
}

class _AgentCard extends ConsumerWidget {
  const _AgentCard({required this.property});
  final PropertyModel property;

  Future<void> _startChat(BuildContext context, WidgetRef ref) async {
    final isAuthed =
        ref.read(authControllerProvider.select((s) => s.isAuthenticated));
    if (!isAuthed) {
      context.showSnack('Log in to message the owner.');
      unawaited(context.push(AppRoutes.login));
      return;
    }
    final id = await StartConversationSheet.show(context, property.id);
    if (id != null && id > 0 && context.mounted) {
      unawaited(context.push(AppRoutes.chat(id)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: context.colors.outline),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primarySurface,
            backgroundImage: property.ownerAvatar != null
                ? CachedNetworkImageProvider(property.ownerAvatar!)
                : null,
            child: property.ownerAvatar == null
                ? const Icon(Icons.person, color: AppColors.primary)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Listed by', style: AppTextStyles.caption),
                Text(property.ownerName!, style: AppTextStyles.titleMd),
                if (property.postedAt != null)
                  Text(Formatters.relative(property.postedAt),
                      style: AppTextStyles.bodySm),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: () => _startChat(context, ref),
            icon: const Icon(Icons.chat_bubble_outline_rounded),
          ),
        ],
      ),
    );
  }
}

class _ContactBar extends ConsumerWidget {
  const _ContactBar({required this.property});
  final PropertyModel property;

  bool _requireAuth(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.read(authControllerProvider.select((s) => s.isAuthenticated));
    if (!isAuthed) {
      context.showSnack('Log in to continue.');
      unawaited(context.push(AppRoutes.login));
    }
    return isAuthed;
  }

  Future<void> _revealContact(BuildContext context, WidgetRef ref) async {
    if (!_requireAuth(context, ref)) return;
    try {
      final phone =
          await ref.read(propertyRepositoryProvider).revealContact(property.id);
      if (!context.mounted) return;
      if (phone == null || phone.isEmpty) {
        context.showSnack('Contact not available for this listing.');
        return;
      }
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Contact owner'),
          content: SelectableText(phone, style: AppTextStyles.headingMd),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } on ApiException catch (e) {
      if (!context.mounted) return;
      context.showSnack(e.message, error: true);
    }
  }

  Future<void> _scheduleVisit(BuildContext context, WidgetRef ref) async {
    if (!_requireAuth(context, ref)) return;
    final ok = await ScheduleVisitSheet.show(context, property.id);
    if (ok == true && context.mounted) {
      context.showSnack('Visit requested');
    }
  }

  Future<void> _book(BuildContext context, WidgetRef ref) async {
    if (!_requireAuth(context, ref)) return;
    final ok = await BookNowSheet.show(context, property.id);
    if (ok == true && context.mounted) {
      context.showSnack('Booking requested');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookable = property.type == ListingType.hotel ||
        property.type == ListingType.vacation;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.outline)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: OutlinedButton.icon(
                  onPressed: () => _revealContact(context, ref),
                  icon: const Icon(Icons.call_outlined),
                  label: const Text('Call'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 5,
                child: bookable
                    ? PrimaryButton(
                        label: 'Book now',
                        icon: Icons.hotel_rounded,
                        onPressed: () => _book(context, ref),
                      )
                    : PrimaryButton(
                        label: 'Schedule visit',
                        icon: Icons.calendar_today_rounded,
                        onPressed: () => _scheduleVisit(context, ref),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewsSection extends ConsumerWidget {
  const _ReviewsSection({required this.listingId});
  final int listingId;

  Future<void> _write(BuildContext context, WidgetRef ref) async {
    final isAuthed =
        ref.read(authControllerProvider.select((s) => s.isAuthenticated));
    if (!isAuthed) {
      context.showSnack('Log in to write a review.');
      unawaited(context.push(AppRoutes.login));
      return;
    }
    final ok = await WriteReviewSheet.show(context, listingId);
    if (ok == true && context.mounted) context.showSnack('Review submitted');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(listingReviewsProvider(listingId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Reviews', style: AppTextStyles.headingMd),
            const Spacer(),
            TextButton.icon(
              onPressed: () => _write(context, ref),
              icon: const Icon(Icons.rate_review_outlined, size: 18),
              label: const Text('Write'),
            ),
          ],
        ),
        AppSpacing.vGapMd,
        reviews.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2.4)),
          ),
          error: (e, _) => const Text('Could not load reviews.',
              style: AppTextStyles.bodySm),
          data: (items) {
            if (items.isEmpty) {
              return Text('No reviews yet. Be the first to review.',
                  style: AppTextStyles.bodyMd
                      .copyWith(color: AppColors.textSecondary));
            }
            return Column(
              children: [for (final r in items) _ReviewTile(review: r)],
            );
          },
        ),
      ],
    );
  }
}

class _ReviewTile extends ConsumerWidget {
  const _ReviewTile({required this.review});
  final ReviewModel review;

  Future<void> _report(BuildContext context, WidgetRef ref) async {
    final reason = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text('Report this review',
                  style: AppTextStyles.headingMd),
            ),
            for (final r in const ['spam', 'inappropriate_content', 'harassment', 'other'])
              ListTile(
                title: Text(r.replaceAll('_', ' ')),
                onTap: () => Navigator.pop(context, r),
              ),
          ],
        ),
      ),
    );
    if (reason == null) return;
    try {
      await ref.read(reviewServiceProvider).report(review.id, reason);
      if (context.mounted) context.showSnack('Review reported');
    } on ApiException catch (e) {
      if (context.mounted) context.showSnack(e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(review.reviewerName ?? 'Guest',
                  style: AppTextStyles.titleSm),
              InkResponse(
                onTap: () => unawaited(_report(context, ref)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(Icons.flag_outlined,
                      size: 14, color: AppColors.textTertiary),
                ),
              ),
              const Spacer(),
              for (var i = 1; i <= 5; i++)
                Icon(
                  i <= review.rating
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  size: 15,
                  color: AppColors.rating,
                ),
            ],
          ),
          if (review.body != null && review.body!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(review.body!, style: AppTextStyles.bodyMd),
          ],
          if (review.createdAt != null) ...[
            const SizedBox(height: 2),
            Text(Formatters.relative(review.createdAt),
                style: AppTextStyles.caption),
          ],
        ],
      ),
    );
  }
}

/// Shares the listing using the OS share sheet. Pulls the canonical share URL
/// from `GET /listings/{id}/share`, falling back to a locally-built link.
class _ShareButton extends ConsumerWidget {
  const _ShareButton({required this.property});
  final PropertyModel property;

  Future<void> _share(BuildContext context, WidgetRef ref) async {
    var url = '${AppConfig.baseUrl}/properties/${property.id}';
    try {
      final data = await ref.read(propertyServiceProvider).share(property.id);
      final remote = (data['url'] ?? data['share_url'] ?? data['link']) as String?;
      if (remote != null && remote.isNotEmpty) url = remote;
    } on ApiException {
      // Fall back to the locally-built link.
    }
    if (!context.mounted) return;
    await SharePlus.instance.share(
      ShareParams(text: '${property.title}\n$url', subject: property.title),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.share_outlined, color: AppColors.ink, size: 20),
      tooltip: 'Share',
      onPressed: () => unawaited(_share(context, ref)),
    );
  }
}

class _MoreMenu extends ConsumerWidget {
  const _MoreMenu({required this.property});
  final PropertyModel property;

  bool _requireAuth(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.read(authControllerProvider.select((s) => s.isAuthenticated));
    if (!isAuthed) {
      context.showSnack('Log in to continue.');
      unawaited(context.push(AppRoutes.login));
    }
    return isAuthed;
  }

  Future<void> _report(BuildContext context, WidgetRef ref) async {
    if (!_requireAuth(context, ref)) return;
    final ok = await ReportSheet.show(context, property.id);
    if (ok == true && context.mounted) context.showSnack('Report submitted');
  }

  Future<void> _block(BuildContext context, WidgetRef ref) async {
    final ownerId = property.ownerId;
    if (ownerId == null || !_requireAuth(context, ref)) return;
    try {
      await ref.read(communityServiceProvider).blockUser(ownerId);
      if (!context.mounted) return;
      context.showSnack('Owner blocked');
    } on ApiException catch (e) {
      if (!context.mounted) return;
      context.showSnack(e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded, color: AppColors.ink, size: 20),
      onSelected: (v) {
        if (v == 'report') unawaited(_report(context, ref));
        if (v == 'block') unawaited(_block(context, ref));
      },
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'report', child: Text('Report listing')),
        if (property.ownerId != null)
          const PopupMenuItem(value: 'block', child: Text('Block owner')),
      ],
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return Padding(
      padding: const EdgeInsets.all(6),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(icon, color: AppColors.ink, size: 20),
          onPressed: () {
            if (icon == Icons.arrow_back_rounded && canPop) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }
}
