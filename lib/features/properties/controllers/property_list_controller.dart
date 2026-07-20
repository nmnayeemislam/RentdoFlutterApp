import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../models/property_filter.dart';
import '../models/property_model.dart';
import 'property_providers.dart';

/// View state for the paginated property list.
@immutable
class PropertyListState {
  const PropertyListState({
    this.items = const [],
    this.filter = const PropertyFilter(),
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.error,
    this.page = 1,
    this.hasMore = true,
    this.total = 0,
  });

  final List<PropertyModel> items;
  final PropertyFilter filter;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isRefreshing;
  final ApiException? error;
  final int page;
  final bool hasMore;
  final int total;

  bool get isEmpty => !isLoading && error == null && items.isEmpty;
  bool get isInitialError => error != null && items.isEmpty;

  PropertyListState copyWith({
    List<PropertyModel>? items,
    PropertyFilter? filter,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    ApiException? error,
    int? page,
    bool? hasMore,
    int? total,
    bool clearError = false,
  }) {
    return PropertyListState(
      items: items ?? this.items,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: clearError ? null : (error ?? this.error),
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      total: total ?? this.total,
    );
  }
}

/// Owns list loading, pagination, pull-to-refresh and filter application.
/// Handles Loading / Success / Empty / Error / Retry states end-to-end.
class PropertyListController extends AutoDisposeNotifier<PropertyListState> {
  /// Bumped on every reset (load / refresh / filter change). An in-flight
  /// `loadMore` compares against this and discards its result if superseded,
  /// preventing stale pages from being appended onto a newer list.
  int _generation = 0;

  @override
  PropertyListState build() {
    Future.microtask(load);
    return const PropertyListState(isLoading: true);
  }

  Future<void> load() async {
    final gen = ++_generation;
    state = state.copyWith(isLoading: true, clearError: true);
    await _fetch(gen: gen, page: 1, replace: true);
  }

  Future<void> refresh() async {
    final gen = ++_generation;
    state = state.copyWith(isRefreshing: true, clearError: true);
    await _fetch(gen: gen, page: 1, replace: true);
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore ||
        !state.hasMore ||
        state.isLoading ||
        state.error != null) {
      return;
    }
    final gen = _generation;
    state = state.copyWith(isLoadingMore: true);
    await _fetch(gen: gen, page: state.page + 1, replace: false);
  }

  /// Retries a failed page-append without resetting the list.
  Future<void> retryLoadMore() async {
    if (state.isLoadingMore || state.error == null || state.items.isEmpty) {
      return;
    }
    final gen = _generation;
    state = state.copyWith(isLoadingMore: true, clearError: true);
    await _fetch(gen: gen, page: state.page + 1, replace: false);
  }

  /// Applies a new filter and reloads from page 1.
  Future<void> applyFilter(PropertyFilter filter) async {
    final gen = ++_generation;
    state = state.copyWith(filter: filter, isLoading: true, clearError: true);
    await _fetch(gen: gen, page: 1, replace: true);
  }

  void setSearch(String value) {
    final trimmed = value.trim();
    applyFilter(
      trimmed.isEmpty
          ? state.filter.copyWith(clearSearch: true)
          : state.filter.copyWith(search: trimmed),
    );
  }

  void setType(ListingType? type) {
    applyFilter(type == null
        ? state.filter.copyWith(clearType: true)
        : state.filter.copyWith(type: type));
  }

  Future<void> _fetch({
    required int gen,
    required int page,
    required bool replace,
  }) async {
    final repo = ref.read(propertyRepositoryProvider);
    try {
      final result = await repo.fetchProperties(state.filter, page: page);
      // Discard results from a request superseded by a newer reset.
      if (gen != _generation) return;
      final items =
          replace ? result.items : [...state.items, ...result.items];
      state = state.copyWith(
        items: items,
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        page: result.currentPage,
        hasMore: result.hasMore,
        total: result.total,
        clearError: true,
      );
    } on ApiException catch (e) {
      if (gen != _generation) return;
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        error: e,
      );
    }
  }
}

final propertyListControllerProvider = AutoDisposeNotifierProvider<
    PropertyListController, PropertyListState>(PropertyListController.new);
