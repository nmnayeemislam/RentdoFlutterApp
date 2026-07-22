import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../viewmodels/technician_viewmodel.dart';

/// Bottom sheet for a technician to quote a booking. Pops `true` on success.
class SubmitQuoteSheet extends ConsumerStatefulWidget {
  const SubmitQuoteSheet({super.key, required this.bookingId});

  final int bookingId;

  static Future<bool?> show(BuildContext context, int bookingId) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SubmitQuoteSheet(bookingId: bookingId),
    );
  }

  @override
  ConsumerState<SubmitQuoteSheet> createState() => _SubmitQuoteSheetState();
}

class _SubmitQuoteSheetState extends ConsumerState<SubmitQuoteSheet> {
  final _amount = TextEditingController();
  final _description = TextEditingController();
  DateTime? _validUntil;
  bool _submitting = false;

  @override
  void dispose() {
    _amount.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickValidUntil() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _validUntil ?? now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() => _validUntil = picked);
  }

  Future<void> _submit() async {
    final amount = num.tryParse(_amount.text.trim());
    if (amount == null || amount <= 0) {
      context.showSnack(context.l10n.quoteEnterValidAmount, error: true);
      return;
    }
    final description = _description.text.trim();
    setState(() => _submitting = true);
    try {
      await ref.read(technicianServiceProvider).submitQuote(
            widget.bookingId,
            amount: amount,
            description: description.isEmpty ? null : description,
            validUntil: _validUntil,
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
    final validLabel = _validUntil == null
        ? context.l10n.quoteValidUntilOptional
        : context.l10n.quoteValidUntil(Formatters.date(_validUntil));

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
            Text(context.l10n.quoteSubmitTitle, style: AppTextStyles.headingMd),
            AppSpacing.vGapLg,
            AppTextField(
              label: context.l10n.amount,
              hint: context.l10n.quoteAmountHint,
              controller: _amount,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            AppSpacing.vGapLg,
            AppTextField(
              label: context.l10n.description,
              hint: context.l10n.quoteDescriptionHint,
              controller: _description,
              maxLines: 3,
            ),
            AppSpacing.vGapLg,
            InkWell(
              borderRadius: AppRadius.brMd,
              onTap: _pickValidUntil,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: AppRadius.brMd,
                  border: Border.all(color: context.colors.outline),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.event_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(validLabel, style: AppTextStyles.bodyMd),
                    ),
                    if (_validUntil != null)
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        tooltip: context.l10n.clearDate,
                        onPressed: () => setState(() => _validUntil = null),
                      ),
                  ],
                ),
              ),
            ),
            AppSpacing.vGapXl,
            PrimaryButton(
              label: context.l10n.quoteSendQuote,
              isLoading: _submitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
