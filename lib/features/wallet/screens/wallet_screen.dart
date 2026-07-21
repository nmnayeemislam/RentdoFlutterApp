import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/wallet_controller.dart';

/// Shows the user's wallet balance and transaction history, or a sign-in
/// prompt for guests.
class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.watch(authControllerProvider.select((s) => s.isAuthenticated));

    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: !isAuthed
          ? const _GuestPrompt()
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: const [
                _BalanceCard(),
                SizedBox(height: AppSpacing.xl),
                Text('Transactions', style: AppTextStyles.headingMd),
                SizedBox(height: AppSpacing.md),
                _TransactionList(),
              ],
            ),
    );
  }
}

class _BalanceCard extends ConsumerWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(walletBalanceProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: AppRadius.brXl,
        boxShadow: AppShadows.raised,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'RENTDO WALLET',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Icon(Icons.account_balance_wallet_rounded,
                  color: Colors.white.withValues(alpha: 0.85), size: 22),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Available balance',
            style: AppTextStyles.bodySm
                .copyWith(color: Colors.white.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: AppSpacing.xs),
          balance.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            ),
            error: (e, _) => Text(
              'Unable to load balance',
              style: AppTextStyles.titleMd.copyWith(color: Colors.white),
            ),
            data: (b) => Text(
              Formatters.money(b.balance, currency: b.currency),
              style: AppTextStyles.displayLarge.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () =>
                  context.showSnack('Card top-up is coming soon'),
              icon: const Icon(Icons.add_rounded, size: 20),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(48),
              ),
              label: const Text('Top up'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionList extends ConsumerWidget {
  const _TransactionList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(walletBalanceProvider);
    final currency = balance.valueOrNull?.currency;
    final transactions = ref.watch(walletTransactionsProvider);

    return transactions.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: LoadingWidget(),
      ),
      error: (e, _) => AppErrorWidget(
        message: '$e',
        onRetry: () => ref.invalidate(walletTransactionsProvider),
      ),
      data: (items) {
        if (items.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text('No transactions yet', style: AppTextStyles.bodySm),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, i) =>
              _TransactionTile(txn: items[i], currency: currency),
        );
      },
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.txn, this.currency});
  final WalletTransaction txn;
  final String? currency;

  @override
  Widget build(BuildContext context) {
    final isCredit = txn.isCredit;
    final color = isCredit ? AppColors.success : AppColors.error;
    final amount =
        '${isCredit ? '+' : '-'}${Formatters.money(txn.amount, currency: currency)}';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: context.colors.outline),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCredit ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn.description ?? txn.type,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleSm,
                ),
                const SizedBox(height: 2),
                Text(
                  Formatters.relative(txn.createdAt),
                  style: AppTextStyles.bodySm,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            amount,
            style: AppTextStyles.titleSm.copyWith(color: color),
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
      icon: Icons.account_balance_wallet_outlined,
      title: 'Sign in to view your wallet',
      subtitle: 'Log in to see your balance and transactions.',
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
