import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../models/property_filter.dart';
import '../models/property_model.dart';
import '../repository/property_repository.dart';
import '../services/property_service.dart';

/// DI wiring for the properties feature.
final propertyServiceProvider = Provider<PropertyService>(
  (ref) => PropertyService(ref.watch(apiClientProvider)),
);

final propertyRepositoryProvider = Provider<PropertyRepository>(
  (ref) => PropertyRepository(ref.watch(propertyServiceProvider)),
);

/// Featured listings for the Home screen.
final featuredPropertiesProvider =
    FutureProvider.autoDispose<List<PropertyModel>>((ref) async {
  final repo = ref.watch(propertyRepositoryProvider);
  final page = await repo.fetchProperties(
    const PropertyFilter(featured: true),
    perPage: 8,
  );
  return page.items;
});

/// Single listing detail, keyed by listing id.
final propertyDetailProvider =
    FutureProvider.autoDispose.family<PropertyModel, int>((ref, id) {
  return ref.watch(propertyRepositoryProvider).fetchDetail(id);
});

/// A single day in the hotel availability calendar.
class AvailabilityDay {
  const AvailabilityDay({
    required this.date,
    this.isAvailable = true,
    this.price,
  });

  final DateTime date;
  final bool isAvailable;
  final num? price;

  factory AvailabilityDay.fromJson(Map<String, dynamic> j) => AvailabilityDay(
        date: DateTime.tryParse('${j['date']}') ??
            DateTime.fromMillisecondsSinceEpoch(0),
        isAvailable: j['is_available'] != false,
        price: j['price'] as num? ?? j['override_price'] as num?,
      );
}

/// Availability window for a listing (next 60 days).
final listingAvailabilityProvider = FutureProvider.autoDispose
    .family<List<AvailabilityDay>, int>((ref, listingId) async {
  final now = DateTime.now();
  final data = await ref.watch(propertyServiceProvider).availability(
        listingId,
        from: DateTime(now.year, now.month, now.day),
        to: DateTime(now.year, now.month, now.day).add(const Duration(days: 60)),
      );
  return (data['dates'] as List? ?? const [])
      .whereType<Map<String, dynamic>>()
      .map(AvailabilityDay.fromJson)
      .toList(growable: false);
});

/// True when any night in `[from, to)` is marked unavailable in [days].
bool rangeHasBlockedNight(
    List<AvailabilityDay> days, DateTime from, DateTime to) {
  bool sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
  for (var d = from; d.isBefore(to); d = d.add(const Duration(days: 1))) {
    final match =
        days.where((x) => sameDay(x.date, d)).cast<AvailabilityDay?>().firstOrNull;
    if (match != null && !match.isAvailable) return true;
  }
  return false;
}

/// Similar listings (same type), excluding the one being viewed.
final similarPropertiesProvider = FutureProvider.autoDispose
    .family<List<PropertyModel>, ({int excludeId, ListingType type})>(
        (ref, args) async {
  final page = await ref.watch(propertyRepositoryProvider).fetchProperties(
        PropertyFilter(type: args.type),
        perPage: 8,
      );
  return page.items.where((p) => p.id != args.excludeId).take(6).toList();
});
