import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../../shared/widgets/state_views.dart';
import '../viewmodels/technician_viewmodel.dart';

/// Public, browsable list of technicians filterable by service category.
class TechniciansScreen extends ConsumerStatefulWidget {
  const TechniciansScreen({super.key});

  @override
  ConsumerState<TechniciansScreen> createState() => _TechniciansScreenState();
}

class _TechniciansScreenState extends ConsumerState<TechniciansScreen> {
  int _categoryId = 0;

  @override
  Widget build(BuildContext context) {
    final technicians = ref.watch(techniciansProvider(_categoryId));

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.technicianFindTitle)),
      body: Column(
        children: [
          _CategoryBar(
            selected: _categoryId,
            onSelected: (id) => setState(() => _categoryId = id),
          ),
          AppSpacing.vGapSm,
          Expanded(
            child: technicians.when(
              loading: () => const LoadingWidget(),
              error: (e, _) => AppErrorWidget(
                message: '$e',
                onRetry: () =>
                    ref.invalidate(techniciansProvider(_categoryId)),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return EmptyState(
                    icon: Icons.handyman_outlined,
                    title: context.l10n.technicianNoneFound,
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, i) =>
                      _TechnicianCard(technician: items[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBar extends ConsumerWidget {
  const _CategoryBar({required this.selected, required this.onSelected});

  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(technicianCategoriesProvider);
    final chips = <(int, String)>[(0, context.l10n.all)];
    categories.whenData((items) {
      for (final c in items) {
        chips.add((c.id, c.name));
      }
    });

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final (id, label) = chips[i];
          final isSel = id == selected;
          return GestureDetector(
            onTap: () => onSelected(id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSel ? AppColors.primary : context.colors.surface,
                borderRadius: AppRadius.brPill,
                border: Border.all(
                  color: isSel ? AppColors.primary : context.colors.outline,
                ),
              ),
              child: Text(
                label,
                style: AppTextStyles.titleSm.copyWith(
                  color: isSel ? Colors.white : context.colors.onSurface,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TechnicianCard extends StatelessWidget {
  const _TechnicianCard({required this.technician});

  final TechnicianModel technician;

  @override
  Widget build(BuildContext context) {
    final name = (technician.name != null && technician.name!.isNotEmpty)
        ? technician.name!
        : context.l10n.technicianFallback(technician.id);
    final rate = technician.hourlyRate;

    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRoutes.technicianDetailName,
        pathParameters: {'id': '${technician.id}'},
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: AppRadius.brLg,
          border: Border.all(color: context.colors.outline),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Avatar(url: technician.avatar),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.titleMd,
                        ),
                      ),
                      if (technician.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: AppColors.verified,
                        ),
                      ],
                    ],
                  ),
                  if (technician.categoryName != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      technician.categoryName!,
                      style: AppTextStyles.bodySm,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: AppColors.rating,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        technician.rating.toStringAsFixed(1),
                        style: AppTextStyles.titleSm,
                      ),
                      if (rate != null) ...[
                        const SizedBox(width: AppSpacing.md),
                        Text(
                          '${Formatters.money(rate)}${context.l10n.technicianPerHour}',
                          style: AppTextStyles.titleSm.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _AvailabilityLabel(isAvailable: technician.isAvailable),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url != null && url!.isNotEmpty) {
      return NetworkImageWidget(
        url: url,
        width: 52,
        height: 52,
        borderRadius: BorderRadius.circular(26),
      );
    }
    return const CircleAvatar(
      radius: 26,
      backgroundColor: AppColors.primarySurface,
      child: Icon(Icons.person, color: AppColors.primary),
    );
  }
}

class _AvailabilityLabel extends StatelessWidget {
  const _AvailabilityLabel({required this.isAvailable});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final color = isAvailable ? AppColors.success : AppColors.textTertiary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          isAvailable ? context.l10n.technicianAvailable : context.l10n.technicianBusy,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
