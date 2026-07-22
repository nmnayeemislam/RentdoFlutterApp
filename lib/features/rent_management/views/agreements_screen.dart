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
import '../viewmodels/rent_management_viewmodel.dart';

/// Lists generated tenancy agreements, with template management and a
/// generate-from-template flow.
class AgreementsScreen extends ConsumerWidget {
  const AgreementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.rentAgreements),
        actions: [
          TextButton(
            onPressed: () => unawaited(_TemplatesSheet.show(context)),
            child: Text(context.l10n.rentTemplates),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: context.l10n.rentGenerateAgreement,
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
                return EmptyState(
                  icon: Icons.description_outlined,
                  title: context.l10n.rentNoAgreementsYet,
                  subtitle: context.l10n.rentAgreementsEmptyDesc,
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
                  context.l10n.rentAgreementFallback(agreement.id),
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
      context.showSnack(context.l10n.rentEnterTemplateName, error: true);
      return;
    }
    if (body.isEmpty) {
      context.showSnack(context.l10n.rentEnterTemplateBody, error: true);
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
      context.showSnack(context.l10n.rentTemplateCreated);
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
      context.showSnack(context.l10n.rentTemplateDeleted);
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
            Text(context.l10n.rentAgreementTemplates,
                style: AppTextStyles.headingMd),
            AppSpacing.vGapLg,
            templates.when(
              loading: () => const LoadingWidget(),
              error: (e, _) => AppErrorWidget(
                message: '$e',
                onRetry: () => ref.invalidate(agreementTemplatesProvider),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Text(
                    context.l10n.rentNoTemplatesYet,
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
                            tooltip: context.l10n.rentDeleteTemplate,
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
            Text(context.l10n.rentNewTemplate, style: AppTextStyles.titleMd),
            AppSpacing.vGapMd,
            AppTextField(
              label: context.l10n.name,
              hint: context.l10n.rentTemplateNameHint,
              controller: _name,
            ),
            AppSpacing.vGapMd,
            AppTextField(
              label: context.l10n.rentBody,
              hint: context.l10n.rentTemplateBodyHint,
              controller: _body,
              maxLines: 5,
            ),
            AppSpacing.vGapSm,
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: _isDefault,
              activeThumbColor: AppColors.primary,
              title: Text(context.l10n.rentIsDefault, style: AppTextStyles.titleSm),
              onChanged: (v) => setState(() => _isDefault = v),
            ),
            AppSpacing.vGapMd,
            PrimaryButton(
              label: context.l10n.rentCreateTemplate,
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
        context.l10n.rentDefault,
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
      context.showSnack(context.l10n.rentChooseTenancy, error: true);
      return;
    }
    if (templateId == null) {
      context.showSnack(context.l10n.rentChooseTemplate, error: true);
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
      context.showSnack(context.l10n.rentAgreementGenerated);
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
            Text(context.l10n.rentGenerateAgreement,
                style: AppTextStyles.headingMd),
            AppSpacing.vGapLg,
            tenancies.when(
              loading: () => const LoadingWidget(),
              error: (e, _) => AppErrorWidget(
                message: '$e',
                onRetry: () => ref.invalidate(tenanciesProvider),
              ),
              data: (items) => DropdownButtonFormField<int>(
                initialValue: _tenancyId,
                decoration:
                    InputDecoration(labelText: context.l10n.rentTenancyLabel),
                items: [
                  for (final t in items)
                    DropdownMenuItem(
                      value: t.id,
                      child: Text(t.tenantName ??
                          context.l10n.rentTenancyFallback(t.id)),
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
                decoration:
                    InputDecoration(labelText: context.l10n.rentTemplateLabel),
                items: [
                  for (final t in items)
                    DropdownMenuItem(value: t.id, child: Text(t.name)),
                ],
                onChanged: (v) => setState(() => _templateId = v),
              ),
            ),
            AppSpacing.vGapXl,
            PrimaryButton(
              label: context.l10n.generate,
              isLoading: _submitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
