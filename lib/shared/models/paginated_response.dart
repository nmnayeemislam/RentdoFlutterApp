/// Generic wrapper for Laravel paginator responses.
///
/// Handles the standard shape:
/// ```json
/// { "data": [...], "meta": { "current_page": 1, "last_page": 5, "total": 66 } }
/// ```
/// as well as the flattened `{ "data": [...], "current_page": 1, ... }` form.
class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    this.perPage = 15,
    this.facets,
  });

  final List<T> items;
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;

  /// Optional facet counts from `meta.facets` (e.g. `by_type`, `by_bedrooms`),
  /// used to annotate filter options with result counts.
  final Map<String, dynamic>? facets;

  bool get hasMore => currentPage < lastPage;
  bool get isEmpty => items.isEmpty;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final Map<String, dynamic> meta =
        (json['meta'] as Map<String, dynamic>?) ?? json;

    final rawList = (json['data'] as List?) ?? const [];
    final items = rawList
        .whereType<Map<String, dynamic>>()
        .map(fromJson)
        .toList(growable: false);

    int asInt(dynamic v, int fallback) =>
        v is int ? v : int.tryParse('$v') ?? fallback;

    final total = asInt(meta['total'], items.length);
    final perPage = asInt(meta['per_page'], 15);
    // When `last_page` is absent, derive it so pagination isn't silently
    // disabled (a hardcoded `1` would make `hasMore` always false).
    final derivedLastPage = perPage > 0 ? (total / perPage).ceil() : 1;

    return PaginatedResponse<T>(
      items: items,
      currentPage: asInt(meta['current_page'], 1),
      lastPage: asInt(meta['last_page'], derivedLastPage < 1 ? 1 : derivedLastPage),
      total: total,
      perPage: perPage,
      facets: meta['facets'] as Map<String, dynamic>?,
    );
  }

  PaginatedResponse<T> copyWithAppended(PaginatedResponse<T> next) {
    return PaginatedResponse<T>(
      items: [...items, ...next.items],
      currentPage: next.currentPage,
      lastPage: next.lastPage,
      total: next.total,
      perPage: next.perPage,
    );
  }
}
