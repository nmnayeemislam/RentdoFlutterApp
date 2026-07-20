import 'package:equatable/equatable.dart';

/// Listing category / purpose. Mirrors the backend `property-types` keys.
enum ListingType {
  rent,
  sale,
  hotel,
  mess,
  land,
  commercial,
  office,
  room,
  vacation,
  parking,
  unknown;

  static ListingType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'rent':
        return ListingType.rent;
      case 'sale':
        return ListingType.sale;
      case 'hotel':
        return ListingType.hotel;
      case 'mess':
        return ListingType.mess;
      case 'land':
        return ListingType.land;
      case 'commercial':
        return ListingType.commercial;
      case 'office':
        return ListingType.office;
      case 'room':
        return ListingType.room;
      case 'vacation':
        return ListingType.vacation;
      case 'parking':
        return ListingType.parking;
      default:
        return ListingType.unknown;
    }
  }

  String get apiValue => name;

  String get label => switch (this) {
        ListingType.rent => 'Rent',
        ListingType.sale => 'For Sale',
        ListingType.hotel => 'Hotel',
        ListingType.mess => 'Mess',
        ListingType.land => 'Land',
        ListingType.commercial => 'Commercial',
        ListingType.office => 'Office',
        ListingType.room => 'Room',
        ListingType.vacation => 'Vacation',
        ListingType.parking => 'Parking',
        ListingType.unknown => 'Property',
      };

  /// Suffix appended after price, e.g. "night", "month", or "" for sale/land.
  String get pricePeriod => switch (this) {
        ListingType.hotel || ListingType.vacation => 'night',
        ListingType.rent ||
        ListingType.room ||
        ListingType.mess ||
        ListingType.office ||
        ListingType.commercial ||
        ListingType.parking =>
          'month',
        _ => '',
      };
}

/// A listing photo, with the id needed to delete it.
class ListingImage {
  const ListingImage({required this.id, required this.url, this.isCover = false});

  final int id;
  final String url;
  final bool isCover;

  factory ListingImage.fromJson(Map<String, dynamic> j) => ListingImage(
        id: (j['id'] as num?)?.toInt() ?? 0,
        url: '${j['url'] ?? ''}',
        isCover: j['is_cover'] == true,
      );
}

/// A property listing. Mirrors the API `ListingResource` (index) and
/// `ListingDetailResource` (show); nullable fields degrade gracefully.
class PropertyModel extends Equatable {
  const PropertyModel({
    required this.id,
    required this.title,
    required this.type,
    this.price,
    this.priceDisplay,
    this.currency,
    this.displayCurrency,
    this.location,
    this.zoneId,
    this.zoneName,
    this.address,
    this.imageUrl,
    this.gallery = const [],
    this.images = const [],
    this.beds,
    this.baths,
    this.sizeSqft,
    this.floor,
    this.totalFloors,
    this.serviceCharge,
    this.advanceMonths,
    this.utilityFlags = const [],
    this.furnished = false,
    this.parking = false,
    this.allowedFor,
    this.isVerified = false,
    this.isFeatured = false,
    this.isFavorite = false,
    this.status,
    this.ownerId,
    this.ownerName,
    this.ownerAvatar,
    this.ownerVerified = false,
    this.description,
    this.amenities = const [],
    this.reviewsCount = 0,
    this.favoritesCount = 0,
    this.postedAt,
    this.latitude,
    this.longitude,
  });

  final int id;
  final String title;
  final ListingType type;
  final num? price;

  /// Pre-formatted, currency-converted price string from the API
  /// (e.g. `"$355.20"`). Prefer this for display when present.
  final String? priceDisplay;
  final String? currency;
  final String? displayCurrency;
  final String? location;
  final int? zoneId;
  final String? zoneName;
  final String? address;
  final String? imageUrl;
  final List<String> gallery;

  /// Photos with ids (detail responses only) — needed to delete individual media.
  final List<ListingImage> images;
  final int? beds;
  final int? baths;
  final num? sizeSqft;
  final int? floor;
  final int? totalFloors;
  final num? serviceCharge;
  final int? advanceMonths;
  final List<String> utilityFlags;
  final bool furnished;
  final bool parking;
  final String? allowedFor;
  final bool isVerified;
  final bool isFeatured;
  final bool isFavorite;

  /// Listing lifecycle: `active` | `pending` | `rented` | `sold` | `archived`.
  final String? status;
  final int? ownerId;
  final String? ownerName;
  final String? ownerAvatar;
  final bool ownerVerified;
  final String? description;
  final List<String> amenities;
  final int reviewsCount;
  final int favoritesCount;
  final DateTime? postedAt;
  final double? latitude;
  final double? longitude;

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    num? asNum(dynamic v) => v is num ? v : num.tryParse('$v');
    int? asInt(dynamic v) => v is num ? v.toInt() : int.tryParse('$v');

    final zone = json['zone'];
    final owner = json['owner'] ?? json['agency'];

    // Images: detail returns `images:[{url,is_cover}]`; index returns `cover_image`.
    final rawImages = json['images'];
    final gallery = rawImages is List
        ? rawImages
            .map((e) => e is Map ? '${e['url'] ?? ''}' : '$e')
            .where((s) => s.isNotEmpty)
            .toList(growable: false)
        : const <String>[];
    String? cover = json['cover_image'] as String?;
    if (cover == null && rawImages is List) {
      final coverImg = rawImages.firstWhere(
        (e) => e is Map && e['is_cover'] == true,
        orElse: () => rawImages.isNotEmpty ? rawImages.first : null,
      );
      if (coverImg is Map) cover = coverImg['url'] as String?;
    }

    final amenities = (json['amenities'] is List)
        ? (json['amenities'] as List)
            .map((e) => e is Map ? '${e['label'] ?? e['key'] ?? ''}' : '$e')
            .where((s) => s.isNotEmpty)
            .toList(growable: false)
        : const <String>[];

    return PropertyModel(
      id: asInt(json['id']) ?? 0,
      title: json['title'] as String? ?? 'Untitled',
      type: ListingType.fromString(json['type'] as String?),
      price: asNum(json['price']),
      priceDisplay: json['price_display'] as String?,
      currency: json['currency'] as String?,
      displayCurrency: json['display_currency'] as String?,
      location: json['address'] as String? ??
          (zone is Map ? zone['name'] as String? : null),
      zoneId: zone is Map ? (zone['id'] as num?)?.toInt() : null,
      zoneName: zone is Map ? zone['name'] as String? : null,
      address: json['address'] as String?,
      imageUrl: cover,
      gallery: gallery,
      images: rawImages is List
          ? rawImages
              .whereType<Map<String, dynamic>>()
              .map(ListingImage.fromJson)
              .toList(growable: false)
          : const [],
      beds: asInt(json['bedrooms']),
      baths: asInt(json['bathrooms']),
      sizeSqft: asNum(json['area_sqft']),
      floor: asInt(json['floor']),
      totalFloors: asInt(json['total_floors']),
      serviceCharge: asNum(json['service_charge']),
      advanceMonths: asInt(json['advance_months']),
      utilityFlags: (json['utility_flags'] as List? ?? const [])
          .map((e) => '$e')
          .where((s) => s.isNotEmpty)
          .toList(growable: false),
      furnished: json['furnished'] == true,
      parking: json['parking'] == true,
      allowedFor: json['allowed_for'] as String?,
      isVerified: json['is_verified'] == true,
      isFeatured: json['is_featured'] == true,
      isFavorite: json['is_favorite'] == true || json['is_favorited'] == true,
      status: json['status'] as String?,
      ownerId: owner is Map ? (owner['id'] as num?)?.toInt() : null,
      ownerName: owner is Map ? owner['name'] as String? : null,
      ownerAvatar: owner is Map ? owner['avatar'] as String? : null,
      ownerVerified: owner is Map && owner['is_verified'] == true,
      description: json['description'] as String?,
      amenities: amenities,
      reviewsCount: asInt(json['reviews_count']) ?? 0,
      favoritesCount: asInt(json['favorites_count']) ?? 0,
      postedAt: DateTime.tryParse(
          '${json['published_at'] ?? json['created_at'] ?? ''}'),
      latitude: (asNum(json['lat']))?.toDouble(),
      longitude: (asNum(json['lng']))?.toDouble(),
    );
  }

  PropertyModel copyWith({bool? isFavorite}) {
    return PropertyModel(
      id: id,
      title: title,
      type: type,
      price: price,
      priceDisplay: priceDisplay,
      currency: currency,
      displayCurrency: displayCurrency,
      location: location,
      zoneId: zoneId,
      zoneName: zoneName,
      address: address,
      imageUrl: imageUrl,
      gallery: gallery,
      images: images,
      beds: beds,
      baths: baths,
      sizeSqft: sizeSqft,
      floor: floor,
      totalFloors: totalFloors,
      serviceCharge: serviceCharge,
      advanceMonths: advanceMonths,
      utilityFlags: utilityFlags,
      furnished: furnished,
      parking: parking,
      allowedFor: allowedFor,
      isVerified: isVerified,
      isFeatured: isFeatured,
      isFavorite: isFavorite ?? this.isFavorite,
      status: status,
      ownerId: ownerId,
      ownerName: ownerName,
      ownerAvatar: ownerAvatar,
      ownerVerified: ownerVerified,
      description: description,
      amenities: amenities,
      reviewsCount: reviewsCount,
      favoritesCount: favoritesCount,
      postedAt: postedAt,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        type,
        price,
        priceDisplay,
        location,
        imageUrl,
        beds,
        baths,
        sizeSqft,
        furnished,
        parking,
        isVerified,
        isFeatured,
        isFavorite,
        reviewsCount,
        favoritesCount,
      ];
}
