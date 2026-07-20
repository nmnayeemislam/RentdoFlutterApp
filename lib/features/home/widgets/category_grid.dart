import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';
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
          return Pressable(
            onTap: () => onSelected(item.type),
            child: SizedBox(
              width: 78,
              child: Column(
                children: [
                  Container(
                    height: 62,
                    width: 62,
                    decoration: const BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: AppRadius.brMd,
                    ),
                    child: Icon(item.icon, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
