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
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/billing_viewmodel.dart';

/// Lists one-off post-quota packages the user can buy with their wallet
/// balance. Guests see a sign-in prompt.
class PackagesScreen extends ConsumerWidget {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.watch(authViewModelProvider.select((s) => s.isAuthenticated));

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.billingPostPackagesTitle)),
      body: !isAuthed
          ? const _GuestPrompt()
          : ref.watch(packagesProvider).when(
                loading: () => const SizedBox.shrink(),
                error: (e, _) => AppErrorWidget(
                  message: '$e',
                  onRetry: () => ref.invalidate(packagesProvider),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return EmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: context.l10n.billingNoPackagesAvailable,
                      subtitle: context.l10n.billingCheckBackLaterPackages,
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: items.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, i) =>
                        _PackageCard(package: items[i]),
                  );
                },
              ),
    );
  }
}

class _PackageCard extends ConsumerWidget {
  const _PackageCard({required this.package});
  final PackageModel package;

  Future<void> _buy(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(billingActionsProvider.notifier).buyPackage(package.id);
      if (context.mounted) {
        context.showSnack(context.l10n.billingPackagePurchased);
      }
    } on ApiException catch (e) {
      if (context.mounted) context.showSnack(e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submitting = ref.watch(billingActionsProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: context.colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  package.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headingMd,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                Formatters.money(package.price, currency: package.currency),
                style: AppTextStyles.price,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const Icon(
                Icons.article_outlined,
                size: 16,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  context.l10n
                      .billingPostsAndDays(package.postQuota, package.durationDays),
                  style: AppTextStyles.bodySm,
                ),
              ),
            ],
          ),
          if (package.features.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            for (final feature in package.features)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(feature, style: AppTextStyles.bodyMd),
                    ),
                  ],
                ),
              ),
          ],
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: context.l10n.buy,
            isLoading: submitting,
            onPressed: submitting
                ? null
                : () {
                    unawaited(_buy(context, ref));
                  },
          ),
        ],
      ),
    );
  }
}

class _GuestPrompt extends StatelessWidget {
  const _GuestPrompt();

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.inventory_2_outlined,
      title: context.l10n.billingSignInToBuyPackages,
      subtitle: context.l10n.billingLogInToPurchasePackages,
      action: SizedBox(
        width: 200,
        child: PrimaryButton(
          label: context.l10n.login,
          onPressed: () => context.push(AppRoutes.login),
        ),
      ),
    );
  }
}
