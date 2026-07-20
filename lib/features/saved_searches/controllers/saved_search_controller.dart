import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/core_providers.dart';
import '../models/saved_search.dart';

/// API layer for saved searches.
class SavedSearchService {
  SavedSearchService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> list() async {
    final res = await _api.get<Map<String, dynamic>>(ApiEndpoints.savedSearches);
    return res.data ?? const {};
  }

  Future<void> create({
    String? name,
    required Map<String, dynamic> criteria,
    bool alertOn = false,
  }) =>
      _api.post<dynamic>(
        ApiEndpoints.savedSearches,
        data: {
          if (name != null && name.isNotEmpty) 'name': name,
          'criteria': criteria,
          'alert_on': alertOn,
        },
      );

  Future<void> update(int id, {bool? alertOn, String? name}) => _api.put<dynamic>(
        ApiEndpoints.savedSearch(id),
        data: {
          'alert_on': ?alertOn,
          'name': ?name,
        },
      );

  Future<void> destroy(int id) =>
      _api.delete<dynamic>(ApiEndpoints.savedSearch(id));
}

final savedSearchServiceProvider = Provider<SavedSearchService>(
  (ref) => SavedSearchService(ref.watch(apiClientProvider)),
);

/// The authenticated user's saved searches.
class SavedSearchController extends AutoDisposeAsyncNotifier<List<SavedSearch>> {
  SavedSearchService get _service => ref.read(savedSearchServiceProvider);

  @override
  Future<List<SavedSearch>> build() => _fetch();

  Future<List<SavedSearch>> _fetch() async {
    final json = await _service.list();
    return (json['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(SavedSearch.fromJson)
        .toList(growable: false);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> create({
    String? name,
    required Map<String, dynamic> criteria,
    bool alertOn = false,
  }) async {
    await _service.create(name: name, criteria: criteria, alertOn: alertOn);
    await refresh();
  }

  Future<void> delete(int id) async {
    await _service.destroy(id);
    final current = state.valueOrNull ?? const [];
    state = AsyncData(current.where((s) => s.id != id).toList());
  }

  /// Toggles the match-alert flag and reflects it optimistically.
  Future<void> setAlert(int id, bool alertOn) async {
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData([
        for (final s in current)
          s.id == id
              ? SavedSearch(
                  id: s.id, name: s.name, criteria: s.criteria, alertOn: alertOn)
              : s,
      ]);
    }
    await _service.update(id, alertOn: alertOn);
  }
}

final savedSearchControllerProvider =
    AutoDisposeAsyncNotifierProvider<SavedSearchController, List<SavedSearch>>(
        SavedSearchController.new);
