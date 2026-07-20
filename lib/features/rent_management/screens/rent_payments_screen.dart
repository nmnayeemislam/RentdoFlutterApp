import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../controllers/rent_management_controller.dart';

/// Lists rent payments with a per-row "Mark paid" action.
class RentPaymentsScreen extends ConsumerWidget {
  const RentPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rent Payments')),
      body: ref.watch(rentPaymentsProvider).when(
            loading: () => const LoadingWidget(),
            error: (e, _) => AppErrorWidget(
              message: '$e',
              onRetry: () => ref.invalidate(rentPaymentsProvider),
            ),
            data: (payments) {
              if (payments.isEmpty) {
                return const EmptyState(
                  icon: Icons.payments_outlined,
                  title: 'No rent payments yet',
                  subtitle: 'Payments appear here once tenancies are active.',
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: payments.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, i) =>
                    _PaymentCard(payment: payments[i]),
              );
            },
          ),
    );
  }
}

class _PaymentCard extends ConsumerStatefulWidget {
  const _PaymentCard({required this.payment});

  final RentPayment payment;

  @override
  ConsumerState<_PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends ConsumerState<_PaymentCard> {
  bool _busy = false;

  String get _period {
    final start = Formatters.date(widget.payment.periodStart);
    final end = Formatters.date(widget.payment.periodEnd);
    if (start.isEmpty && end.isEmpty) return '';
    return '${start.isEmpty ? '—' : start} – ${end.isEmpty ? '—' : end}';
  }

  Future<void> _markPaid() async {
    setState(() => _busy = true);
    try {
      await ref
          .read(rentManagementServiceProvider)
          .markPaid(widget.payment.id);
      ref.invalidate(rentPaymentsProvider);
      if (mounted) context.showSnack('Marked as paid');
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        context.showSnack(e.message, error: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final payment = widget.payment;
    final period = _period;

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
                  Formatters.money(payment.amount),
                  style: AppTextStyles.titleMd.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatusChip(isPaid: payment.isPaid, status: payment.status),
            ],
          ),
          if (payment.dueDate != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(
                  Icons.event_outlined,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Due ${Formatters.date(payment.dueDate)}',
                  style: AppTextStyles.bodySm,
                ),
              ],
            ),
          ],
          if (period.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(
                  Icons.date_range_rounded,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(period, style: AppTextStyles.bodySm),
                ),
              ],
            ),
          ],
          if (!payment.isPaid) ...[
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 140,
                child: PrimaryButton(
                  label: 'Mark paid',
                  height: 42,
                  isLoading: _busy,
                  onPressed: _markPaid,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.isPaid, required this.status});

  final bool isPaid;
  final String status;

  String get _label => status.isEmpty
      ? status
      : '${status[0].toUpperCase()}${status.substring(1)}';

  @override
  Widget build(BuildContext context) {
    final color = isPaid ? AppColors.success : AppColors.warning;
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
