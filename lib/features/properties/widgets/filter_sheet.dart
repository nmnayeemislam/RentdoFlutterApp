import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../zones/widgets/zone_picker_sheet.dart';
import '../models/property_filter.dart';
import '../models/property_model.dart';

/// Bottom-sheet UI for refining the property list. Returns the updated
/// [PropertyFilter] via [Navigator.pop], or `null` if dismissed.
class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key, required this.initial});

  final PropertyFilter initial;

  static Future<PropertyFilter?> show(
    BuildContext context,
    PropertyFilter initial,
  ) {
    return showModalBottomSheet<PropertyFilter>(
      context: context,
      isScrollControlled: true,
      builder: (_) => FilterSheet(initial: initial),
    );
  }

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late ListingType? _type = widget.initial.type;
  late RangeValues _price = RangeValues(
    (widget.initial.minPrice ?? 0).toDouble(),
    (widget.initial.maxPrice ?? 1000000).toDouble(),
  );
  late int? _beds = widget.initial.beds;
  late int? _baths = widget.initial.baths;
  late int? _zoneId = widget.initial.zoneId;
  late String? _zoneName = widget.initial.zoneName;
  late bool _verified = widget.initial.verified;
  late bool _featured = widget.initial.featured;
  late PropertySort _sort = widget.initial.sort;

  static const double _maxPrice = 1000000;

  void _reset() {
    setState(() {
      _type = null;
      _price = const RangeValues(0, _maxPrice);
      _beds = null;
      _baths = null;
      _zoneId = null;
      _zoneName = null;
      _verified = false;
      _featured = false;
      _sort = PropertySort.newest;
    });
  }

  Future<void> _openLocation() async {
    final zone = await ZonePickerSheet.show(context);
    if (zone == null) return;
    setState(() {
      if (zone.id == 0) {
        _zoneId = null;
        _zoneName = null;
      } else {
        _zoneId = zone.id;
        _zoneName = zone.displayName;
      }
    });
  }

  void _apply() {
    Navigator.pop(
      context,
      widget.initial.copyWith(
        type: _type,
        clearType: _type == null,
        zoneId: _zoneId,
        zoneName: _zoneName,
        clearZone: _zoneId == null,
        minPrice: _price.start == 0 ? null : _price.start,
        maxPrice: _price.end >= _maxPrice ? null : _price.end,
        clearPrice: _price.start == 0 && _price.end >= _maxPrice,
        beds: _beds,
        clearBeds: _beds == null,
        baths: _baths,
        clearBaths: _baths == null,
        verified: _verified,
        featured: _featured,
        sort: _sort,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            const SizedBox(height: 12),
            Container(
              height: 4,
              width: 44,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                children: [
                  const Text('Filters', style: AppTextStyles.headingLg),
                  const Spacer(),
                  TextButton(onPressed: _reset, child: const Text('Reset')),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: [
                  _label('Property type'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _choice('All', _type == null,
                          () => setState(() => _type = null)),
                      for (final t in [
                        ListingType.rent,
                        ListingType.sale,
                        ListingType.hotel,
                        ListingType.land,
                        ListingType.office,
                        ListingType.room,
                      ])
                        _choice(t.label, _type == t,
                            () => setState(() => _type = t)),
                    ],
                  ),
                  AppSpacing.vGapXl,
                  _label('Location'),
                  InkWell(
                    borderRadius: AppRadius.brMd,
                    onTap: _openLocation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.brMd,
                        border: Border.all(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 20, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _zoneName ?? 'Any location',
                              style: AppTextStyles.bodyMd.copyWith(
                                color: _zoneName == null
                                    ? AppColors.textTertiary
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded,
                              color: AppColors.textTertiary),
                        ],
                      ),
                    ),
                  ),
                  AppSpacing.vGapXl,
                  _label('Price range'),
                  RangeSlider(
                    values: _price,
                    max: _maxPrice,
                    divisions: 50,
                    activeColor: AppColors.primary,
                    labels: RangeLabels(
                      '\$${_price.start.toInt()}',
                      _price.end >= _maxPrice
                          ? '\$${_maxPrice.toInt()}+'
                          : '\$${_price.end.toInt()}',
                    ),
                    onChanged: (v) => setState(() => _price = v),
                  ),
                  AppSpacing.vGapMd,
                  _label('Bedrooms'),
                  _countRow(_beds, (v) => setState(() => _beds = v)),
                  AppSpacing.vGapLg,
                  _label('Bathrooms'),
                  _countRow(_baths, (v) => setState(() => _baths = v)),
                  AppSpacing.vGapLg,
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: _verified,
                    activeThumbColor: AppColors.primary,
                    title: const Text('Verified listings only',
                        style: AppTextStyles.titleSm),
                    onChanged: (v) => setState(() => _verified = v),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: _featured,
                    activeThumbColor: AppColors.primary,
                    title: const Text('Featured only', style: AppTextStyles.titleSm),
                    onChanged: (v) => setState(() => _featured = v),
                  ),
                  AppSpacing.vGapMd,
                  _label('Sort by'),
                  RadioGroup<PropertySort>(
                    groupValue: _sort,
                    onChanged: (v) => setState(() => _sort = v ?? _sort),
                    child: Column(
                      children: [
                        for (final s in PropertySort.values)
                          RadioListTile<PropertySort>(
                            contentPadding: EdgeInsets.zero,
                            value: s,
                            activeColor: AppColors.primary,
                            title: Text(s.label, style: AppTextStyles.bodyMd),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: PrimaryButton(label: 'Show results', onPressed: _apply),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text, style: AppTextStyles.titleMd),
      );

  Widget _choice(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: AppRadius.brPill,
          border: Border.all(
            color: selected
                ? AppColors.primary
                : Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.titleSm.copyWith(
            color: selected
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _countRow(int? value, ValueChanged<int?> onChanged) {
    return Wrap(
      spacing: 8,
      children: [
        _choice('Any', value == null, () => onChanged(null)),
        for (final n in [1, 2, 3, 4, 5])
          _choice(n == 5 ? '5+' : '$n', value == n, () => onChanged(n)),
      ],
    );
  }
}
