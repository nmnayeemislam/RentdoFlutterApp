import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/visits_viewmodel.dart';

/// Lists the user's scheduled property visits, or a sign-in prompt for guests.
class MyVisitsScreen extends ConsumerWidget {
  const MyVisitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.watch(authViewModelProvider.select((s) => s.isAuthenticated));

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.visitsTitle)),
      body: !isAuthed
          ? const _GuestPrompt()
          : ref.watch(visitsViewModelProvider).when(
                loading: () => const SizedBox.shrink(),
                error: (e, _) => AppErrorWidget(
                  message: '$e',
                  onRetry: () =>
                      ref.read(visitsViewModelProvider.notifier).refresh(),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return EmptyState(
                      icon: Icons.event_busy_rounded,
                      title: context.l10n.visitsNoneScheduled,
                      subtitle: context.l10n.visitsBookViewingDesc,
                      action: SizedBox(
                        width: 200,
                        child: PrimaryButton(
                          label: context.l10n.browseProperties,
                          onPressed: () => context.go(AppRoutes.properties),
                        ),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () =>
                        ref.read(visitsViewModelProvider.notifier).refresh(),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => _VisitCard(visit: items[i]),
                    ),
                  );
                },
              ),
    );
  }
}

class _VisitCard extends ConsumerWidget {
  const _VisitCard({required this.visit});
  final VisitModel visit;

  /// Builds a readable label like "Mon, 12 Aug · 3:00 PM" from [scheduledAt].
  String _formatSchedule(BuildContext context, DateTime dt) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat('EEE, d MMM · h:mm a', locale).format(dt);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = (visit.listingTitle != null && visit.listingTitle!.isNotEmpty)
        ? visit.listingTitle!
        : context.l10n.visitsPropertyFallback(visit.listingId ?? visit.id);
    final canCancel = visit.status == 'pending' || visit.status == 'confirmed';

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
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMd,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatusChip(status: visit.status),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 16,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _formatSchedule(context, visit.scheduledAt),
                  style: AppTextStyles.bodySm,
                ),
              ),
            ],
          ),
          if (visit.listingAddress != null &&
              visit.listingAddress!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.place_outlined,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    visit.listingAddress!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySm,
                  ),
                ),
              ],
            ),
          ],
          if (canCancel) ...[
            const SizedBox(height: AppSpacing.xs),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => unawaited(
                  ref.read(visitsViewModelProvider.notifier).cancel(visit.id),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                ),
                child: Text(context.l10n.cancel),
              ),
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
      case 'confirmed':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'completed':
        return AppColors.info;
      case 'cancelled':
      default:
        return AppColors.textTertiary;
    }
  }

  String get _label =>
      status.isEmpty ? status : '${status[0].toUpperCase()}${status.substring(1)}';

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
      icon: Icons.calendar_today_rounded,
      title: context.l10n.visitsSignInToSeeVisits,
      subtitle: context.l10n.visitsLogInToSchedule,
      action: SizedBox(
        width: 200,
        child: PrimaryButton(
          label: context.l10n.login,
          onPressed: () => context.push(AppRoutes.login),
        ),
      ),
    );
  }
}
