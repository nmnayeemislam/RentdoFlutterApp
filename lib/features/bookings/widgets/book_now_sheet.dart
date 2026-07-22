import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../properties/viewmodels/property_providers.dart';
import '../viewmodels/bookings_viewmodel.dart';

/// Bottom sheet to book a hotel/short-stay listing. Pops `true` on success.
class BookNowSheet extends ConsumerStatefulWidget {
  const BookNowSheet({super.key, required this.listingId});

  final int listingId;

  static Future<bool?> show(BuildContext context, int listingId) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BookNowSheet(listingId: listingId),
    );
  }

  @override
  ConsumerState<BookNowSheet> createState() => _BookNowSheetState();
}

class _BookNowSheetState extends ConsumerState<BookNowSheet> {
  final _requests = TextEditingController();
  DateTimeRange? _range;
  int _guests = 1;
  bool _submitting = false;

  @override
  void dispose() {
    _requests.dispose();
    super.dispose();
  }

  int get _nights =>
      _range == null ? 0 : _range!.end.difference(_range!.start).inDays;

  Future<void> _pickDates() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      initialDateRange: _range,
    );
    if (picked != null) setState(() => _range = picked);
  }

  Future<void> _submit() async {
    if (_range == null || _nights < 1) {
      context.showSnack('Select your check-in and check-out dates', error: true);
      return;
    }
    // Validate against the live availability calendar before hitting the API.
    final days =
        ref.read(listingAvailabilityProvider(widget.listingId)).valueOrNull;
    if (days != null && rangeHasBlockedNight(days, _range!.start, _range!.end)) {
      context.showSnack('Some of those nights are unavailable', error: true);
      return;
    }
    setState(() => _submitting = true);
    try {
      await ref.read(bookingServiceProvider).create(
            listingId: widget.listingId,
            checkIn: _range!.start,
            checkOut: _range!.end,
            guests: _guests,
            specialRequests: _requests.text.trim(),
          );
      if (!mounted) return;
      ref.invalidate(bookingsViewModelProvider);
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      context.showSnack(e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = _range == null
        ? 'Select dates'
        : '${_range!.start.day}/${_range!.start.month} → '
            '${_range!.end.day}/${_range!.end.month}  ·  $_nights night${_nights == 1 ? '' : 's'}';

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Book your stay', style: AppTextStyles.headingMd),
          ref.watch(listingAvailabilityProvider(widget.listingId)).maybeWhen(
                data: (days) {
                  final blocked = days.where((d) => !d.isAvailable).length;
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      blocked == 0
                          ? 'All dates available in the next 60 days'
                          : '$blocked date(s) unavailable — they are blocked',
                      style: AppTextStyles.caption,
                    ),
                  );
                },
                orElse: () => const SizedBox.shrink(),
              ),
          AppSpacing.vGapLg,
          InkWell(
            borderRadius: AppRadius.brMd,
            onTap: _pickDates,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: AppRadius.brMd,
                border: Border.all(color: Theme.of(context).colorScheme.outline),
              ),
              child: Row(
                children: [
                  const Icon(Icons.date_range_rounded,
                      size: 18, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(dateLabel, style: AppTextStyles.bodyMd),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.vGapLg,
          Row(
            children: [
              const Text('Guests', style: AppTextStyles.titleSm),
              const Spacer(),
              _StepperButton(
                icon: Icons.remove_rounded,
                onTap: _guests > 1 ? () => setState(() => _guests--) : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text('$_guests', style: AppTextStyles.titleMd),
              ),
              _StepperButton(
                icon: Icons.add_rounded,
                onTap: _guests < 20 ? () => setState(() => _guests++) : null,
              ),
            ],
          ),
          AppSpacing.vGapLg,
          AppTextField(
            label: 'Special requests (optional)',
            hint: 'Early check-in, extra bed…',
            controller: _requests,
            maxLines: 3,
          ),
          AppSpacing.vGapXl,
          PrimaryButton(
            label: 'Request booking',
            isLoading: _submitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled
                ? AppColors.primary
                : Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Icon(icon,
            size: 18,
            color: enabled ? AppColors.primary : AppColors.textTertiary),
      ),
    );
  }
}
