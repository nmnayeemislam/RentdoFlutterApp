import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/state_views.dart';
import '../models/zone_model.dart';
import '../providers/zone_providers.dart';

/// Bottom-sheet zone search. Returns the picked [ZoneModel] via `Navigator.pop`,
/// or a zone with id 0 to signify "clear".
class ZonePickerSheet extends ConsumerStatefulWidget {
  const ZonePickerSheet({super.key});

  static Future<ZoneModel?> show(BuildContext context) {
    return showModalBottomSheet<ZoneModel>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ZonePickerSheet(),
    );
  }

  @override
  ConsumerState<ZonePickerSheet> createState() => _ZonePickerSheetState();
}

class _ZonePickerSheetState extends ConsumerState<ZonePickerSheet> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(zoneSearchProvider(_query));

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
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
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    Text(context.l10n.ownerChooseLocationPlaceholder,
                        style: AppTextStyles.headingMd),
                    const Spacer(),
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context, const ZoneModel(id: 0, name: '')),
                      child: Text(context.l10n.clear),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _controller,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: context.l10n.zoneSearchHint,
                    prefixIcon: const Icon(Icons.search_rounded),
                  ),
                ),
              ),
              AppSpacing.vGapMd,
              Expanded(
                child: results.when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, _) => AppErrorWidget(
                    message: '$e',
                    onRetry: () => ref.invalidate(zoneSearchProvider(_query)),
                  ),
                  data: (zones) => zones.isEmpty
                      ? EmptyState(
                          title: context.l10n.zoneNoLocationsFound,
                          icon: Icons.location_off_outlined,
                        )
                      : ListView.separated(
                          controller: scrollController,
                          itemCount: zones.length,
                          separatorBuilder: (_, _) =>
                              const Divider(height: 1, indent: 56),
                          itemBuilder: (context, i) {
                            final zone = zones[i];
                            return ListTile(
                              leading: const Icon(Icons.location_on_outlined,
                                  color: AppColors.primary),
                              title: Text(zone.name,
                                  style: AppTextStyles.titleSm),
                              subtitle: zone.type != null
                                  ? Text(zone.type!,
                                      style: AppTextStyles.caption)
                                  : null,
                              onTap: () => Navigator.pop(context, zone),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
