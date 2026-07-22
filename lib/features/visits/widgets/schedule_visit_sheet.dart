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
import '../viewmodels/visits_viewmodel.dart';

/// Bottom sheet to schedule a property visit. Pops `true` on success.
class ScheduleVisitSheet extends ConsumerStatefulWidget {
  const ScheduleVisitSheet({super.key, required this.listingId});

  final int listingId;

  static Future<bool?> show(BuildContext context, int listingId) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ScheduleVisitSheet(listingId: listingId),
    );
  }

  @override
  ConsumerState<ScheduleVisitSheet> createState() => _ScheduleVisitSheetState();
}

class _ScheduleVisitSheetState extends ConsumerState<ScheduleVisitSheet> {
  final _note = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;
  bool _submitting = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _submit() async {
    if (_date == null || _time == null) {
      context.showSnack(context.l10n.technicianPickDateAndTime, error: true);
      return;
    }
    final when = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _time!.hour,
      _time!.minute,
    );
    if (!when.isAfter(DateTime.now())) {
      context.showSnack(context.l10n.technicianChooseFutureTime, error: true);
      return;
    }
    setState(() => _submitting = true);
    try {
      await ref
          .read(visitsViewModelProvider.notifier)
          .schedule(widget.listingId, when, note: _note.text.trim());
      if (!mounted) return;
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      context.showSnack(e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = _date == null
        ? context.l10n.selectDate
        : '${_date!.day}/${_date!.month}/${_date!.year}';
    final timeLabel =
        _time == null ? context.l10n.selectTime : _time!.format(context);

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
          Text(context.l10n.visitScheduleTitle, style: AppTextStyles.headingMd),
          AppSpacing.vGapLg,
          Row(
            children: [
              Expanded(
                child: _PickerTile(
                  icon: Icons.calendar_today_rounded,
                  label: dateLabel,
                  onTap: _pickDate,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PickerTile(
                  icon: Icons.schedule_rounded,
                  label: timeLabel,
                  onTap: _pickTime,
                ),
              ),
            ],
          ),
          AppSpacing.vGapLg,
          AppTextField(
            label: context.l10n.visitNoteOptional,
            hint: context.l10n.visitNoteHint,
            controller: _note,
            maxLines: 3,
          ),
          AppSpacing.vGapXl,
          PrimaryButton(
            label: context.l10n.visitRequestVisit,
            isLoading: _submitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.brMd,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: AppRadius.brMd,
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMd),
            ),
          ],
        ),
      ),
    );
  }
}
