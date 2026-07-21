import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';

/// Rounded search input used on Home and the property list.
///
/// When [readOnly] is true it behaves as a button (e.g. to open a search page).
class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.hint = 'Search location, property...',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
    this.onFilterTap,
    this.filterActive = false,
  });

  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool readOnly;
  final VoidCallback? onFilterTap;

  /// When true, a dot badge is shown on the filter button.
  final bool filterActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? AppColors.surfaceAltDark
                  : AppColors.surfaceLight,
              borderRadius: AppRadius.brLg,
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              onTap: onTap,
              readOnly: readOnly,
              style: AppTextStyles.bodyMd
                  .copyWith(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: hint,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.textTertiary),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        if (onFilterTap != null) ...[
          const SizedBox(width: 10),
          InkWell(
            onTap: onFilterTap,
            borderRadius: AppRadius.brLg,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: AppRadius.brLg,
                  ),
                  child: const Icon(Icons.tune_rounded, color: Colors.white),
                ),
                if (filterActive)
                  Positioned(
                    top: -3,
                    right: -3,
                    child: Container(
                      height: 14,
                      width: 14,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: theme.scaffoldBackgroundColor, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
