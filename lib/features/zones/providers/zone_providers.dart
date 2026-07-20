import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../models/zone_model.dart';
import '../repository/zone_repository.dart';

final zoneRepositoryProvider = Provider<ZoneRepository>(
  (ref) => ZoneRepository(ref.watch(apiClientProvider)),
);

/// Zone search results for the location picker, keyed by query string. Empty
/// query browses countries; typing searches cities (property search is
/// city-centric, and picking a city still includes its child areas server-side).
final zoneSearchProvider =
    FutureProvider.autoDispose.family<List<ZoneModel>, String>((ref, query) {
  final repo = ref.watch(zoneRepositoryProvider);
  final q = query.trim();
  return q.isEmpty ? repo.countries() : repo.zones(query: q, type: 'city');
});

/// Cities for the home "Browse by location" rail.
final citiesProvider = FutureProvider.autoDispose<List<ZoneModel>>(
  (ref) => ref.watch(zoneRepositoryProvider).zones(type: 'city'),
);
