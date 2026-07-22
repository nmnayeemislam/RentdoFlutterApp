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
import '../viewmodels/technician_viewmodel.dart';

/// Bottom sheet to request a technician. Pops `true` on success.
class BookTechnicianSheet extends ConsumerStatefulWidget {
  const BookTechnicianSheet({super.key, required this.technicianId});

  final int technicianId;

  static Future<bool?> show(BuildContext context, int technicianId) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BookTechnicianSheet(technicianId: technicianId),
    );
  }

  @override
  ConsumerState<BookTechnicianSheet> createState() =>
      _BookTechnicianSheetState();
}

class _BookTechnicianSheetState extends ConsumerState<BookTechnicianSheet> {
  final _description = TextEditingController();
  final _address = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;
  bool _urgent = false;
  bool _submitting = false;

  @override
  void dispose() {
    _description.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _date ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 10, minute: 0),
    );
    if (time == null) return;
    setState(() {
      _date = date;
      _time = time;
    });
  }

  Future<void> _submit() async {
    final description = _description.text.trim();
    final address = _address.text.trim();
    if (description.isEmpty || address.isEmpty) {
      context.showSnack(context.l10n.technicianDescribeJobAddress, error: true);
      return;
    }
    if (_date == null || _time == null) {
      context.showSnack(context.l10n.technicianPickDateAndTime, error: true);
      return;
    }
    final when = DateTime(
        _date!.year, _date!.month, _date!.day, _time!.hour, _time!.minute);
    if (!when.isAfter(DateTime.now())) {
      context.showSnack(context.l10n.technicianChooseFutureTime, error: true);
      return;
    }
    setState(() => _submitting = true);
    try {
      await ref.read(technicianServiceProvider).book(
            technicianId: widget.technicianId,
            description: description,
            scheduledAt: when,
            address: address,
            isUrgent: _urgent,
          );
      if (!mounted) return;
      ref.invalidate(technicianBookingsViewModelProvider);
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      context.showSnack(e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dtLabel = _date == null || _time == null
        ? context.l10n.technicianSelectDateTime
        : '${_date!.day}/${_date!.month}/${_date!.year}  ·  ${_time!.format(context)}';

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(context.l10n.technicianRequestTitle, style: AppTextStyles.headingMd),
            AppSpacing.vGapLg,
            AppTextField(
              label: context.l10n.technicianWhatNeedDone,
              hint: context.l10n.technicianDescribeJobHint,
              controller: _description,
              maxLines: 3,
            ),
            AppSpacing.vGapLg,
            AppTextField(
              label: context.l10n.technicianServiceAddress,
              hint: context.l10n.technicianWhereComeHint,
              controller: _address,
              maxLines: 2,
            ),
            AppSpacing.vGapLg,
            InkWell(
              borderRadius: AppRadius.brMd,
              onTap: _pickDateTime,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: AppRadius.brMd,
                  border:
                      Border.all(color: Theme.of(context).colorScheme.outline),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event_rounded,
                        size: 18, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(dtLabel, style: AppTextStyles.bodyMd)),
                  ],
                ),
              ),
            ),
            AppSpacing.vGapSm,
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: _urgent,
              activeThumbColor: AppColors.primary,
              title: Text(context.l10n.technicianMarkUrgent,
                  style: AppTextStyles.titleSm),
              onChanged: (v) => setState(() => _urgent = v),
            ),
            AppSpacing.vGapMd,
            PrimaryButton(
              label: context.l10n.technicianSendRequest,
              isLoading: _submitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
