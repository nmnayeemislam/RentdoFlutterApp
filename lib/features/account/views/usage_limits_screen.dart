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
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/account_viewmodel.dart';

/// Posting entitlements and plan feature gates (`GET /me/limits`).
class UsageLimitsScreen extends ConsumerWidget {
  const UsageLimitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthed = ref.watch(
      authViewModelProvider.select((s) => s.isAuthenticated),
    );

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.accountUsageLimitsTitle)),
      body: !isAuthed
          ? const _GuestPrompt()
          : ref.watch(usageLimitsProvider).when(
                loading: () => const SizedBox.shrink(),
                error: (e, _) => AppErrorWidget(
                  message: e is ApiException ? e.message : '$e',
                  onRetry: () => ref.invalidate(usageLimitsProvider),
                ),
                data: (limits) {
                  final gates = limits.featureGates.entries.toList();
                  return ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      _PostsCard(limits: limits),
                      AppSpacing.vGapXl,
                      Text(context.l10n.accountPlanFeatures,
                          style: AppTextStyles.headingMd),
                      AppSpacing.vGapMd,
                      if (gates.isEmpty)
                        Text(
                          context.l10n.accountNoPlanFeatures,
                          style: AppTextStyles.bodyMd,
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: context.colors.surface,
                            borderRadius: AppRadius.brLg,
                            border: Border.all(color: context.colors.outline),
                          ),
                          child: Column(
                            children: [
                              for (final gate in gates)
                                _FeatureRow(
                                  label: _humanize(gate.key),
                                  enabled: gate.value == true,
                                ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
    );
  }

  static String _humanize(String key) {
    final words = key.replaceAll('_', ' ');
    return words.isEmpty
        ? words
        : '${words[0].toUpperCase()}${words.substring(1)}';
  }
}

class _PostsCard extends StatelessWidget {
  const _PostsCard({required this.limits});
  final UsageLimits limits;

  @override
  Widget build(BuildContext context) {
    final limit = limits.postLimit;
    final isUnlimited = limit == null;
    final progress = isUnlimited || limit <= 0
        ? 0.0
        : (limits.postsUsed / limit).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppRadius.brLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.accountPostsUsed,
                  style: AppTextStyles.titleMd.copyWith(color: Colors.white),
                ),
              ),
              Text(
                '${limits.postsUsed} / ${isUnlimited ? '∞' : limit}',
                style: AppTextStyles.headingMd.copyWith(color: Colors.white),
              ),
            ],
          ),
          AppSpacing.vGapMd,
          ClipRRect(
            borderRadius: AppRadius.brPill,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          AppSpacing.vGapSm,
          Text(
            isUnlimited
                ? context.l10n.accountUnlimited
                : '${limits.postsRemaining ?? (limit - limits.postsUsed)} '
                    '${context.l10n.accountRemainingSuffix}',
            style: AppTextStyles.bodySm.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.label, required this.enabled});

  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(
            enabled ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
            size: 20,
            color: enabled ? AppColors.success : AppColors.textTertiary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMd.copyWith(
                color: enabled ? null : AppColors.textSecondary,
              ),
            ),
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
      icon: Icons.speed_rounded,
      title: context.l10n.accountSignInToSeeLimits,
      subtitle: context.l10n.accountLogInToTrackUsage,
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
