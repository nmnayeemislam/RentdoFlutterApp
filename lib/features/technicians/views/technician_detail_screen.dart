import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/technician_viewmodel.dart';
import '../widgets/book_technician_sheet.dart';

/// Full-screen technician profile keyed by [id].
class TechnicianDetailScreen extends ConsumerWidget {
  const TechnicianDetailScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(technicianDetailProvider(id));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: async.when(
        loading: () => const SizedBox.shrink(),
        error: (e, _) => AppErrorWidget(
          message: '$e',
          onRetry: () => ref.invalidate(technicianDetailProvider(id)),
        ),
        data: (technician) => _DetailBody(technician: technician),
      ),
      bottomNavigationBar: async.maybeWhen(
        data: (_) => _RequestBar(technicianId: id),
        orElse: () => null,
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.technician});

  final TechnicianModel technician;

  @override
  Widget build(BuildContext context) {
    final name = (technician.name != null && technician.name!.isNotEmpty)
        ? technician.name!
        : context.l10n.technicianFallback(technician.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                _Avatar(url: technician.avatar),
                AppSpacing.vGapLg,
                Text(name, style: AppTextStyles.headingXl),
                if (technician.isVerified) ...[
                  AppSpacing.vGapSm,
                  const AppBadge.verified(),
                ],
                if (technician.categoryName != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    technician.categoryName!,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          AppSpacing.vGapXl,
          _StatRow(technician: technician),
          if (technician.hourlyRate != null) ...[
            AppSpacing.vGapLg,
            Center(
              child: Text(
                '${Formatters.money(technician.hourlyRate)}'
                '${context.l10n.technicianPerHour}',
                style: AppTextStyles.headingMd
                    .copyWith(color: AppColors.primary),
              ),
            ),
          ],
          if (technician.bio != null && technician.bio!.isNotEmpty) ...[
            AppSpacing.vGapXxl,
            Text(context.l10n.about, style: AppTextStyles.headingMd),
            AppSpacing.vGapMd,
            Text(technician.bio!, style: AppTextStyles.bodyLg),
          ],
          if (technician.skills.isNotEmpty) ...[
            AppSpacing.vGapXxl,
            Text(context.l10n.skills, style: AppTextStyles.headingMd),
            AppSpacing.vGapMd,
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final s in technician.skills) _SkillChip(label: s),
              ],
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url != null && url!.isNotEmpty) {
      return NetworkImageWidget(
        url: url,
        width: 104,
        height: 104,
        borderRadius: BorderRadius.circular(52),
      );
    }
    return const CircleAvatar(
      radius: 52,
      backgroundColor: AppColors.primarySurface,
      child: Icon(Icons.person, color: AppColors.primary, size: 44),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.technician});

  final TechnicianModel technician;

  @override
  Widget build(BuildContext context) {
    final stats = <(IconData, String, String)>[
      (
        Icons.star_rounded,
        technician.rating.toStringAsFixed(1),
        context.l10n.technicianRating,
      ),
      if (technician.jobsDone != null)
        (Icons.check_circle_outline_rounded, '${technician.jobsDone}',
            context.l10n.technicianJobs),
      if (technician.experienceYears != null)
        (Icons.workspace_premium_outlined, '${technician.experienceYears}',
            context.l10n.technicianYrsExp),
    ];

    return Row(
      children: [
        for (final stat in stats)
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: AppRadius.brMd,
                border: Border.all(color: context.colors.outline),
              ),
              child: Column(
                children: [
                  Icon(stat.$1, color: AppColors.primary),
                  const SizedBox(height: 6),
                  Text(stat.$2, style: AppTextStyles.titleMd),
                  Text(stat.$3, style: AppTextStyles.caption),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SkillChip extends StatelessWidget {
  const _SkillChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: const BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppRadius.brSm,
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySm.copyWith(color: AppColors.primaryDark),
      ),
    );
  }
}

class _RequestBar extends ConsumerWidget {
  const _RequestBar({required this.technicianId});

  final int technicianId;

  Future<void> _request(BuildContext context, WidgetRef ref) async {
    final isAuthed =
        ref.read(authViewModelProvider.select((s) => s.isAuthenticated));
    if (!isAuthed) {
      context.showSnack(context.l10n.technicianLogInToRequest);
      unawaited(context.push(AppRoutes.login));
      return;
    }
    final ok = await BookTechnicianSheet.show(context, technicianId);
    if (ok == true && context.mounted) {
      context.showSnack(context.l10n.technicianRequestSent);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.outline)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: PrimaryButton(
            label: context.l10n.technicianRequestService,
            icon: Icons.handyman_rounded,
            onPressed: () => _request(context, ref),
          ),
        ),
      ),
    );
  }
}
