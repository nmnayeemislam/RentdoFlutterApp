import 'package:dio/dio.dart';

import '../../../shared/models/paginated_response.dart';
import '../models/property_filter.dart';
import '../models/property_model.dart';
import '../services/property_service.dart';

/// Maps listing API responses into domain models and exposes a clean surface
/// to controllers. All pagination logic is normalized here.
class PropertyRepository {
  PropertyRepository(this._service);

  final PropertyService _service;

  Future<PaginatedResponse<PropertyModel>> fetchProperties(
    PropertyFilter filter, {
    int page = 1,
    int perPage = 15,
    CancelToken? cancelToken,
  }) async {
    final json = await _service.list(
      filter.toQuery(page: page, perPage: perPage),
      cancelToken: cancelToken,
    );
    return PaginatedResponse<PropertyModel>.fromJson(
      json,
      PropertyModel.fromJson,
    );
  }

  /// Listings inside a map viewport, filtered by [filter] (paging/sort dropped —
  /// the map shows up to 100 pins in view).
  Future<List<PropertyModel>> fetchInBounds({
    required double swLat,
    required double swLng,
    required double neLat,
    required double neLng,
    PropertyFilter? filter,
    CancelToken? cancelToken,
  }) async {
    final extra = Map<String, dynamic>.of(filter?.toQuery() ?? const {})
      ..remove('page')
      ..remove('per_page');
    final json = await _service.listInBounds(
      swLat: swLat,
      swLng: swLng,
      neLat: neLat,
      neLng: neLng,
      extra: extra,
      cancelToken: cancelToken,
    );
    return (json['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(PropertyModel.fromJson)
        .toList(growable: false);
  }

  Future<PropertyModel> fetchDetail(int id) async {
    final json = await _service.detail(id);
    final data = (json['data'] as Map<String, dynamic>?) ?? json;
    return PropertyModel.fromJson(data);
  }

  Future<String?> revealContact(int id) => _service.revealContact(id);
}
