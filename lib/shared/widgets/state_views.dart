import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import 'primary_button.dart';

/// Centered loading indicator for async view states.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(strokeWidth: 2.6),
          if (message != null) ...[
            AppSpacing.vGapLg,
            Text(message!, style: AppTextStyles.bodyMd),
          ],
        ],
      ),
    );
  }
}

/// Full-width error state with a retry action.
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    this.message,
    this.onRetry,
    this.icon = Icons.cloud_off_rounded,
  });

  final String? message;
  final VoidCallback? onRetry;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.textTertiary),
            AppSpacing.vGapLg,
            Text(
              message ?? AppStrings.somethingWentWrong,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMd,
            ),
            if (onRetry != null) ...[
              AppSpacing.vGapLg,
              SizedBox(
                width: 160,
                child: PrimaryButton(
                  label: AppStrings.retry,
                  icon: Icons.refresh,
                  onPressed: onRetry,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty-result state.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.title = AppStrings.noResults,
    this.subtitle,
    this.icon = Icons.search_off_rounded,
    this.action,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.textTertiary),
            AppSpacing.vGapLg,
            Text(title, style: AppTextStyles.headingMd),
            if (subtitle != null) ...[
              AppSpacing.vGapSm,
              Text(subtitle!,
                  textAlign: TextAlign.center, style: AppTextStyles.bodyMd),
            ],
            if (action != null) ...[AppSpacing.vGapLg, action!],
          ],
        ),
      ),
    );
  }
}
