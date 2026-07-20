import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../config/providers/config_providers.dart';
import '../models/property_model.dart';

/// Horizontal scrollable "All / Rent / Sale / Hotel ..." selector, populated
/// from the backend's property types (falls back to a static set while the
/// bootstrap config loads).
class TypeFilterBar extends ConsumerWidget {
  const TypeFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  /// `null` == "All".
  final ListingType? selected;
  final ValueChanged<ListingType?> onSelected;

  static const _fallback = <ListingType>[
    ListingType.rent,
    ListingType.sale,
    ListingType.hotel,
    ListingType.land,
    ListingType.office,
    ListingType.room,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(propertyTypeOptionsProvider);
    final types = <(ListingType?, String)>[(null, 'All')];
    if (options.isEmpty) {
      for (final t in _fallback) {
        types.add((t, t.label));
      }
    } else {
      for (final o in options) {
        final t = ListingType.fromString(o.key);
        if (t != ListingType.unknown) types.add((t, o.label));
      }
    }

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: types.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (type, label) = types[i];
          final isSel = type == selected;
          return GestureDetector(
            onTap: () => onSelected(type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSel
                    ? AppColors.primary
                    : Theme.of(context).colorScheme.surface,
                borderRadius: AppRadius.brPill,
                border: Border.all(
                  color: isSel
                      ? AppColors.primary
                      : Theme.of(context).colorScheme.outline,
                ),
              ),
              child: Text(
                label,
                style: AppTextStyles.titleSm.copyWith(
                  color: isSel
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
