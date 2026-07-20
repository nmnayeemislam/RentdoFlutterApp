/// A geographic zone: country → city → area hierarchy.
class ZoneModel {
  const ZoneModel({
    required this.id,
    required this.name,
    this.slug,
    this.type,
    this.lat,
    this.lng,
    this.parentId,
    this.parentName,
    this.childrenCount,
  });

  final int id;
  final String name;
  final String? slug;

  /// `country` | `city` | `area`.
  final String? type;
  final double? lat;
  final double? lng;
  final int? parentId;
  final String? parentName;
  final int? childrenCount;

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    final parent = json['parent'];
    return ZoneModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: '${json['name'] ?? ''}',
      slug: json['slug'] as String?,
      type: json['type'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      parentId: (json['parent_id'] as num?)?.toInt(),
      parentName: parent is Map ? parent['name'] as String? : null,
      childrenCount: (json['children_count'] as num?)?.toInt(),
    );
  }

  /// e.g. "Singapore, Singapore" — name with parent country appended.
  String get displayName =>
      parentName != null && parentName != name ? '$name, $parentName' : name;
}
