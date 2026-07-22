import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../viewmodels/community_viewmodel.dart';

/// Bottom sheet to report a listing. Pops `true` on success.
class ReportSheet extends ConsumerStatefulWidget {
  const ReportSheet({super.key, required this.listingId});

  final int listingId;

  static Future<bool?> show(BuildContext context, int listingId) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ReportSheet(listingId: listingId),
    );
  }

  @override
  ConsumerState<ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends ConsumerState<ReportSheet> {
  final _details = TextEditingController();
  ReportReason _reason = ReportReason.spam;
  bool _submitting = false;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      await ref.read(communityServiceProvider).reportListing(
            widget.listingId,
            _reason,
            details: _details.text.trim(),
          );
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
          Text(context.l10n.propertyReportListing, style: AppTextStyles.headingMd),
          AppSpacing.vGapLg,
          DropdownButtonFormField<ReportReason>(
            initialValue: _reason,
            decoration: InputDecoration(labelText: context.l10n.reason),
            items: [
              for (final r in ReportReason.values)
                DropdownMenuItem(value: r, child: Text(r.label)),
            ],
            onChanged: (v) => setState(() => _reason = v ?? _reason),
          ),
          AppSpacing.vGapLg,
          AppTextField(
            label: context.l10n.reportDetailsOptional,
            hint: context.l10n.reportDetailsHint,
            controller: _details,
            maxLines: 3,
          ),
          AppSpacing.vGapXl,
          PrimaryButton(
            label: context.l10n.reportSubmitReport,
            isLoading: _submitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
