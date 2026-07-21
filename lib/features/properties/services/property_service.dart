import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';

/// API layer for listing endpoints. Returns the raw envelope map; mapping to
/// models happens in the repository.
class PropertyService {
  PropertyService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> list(
    Map<String, dynamic> query, {
    CancelToken? cancelToken,
  }) async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.listings,
      query: query,
      requiresAuth: false,
      cancelToken: cancelToken,
    );
    return res.data ?? const {};
  }

  /// Listings whose coordinates fall inside a map viewport
  /// (`sw_lat`/`sw_lng`/`ne_lat`/`ne_lng`). [extra] carries the active filter
  /// query so the map respects type/price/etc.
  Future<Map<String, dynamic>> listInBounds({
    required double swLat,
    required double swLng,
    required double neLat,
    required double neLng,
    Map<String, dynamic> extra = const {},
    CancelToken? cancelToken,
  }) {
    return list({
      ...extra,
      'sw_lat': swLat,
      'sw_lng': swLng,
      'ne_lat': neLat,
      'ne_lng': neLng,
      'per_page': 100,
      'page': 1,
    }, cancelToken: cancelToken);
  }

  Future<Map<String, dynamic>> detail(int id) async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.listing(id),
      requiresAuth: false,
    );
    return res.data ?? const {};
  }

  /// Creates a listing (multipart so photos can be attached inline).
  Future<void> createListing({
    required int zoneId,
    required String type,
    required String title,
    required int price,
    String? description,
    int? bedrooms,
    int? bathrooms,
    int? areaSqft,
    String? allowedFor,
    bool furnished = false,
    bool parking = false,
    String? address,
    List<String> imagePaths = const [],
  }) async {
    final formData = FormData();
    formData.fields.addAll([
      MapEntry('zone_id', '$zoneId'),
      MapEntry('type', type),
      MapEntry('title', title),
      MapEntry('price', '$price'),
      MapEntry('furnished', furnished ? '1' : '0'),
      MapEntry('parking', parking ? '1' : '0'),
      if (description != null && description.isNotEmpty)
        MapEntry('description', description),
      if (bedrooms != null) MapEntry('bedrooms', '$bedrooms'),
      if (bathrooms != null) MapEntry('bathrooms', '$bathrooms'),
      if (areaSqft != null) MapEntry('area_sqft', '$areaSqft'),
      if (allowedFor != null) MapEntry('allowed_for', allowedFor),
      if (address != null && address.isNotEmpty) MapEntry('address', address),
    ]);
    for (final path in imagePaths) {
      formData.files.add(MapEntry('images[]', await MultipartFile.fromFile(path)));
    }
    await _api.upload<dynamic>(ApiEndpoints.listings, formData: formData);
  }

  /// Updates a listing's editable fields (JSON; media managed separately).
  Future<void> updateListing(
    int id, {
    required int zoneId,
    required String type,
    required String title,
    required int price,
    String? description,
    int? bedrooms,
    int? bathrooms,
    int? areaSqft,
    String? allowedFor,
    bool furnished = false,
    bool parking = false,
    String? address,
  }) =>
      _api.put<dynamic>(ApiEndpoints.listing(id), data: {
        'zone_id': zoneId,
        'type': type,
        'title': title,
        'price': price,
        'furnished': furnished,
        'parking': parking,
        if (description != null && description.isNotEmpty)
          'description': description,
        'bedrooms': ?bedrooms,
        'bathrooms': ?bathrooms,
        'area_sqft': ?areaSqft,
        'allowed_for': ?allowedFor,
        if (address != null && address.isNotEmpty) 'address': address,
      });

  /// Adds photos to an existing listing (`POST /listings/{id}/media`).
  Future<void> uploadMedia(int listingId, List<String> imagePaths,
      {int? coverIndex}) async {
    if (imagePaths.isEmpty) return;
    final formData = FormData();
    if (coverIndex != null) {
      formData.fields.add(MapEntry('cover_index', '$coverIndex'));
    }
    for (final path in imagePaths) {
      formData.files.add(MapEntry('images[]', await MultipartFile.fromFile(path)));
    }
    await _api.upload<dynamic>(
      ApiEndpoints.listingMedia(listingId),
      formData: formData,
    );
  }

  /// Removes a single photo/video (`DELETE /listings/{id}/media/{type}/{mediaId}`).
  Future<void> deleteMedia(int listingId, int mediaId,
          {String type = 'image'}) =>
      _api.delete<dynamic>(
        '${ApiEndpoints.listingMedia(listingId)}/$type/$mediaId',
      );

  /// Deletes one of the owner's listings.
  Future<void> deleteListing(int id) =>
      _api.delete<dynamic>(ApiEndpoints.listing(id));

  /// The authenticated owner's own listings (any status).
  Future<Map<String, dynamic>> ownerListings(int ownerId) async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.listings,
      query: {'owner_id': ownerId, 'per_page': 50},
    );
    return res.data ?? const {};
  }

  /// Updates a listing's status (`rented` | `sold` | `archived`).
  Future<void> updateStatus(int id, String status) => _api.patch<dynamic>(
        ApiEndpoints.listingStatus(id),
        data: {'status': status},
      );

  /// Hotel availability calendar for a date window (hotel-type listings only).
  Future<Map<String, dynamic>> availability(
    int id, {
    required DateTime from,
    required DateTime to,
  }) async {
    String ymd(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.listingAvailability(id),
      query: {'from': ymd(from), 'to': ymd(to)},
      requiresAuth: false,
    );
    return (res.data?['data'] as Map<String, dynamic>?) ?? const {};
  }

  /// Straight-line distance from the listing to a coordinate.
  Future<Map<String, dynamic>> distance(
    int id, {
    required double lat,
    required double lng,
  }) async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.listingDistance(id),
      query: {'lat': lat, 'lng': lng},
      requiresAuth: false,
    );
    return (res.data?['data'] as Map<String, dynamic>?) ?? const {};
  }

  /// Shareable link/metadata for a listing.
  Future<Map<String, dynamic>> share(int id) async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.listingShare(id),
      requiresAuth: false,
    );
    return (res.data?['data'] as Map<String, dynamic>?) ?? const {};
  }

  /// Reveals the owner's phone (auth + quota enforced server-side).
  Future<String?> revealContact(int id) async {
    final res = await _api.post<Map<String, dynamic>>(
      ApiEndpoints.listingRevealContact(id),
    );
    final data = res.data?['data'] as Map<String, dynamic>?;
    return data?['phone'] as String?;
  }
}
