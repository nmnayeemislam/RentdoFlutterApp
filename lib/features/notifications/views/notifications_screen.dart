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
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../models/notification_model.dart';
import '../viewmodels/notifications_viewmodel.dart';

/// Lists the user's notifications, or a sign-in prompt for guests.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.watch(authViewModelProvider.select((s) => s.isAuthenticated));
    final notifications = ref.watch(notificationsViewModelProvider);

    final hasUnread = notifications.valueOrNull?.any((n) => !n.isRead) ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.notifications),
        actions: [
          if (isAuthed && hasUnread)
            TextButton(
              onPressed: () => unawaited(
                ref
                    .read(notificationsViewModelProvider.notifier)
                    .markAllRead(),
              ),
              child: Text(context.l10n.notificationsMarkAllRead),
            ),
        ],
      ),
      body: !isAuthed
          ? const _GuestPrompt()
          : notifications.when(
              loading: () => const LoadingWidget(),
              error: (e, _) => AppErrorWidget(
                message: '$e',
                onRetry: () => ref
                    .read(notificationsViewModelProvider.notifier)
                    .refresh(),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return EmptyState(
                    icon: Icons.notifications_none_rounded,
                    title: context.l10n.notificationsNoneYet,
                    subtitle: context.l10n.notificationsWillNotify,
                  );
                }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => ref
                      .read(notificationsViewModelProvider.notifier)
                      .refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) =>
                        _NotificationTile(notification: items[i]),
                  ),
                );
              },
            ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  const _NotificationTile({required this.notification});
  final NotificationModel notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = !notification.isRead;

    return Material(
      color: unread ? AppColors.primarySurface : context.colors.surface,
      borderRadius: AppRadius.brLg,
      child: InkWell(
        borderRadius: AppRadius.brLg,
        onTap: unread
            ? () => unawaited(
                  ref
                      .read(notificationsViewModelProvider.notifier)
                      .markRead(notification.id),
                )
            : null,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: AppRadius.brLg,
            border: Border.all(
              color: unread ? AppColors.primary.withValues(alpha: 0.25)
                  : context.colors.outline,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                unread
                    ? Icons.notifications_rounded
                    : Icons.notifications_none_rounded,
                size: 22,
                color: unread ? AppColors.primary : AppColors.textTertiary,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleSm.copyWith(
                              fontWeight:
                                  unread ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                        if (unread) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (notification.body != null &&
                        notification.body!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        notification.body!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySm,
                      ),
                    ],
                    if (notification.createdAt != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        Formatters.relative(notification.createdAt),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
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
      icon: Icons.notifications_none_rounded,
      title: context.l10n.notificationsSignInTitle,
      subtitle: context.l10n.notificationsLogInDesc,
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
