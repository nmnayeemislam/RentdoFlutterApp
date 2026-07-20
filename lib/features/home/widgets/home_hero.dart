import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../notifications/widgets/notification_bell.dart';

/// Gradient hero banner at the top of Home: greeting, tagline and a tappable
/// search field that routes to the property list.
class HomeHero extends StatelessWidget {
  const HomeHero({
    super.key,
    required this.userName,
    required this.onSearchTap,
  });

  final String? userName;
  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.viewPaddingOf(context).top;
    return Container(
      padding: EdgeInsets.fromLTRB(20, topPad + 16, 20, 26),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName == null ? 'Welcome 👋' : 'Hi, $userName 👋',
                      style: AppTextStyles.bodyMd
                          .copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Find your dream property',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const NotificationBell(),
            ],
          ),
          AppSpacing.vGapMd,
          Text(
            AppStrings.heroSubtitle,
            style: AppTextStyles.bodySm.copyWith(color: Colors.white70),
          ),
          AppSpacing.vGapLg,
          GestureDetector(
            onTap: onSearchTap,
            child: Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: AppRadius.brMd,
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded,
                      color: AppColors.textTertiary),
                  const SizedBox(width: 10),
                  Text('Search location, property...',
                      style: AppTextStyles.bodyMd
                          .copyWith(color: AppColors.textTertiary)),
                  const Spacer(),
                  Container(
                    height: 38,
                    width: 38,
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: AppRadius.brSm,
                    ),
                    child: const Icon(Icons.tune_rounded,
                        color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
