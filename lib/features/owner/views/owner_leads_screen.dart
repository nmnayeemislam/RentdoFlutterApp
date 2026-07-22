import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import '../viewmodels/owner_viewmodel.dart';

class OwnerLeadsScreen extends ConsumerWidget {
  const OwnerLeadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.watch(authViewModelProvider.select((s) => s.isAuthenticated));

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.ownerLeadsTitle)),
      body: !isAuthed
          ? EmptyState(
              icon: Icons.insights_outlined,
              title: context.l10n.ownerSignInToSeeLeads,
              subtitle: context.l10n.ownerLogInToTrackInterest,
              action: SizedBox(
                width: 200,
                child: PrimaryButton(
                  label: context.l10n.login,
                  onPressed: () => context.push(AppRoutes.login),
                ),
              ),
            )
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                ref.invalidate(ownerLeadsProvider);
                ref.invalidate(ownerLeadsSummaryProvider);
              },
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  const _SummaryCard(),
                  AppSpacing.vGapLg,
                  Text(context.l10n.ownerRecentActivity,
                      style: AppTextStyles.titleMd),
                  AppSpacing.vGapMd,
                  const _LeadsList(),
                ],
              ),
            ),
    );
  }
}

class _SummaryCard extends ConsumerWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(ownerLeadsSummaryProvider);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppRadius.brLg,
      ),
      child: summary.when(
        loading: () => const SizedBox(
          height: 52,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ),
        error: (_, _) => Text(context.l10n.ownerCouldNotLoadStats,
            style: const TextStyle(color: Colors.white)),
        data: (s) => Row(
          children: [
            _Stat(label: context.l10n.ownerViews, value: '${s.totalViews}'),
            Container(width: 1, height: 36, color: Colors.white24),
            _Stat(label: context.l10n.ownerLeads, value: '${s.totalLeads}'),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: AppTextStyles.headingLg.copyWith(color: Colors.white)),
          Text(label,
              style: AppTextStyles.bodySm.copyWith(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _LeadsList extends ConsumerWidget {
  const _LeadsList();

  IconData _icon(String type) => switch (type) {
        'visit' => Icons.event_available_outlined,
        'contact_reveal' => Icons.call_outlined,
        'message' => Icons.chat_bubble_outline_rounded,
        _ => Icons.notifications_none_rounded,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leads = ref.watch(ownerLeadsProvider);
    return leads.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2.4)),
      ),
      error: (e, _) => Text(context.l10n.ownerCouldNotLoadActivity,
          style: AppTextStyles.bodySm),
      data: (items) {
        if (items.isEmpty) {
          return Text(context.l10n.ownerNoActivityYet,
              style: AppTextStyles.bodyMd
                  .copyWith(color: AppColors.textSecondary));
        }
        return Column(
          children: [
            for (final lead in items)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: AppRadius.brMd,
                  border: Border.all(color: context.colors.outline),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primarySurface,
                      child: Icon(_icon(lead.type),
                          size: 18, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${lead.typeLabel} · ${lead.userName ?? context.l10n.ownerSomeoneFallback}',
                              style: AppTextStyles.titleSm),
                          if (lead.listingTitle != null)
                            Text(lead.listingTitle!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodySm),
                        ],
                      ),
                    ),
                    Text(Formatters.relative(lead.occurredAt),
                        style: AppTextStyles.caption),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
