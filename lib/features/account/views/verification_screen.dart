import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/account_viewmodel.dart';

/// Owner-verification status + document upload (`GET|POST /me/verification`).
class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  bool _submitting = false;

  Future<void> _pickAndSubmit() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() => _submitting = true);
    try {
      await ref.read(accountServiceProvider).submitVerification(picked.path);
      if (!mounted) return;
      ref.invalidate(verificationStatusProvider);
      context.showSnack('Document submitted for review');
    } on ApiException catch (e) {
      if (!mounted) return;
      context.showSnack(e.message, error: true);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAuthed = ref.watch(
      authViewModelProvider.select((s) => s.isAuthenticated),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Owner Verification')),
      body: !isAuthed
          ? const _GuestPrompt()
          : ref.watch(verificationStatusProvider).when(
                loading: () => const LoadingWidget(),
                error: (e, _) => AppErrorWidget(
                  message: e is ApiException ? e.message : '$e',
                  onRetry: () => ref.invalidate(verificationStatusProvider),
                ),
                data: (status) => ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    _StatusCard(status: status),
                    AppSpacing.vGapXl,
                    const Text(
                      'Upload a government ID or business document to get the '
                      'verified badge.',
                      style: AppTextStyles.bodyMd,
                    ),
                    if (!status.isVerified) ...[
                      AppSpacing.vGapXl,
                      PrimaryButton(
                        label: 'Upload document',
                        icon: Icons.upload_file_rounded,
                        isLoading: _submitting,
                        onPressed: () => unawaited(_pickAndSubmit()),
                      ),
                    ],
                  ],
                ),
              ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.status});
  final VerificationStatus status;

  @override
  Widget build(BuildContext context) {
    final reviewedAt = status.reviewedAt;
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
              const Expanded(
                child: Text('Verification status',
                    style: AppTextStyles.titleMd),
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatusChip(status: status.status),
            ],
          ),
          if (status.note != null && status.note!.isNotEmpty) ...[
            AppSpacing.vGapSm,
            Text(status.note!, style: AppTextStyles.bodySm),
          ],
          if (reviewedAt != null) ...[
            AppSpacing.vGapSm,
            Row(
              children: [
                const Icon(
                  Icons.event_available_rounded,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Reviewed ${Formatters.date(reviewedAt)}',
                  style: AppTextStyles.bodySm,
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

  Color get _color {
    switch (status) {
      case 'verified':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'rejected':
        return AppColors.error;
      case 'unverified':
      default:
        return AppColors.textTertiary;
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

class _GuestPrompt extends StatelessWidget {
  const _GuestPrompt();

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.verified_user_outlined,
      title: 'Sign in to get verified',
      subtitle: 'Log in to submit your documents and earn the verified badge.',
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
