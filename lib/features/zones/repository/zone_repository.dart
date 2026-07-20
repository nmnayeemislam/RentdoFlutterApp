import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../models/zone_model.dart';

/// Data access for the public zones endpoints (country → city → area).
class ZoneRepository {
  ZoneRepository(this._api);

  final ApiClient _api;

  List<ZoneModel> _parseList(Map<String, dynamic>? data) {
    final list = data?['data'] as List? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(ZoneModel.fromJson)
        .toList(growable: false);
  }

  Future<List<ZoneModel>> countries() async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.zoneCountries,
      requiresAuth: false,
    );
    return _parseList(res.data);
  }

  Future<List<ZoneModel>> zones({String? query, int? parentId, String? type}) async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.zones,
      query: {
        if (query != null && query.isNotEmpty) 'search': query,
        'parent_id': ?parentId,
        'type': ?type,
        'per_page': 50,
      },
      requiresAuth: false,
    );
    return _parseList(res.data);
  }

  Future<List<ZoneModel>> areas(int zoneId) async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.zoneAreas(zoneId),
      requiresAuth: false,
    );
    return _parseList(res.data);
  }

  Future<ZoneModel?> resolve({required double lat, required double lng}) async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.zoneResolve,
      query: {'lat': lat, 'lng': lng},
      requiresAuth: false,
    );
    final data = res.data?['data'] as Map<String, dynamic>?;
    return data == null ? null : ZoneModel.fromJson(data);
  }
}
