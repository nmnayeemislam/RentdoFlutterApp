import 'dart:async';

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
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/technician_viewmodel.dart';
import '../widgets/submit_quote_sheet.dart';

/// The user's technician-service bookings, or a sign-in prompt for guests.
class MyServiceBookingsScreen extends ConsumerWidget {
  const MyServiceBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.watch(authViewModelProvider.select((s) => s.isAuthenticated));

    return Scaffold(
      appBar: AppBar(title: const Text('Service Bookings')),
      body: !isAuthed
          ? const _GuestPrompt()
          : ref.watch(technicianBookingsViewModelProvider).when(
                loading: () => const LoadingWidget(),
                error: (e, _) => AppErrorWidget(
                  message: '$e',
                  onRetry: () => ref
                      .read(technicianBookingsViewModelProvider.notifier)
                      .refresh(),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return const EmptyState(
                      icon: Icons.build_outlined,
                      title: 'No service bookings',
                      subtitle: 'Book a technician to see requests here.',
                    );
                  }
                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () => ref
                        .read(technicianBookingsViewModelProvider.notifier)
                        .refresh(),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: items.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, i) =>
                          _BookingCard(booking: items[i]),
                    ),
                  );
                },
              ),
    );
  }
}

class _BookingCard extends ConsumerWidget {
  const _BookingCard({required this.booking});

  final TechnicianBooking booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = booking.technicianName ?? 'Technician';
    final scheduled = booking.scheduledAt;

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
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMd,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatusChip(status: booking.status),
            ],
          ),
          if (booking.isUrgent) ...[
            const SizedBox(height: AppSpacing.sm),
            const AppBadge(
              label: 'Urgent',
              color: Colors.white,
              background: AppColors.error,
              icon: Icons.priority_high_rounded,
            ),
          ],
          if (booking.description != null &&
              booking.description!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(booking.description!, style: AppTextStyles.bodyMd),
          ],
          if (scheduled != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(
                  Icons.event_outlined,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${Formatters.date(scheduled)}'
                    ' · ${Formatters.relative(scheduled)}',
                    style: AppTextStyles.bodySm,
                  ),
                ),
              ],
            ),
          ],
          if (booking.agreedAmount != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(
                  Icons.payments_outlined,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 6),
                Text(
                  Formatters.money(
                    booking.agreedAmount,
                    currency: booking.currency,
                  ),
                  style: AppTextStyles.titleSm.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
          if (booking.quotes.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            const Text('Quotes', style: AppTextStyles.titleSm),
            const SizedBox(height: AppSpacing.sm),
            for (final quote in booking.quotes)
              _QuoteTile(bookingId: booking.id, quote: quote),
          ],
          // Technician-side action: offer a quote on an open job.
          if (booking.quotes.isEmpty && booking.status == 'pending') ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () =>
                    unawaited(SubmitQuoteSheet.show(context, booking.id)),
                icon: const Icon(Icons.request_quote_outlined, size: 18),
                label: const Text('Submit a quote'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuoteTile extends ConsumerWidget {
  const _QuoteTile({required this.bookingId, required this.quote});

  final int bookingId;
  final QuoteModel quote;

  bool get _isPending {
    final status = quote.status?.toLowerCase();
    return status != 'accepted' && status != 'rejected';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppRadius.brMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                Formatters.money(quote.amount, currency: quote.currency),
                style: AppTextStyles.titleSm.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
              const Spacer(),
              if (quote.status != null && quote.status!.isNotEmpty)
                Text(
                  quote.status!,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          if (quote.description != null && quote.description!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(quote.description!, style: AppTextStyles.bodySm),
          ],
          if (_isPending) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: 'Reject',
                    onPressed: () => unawaited(
                      ref
                          .read(technicianBookingsViewModelProvider.notifier)
                          .rejectQuote(bookingId),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: PrimaryButton(
                    label: 'Accept',
                    onPressed: () => unawaited(
                      ref
                          .read(technicianBookingsViewModelProvider.notifier)
                          .acceptQuote(bookingId),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  Color get _color {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'accepted':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'completed':
        return AppColors.info;
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
      icon: Icons.build_outlined,
      title: 'Sign in to see your service bookings',
      subtitle: 'Log in to book technicians and track requests.',
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
