import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';
import '../extensions/context_extensions.dart';

/// Small pill label used for "Featured", "Verified", "New", listing type, etc.
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required String this.label,
    this.color = AppColors.navy,
    this.background,
    this.icon,
    this.iconColor,
    this.filled = true,
  });

  final String? label;
  final Color color;
  final Color? background;
  final IconData? icon;

  /// Overrides the icon tint (defaults to the label colour).
  final Color? iconColor;
  final bool filled;

  const AppBadge.verified({super.key})
      : label = null,
        color = AppColors.navy,
        background = Colors.white,
        icon = Icons.verified_rounded,
        iconColor = AppColors.verified,
        filled = true;

  const AppBadge.featured({super.key})
      : label = null,
        color = Colors.white,
        background = AppColors.navy,
        icon = Icons.star_rounded,
        iconColor = null,
        filled = true;

  const AppBadge.isNew({super.key})
      : label = null,
        color = Colors.white,
        background = AppColors.info,
        icon = null,
        iconColor = null,
        filled = true;

  @override
  Widget build(BuildContext context) {
    final Color bg = filled
        ? (background ?? color)
        : (background ?? color).withValues(alpha: 0.12);
    // A filled badge with no explicit background uses [color] as its fill, so
    // the label must contrast — white — rather than matching the fill.
    final Color fg = filled && background == null ? Colors.white : color;
    final resolvedLabel = label ??
        (icon == Icons.verified_rounded
            ? context.l10n.verified
            : icon == Icons.star_rounded
                ? context.l10n.featured
                : context.l10n.newLabel);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.brPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: iconColor ?? fg),
            const SizedBox(width: 4),
          ],
          Text(
            resolvedLabel,
            style: AppTextStyles.caption
                .copyWith(color: fg, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
