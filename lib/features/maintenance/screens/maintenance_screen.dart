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
import '../../auth/controllers/auth_controller.dart';
import '../controllers/maintenance_controller.dart';

class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.watch(authControllerProvider.select((s) => s.isAuthenticated));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance'),
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
              title: 'Sign in for maintenance',
              subtitle: 'Log in to raise and track maintenance requests.',
              action: SizedBox(
                width: 200,
                child: PrimaryButton(
                  label: 'Log in',
                  onPressed: () => context.push(AppRoutes.login),
                ),
              ),
            )
          : ref.watch(maintenanceControllerProvider).when(
                loading: () => const LoadingWidget(),
                error: (e, _) => AppErrorWidget(
                  message: '$e',
                  onRetry: () =>
                      ref.read(maintenanceControllerProvider.notifier).refresh(),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return const EmptyState(
                      icon: Icons.build_outlined,
                      title: 'No maintenance requests',
                      subtitle: 'Tap + to raise an issue for a property.',
                    );
                  }
                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () => ref
                        .read(maintenanceControllerProvider.notifier)
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
                Text('Priority: ${request.priority}',
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
      context.showSnack('Enter a valid listing ID', error: true);
      return;
    }
    if (_title.text.trim().isEmpty || _description.text.trim().isEmpty) {
      context.showSnack('Add a title and description', error: true);
      return;
    }
    setState(() => _submitting = true);
    try {
      await ref.read(maintenanceControllerProvider.notifier).create(
            propertyListingId: listingId,
            title: _title.text.trim(),
            description: _description.text.trim(),
            priority: _priority,
          );
      if (!mounted) return;
      Navigator.pop(context);
      context.showSnack('Request submitted');
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
          const Text('Raise an issue', style: AppTextStyles.headingMd),
          AppSpacing.vGapLg,
          AppTextField(
            label: 'Listing ID',
            hint: 'The property this relates to',
            controller: _listingId,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          AppSpacing.vGapLg,
          AppTextField(
            label: 'Title',
            hint: 'e.g. Leaking tap',
            controller: _title,
          ),
          AppSpacing.vGapLg,
          AppTextField(
            label: 'Description',
            hint: 'Describe the problem',
            controller: _description,
            maxLines: 3,
          ),
          AppSpacing.vGapLg,
          DropdownButtonFormField<String>(
            initialValue: _priority,
            decoration: const InputDecoration(labelText: 'Priority'),
            items: const [
              DropdownMenuItem(value: 'low', child: Text('Low')),
              DropdownMenuItem(value: 'normal', child: Text('Normal')),
              DropdownMenuItem(value: 'high', child: Text('High')),
              DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
            ],
            onChanged: (v) => setState(() => _priority = v ?? 'normal'),
          ),
          AppSpacing.vGapXl,
          PrimaryButton(
            label: 'Submit request',
            isLoading: _submitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
