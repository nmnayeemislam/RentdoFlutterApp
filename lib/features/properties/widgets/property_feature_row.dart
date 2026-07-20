import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../models/property_model.dart';

/// Compact beds / baths / size row shown on property cards and detail headers.
class PropertyFeatureRow extends StatelessWidget {
  const PropertyFeatureRow({super.key, required this.property, this.spacing = 14});

  final PropertyModel property;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      if (property.beds != null)
        _Feature(Icons.king_bed_outlined, '${property.beds} Beds'),
      if (property.baths != null)
        _Feature(Icons.bathtub_outlined, '${property.baths} Baths'),
      if (property.sizeSqft != null)
        _Feature(Icons.square_foot_rounded,
            '${Formatters.compact(property.sizeSqft)} sqft'),
    ];
    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: spacing,
      runSpacing: 6,
      children: items,
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.bodySm),
      ],
    );
  }
}
