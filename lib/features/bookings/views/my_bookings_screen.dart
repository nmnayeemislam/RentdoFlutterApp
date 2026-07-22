import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/bookings_viewmodel.dart';

/// Lists the user's hotel/short-stay bookings, or a sign-in prompt for guests.
class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.watch(authViewModelProvider.select((s) => s.isAuthenticated));

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: !isAuthed
          ? const _GuestPrompt()
          : ref.watch(bookingsViewModelProvider).when(
                loading: () => const LoadingWidget(),
                error: (e, _) => AppErrorWidget(
                  message: '$e',
                  onRetry: () =>
                      ref.read(bookingsViewModelProvider.notifier).refresh(),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return EmptyState(
                      icon: Icons.hotel_outlined,
                      title: 'No bookings yet',
                      subtitle: 'Book a stay from a hotel listing.',
                      action: SizedBox(
                        width: 200,
                        child: PrimaryButton(
                          label: 'Browse properties',
                          onPressed: () => context.go(AppRoutes.properties),
                        ),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () =>
                        ref.read(bookingsViewModelProvider.notifier).refresh(),
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
  final BookingModel booking;

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String _day(DateTime dt) => '${dt.day} ${_months[(dt.month - 1) % 12]}';

  /// e.g. "12 Aug → 15 Aug · 3 nights".
  String get _dateRange {
    final nightsLabel = booking.nights == 1 ? 'night' : 'nights';
    return '${_day(booking.checkIn)} → ${_day(booking.checkOut)}'
        ' · ${booking.nights} $nightsLabel';
  }

  String? get _amount {
    if (booking.amount == null) return null;
    final value = booking.amount!;
    final asInt = value == value.roundToDouble() ? value.toInt() : value;
    final currency = booking.currency;
    return currency == null ? '$asInt' : '$asInt $currency';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = (booking.listingTitle != null &&
            booking.listingTitle!.isNotEmpty)
        ? booking.listingTitle!
        : 'Booking #${booking.id}';
    final canCancel =
        booking.status == 'pending' || booking.status == 'confirmed';
    final amount = _amount;

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
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(
                Icons.date_range_rounded,
                size: 16,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(_dateRange, style: AppTextStyles.bodySm),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const Icon(
                Icons.people_outline_rounded,
                size: 16,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 6),
              Text(
                booking.guests == 1 ? '1 guest' : '${booking.guests} guests',
                style: AppTextStyles.bodySm,
              ),
            ],
          ),
          if (amount != null) ...[
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
                  amount,
                  style: AppTextStyles.titleSm.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
          if (canCancel) ...[
            const SizedBox(height: AppSpacing.xs),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => unawaited(
                  ref
                      .read(bookingsViewModelProvider.notifier)
                      .cancel(booking.id),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                ),
                child: const Text('Cancel'),
              ),
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
    switch (status) {
      case 'confirmed':
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
      icon: Icons.hotel_outlined,
      title: 'Sign in to see your bookings',
      subtitle: 'Log in to book stays and manage reservations.',
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
