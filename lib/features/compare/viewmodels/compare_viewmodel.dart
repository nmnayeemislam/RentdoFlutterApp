import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../properties/models/property_model.dart';
import '../services/compare_service.dart';

final compareServiceProvider = Provider<CompareService>(
  (ref) => CompareService(ref.watch(apiClientProvider)),
);

/// Owns the authenticated user's persisted compare set (max a handful of
/// listings). Exposes membership + add/remove/clear used by the compare screen
/// and the per-card compare toggle.
class CompareViewModel extends AutoDisposeAsyncNotifier<List<PropertyModel>> {
  CompareService get _service => ref.read(compareServiceProvider);

  @override
  Future<List<PropertyModel>> build() => _fetch();

  Future<List<PropertyModel>> _fetch() async {
    final json = await _service.mySet();
    final data = (json['data'] as Map<String, dynamic>?) ?? const {};
    final list = (data['listings'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(PropertyModel.fromJson)
        .toList(growable: false);
    return list;
  }

  bool contains(int listingId) =>
      state.valueOrNull?.any((p) => p.id == listingId) ?? false;

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  /// Adds/removes and returns the resulting membership for the toggle button.
  Future<bool> toggle(PropertyModel property) async {
    final isIn = contains(property.id);
    if (isIn) {
      await _service.remove(property.id);
      final current = state.valueOrNull ?? const [];
      state = AsyncData(current.where((p) => p.id != property.id).toList());
      return false;
    } else {
      await _service.add(property.id);
      final current = state.valueOrNull ?? const [];
      state = AsyncData([property, ...current]);
      return true;
    }
  }

  Future<void> remove(int listingId) async {
    await _service.remove(listingId);
    final current = state.valueOrNull ?? const [];
    state = AsyncData(current.where((p) => p.id != listingId).toList());
  }

  Future<void> clear() async {
    await _service.clear();
    state = const AsyncData([]);
  }
}

final compareViewModelProvider =
    AutoDisposeAsyncNotifierProvider<CompareViewModel, List<PropertyModel>>(
        CompareViewModel.new);
