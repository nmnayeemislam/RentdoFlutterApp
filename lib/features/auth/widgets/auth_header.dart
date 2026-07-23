import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Branded logo badge + title/subtitle block used at the top of auth screens.
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.logoSize = 60,
    this.logoPadding = 12,
  });

  final String title;
  final String subtitle;
  final double logoSize;
  final double logoPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            height: 170,
            width: 170,
            padding: EdgeInsets.all(logoPadding),
            decoration: const BoxDecoration(
              // color: Colors.white,
              borderRadius: AppRadius.brLg,
              boxShadow: AppShadows.card,
            ),
            child: Image.asset('assets/icons/mark.png', fit: BoxFit.contain),
          ),
        ),
        AppSpacing.vGapXl,
        Text(title, style: AppTextStyles.displayLarge.copyWith(fontSize: 28)),
        AppSpacing.vGapSm,
        Text(subtitle, style: AppTextStyles.bodyLg),
      ],
    );
  }
}
