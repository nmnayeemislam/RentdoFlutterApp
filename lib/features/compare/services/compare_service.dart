import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';

/// API layer for the compare-set endpoints.
class CompareService {
  CompareService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> mySet() async {
    final res = await _api.get<Map<String, dynamic>>(ApiEndpoints.compareMine);
    return res.data ?? const {};
  }

  Future<void> add(int listingId) =>
      _api.post<dynamic>(ApiEndpoints.compareItem(listingId));

  Future<void> remove(int listingId) =>
      _api.delete<dynamic>(ApiEndpoints.compareItem(listingId));

  Future<void> clear() => _api.delete<dynamic>(ApiEndpoints.compare);
}
