import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../notifications/widgets/notification_bell.dart';

/// Light home header: avatar, greeting, and the notification bell.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.userName});

  final String? userName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial = (userName != null && userName!.isNotEmpty)
        ? userName![0].toUpperCase()
        : null;

    return Row(
      children: [
        Container(
          height: 46,
          width: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: initial != null
              ? Text(initial,
                  style: AppTextStyles.titleMd
                      .copyWith(color: AppColors.primary))
              : Icon(Icons.person_outline_rounded,
                  color: theme.colorScheme.onSurface, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName == null ? 'Welcome 👋' : 'Hi, $userName 👋',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySm
                    .copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 2),
              const Text(
                'Find your next home',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                // Inherits on-surface (near-navy in light, legible in dark).
                style: AppTextStyles.headingLg,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        const NotificationBell(),
      ],
    );
  }
}
