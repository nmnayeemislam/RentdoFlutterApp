import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../extensions/context_extensions.dart';
import 'primary_button.dart';

/// Full-width error state with a retry action.
class AppErrorWidget extends StatelessWidget {
  static const MethodChannel _settingsChannel = MethodChannel(
    'rentdo/device_settings',
  );

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
    final bool showNoInternetImage = _isNoInternetMessage(message);

    return SizedBox.expand(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showNoInternetImage) ...[
                Expanded(
                  flex: 7,
                  child: Center(
                    child: Image.asset(
                      'assets/images/no_internet.png',
                      width: context.width,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                AppSpacing.vGapMd,
                Text(
                  context.l10n.noInternetTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headingLg.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.vGapSm,
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Text(
                    context.l10n.noInternetSubtitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                AppSpacing.vGapLg,
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    label: context.l10n.retry,
                    icon: Icons.refresh_rounded,
                    onPressed: onRetry,
                  ),
                ),
                AppSpacing.vGapSm,
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _openPhoneSettings,
                    icon: const Icon(Icons.settings_rounded),
                    label: Text(context.l10n.openSettings),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      side: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.35),
                      ),
                      foregroundColor: AppColors.primary,
                      textStyle: AppTextStyles.button,
                    ),
                  ),
                ),
              ] else ...[
                const Spacer(),
                Icon(icon, size: 56, color: AppColors.textTertiary),
                AppSpacing.vGapLg,
                Text(
                  message ?? context.l10n.somethingWentWrong,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMd,
                ),
                if (onRetry != null) ...[
                  AppSpacing.vGapLg,
                  SizedBox(
                    width: 160,
                    child: PrimaryButton(
                      label: context.l10n.retry,
                      icon: Icons.refresh,
                      onPressed: onRetry,
                    ),
                  ),
                ],
                const Spacer(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool _isNoInternetMessage(String? value) {
    final normalized = value?.toLowerCase() ?? '';
    return normalized.contains('no internet') ||
        normalized.contains('internet connection') ||
        normalized.contains('ইন্টারনেট সংযোগ নেই');
  }

  Future<void> _openPhoneSettings() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        await _settingsChannel.invokeMethod<void>('openSettings');
        return;
      } on PlatformException {
        // Fall back below if the native bridge is unavailable.
      }
    }

    await launchUrl(
      Uri.parse('app-settings:'),
      mode: LaunchMode.externalApplication,
    );
  }
}

/// Empty-result state.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.title,
    this.subtitle,
    this.icon = Icons.search_off_rounded,
    this.action,
  });

  final String? title;
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
            Text(
              title ?? context.l10n.noResults,
              style: AppTextStyles.headingMd,
            ),
            if (subtitle != null) ...[
              AppSpacing.vGapSm,
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMd,
              ),
            ],
            if (action != null) ...[AppSpacing.vGapLg, action!],
          ],
        ),
      ),
    );
  }
}
