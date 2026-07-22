import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/animations.dart';
import '../../../shared/widgets/app_search_bar.dart';
import '../../../shared/widgets/skeletons.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../saved_searches/viewmodels/saved_search_viewmodel.dart';
import '../models/property_filter.dart';
import '../viewmodels/property_list_viewmodel.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/property_card.dart';
import '../widgets/type_filter_bar.dart';

/// Paginated, filterable property list (the "Search" tab).
class PropertyListScreen extends ConsumerStatefulWidget {
  const PropertyListScreen({super.key});

  @override
  ConsumerState<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends ConsumerState<PropertyListScreen> {
  final _scroll = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 400) {
      ref.read(propertyListViewModelProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openFilters() async {
    final controller = ref.read(propertyListViewModelProvider.notifier);
    final current = ref.read(propertyListViewModelProvider).filter;
    final result = await FilterSheet.show(context, current);
    if (result != null) await controller.applyFilter(result);
  }

  @override
  Widget build(BuildContext context) {
    // Read the notifier once; the pieces below watch only the slices they need
    // so scrolling / load-more doesn't rebuild the search bar or filter chips.
    final controller = ref.read(propertyListViewModelProvider.notifier);
    final state = ref.watch(propertyListViewModelProvider);
    final hideMapButton = state.error?.type == ApiErrorType.network;

    return Scaffold(
      floatingActionButton: hideMapButton
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.push(AppRoutes.mapSearch),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.map_outlined),
              label: Text(context.l10n.map),
            ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Consumer(
                builder: (context, ref, _) {
                  final active = ref.watch(
                    propertyListViewModelProvider.select(
                      (s) => s.filter.hasActiveFilters,
                    ),
                  );
                  return AppSearchBar(
                    controller: _searchController,
                    onSubmitted: controller.setSearch,
                    onFilterTap: _openFilters,
                    filterActive: active,
                  );
                },
              ),
            ),
            Consumer(
              builder: (context, ref, _) {
                final type = ref.watch(
                  propertyListViewModelProvider.select((s) => s.filter.type),
                );
                return TypeFilterBar(
                  selected: type,
                  onSelected: controller.setType,
                );
              },
            ),
            AppSpacing.vGapMd,
            Consumer(
              builder: (context, ref, _) {
                final total = ref.watch(
                  propertyListViewModelProvider.select((s) => s.total),
                );
                final filter = ref.watch(
                  propertyListViewModelProvider.select((s) => s.filter),
                );
                return _ResultHeader(count: total, filter: filter);
              },
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(propertyListViewModelProvider);
                  return _body(state, controller);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(PropertyListState state, PropertyListViewModel controller) {
    if (state.isLoading) return const PropertyListSkeleton();
    if (state.isInitialError) {
      return AppErrorWidget(
        message: state.error?.message,
        onRetry: controller.load,
      );
    }
    if (state.isEmpty) {
      return EmptyState(
        title: context.l10n.propertiesNoneFound,
        subtitle: context.l10n.propertiesTryAdjusting,
        action: TextButton(
          onPressed: () => controller.applyFilter(
            state.filter.copyWith(clearType: true, clearPrice: true),
          ),
          child: Text(context.l10n.clearFilters),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: controller.refresh,
      child: ListView.separated(
        controller: _scroll,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        itemCount: state.items.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index >= state.items.length) {
            // A failed page-append shows a retry affordance instead of an
            // endless spinner.
            if (state.error != null) {
              return _LoadMoreError(onRetry: controller.retryLoadMore);
            }
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2.4)),
            );
          }
          final property = state.items[index];
          return FadeSlideIn(
            // Windowed stagger so each visible batch cascades in without
            // long delays deep in the list.
            delay: Duration(milliseconds: (index % 6) * 55),
            child: PropertyCard(
              property: property,
              onTap: () => context.pushNamed(
                AppRoutes.propertyDetailName,
                pathParameters: {'id': '${property.id}'},
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LoadMoreError extends StatelessWidget {
  const _LoadMoreError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: TextButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: Text(context.l10n.retry),
        ),
      ),
    );
  }
}

class _ResultHeader extends ConsumerWidget {
  const _ResultHeader({required this.count, required this.filter});
  final int count;
  final PropertyFilter filter;

  Future<void> _saveSearch(BuildContext context, WidgetRef ref) async {
    final isAuthed = ref.read(
      authViewModelProvider.select((s) => s.isAuthenticated),
    );
    if (!isAuthed) {
      context.showSnack(context.l10n.propertiesLogInToSaveSearches);
      unawaited(context.push(AppRoutes.login));
      return;
    }
    try {
      await ref
          .read(savedSearchViewModelProvider.notifier)
          .create(criteria: filter.toCriteria());
      if (!context.mounted) return;
      context.showSnack(context.l10n.propertiesSearchSaved);
    } on ApiException catch (e) {
      if (!context.mounted) return;
      context.showSnack(e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 4),
      child: Row(
        children: [
          Text(
            context.l10n.propertiesCount(count),
            style: AppTextStyles.titleMd,
          ),
          const Spacer(),
          if (filter.hasActiveFilters)
            TextButton.icon(
              onPressed: () => _saveSearch(context, ref),
              icon: const Icon(Icons.bookmark_add_outlined, size: 18),
              label: Text(context.l10n.propertiesSaveSearch),
            ),
        ],
      ),
    );
  }
}
