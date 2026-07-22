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

/// Lists tenancies with an add-tenancy sheet.
class TenanciesScreen extends ConsumerWidget {
  const TenanciesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tenancies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add tenancy',
            onPressed: () => _AddTenancySheet.show(context),
          ),
        ],
      ),
      body: ref.watch(tenanciesProvider).when(
            loading: () => const LoadingWidget(),
            error: (e, _) => AppErrorWidget(
              message: '$e',
              onRetry: () => ref.invalidate(tenanciesProvider),
            ),
            data: (tenancies) {
              if (tenancies.isEmpty) {
                return const EmptyState(
                  icon: Icons.people_outline,
                  title: 'No tenancies yet',
                  subtitle: 'Add a tenancy to track a tenant and their rent.',
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: tenancies.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, i) =>
                    _TenancyCard(tenancy: tenancies[i]),
              );
            },
          ),
    );
  }
}

class _TenancyCard extends StatelessWidget {
  const _TenancyCard({required this.tenancy});

  final Tenancy tenancy;

  String get _period {
    final start = Formatters.date(tenancy.startDate);
    final end = Formatters.date(tenancy.endDate);
    if (start.isEmpty && end.isEmpty) return '';
    return '${start.isEmpty ? '—' : start} – ${end.isEmpty ? 'ongoing' : end}';
  }

  @override
  Widget build(BuildContext context) {
    final period = _period;
    final name = (tenancy.tenantName != null && tenancy.tenantName!.isNotEmpty)
        ? tenancy.tenantName!
        : 'Tenancy #${tenancy.id}';

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
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMd,
                ),
              ),
              if (tenancy.status != null && tenancy.status!.isNotEmpty) ...[
                const SizedBox(width: AppSpacing.sm),
                _StatusChip(status: tenancy.status!),
              ],
            ],
          ),
          if (tenancy.tenantPhone != null &&
              tenancy.tenantPhone!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(
                  Icons.phone_outlined,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 6),
                Text(tenancy.tenantPhone!, style: AppTextStyles.bodySm),
              ],
            ),
          ],
          if (tenancy.rentAmount != null) ...[
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
                  '${Formatters.money(tenancy.rentAmount)}/mo',
                  style: AppTextStyles.titleSm.copyWith(
                    color: AppColors.primary,
                  ),
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
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  String get _label => status.isEmpty
      ? status
      : '${status[0].toUpperCase()}${status.substring(1)}';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: AppRadius.brPill,
      ),
      child: Text(
        _label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.success,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AddTenancySheet extends ConsumerStatefulWidget {
  const _AddTenancySheet();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _AddTenancySheet(),
    );
  }

  @override
  ConsumerState<_AddTenancySheet> createState() => _AddTenancySheetState();
}

class _AddTenancySheetState extends ConsumerState<_AddTenancySheet> {
  final _listingId = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _rent = TextEditingController();
  final _deposit = TextEditingController();
  final _dueDay = TextEditingController();
  DateTime? _startDate;
  bool _submitting = false;

  @override
  void dispose() {
    _listingId.dispose();
    _name.dispose();
    _phone.dispose();
    _rent.dispose();
    _deposit.dispose();
    _dueDay.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _submit() async {
    final listingId = int.tryParse(_listingId.text.trim());
    final name = _name.text.trim();
    final rent = num.tryParse(_rent.text.trim());
    if (listingId == null || listingId <= 0) {
      context.showSnack('Enter a valid listing ID', error: true);
      return;
    }
    if (name.isEmpty) {
      context.showSnack('Enter a tenant name', error: true);
      return;
    }
    if (rent == null) {
      context.showSnack('Enter a rent amount', error: true);
      return;
    }
    if (_startDate == null) {
      context.showSnack('Pick a start date', error: true);
      return;
    }
    final phone = _phone.text.trim();
    int? dueDay = int.tryParse(_dueDay.text.trim());
    if (dueDay != null && (dueDay < 1 || dueDay > 31)) dueDay = null;
    setState(() => _submitting = true);
    try {
      await ref.read(rentManagementServiceProvider).createTenancy(
            propertyListingId: listingId,
            tenantName: name,
            tenantPhone: phone.isEmpty ? null : phone,
            rentAmount: rent,
            depositAmount: num.tryParse(_deposit.text.trim()),
            dueDayOfMonth: dueDay,
            startDate: _startDate!,
          );
      ref.invalidate(tenanciesProvider);
      if (!mounted) return;
      Navigator.pop(context);
      context.showSnack('Tenancy added');
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      context.showSnack(e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = _startDate == null
        ? 'Select start date'
        : Formatters.date(_startDate);

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
            const Text('Add tenancy', style: AppTextStyles.headingMd),
            AppSpacing.vGapLg,
            AppTextField(
              label: 'Listing ID',
              hint: "Your property's listing ID",
              controller: _listingId,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            AppSpacing.vGapMd,
            AppTextField(
              label: 'Tenant name',
              hint: 'Full name',
              controller: _name,
            ),
            AppSpacing.vGapMd,
            AppTextField(
              label: 'Tenant phone',
              hint: 'Optional',
              controller: _phone,
              keyboardType: TextInputType.phone,
            ),
            AppSpacing.vGapMd,
            AppTextField(
              label: 'Rent amount',
              hint: 'Monthly rent',
              controller: _rent,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            AppSpacing.vGapMd,
            AppTextField(
              label: 'Deposit',
              hint: 'Optional',
              controller: _deposit,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            AppSpacing.vGapMd,
            AppTextField(
              label: 'Due day of month',
              hint: '1–31',
              controller: _dueDay,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            AppSpacing.vGapMd,
            const Text('Start date', style: AppTextStyles.label),
            AppSpacing.vGapSm,
            _DateTile(label: dateLabel, onTap: _pickStartDate),
            AppSpacing.vGapXl,
            PrimaryButton(
              label: 'Add tenancy',
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
