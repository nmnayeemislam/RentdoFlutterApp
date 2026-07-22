import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/animations.dart';
import '../../properties/models/property_model.dart';
import '../models/category_item.dart';

/// Horizontally scrollable "Featured Categories" rail.
class CategoryRail extends StatelessWidget {
  const CategoryRail({super.key, required this.onSelected});

  final ValueChanged<ListingType> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: CategoryItem.all.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final item = CategoryItem.all[i];
          final label = _labelFor(context, item.type);
          return Pressable(
            onTap: () => onSelected(item.type),
            child: SizedBox(
              width: 78,
              child: Column(
                children: [
                  Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: AppRadius.brLg,
                      border: Border.all(color: context.colors.outline),
                      boxShadow: context.isDark ? null : AppShadows.soft,
                    ),
                    child: Icon(item.icon,
                        color: context.colors.onSurface, size: 26),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _labelFor(BuildContext context, ListingType type) {
    final l10n = context.l10n;
    return switch (type) {
      ListingType.sale => l10n.categoryForSale,
      ListingType.rent => l10n.categoryForRent,
      ListingType.hotel => l10n.categoryShortStay,
      ListingType.land => l10n.categoryLand,
      ListingType.office => l10n.categoryOffice,
      ListingType.room => l10n.categoryRooms,
      _ => type.label,
    };
  }
}
