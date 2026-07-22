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
import '../viewmodels/rent_management_viewmodel.dart';

/// Landlord rent-management hub: a ledger summary card plus navigation into
/// units, tenancies, rent payments and the ledger. Guests see a sign-in prompt.
class RentDashboardScreen extends ConsumerWidget {
  const RentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.watch(authViewModelProvider.select((s) => s.isAuthenticated));

    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.rentManagementTitle)),
      body: !isAuthed
          ? const _GuestPrompt()
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                _SummaryCard(
                  summary: ref.watch(ledgerSummaryProvider),
                ),
                AppSpacing.vGapXl,
                _MenuGroup(
                  items: [
                    (
                      Icons.meeting_room_outlined,
                      l10n.rentUnits,
                      AppRoutes.rentUnits,
                    ),
                    (
                      Icons.people_outline,
                      l10n.rentTenancies,
                      AppRoutes.tenancies,
                    ),
                    (
                      Icons.payments_outlined,
                      l10n.rentPayments,
                      AppRoutes.rentPayments,
                    ),
                    (
                      Icons.receipt_long_outlined,
                      l10n.rentLedger,
                      AppRoutes.ledger,
                    ),
                    (
                      Icons.description_outlined,
                      l10n.rentAgreements,
                      AppRoutes.agreements,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});

  final AsyncValue<LedgerSummary> summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppRadius.brLg,
      ),
      child: summary.when(
        loading: () => const SizedBox(
          height: 64,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ),
        error: (e, _) => Text(
          context.l10n.rentCouldNotLoadSummary,
          style: AppTextStyles.bodyMd.copyWith(color: Colors.white),
        ),
        data: (data) => Row(
          children: [
            _SummaryTile(label: context.l10n.rentIncome, value: data.income),
            const _Divider(),
            _SummaryTile(label: context.l10n.rentExpenses, value: data.expense),
            const _Divider(),
            _SummaryTile(label: context.l10n.rentNet, value: data.net),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white24,
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.label, required this.value});

  final String label;
  final num value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.bodySm.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            Formatters.money(value),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleMd.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.items});

  final List<(IconData, String, String)> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: context.colors.outline),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            ListTile(
              leading: Icon(items[i].$1, color: AppColors.primary),
              title: Text(items[i].$2, style: AppTextStyles.titleSm),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textTertiary,
              ),
              onTap: () => context.push(items[i].$3),
            ),
            if (i != items.length - 1)
              const Divider(height: 1, indent: 56, endIndent: 16),
          ],
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
      icon: Icons.receipt_long_outlined,
      title: context.l10n.rentSignInToManage,
      subtitle: context.l10n.rentLogInToTrack,
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
