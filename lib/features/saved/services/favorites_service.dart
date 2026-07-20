import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';

/// API layer for the favorites endpoints.
class FavoritesService {
  FavoritesService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> list({int page = 1, int perPage = 20}) async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.favorites,
      query: {'page': page, 'per_page': perPage},
    );
    return res.data ?? const {};
  }

  Future<void> add(int listingId) =>
      _api.post<dynamic>(ApiEndpoints.favorite(listingId));

  Future<void> remove(int listingId) =>
      _api.delete<dynamic>(ApiEndpoints.favorite(listingId));
}
