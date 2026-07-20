import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Branded logo + title/subtitle block used at the top of auth screens.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 40,
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
        ),
        AppSpacing.vGapXl,
        Text(title, style: AppTextStyles.displayLarge.copyWith(fontSize: 28)),
        AppSpacing.vGapSm,
        Text(subtitle, style: AppTextStyles.bodyLg),
      ],
    );
  }
}
