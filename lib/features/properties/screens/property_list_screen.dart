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
import '../../../shared/widgets/state_views.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../saved_searches/controllers/saved_search_controller.dart';
import '../controllers/property_list_controller.dart';
import '../models/property_filter.dart';
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
    if (_scroll.position.pixels >=
        _scroll.position.maxScrollExtent - 400) {
      ref.read(propertyListControllerProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openFilters() async {
    final controller = ref.read(propertyListControllerProvider.notifier);
    final current = ref.read(propertyListControllerProvider).filter;
    final result = await FilterSheet.show(context, current);
    if (result != null) await controller.applyFilter(result);
  }

  @override
  Widget build(BuildContext context) {
    // Read the notifier once; the pieces below watch only the slices they need
    // so scrolling / load-more doesn't rebuild the search bar or filter chips.
    final controller = ref.read(propertyListControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: AppSearchBar(
                controller: _searchController,
                onSubmitted: controller.setSearch,
                onFilterTap: _openFilters,
              ),
            ),
            Consumer(
              builder: (context, ref, _) {
                final type = ref.watch(propertyListControllerProvider
                    .select((s) => s.filter.type));
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
                    propertyListControllerProvider.select((s) => s.total));
                final filter = ref.watch(
                    propertyListControllerProvider.select((s) => s.filter));
                return _ResultHeader(count: total, filter: filter);
              },
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(propertyListControllerProvider);
                  return _body(state, controller);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(PropertyListState state, PropertyListController controller) {
    if (state.isLoading) return const LoadingWidget();
    if (state.isInitialError) {
      return AppErrorWidget(
        message: state.error?.message,
        onRetry: controller.load,
      );
    }
    if (state.isEmpty) {
      return EmptyState(
        title: 'No properties found',
        subtitle: 'Try adjusting your filters or search terms.',
        action: TextButton(
          onPressed: () => controller.applyFilter(
            state.filter.copyWith(clearType: true, clearPrice: true),
          ),
          child: const Text('Clear filters'),
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
          label: const Text('Retry'),
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
    final isAuthed =
        ref.read(authControllerProvider.select((s) => s.isAuthenticated));
    if (!isAuthed) {
      context.showSnack('Log in to save searches.');
      unawaited(context.push(AppRoutes.login));
      return;
    }
    try {
      await ref.read(savedSearchControllerProvider.notifier).create(
            criteria: filter.toCriteria(),
          );
      if (!context.mounted) return;
      context.showSnack('Search saved');
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
          Text('$count properties', style: AppTextStyles.titleMd),
          const Spacer(),
          if (filter.hasActiveFilters)
            TextButton.icon(
              onPressed: () => _saveSearch(context, ref),
              icon: const Icon(Icons.bookmark_add_outlined, size: 18),
              label: const Text('Save search'),
            ),
        ],
      ),
    );
  }
}
