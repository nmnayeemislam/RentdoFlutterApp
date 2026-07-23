import 'package:flutter/material.dart';

import '../../notifications/widgets/notification_bell.dart';

/// Light home header: avatar, greeting, and the notification bell.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.userName});

  final String? userName;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Image.asset(
              isDark ? 'assets/images/logo_dark.png' : 'assets/images/logo.png',
              height: 34,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const NotificationBell(),
      ],
    );
  }
}
