import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';

/// Small pill label used for "Featured", "Verified", "New", listing type, etc.
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.color = AppColors.primary,
    this.background,
    this.icon,
    this.filled = true,
  });

  final String label;
  final Color color;
  final Color? background;
  final IconData? icon;
  final bool filled;

  const AppBadge.verified({super.key})
      : label = 'Verified',
        color = Colors.white,
        background = AppColors.verified,
        icon = Icons.verified_rounded,
        filled = true;

  const AppBadge.featured({super.key})
      : label = 'Featured',
        color = AppColors.ink,
        background = AppColors.accent,
        icon = Icons.star_rounded,
        filled = true;

  const AppBadge.isNew({super.key})
      : label = 'New',
        color = Colors.white,
        background = AppColors.info,
        icon = null,
        filled = true;

  @override
  Widget build(BuildContext context) {
    final Color bg = filled
        ? (background ?? color)
        : (background ?? color).withValues(alpha: 0.12);
    // A filled badge with no explicit background uses [color] as its fill, so
    // the label must contrast — white — rather than matching the fill.
    final Color fg = filled && background == null ? Colors.white : color;
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
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.caption
                .copyWith(color: fg, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
