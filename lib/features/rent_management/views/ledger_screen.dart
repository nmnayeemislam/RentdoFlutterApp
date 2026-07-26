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
import '../../../shared/widgets/state_views.dart';
import '../viewmodels/rent_management_viewmodel.dart';

/// Income/expense ledger with a summary card and an add-entry sheet.
class LedgerScreen extends ConsumerWidget {
  const LedgerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.rentLedger),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: context.l10n.rentAddEntry,
            onPressed: () => _AddEntrySheet.show(context),
          ),
        ],
      ),
      body: ref.watch(ledgerProvider).when(
            loading: () => const SizedBox.shrink(),
            error: (e, _) => AppErrorWidget(
              message: '$e',
              onRetry: () => ref.invalidate(ledgerProvider),
            ),
            data: (entries) {
              return ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  _SummaryCard(summary: ref.watch(ledgerSummaryProvider)),
                  AppSpacing.vGapLg,
                  if (entries.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xxl),
                      child: EmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: context.l10n.rentNoLedgerEntriesYet,
                        subtitle: context.l10n.rentLedgerEmptyDesc,
                      ),
                    )
                  else
                    for (var i = 0; i < entries.length; i++) ...[
                      _EntryCard(entry: entries[i]),
                      if (i != entries.length - 1)
                        const SizedBox(height: AppSpacing.md),
                    ],
                ],
              );
            },
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
            const _VDivider(),
            _SummaryTile(label: context.l10n.rentExpenses, value: data.expense),
            const _VDivider(),
            _SummaryTile(label: context.l10n.rentNet, value: data.net),
          ],
        ),
      ),
    );
  }
}

class _VDivider extends StatelessWidget {
  const _VDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: Colors.white24);
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

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry});

  final LedgerEntry entry;

  @override
  Widget build(BuildContext context) {
    final title =
        (entry.category != null && entry.category!.isNotEmpty)
            ? entry.category!
            : (entry.isIncome
                ? context.l10n.rentIncomeLabel
                : context.l10n.rentExpenseLabel);
    final color = entry.isIncome ? AppColors.success : AppColors.error;
    final sign = entry.isIncome ? '+' : '-';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: context.colors.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleSm,
                ),
                if (entry.description != null &&
                    entry.description!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    entry.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySm,
                  ),
                ],
                if (entry.occurredOn != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    Formatters.date(entry.occurredOn),
                    style: AppTextStyles.caption,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '$sign${Formatters.money(entry.amount)}',
            style: AppTextStyles.titleSm.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _AddEntrySheet extends ConsumerStatefulWidget {
  const _AddEntrySheet();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _AddEntrySheet(),
    );
  }

  @override
  ConsumerState<_AddEntrySheet> createState() => _AddEntrySheetState();
}

class _AddEntrySheetState extends ConsumerState<_AddEntrySheet> {
  final _category = TextEditingController();
  final _amount = TextEditingController();
  final _description = TextEditingController();
  final _listingId = TextEditingController();
  String _type = 'income';
  DateTime _date = DateTime.now();
  bool _submitting = false;

  @override
  void dispose() {
    _category.dispose();
    _amount.dispose();
    _description.dispose();
    _listingId.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit() async {
    final category = _category.text.trim();
    final amount = num.tryParse(_amount.text.trim());
    if (category.isEmpty) {
      context.showSnack(context.l10n.rentEnterCategory, error: true);
      return;
    }
    if (amount == null) {
      context.showSnack(context.l10n.rentEnterAmount, error: true);
      return;
    }
    final description = _description.text.trim();
    final listingId = int.tryParse(_listingId.text.trim());
    setState(() => _submitting = true);
    try {
      await ref.read(rentManagementServiceProvider).addLedgerEntry(
            type: _type,
            category: category,
            amount: amount,
            occurredOn: _date,
            propertyListingId:
                (listingId != null && listingId > 0) ? listingId : null,
            description: description.isEmpty ? null : description,
          );
      ref.invalidate(ledgerProvider);
      ref.invalidate(ledgerSummaryProvider);
      if (!mounted) return;
      Navigator.pop(context);
      context.showSnack(context.l10n.rentEntryAdded);
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(context.l10n.rentAddLedgerEntry, style: AppTextStyles.headingMd),
            AppSpacing.vGapLg,
            Text(context.l10n.type, style: AppTextStyles.label),
            AppSpacing.vGapSm,
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                    value: 'income', label: Text(context.l10n.rentIncomeLabel)),
                ButtonSegment(
                    value: 'expense', label: Text(context.l10n.rentExpenseLabel)),
              ],
              selected: {_type},
              onSelectionChanged: (s) => setState(() => _type = s.first),
            ),
            AppSpacing.vGapMd,
            AppTextField(
              label: context.l10n.rentCategory,
              hint: context.l10n.rentCategoryHint,
              controller: _category,
            ),
            AppSpacing.vGapMd,
            AppTextField(
              label: context.l10n.amount,
              hint: context.l10n.amount,
              controller: _amount,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            AppSpacing.vGapMd,
            Text(context.l10n.date, style: AppTextStyles.label),
            AppSpacing.vGapSm,
            _DateTile(label: Formatters.date(_date), onTap: _pickDate),
            AppSpacing.vGapMd,
            AppTextField(
              label: context.l10n.description,
              hint: context.l10n.optional,
              controller: _description,
              maxLines: 2,
            ),
            AppSpacing.vGapMd,
            AppTextField(
              label: context.l10n.maintenanceListingId,
              hint: context.l10n.rentListingIdOptionalHint,
              controller: _listingId,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            AppSpacing.vGapXl,
            PrimaryButton(
              label: context.l10n.rentAddEntry,
              isLoading: _submitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({required this.label, required this.onTap});

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
          border: Border.all(color: context.colors.outline),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMd,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
