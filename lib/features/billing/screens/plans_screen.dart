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
import '../../auth/controllers/auth_controller.dart';
import '../../payments/controllers/payments_controller.dart';
import '../controllers/billing_controller.dart';

/// Lists membership plans, the user's current subscription, and lets them
/// subscribe or cancel. Guests see a sign-in prompt.
class PlansScreen extends ConsumerWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.watch(authControllerProvider.select((s) => s.isAuthenticated));

    return Scaffold(
      appBar: AppBar(title: const Text('Membership')),
      body: !isAuthed
          ? const _GuestPrompt()
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: const [
                _CurrentSubscription(),
                _PlanList(),
              ],
            ),
    );
  }
}

class _CurrentSubscription extends ConsumerWidget {
  const _CurrentSubscription();

  Future<void> _cancel(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(billingActionsProvider.notifier).cancel();
      if (context.mounted) context.showSnack('Subscription cancelled');
    } on ApiException catch (e) {
      if (context.mounted) context.showSnack(e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(mySubscriptionProvider);
    final submitting = ref.watch(billingActionsProvider);

    return subscription.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      data: (sub) {
        if (sub == null) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.xl),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: AppRadius.brLg,
            border: Border.all(color: AppColors.primary),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      sub.planName ?? 'Your plan',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMd,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _StatusChip(status: sub.status),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              _InfoRow(
                icon: Icons.event_available_rounded,
                label: '${sub.autoRenew ? 'Renews' : 'Ends'} '
                    '${Formatters.date(sub.endsAt)}',
              ),
              const SizedBox(height: AppSpacing.xs),
              _InfoRow(
                icon: Icons.article_outlined,
                label:
                    'Posts used ${sub.postsUsed}/${sub.postsLimit ?? '∞'}',
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: submitting
                      ? null
                      : () {
                          unawaited(_cancel(context, ref));
                        },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                  child: const Text('Cancel plan'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PlanList extends ConsumerWidget {
  const _PlanList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(plansProvider);
    final currentPlanName = ref.watch(
      mySubscriptionProvider.select((s) => s.valueOrNull?.planName),
    );

    return plans.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
        child: LoadingWidget(),
      ),
      error: (e, _) => AppErrorWidget(
        message: '$e',
        onRetry: () => ref.invalidate(plansProvider),
      ),
      data: (items) {
        if (items.isEmpty) {
          return const EmptyState(
            icon: Icons.workspace_premium_outlined,
            title: 'No plans available',
            subtitle: 'Check back later for membership options.',
          );
        }
        return Column(
          children: [
            for (final plan in items) ...[
              _PlanCard(
                plan: plan,
                isCurrent: currentPlanName != null &&
                    currentPlanName == plan.name,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        );
      },
    );
  }
}

class _PlanCard extends ConsumerWidget {
  const _PlanCard({required this.plan, required this.isCurrent});
  final PlanModel plan;
  final bool isCurrent;

  String get _priceLine => plan.isFree
      ? 'Free'
      : '${Formatters.money(plan.price, currency: plan.currency)} '
          '/ ${plan.durationDays} days';

  String _capitalize(String value) => value.isEmpty
      ? value
      : '${value[0].toUpperCase()}${value.substring(1)}';

  /// Optional coupon step for paid plans: collects a code, validates it against
  /// `POST /coupons/apply`, and returns the code to send with the subscription.
  /// Returns `('')` to continue without a coupon, or `null` to abort.
  Future<String?> _promptCoupon(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    try {
      final code = await showDialog<String>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Have a coupon?'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(hintText: 'Coupon code (optional)'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, ''),
              child: const Text('Skip'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, controller.text.trim()),
              child: const Text('Apply'),
            ),
          ],
        ),
      );
      if (code == null || code.isEmpty) return code;

      final result = await ref.read(paymentServiceProvider).applyCoupon(
            code: code,
            amount: plan.price,
          );
      if (!context.mounted) return null;
      if (!result.valid) {
        context.showSnack(result.message ?? 'Invalid coupon', error: true);
        return null;
      }
      context.showSnack(result.discount != null
          ? 'Coupon applied — you save ${Formatters.money(result.discount, currency: plan.currency)}'
          : 'Coupon applied');
      return code;
    } on ApiException catch (e) {
      if (context.mounted) context.showSnack(e.message, error: true);
      return null;
    } finally {
      controller.dispose();
    }
  }

  Future<void> _subscribe(BuildContext context, WidgetRef ref) async {
    String? coupon = '';
    if (!plan.isFree) {
      coupon = await _promptCoupon(context, ref);
      if (coupon == null || !context.mounted) return; // aborted / invalid
    }
    try {
      await ref
          .read(billingActionsProvider.notifier)
          .subscribe(plan.id, couponCode: coupon);
      if (context.mounted) context.showSnack('Subscribed to ${plan.name}');
    } on ApiException catch (e) {
      if (context.mounted) context.showSnack(e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submitting = ref.watch(billingActionsProvider);
    final featured = plan.isFeatured;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.brLg,
        border: Border.all(
          color: featured ? AppColors.primary : context.colors.outline,
          width: featured ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  plan.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headingMd,
                ),
              ),
              if (featured) ...[
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: AppRadius.brPill,
                  ),
                  child: Text(
                    'Popular',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _priceLine,
            style: AppTextStyles.price,
          ),
          if (plan.postLimitLabel != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${plan.postLimitLabel} listings',
              style: AppTextStyles.bodySm,
            ),
          ],
          if (plan.enabledFeatures.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            for (final feature in plan.enabledFeatures)
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
                      child: Text(
                        _capitalize(feature),
                        style: AppTextStyles.bodyMd,
                      ),
                    ),
                  ],
                ),
              ),
          ],
          const SizedBox(height: AppSpacing.md),
          if (isCurrent)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: null,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.brMd,
                  ),
                ),
                child: const Text(
                  'Current plan',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          else
            PrimaryButton(
              label: plan.isFree ? 'Choose Free' : 'Subscribe',
              isLoading: submitting,
              onPressed: submitting
                  ? null
                  : () {
                      unawaited(_subscribe(context, ref));
                    },
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: 6),
        Expanded(child: Text(label, style: AppTextStyles.bodySm)),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  Color get _color {
    switch (status) {
      case 'active':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'expired':
      case 'cancelled':
      default:
        return AppColors.textTertiary;
    }
  }

  String get _label => status.isEmpty
      ? status
      : '${status[0].toUpperCase()}${status.substring(1)}';

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.brPill,
      ),
      child: Text(
        _label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _GuestPrompt extends StatelessWidget {
  const _GuestPrompt();

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.workspace_premium_outlined,
      title: 'Sign in to view memberships',
      subtitle: 'Log in to subscribe to a membership plan.',
      action: SizedBox(
        width: 200,
        child: PrimaryButton(
          label: 'Log in',
          onPressed: () => context.push(AppRoutes.login),
        ),
      ),
    );
  }
}
