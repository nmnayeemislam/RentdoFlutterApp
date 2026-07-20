import 'dart:async';

import 'package:flutter/material.dart';
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
import '../controllers/rent_management_controller.dart';

/// Lists generated tenancy agreements, with template management and a
/// generate-from-template flow.
class AgreementsScreen extends ConsumerWidget {
  const AgreementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agreements'),
        actions: [
          TextButton(
            onPressed: () => unawaited(_TemplatesSheet.show(context)),
            child: const Text('Templates'),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Generate agreement',
            onPressed: () => unawaited(_GenerateAgreementSheet.show(context)),
          ),
        ],
      ),
      body: ref.watch(agreementsProvider).when(
            loading: () => const LoadingWidget(),
            error: (e, _) => AppErrorWidget(
              message: '$e',
              onRetry: () => ref.invalidate(agreementsProvider),
            ),
            data: (agreements) {
              if (agreements.isEmpty) {
                return const EmptyState(
                  icon: Icons.description_outlined,
                  title: 'No agreements yet',
                  subtitle: 'Generate one from a tenancy and template.',
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: agreements.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, i) =>
                    _AgreementCard(agreement: agreements[i]),
              );
            },
          ),
    );
  }
}

class _AgreementCard extends StatelessWidget {
  const _AgreementCard({required this.agreement});

  final Agreement agreement;

  @override
  Widget build(BuildContext context) {
    final status = agreement.status;
    final content = agreement.content;

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
                child: Text(
                  'Agreement #${agreement.id}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMd,
                ),
              ),
              if (status != null && status.isNotEmpty) ...[
                const SizedBox(width: AppSpacing.sm),
                _StatusChip(status: status),
              ],
            ],
          ),
          if (agreement.generatedAt != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(
                  Icons.event_outlined,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 6),
                Text(
                  Formatters.date(agreement.generatedAt),
                  style: AppTextStyles.bodySm,
                ),
              ],
            ),
          ],
          if (content != null && content.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySm,
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
    switch (status.toLowerCase()) {
      case 'signed':
      case 'active':
        return AppColors.success;
      case 'pending':
      case 'draft':
        return AppColors.warning;
      case 'expired':
      case 'cancelled':
        return AppColors.textTertiary;
      default:
        return AppColors.info;
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

/// Sheet listing agreement templates with an inline create form.
class _TemplatesSheet extends ConsumerStatefulWidget {
  const _TemplatesSheet();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _TemplatesSheet(),
    );
  }

  @override
  ConsumerState<_TemplatesSheet> createState() => _TemplatesSheetState();
}

class _TemplatesSheetState extends ConsumerState<_TemplatesSheet> {
  final _name = TextEditingController();
  final _body = TextEditingController();
  bool _isDefault = false;
  bool _submitting = false;

  @override
  void dispose() {
    _name.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final name = _name.text.trim();
    final body = _body.text.trim();
    if (name.isEmpty) {
      context.showSnack('Enter a template name', error: true);
      return;
    }
    if (body.isEmpty) {
      context.showSnack('Enter the template body', error: true);
      return;
    }
    setState(() => _submitting = true);
    try {
      await ref.read(rentManagementServiceProvider).createAgreementTemplate(
            name: name,
            body: body,
            isDefault: _isDefault,
          );
      ref.invalidate(agreementTemplatesProvider);
      if (!mounted) return;
      _name.clear();
      _body.clear();
      setState(() {
        _isDefault = false;
        _submitting = false;
      });
      context.showSnack('Template created');
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      context.showSnack(e.message, error: true);
    }
  }

  Future<void> _delete(int id) async {
    try {
      await ref.read(rentManagementServiceProvider).deleteAgreementTemplate(id);
      ref.invalidate(agreementTemplatesProvider);
      if (!mounted) return;
      context.showSnack('Template deleted');
    } on ApiException catch (e) {
      if (!mounted) return;
      context.showSnack(e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final templates = ref.watch(agreementTemplatesProvider);

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
            const Text('Agreement templates', style: AppTextStyles.headingMd),
            AppSpacing.vGapLg,
            templates.when(
              loading: () => const LoadingWidget(),
              error: (e, _) => AppErrorWidget(
                message: '$e',
                onRetry: () => ref.invalidate(agreementTemplatesProvider),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return const Text(
                    'No templates yet. Create your first one below.',
                    style: AppTextStyles.bodySm,
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) {
                    final template = items[i];
                    return Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.brMd,
                        border: Border.all(color: context.colors.outline),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              template.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.titleSm,
                            ),
                          ),
                          if (template.isDefault) ...[
                            const SizedBox(width: AppSpacing.sm),
                            const _DefaultChip(),
                          ],
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppColors.error,
                            ),
                            tooltip: 'Delete template',
                            onPressed: () => unawaited(_delete(template.id)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            AppSpacing.vGapXl,
            const Text('New template', style: AppTextStyles.titleMd),
            AppSpacing.vGapMd,
            AppTextField(
              label: 'Name',
              hint: 'e.g. Standard 12-month lease',
              controller: _name,
            ),
            AppSpacing.vGapMd,
            AppTextField(
              label: 'Body',
              hint: 'The agreement text',
              controller: _body,
              maxLines: 5,
            ),
            AppSpacing.vGapSm,
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: _isDefault,
              activeThumbColor: AppColors.primary,
              title: const Text('Is default', style: AppTextStyles.titleSm),
              onChanged: (v) => setState(() => _isDefault = v),
            ),
            AppSpacing.vGapMd,
            PrimaryButton(
              label: 'Create template',
              isLoading: _submitting,
              onPressed: _create,
            ),
          ],
        ),
      ),
    );
  }
}

class _DefaultChip extends StatelessWidget {
  const _DefaultChip();

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
        'Default',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.success,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Sheet that generates an agreement from a tenancy plus a template.
class _GenerateAgreementSheet extends ConsumerStatefulWidget {
  const _GenerateAgreementSheet();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _GenerateAgreementSheet(),
    );
  }

  @override
  ConsumerState<_GenerateAgreementSheet> createState() =>
      _GenerateAgreementSheetState();
}

class _GenerateAgreementSheetState
    extends ConsumerState<_GenerateAgreementSheet> {
  int? _tenancyId;
  int? _templateId;
  bool _submitting = false;

  Future<void> _submit() async {
    final tenancyId = _tenancyId;
    final templateId = _templateId;
    if (tenancyId == null) {
      context.showSnack('Choose a tenancy', error: true);
      return;
    }
    if (templateId == null) {
      context.showSnack('Choose a template', error: true);
      return;
    }
    setState(() => _submitting = true);
    try {
      await ref.read(rentManagementServiceProvider).createAgreement(
            tenancyId: tenancyId,
            templateId: templateId,
          );
      ref.invalidate(agreementsProvider);
      if (!mounted) return;
      Navigator.pop(context);
      context.showSnack('Agreement generated');
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      context.showSnack(e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tenancies = ref.watch(tenanciesProvider);
    final templates = ref.watch(agreementTemplatesProvider);

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
            const Text('Generate agreement', style: AppTextStyles.headingMd),
            AppSpacing.vGapLg,
            tenancies.when(
              loading: () => const LoadingWidget(),
              error: (e, _) => AppErrorWidget(
                message: '$e',
                onRetry: () => ref.invalidate(tenanciesProvider),
              ),
              data: (items) => DropdownButtonFormField<int>(
                initialValue: _tenancyId,
                decoration: const InputDecoration(labelText: 'Tenancy'),
                items: [
                  for (final t in items)
                    DropdownMenuItem(
                      value: t.id,
                      child: Text(t.tenantName ?? 'Tenancy #${t.id}'),
                    ),
                ],
                onChanged: (v) => setState(() => _tenancyId = v),
              ),
            ),
            AppSpacing.vGapLg,
            templates.when(
              loading: () => const LoadingWidget(),
              error: (e, _) => AppErrorWidget(
                message: '$e',
                onRetry: () => ref.invalidate(agreementTemplatesProvider),
              ),
              data: (items) => DropdownButtonFormField<int>(
                initialValue: _templateId,
                decoration: const InputDecoration(labelText: 'Template'),
                items: [
                  for (final t in items)
                    DropdownMenuItem(value: t.id, child: Text(t.name)),
                ],
                onChanged: (v) => setState(() => _templateId = v),
              ),
            ),
            AppSpacing.vGapXl,
            PrimaryButton(
              label: 'Generate',
              isLoading: _submitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
