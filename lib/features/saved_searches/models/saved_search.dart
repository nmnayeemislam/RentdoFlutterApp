/// A persisted search with alerting. `criteria` mirrors the listing filter
/// params (see `PropertyFilter.toCriteria`).
class SavedSearch {
  const SavedSearch({
    required this.id,
    required this.name,
    required this.criteria,
    this.alertOn = false,
  });

  final int id;
  final String name;
  final Map<String, dynamic> criteria;
  final bool alertOn;

  factory SavedSearch.fromJson(Map<String, dynamic> json) => SavedSearch(
        id: (json['id'] as num?)?.toInt() ?? 0,
        name: json['name'] as String? ?? 'Saved search',
        criteria: (json['criteria'] as Map<String, dynamic>?) ?? const {},
        alertOn: json['alert_on'] == true,
      );

  /// A short human summary of the criteria for list display.
  String get summary {
    final parts = <String>[];
    if (criteria['type'] != null) parts.add('${criteria['type']}');
    if (criteria['bedrooms'] != null) parts.add('${criteria['bedrooms']}+ bed');
    if (criteria['min_price'] != null || criteria['max_price'] != null) {
      parts.add('${criteria['min_price'] ?? 0}–${criteria['max_price'] ?? '∞'}');
    }
    if (criteria['keyword'] != null) parts.add('"${criteria['keyword']}"');
    return parts.isEmpty ? 'All properties' : parts.join(' · ');
  }
}
