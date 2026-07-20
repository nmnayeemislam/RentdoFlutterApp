import 'property_model.dart';

/// Immutable query/filter state for the listing search. Serializes to the query
/// params the `GET /listings` endpoint expects.
class PropertyFilter {
  const PropertyFilter({
    this.search,
    this.type,
    this.zoneId,
    this.zoneName,
    this.minPrice,
    this.maxPrice,
    this.beds,
    this.baths,
    this.allowedFor,
    this.furnished,
    this.parking,
    this.featured = false,
    this.verified = false,
    this.sort = PropertySort.newest,
  });

  final String? search;
  final ListingType? type;
  final int? zoneId;
  final String? zoneName;
  final num? minPrice;
  final num? maxPrice;
  final int? beds;
  final int? baths;

  /// `bachelor` | `family` | `both`.
  final String? allowedFor;
  final bool? furnished;
  final bool? parking;
  final bool featured;
  final bool verified;
  final PropertySort sort;

  bool get hasActiveFilters =>
      type != null ||
      zoneId != null ||
      minPrice != null ||
      maxPrice != null ||
      beds != null ||
      baths != null ||
      allowedFor != null ||
      furnished != null ||
      parking != null ||
      featured ||
      verified ||
      sort != PropertySort.newest;

  Map<String, dynamic> toQuery({int page = 1, int perPage = 15}) {
    // Laravel's `boolean` validation rule rejects the string "true"/"false"
    // that Dio serializes bools to in a query string, so booleans are sent
    // as 1/0.
    String bit(bool v) => v ? '1' : '0';
    return {
      'page': page,
      'per_page': perPage,
      if (search != null && search!.isNotEmpty) 'keyword': search,
      if (type != null && type != ListingType.unknown) 'type': type!.apiValue,
      if (zoneId != null) 'zone_id': zoneId,
      if (zoneId != null) 'include_children': '1',
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
      if (beds != null) 'bedrooms': beds,
      if (baths != null) 'bathrooms': baths,
      if (allowedFor != null) 'allowed_for': allowedFor,
      if (furnished != null) 'furnished': bit(furnished!),
      if (parking != null) 'parking': bit(parking!),
      if (featured) 'featured': '1',
      if (verified) 'verified': '1',
      'sort': sort.query,
    };
  }

  /// Serializes the active filters into a `criteria` map for a saved search
  /// (JSON body, so real booleans are fine here — unlike [toQuery]).
  Map<String, dynamic> toCriteria() {
    return {
      if (search != null && search!.isNotEmpty) 'keyword': search,
      if (type != null && type != ListingType.unknown) 'type': type!.apiValue,
      if (zoneId != null) 'zone_id': zoneId,
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
      if (beds != null) 'bedrooms': beds,
      if (baths != null) 'bathrooms': baths,
      if (allowedFor != null) 'allowed_for': allowedFor,
      if (furnished != null) 'furnished': furnished,
      if (parking != null) 'parking': parking,
    };
  }

  /// Rebuilds a filter from a saved-search `criteria` map.
  factory PropertyFilter.fromCriteria(Map<String, dynamic> c) {
    num? asNum(dynamic v) => v is num ? v : num.tryParse('$v');
    int? asInt(dynamic v) => v is num ? v.toInt() : int.tryParse('$v');
    return PropertyFilter(
      search: c['keyword'] as String?,
      type: c['type'] != null ? ListingType.fromString('${c['type']}') : null,
      zoneId: asInt(c['zone_id']),
      zoneName: c['zone_name'] as String?,
      minPrice: asNum(c['min_price']),
      maxPrice: asNum(c['max_price']),
      beds: asInt(c['bedrooms']),
      baths: asInt(c['bathrooms']),
      allowedFor: c['allowed_for'] as String?,
      furnished: c['furnished'] is bool ? c['furnished'] as bool : null,
      parking: c['parking'] is bool ? c['parking'] as bool : null,
    );
  }

  PropertyFilter copyWith({
    String? search,
    ListingType? type,
    int? zoneId,
    String? zoneName,
    num? minPrice,
    num? maxPrice,
    int? beds,
    int? baths,
    String? allowedFor,
    bool? furnished,
    bool? parking,
    bool? featured,
    bool? verified,
    PropertySort? sort,
    bool clearType = false,
    bool clearZone = false,
    bool clearPrice = false,
    bool clearBeds = false,
    bool clearBaths = false,
    bool clearSearch = false,
    bool clearAllowedFor = false,
    bool clearFurnished = false,
    bool clearParking = false,
  }) {
    return PropertyFilter(
      search: clearSearch ? null : (search ?? this.search),
      type: clearType ? null : (type ?? this.type),
      zoneId: clearZone ? null : (zoneId ?? this.zoneId),
      zoneName: clearZone ? null : (zoneName ?? this.zoneName),
      minPrice: clearPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPrice ? null : (maxPrice ?? this.maxPrice),
      beds: clearBeds ? null : (beds ?? this.beds),
      baths: clearBaths ? null : (baths ?? this.baths),
      allowedFor: clearAllowedFor ? null : (allowedFor ?? this.allowedFor),
      furnished: clearFurnished ? null : (furnished ?? this.furnished),
      parking: clearParking ? null : (parking ?? this.parking),
      featured: featured ?? this.featured,
      verified: verified ?? this.verified,
      sort: sort ?? this.sort,
    );
  }
}

enum PropertySort {
  newest('newest', 'Newest'),
  priceLow('price_asc', 'Price: Low to High'),
  priceHigh('price_desc', 'Price: High to Low');

  const PropertySort(this.query, this.label);
  final String query;
  final String label;
}
