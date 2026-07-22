import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../routes/app_routes.dart';
import '../viewmodels/notifications_viewmodel.dart';

/// Notification bell with an unread dot; navigates to the notifications
/// screen. A bordered white tile that sits on the light home header.
class NotificationBell extends ConsumerWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadNotificationsProvider).valueOrNull ?? 0;
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      label: unread > 0 ? 'Notifications, $unread unread' : 'Notifications',
      child: GestureDetector(
        onTap: () => context.push(AppRoutes.notifications),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: AppRadius.brMd,
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Icon(Icons.notifications_none_rounded,
                  color: theme.colorScheme.onSurface, size: 22),
            ),
            if (unread > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: theme.colorScheme.surface, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
