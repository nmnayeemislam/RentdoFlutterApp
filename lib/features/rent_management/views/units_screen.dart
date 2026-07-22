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

/// Lists rental units with an add-unit sheet and per-row delete.
class UnitsScreen extends ConsumerWidget {
  const UnitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Units'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add unit',
            onPressed: () => _AddUnitSheet.show(context),
          ),
        ],
      ),
      body: ref.watch(rentUnitsProvider).when(
            loading: () => const LoadingWidget(),
            error: (e, _) => AppErrorWidget(
              message: '$e',
              onRetry: () => ref.invalidate(rentUnitsProvider),
            ),
            data: (units) {
              if (units.isEmpty) {
                return const EmptyState(
                  icon: Icons.meeting_room_outlined,
                  title: 'No units yet',
                  subtitle: 'Add a unit to start tracking rent.',
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: units.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, i) => _UnitCard(unit: units[i]),
              );
            },
          ),
    );
  }
}

class _UnitCard extends ConsumerWidget {
  const _UnitCard({required this.unit});

  final RentUnit unit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        unit.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleMd,
                      ),
                    ),
                    if (unit.status != null && unit.status!.isNotEmpty) ...[
                      const SizedBox(width: AppSpacing.sm),
                      _StatusChip(status: unit.status!),
                    ],
                  ],
                ),
                if (unit.floor != null && unit.floor!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      const Icon(
                        Icons.stairs_outlined,
                        size: 16,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 6),
                      Text('Floor ${unit.floor}', style: AppTextStyles.bodySm),
                    ],
                  ),
                ],
                if (unit.rentAmount != null) ...[
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
                        '${Formatters.money(unit.rentAmount)}/mo',
                        style: AppTextStyles.titleSm.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            tooltip: 'Delete unit',
            onPressed: () async {
              try {
                await ref
                    .read(rentManagementServiceProvider)
                    .deleteUnit(unit.id);
                ref.invalidate(rentUnitsProvider);
                if (context.mounted) context.showSnack('Unit deleted');
              } on ApiException catch (e) {
                if (context.mounted) {
                  context.showSnack(e.message, error: true);
                }
              }
            },
          ),
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
        color: AppColors.info.withValues(alpha: 0.12),
        borderRadius: AppRadius.brPill,
      ),
      child: Text(
        _label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.info,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AddUnitSheet extends ConsumerStatefulWidget {
  const _AddUnitSheet();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _AddUnitSheet(),
    );
  }

  @override
  ConsumerState<_AddUnitSheet> createState() => _AddUnitSheetState();
}

class _AddUnitSheetState extends ConsumerState<_AddUnitSheet> {
  final _listingId = TextEditingController();
  final _name = TextEditingController();
  final _floor = TextEditingController();
  final _rent = TextEditingController();
  final _notes = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _listingId.dispose();
    _name.dispose();
    _floor.dispose();
    _rent.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final listingId = int.tryParse(_listingId.text.trim());
    final name = _name.text.trim();
    if (listingId == null || listingId <= 0) {
      context.showSnack('Enter a valid listing ID', error: true);
      return;
    }
    if (name.isEmpty) {
      context.showSnack('Enter a unit name', error: true);
      return;
    }
    final floor = _floor.text.trim();
    final notes = _notes.text.trim();
    setState(() => _submitting = true);
    try {
      await ref.read(rentManagementServiceProvider).createUnit(
            propertyListingId: listingId,
            name: name,
            floor: floor.isEmpty ? null : floor,
            rentAmount: num.tryParse(_rent.text.trim()),
            notes: notes.isEmpty ? null : notes,
          );
      ref.invalidate(rentUnitsProvider);
      if (!mounted) return;
      Navigator.pop(context);
      context.showSnack('Unit added');
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
            const Text('Add unit', style: AppTextStyles.headingMd),
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
              label: 'Name',
              hint: 'e.g. Apartment 2B',
              controller: _name,
            ),
            AppSpacing.vGapMd,
            AppTextField(
              label: 'Floor',
              hint: 'e.g. 2',
              controller: _floor,
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
              label: 'Notes',
              hint: 'Optional notes',
              controller: _notes,
              maxLines: 3,
            ),
            AppSpacing.vGapXl,
            PrimaryButton(
              label: 'Add unit',
              isLoading: _submitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
