import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/screen_loading_overlay.dart';
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
  bool _applying = false;

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

  Future<void> _apply() async {
    setState(() => _applying = true);
    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (!mounted) return;
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
        return ScreenLoadingOverlay(
          loading: _applying,
          child: Column(
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
                padding: const EdgeInsetsDirectional.only(
                  start: 20,
                  top: 12,
                  end: 20,
                  bottom: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      context.l10n.filtersTitle,
                      style: AppTextStyles.headingLg,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _applying ? null : _reset,
                      child: Text(context.l10n.reset),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsetsDirectional.only(
                    start: 20,
                    end: 20,
                    bottom: 20,
                  ),
                  children: [
                    _label(context.l10n.filterPropertyType),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _choice(
                          context.l10n.all,
                          _type == null,
                          _applying
                              ? () {}
                              : () => setState(() => _type = null),
                        ),
                        for (final t in [
                          ListingType.rent,
                          ListingType.sale,
                          ListingType.hotel,
                          ListingType.land,
                          ListingType.office,
                          ListingType.room,
                        ])
                          _choice(
                            t.label,
                            _type == t,
                            _applying ? () {} : () => setState(() => _type = t),
                          ),
                      ],
                    ),
                    AppSpacing.vGapXl,
                    _label(context.l10n.compareAttrLocation),
                    InkWell(
                      borderRadius: AppRadius.brMd,
                      onTap: _applying ? null : _openLocation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: AppRadius.brMd,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _zoneName ?? context.l10n.filterAnyLocation,
                                style: AppTextStyles.bodyMd.copyWith(
                                  color: _zoneName == null
                                      ? AppColors.textTertiary
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.textTertiary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppSpacing.vGapXl,
                    _label(context.l10n.filterPriceRange),
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
                      onChanged: _applying
                          ? null
                          : (v) => setState(() => _price = v),
                    ),
                    AppSpacing.vGapMd,
                    _label(context.l10n.compareAttrBedrooms),
                    _countRow(
                      _beds,
                      _applying ? (_) {} : (v) => setState(() => _beds = v),
                    ),
                    AppSpacing.vGapLg,
                    _label(context.l10n.compareAttrBathrooms),
                    _countRow(
                      _baths,
                      _applying ? (_) {} : (v) => setState(() => _baths = v),
                    ),
                    AppSpacing.vGapLg,
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: _verified,
                      activeThumbColor: AppColors.primary,
                      title: Text(
                        context.l10n.filterVerifiedOnly,
                        style: AppTextStyles.titleSm,
                      ),
                      onChanged: _applying
                          ? null
                          : (v) => setState(() => _verified = v),
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: _featured,
                      activeThumbColor: AppColors.primary,
                      title: Text(
                        context.l10n.filterFeaturedOnly,
                        style: AppTextStyles.titleSm,
                      ),
                      onChanged: _applying
                          ? null
                          : (v) => setState(() => _featured = v),
                    ),
                    AppSpacing.vGapMd,
                    _label(context.l10n.filterSortBy),
                    RadioGroup<PropertySort>(
                      groupValue: _sort,
                      onChanged: _applying
                          ? (_) {}
                          : (v) => setState(() => _sort = v ?? _sort),
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
                  padding: const EdgeInsetsDirectional.only(
                    start: 20,
                    top: 8,
                    end: 20,
                    bottom: 12,
                  ),
                  child: PrimaryButton(
                    label: context.l10n.filterShowResults,
                    isLoading: _applying,
                    onPressed: _apply,
                  ),
                ),
              ),
            ],
          ),
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
      onTap: _applying ? null : onTap,
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
        _choice(context.l10n.any, value == null, () => onChanged(null)),
        for (final n in [1, 2, 3, 4, 5])
          _choice(n == 5 ? '5+' : '$n', value == n, () => onChanged(n)),
      ],
    );
  }
}
