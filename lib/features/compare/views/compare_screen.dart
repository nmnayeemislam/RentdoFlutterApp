import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../properties/models/property_model.dart';
import '../viewmodels/compare_viewmodel.dart';

const _attributes = <String>[
  'Price',
  'Type',
  'Bedrooms',
  'Bathrooms',
  'Area (sqft)',
  'Furnished',
  'Parking',
  'Location',
];

const double _rowHeight = 46;
const double _headerHeight = 168;
const double _labelWidth = 104;
const double _colWidth = 168;

class CompareScreen extends ConsumerWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.watch(authViewModelProvider.select((s) => s.isAuthenticated));
    final compare = ref.watch(compareViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare'),
        actions: [
          if ((compare.valueOrNull?.isNotEmpty ?? false))
            TextButton(
              onPressed: () =>
                  ref.read(compareViewModelProvider.notifier).clear(),
              child: const Text('Clear'),
            ),
        ],
      ),
      body: !isAuthed
          ? const _GuestPrompt()
          : compare.when(
              loading: () => const LoadingWidget(),
              error: (e, _) => AppErrorWidget(
                message: '$e',
                onRetry: () =>
                    ref.read(compareViewModelProvider.notifier).refresh(),
              ),
              data: (items) => items.isEmpty
                  ? const _EmptyCompare()
                  : _CompareTable(items: items),
            ),
    );
  }
}

class _CompareTable extends ConsumerWidget {
  const _CompareTable({required this.items});
  final List<PropertyModel> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _LabelColumn(),
          for (final p in items)
            _ListingColumn(
              property: p,
              onRemove: () =>
                  ref.read(compareViewModelProvider.notifier).remove(p.id),
            ),
        ],
      ),
    );
  }
}

class _LabelColumn extends StatelessWidget {
  const _LabelColumn();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _labelWidth,
      color: context.colors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: _headerHeight),
          for (final label in _attributes)
            Container(
              height: _rowHeight,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(label,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textSecondary)),
            ),
        ],
      ),
    );
  }
}

class _ListingColumn extends StatelessWidget {
  const _ListingColumn({required this.property, required this.onRemove});
  final PropertyModel property;
  final VoidCallback onRemove;

  String _value(int i) => switch (i) {
        0 => property.priceDisplay ?? '${property.price ?? '—'}',
        1 => property.type.label,
        2 => '${property.beds ?? '—'}',
        3 => '${property.baths ?? '—'}',
        4 => property.sizeSqft == null ? '—' : '${property.sizeSqft}',
        5 => property.furnished ? 'Yes' : 'No',
        6 => property.parking ? 'Yes' : 'No',
        7 => property.location ?? property.zoneName ?? '—',
        _ => '—',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _colWidth,
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: context.colors.outline)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: _headerHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: AppRadius.brSm,
                      child: NetworkImageWidget(
                        url: property.imageUrl,
                        width: _colWidth,
                        height: 104,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: InkResponse(
                        onTap: onRemove,
                        child: const CircleAvatar(
                          radius: 13,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.close_rounded,
                              size: 16, color: AppColors.ink),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                  child: Text(
                    property.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleSm,
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < _attributes.length; i++)
            Container(
              height: _rowHeight,
              width: _colWidth,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: i.isEven ? context.colors.surface : null,
              ),
              child: Text(
                _value(i),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: i == 0
                    ? AppTextStyles.titleSm.copyWith(color: AppColors.primary)
                    : AppTextStyles.bodySm,
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyCompare extends StatelessWidget {
  const _EmptyCompare();

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.compare_arrows_rounded,
      title: 'Nothing to compare',
      subtitle: 'Add properties to compare them side by side.',
      action: SizedBox(
        width: 200,
        child: PrimaryButton(
          label: 'Browse properties',
          onPressed: () => context.go(AppRoutes.properties),
        ),
      ),
    );
  }
}

class _GuestPrompt extends StatelessWidget {
  const _GuestPrompt();

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.compare_arrows_rounded,
      title: 'Sign in to compare',
      subtitle: 'Log in to build and compare property shortlists.',
      action: SizedBox(
        width: 200,
        child: PrimaryButton(
          label: 'Log in',
          onPressed: () => context.push(AppRoutes.login),
        ),
      ),
    );
  }
}
