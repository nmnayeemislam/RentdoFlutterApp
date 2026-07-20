import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../properties/models/property_model.dart';
import '../controllers/owner_controller.dart';

class MyListingsScreen extends ConsumerWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.watch(authControllerProvider.select((s) => s.isAuthenticated));
    if (!isAuthed) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Listings')),
        body: EmptyState(
          icon: Icons.home_work_outlined,
          title: 'Sign in to manage listings',
          subtitle: 'Log in to see and manage the properties you posted.',
          action: SizedBox(
            width: 200,
            child: PrimaryButton(
              label: 'Log in',
              onPressed: () => context.push(AppRoutes.login),
            ),
          ),
        ),
      );
    }

    final listings = ref.watch(myListingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Listings')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.createListing),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Post'),
      ),
      body: listings.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => AppErrorWidget(
          message: '$e',
          onRetry: () => ref.invalidate(myListingsProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
              icon: Icons.home_work_outlined,
              title: 'No listings yet',
              subtitle: 'Properties you post will appear here.',
            );
          }
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => ref.invalidate(myListingsProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) => _OwnerListingTile(property: items[i]),
            ),
          );
        },
      ),
    );
  }
}

class _OwnerListingTile extends ConsumerWidget {
  const _OwnerListingTile({required this.property});
  final PropertyModel property;

  static const _statusColors = {
    'active': AppColors.success,
    'pending': AppColors.warning,
    'rented': AppColors.info,
    'sold': AppColors.info,
    'archived': AppColors.textTertiary,
  };

  Future<void> _setStatus(BuildContext context, WidgetRef ref, String status) async {
    try {
      await ref.read(listingStatusUpdater)(property.id, status);
      if (context.mounted) context.showSnack('Listing marked $status');
    } on ApiException catch (e) {
      if (context.mounted) context.showSnack(e.message, error: true);
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(listingDeleter)(property.id);
      if (context.mounted) context.showSnack('Listing deleted');
    } on ApiException catch (e) {
      if (context.mounted) context.showSnack(e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = property.status ?? 'active';
    return InkWell(
      borderRadius: AppRadius.brLg,
      onTap: () => context.pushNamed(
        AppRoutes.propertyDetailName,
        pathParameters: {'id': '${property.id}'},
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: AppRadius.brLg,
          border: Border.all(color: context.colors.outline),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: AppRadius.brSm,
              child: NetworkImageWidget(
                  url: property.imageUrl, width: 76, height: 76),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(property.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleSm),
                  const SizedBox(height: 2),
                  Text(property.priceDisplay ?? Formatters.price(property.price),
                      style: AppTextStyles.titleMd
                          .copyWith(color: AppColors.primary)),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: (_statusColors[status] ?? AppColors.textTertiary)
                          .withValues(alpha: 0.14),
                      borderRadius: AppRadius.brPill,
                    ),
                    child: Text(status.toUpperCase(),
                        style: AppTextStyles.caption.copyWith(
                          color: _statusColors[status] ?? AppColors.textTertiary,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded,
                  color: AppColors.textTertiary),
              onSelected: (v) {
                if (v == 'edit') {
                  context.push(AppRoutes.createListing, extra: property);
                } else if (v == 'delete') {
                  unawaited(_delete(context, ref));
                } else {
                  unawaited(_setStatus(context, ref, v));
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'rented', child: Text('Mark as rented')),
                PopupMenuItem(value: 'sold', child: Text('Mark as sold')),
                PopupMenuItem(value: 'archived', child: Text('Archive')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
