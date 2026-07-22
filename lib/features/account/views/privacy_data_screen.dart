import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/account_viewmodel.dart';

/// GDPR data export + account deletion (`GET /me/export`, `DELETE /me`).
class PrivacyDataScreen extends ConsumerStatefulWidget {
  const PrivacyDataScreen({super.key});

  @override
  ConsumerState<PrivacyDataScreen> createState() => _PrivacyDataScreenState();
}

class _PrivacyDataScreenState extends ConsumerState<PrivacyDataScreen> {
  bool _exporting = false;
  bool _deleting = false;
  String? _exportUrl;

  Future<void> _requestExport() async {
    setState(() => _exporting = true);
    try {
      final url = await ref.read(accountServiceProvider).requestExport();
      if (!mounted) return;
      setState(() => _exportUrl = url);
      context.showSnack('Export requested');
    } on ApiException catch (e) {
      if (!mounted) return;
      context.showSnack(e.message, error: true);
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _confirmDeletion() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete account'),
        content: const Text(
          'This schedules your account for deletion. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);
    try {
      final date = await ref.read(accountServiceProvider).requestDeletion();
      if (!mounted) return;
      context.showSnack(
        date == null
            ? 'Account scheduled for deletion'
            : 'Account scheduled for deletion on $date',
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      context.showSnack(e.message, error: true);
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAuthed = ref.watch(
      authViewModelProvider.select((s) => s.isAuthenticated),
    );
    final exportUrl = _exportUrl;

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & Data')),
      body: !isAuthed
          ? const _GuestPrompt()
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                _Section(
                  title: 'Export my data',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Request a copy of your account data, listings, '
                        'messages and bookings. We prepare a download link '
                        'for you.',
                        style: AppTextStyles.bodyMd,
                      ),
                      if (exportUrl != null) ...[
                        AppSpacing.vGapMd,
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: const BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: AppRadius.brMd,
                          ),
                          child: SelectableText(
                            exportUrl,
                            style: AppTextStyles.bodySm,
                          ),
                        ),
                      ],
                      AppSpacing.vGapLg,
                      PrimaryButton(
                        label: 'Request export',
                        icon: Icons.download_rounded,
                        isLoading: _exporting,
                        onPressed: () => unawaited(_requestExport()),
                      ),
                    ],
                  ),
                ),
                AppSpacing.vGapLg,
                _Section(
                  title: 'Delete account',
                  danger: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Deleting your account is permanent. Your listings, '
                        'messages, bookings and saved searches will be removed '
                        'and cannot be restored.',
                        style: AppTextStyles.bodyMd,
                      ),
                      AppSpacing.vGapLg,
                      SizedBox(
                        height: 52,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _deleting
                              ? null
                              : () => unawaited(_confirmDeletion()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                          ),
                          child: _deleting
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text('Delete my account'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.danger = false,
  });

  final String title;
  final Widget child;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: danger
            ? AppColors.error.withValues(alpha: 0.06)
            : context.colors.surface,
        borderRadius: AppRadius.brLg,
        border: Border.all(
          color: danger
              ? AppColors.error.withValues(alpha: 0.35)
              : context.colors.outline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMd.copyWith(
              color: danger ? AppColors.error : null,
            ),
          ),
          AppSpacing.vGapSm,
          child,
        ],
      ),
    );
  }
}

class _GuestPrompt extends StatelessWidget {
  const _GuestPrompt();

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.privacy_tip_outlined,
      title: 'Sign in to manage your data',
      subtitle: 'Log in to export your data or delete your account.',
      action: SizedBox(
        width: 200,
        child: PrimaryButton(
          label: 'Log in',
          onPressed: () => context.push(AppRoutes.login),
        ),
      ),
    );
  }
}
