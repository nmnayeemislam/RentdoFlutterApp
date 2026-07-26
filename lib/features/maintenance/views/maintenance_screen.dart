import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/maintenance_viewmodel.dart';

class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.watch(authViewModelProvider.select((s) => s.isAuthenticated));

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.maintenanceTitle),
        actions: [
          if (isAuthed)
            IconButton(
              icon: const Icon(Icons.add_rounded),
              onPressed: () => _MaintenanceSheet.show(context),
            ),
        ],
      ),
      body: !isAuthed
          ? EmptyState(
              icon: Icons.build_outlined,
              title: context.l10n.maintenanceSignInTitle,
              subtitle: context.l10n.maintenanceLogInDesc,
              action: SizedBox(
                width: 200,
                child: PrimaryButton(
                  label: context.l10n.login,
                  onPressed: () => context.push(AppRoutes.login),
                ),
              ),
            )
          : ref.watch(maintenanceViewModelProvider).when(
                loading: () => const SizedBox.shrink(),
                error: (e, _) => AppErrorWidget(
                  message: '$e',
                  onRetry: () =>
                      ref.read(maintenanceViewModelProvider.notifier).refresh(),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return EmptyState(
                      icon: Icons.build_outlined,
                      title: context.l10n.maintenanceNoRequests,
                      subtitle: context.l10n.maintenanceTapPlusDesc,
                    );
                  }
                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () => ref
                        .read(maintenanceViewModelProvider.notifier)
                        .refresh(),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => _RequestCard(request: items[i]),
                    ),
                  );
                },
              ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request});
  final MaintenanceRequest request;

  static const _statusColors = {
    'open': AppColors.warning,
    'in_progress': AppColors.info,
    'resolved': AppColors.success,
    'cancelled': AppColors.textTertiary,
  };

  @override
  Widget build(BuildContext context) {
    final status = request.status ?? 'open';
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
            children: [
              Expanded(
                child: Text(request.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMd),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (_statusColors[status] ?? AppColors.textTertiary)
                      .withValues(alpha: 0.14),
                  borderRadius: AppRadius.brPill,
                ),
                child: Text(status.replaceAll('_', ' ').toUpperCase(),
                    style: AppTextStyles.caption.copyWith(
                      color: _statusColors[status] ?? AppColors.textTertiary,
                      fontWeight: FontWeight.w700,
                    )),
              ),
            ],
          ),
          if (request.listingTitle != null) ...[
            const SizedBox(height: 2),
            Text(request.listingTitle!, style: AppTextStyles.bodySm),
          ],
          if (request.description != null) ...[
            const SizedBox(height: 6),
            Text(request.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMd),
          ],
          const SizedBox(height: 6),
          Row(
            children: [
              if (request.priority != null)
                Text(
                    context.l10n.maintenancePriorityLabel(request.priority!),
                    style: AppTextStyles.caption),
              const Spacer(),
              Text(Formatters.relative(request.createdAt),
                  style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}

class _MaintenanceSheet extends ConsumerStatefulWidget {
  const _MaintenanceSheet();

  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const _MaintenanceSheet(),
      );

  @override
  ConsumerState<_MaintenanceSheet> createState() => _MaintenanceSheetState();
}

class _MaintenanceSheetState extends ConsumerState<_MaintenanceSheet> {
  final _listingId = TextEditingController();
  final _title = TextEditingController();
  final _description = TextEditingController();
  String _priority = 'normal';
  bool _submitting = false;

  @override
  void dispose() {
    _listingId.dispose();
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final listingId = int.tryParse(_listingId.text.trim());
    if (listingId == null || listingId <= 0) {
      context.showSnack(context.l10n.maintenanceEnterValidListingId, error: true);
      return;
    }
    if (_title.text.trim().isEmpty || _description.text.trim().isEmpty) {
      context.showSnack(context.l10n.maintenanceAddTitleDesc, error: true);
      return;
    }
    setState(() => _submitting = true);
    try {
      await ref.read(maintenanceViewModelProvider.notifier).create(
            propertyListingId: listingId,
            title: _title.text.trim(),
            description: _description.text.trim(),
            priority: _priority,
          );
      if (!mounted) return;
      Navigator.pop(context);
      context.showSnack(context.l10n.maintenanceRequestSubmitted);
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
          Text(context.l10n.maintenanceRaiseIssue,
              style: AppTextStyles.headingMd),
          AppSpacing.vGapLg,
          AppTextField(
            label: context.l10n.maintenanceListingId,
            hint: context.l10n.maintenanceListingIdHint,
            controller: _listingId,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          AppSpacing.vGapLg,
          AppTextField(
            label: context.l10n.maintenanceTitleLabel,
            hint: context.l10n.maintenanceTitleHint,
            controller: _title,
          ),
          AppSpacing.vGapLg,
          AppTextField(
            label: context.l10n.description,
            hint: context.l10n.maintenanceDescribeHint,
            controller: _description,
            maxLines: 3,
          ),
          AppSpacing.vGapLg,
          DropdownButtonFormField<String>(
            initialValue: _priority,
            decoration: InputDecoration(labelText: context.l10n.priority),
            items: [
              DropdownMenuItem(
                  value: 'low', child: Text(context.l10n.maintenancePriorityLow)),
              DropdownMenuItem(
                  value: 'normal',
                  child: Text(context.l10n.maintenancePriorityNormal)),
              DropdownMenuItem(
                  value: 'high',
                  child: Text(context.l10n.maintenancePriorityHigh)),
              DropdownMenuItem(
                  value: 'urgent',
                  child: Text(context.l10n.maintenancePriorityUrgent)),
            ],
            onChanged: (v) => setState(() => _priority = v ?? 'normal'),
          ),
          AppSpacing.vGapXl,
          PrimaryButton(
            label: context.l10n.submitRequest,
            isLoading: _submitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
