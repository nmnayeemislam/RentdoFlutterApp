import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../properties/models/property_model.dart';
import '../repository/favorites_repository.dart';
import '../services/favorites_service.dart';

final favoritesServiceProvider = Provider<FavoritesService>(
  (ref) => FavoritesService(ref.watch(apiClientProvider)),
);

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => FavoritesRepository(ref.watch(favoritesServiceProvider)),
);

/// The authenticated user's saved listings (Saved tab). Refetches on demand.
class SavedController extends AutoDisposeAsyncNotifier<List<PropertyModel>> {
  @override
  Future<List<PropertyModel>> build() async {
    final page = await ref.watch(favoritesRepositoryProvider).fetchFavorites();
    return page.items;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async =>
          (await ref.read(favoritesRepositoryProvider).fetchFavorites()).items,
    );
  }

  /// Optimistically removes a listing from the saved list after unfavoriting.
  void removeLocally(int listingId) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.where((p) => p.id != listingId).toList());
  }
}

final savedControllerProvider =
    AutoDisposeAsyncNotifierProvider<SavedController, List<PropertyModel>>(
        SavedController.new);
