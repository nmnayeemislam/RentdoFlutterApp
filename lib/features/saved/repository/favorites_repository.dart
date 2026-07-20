import '../../../shared/models/paginated_response.dart';
import '../../properties/models/property_model.dart';
import '../services/favorites_service.dart';

/// Maps favorites responses into domain models.
class FavoritesRepository {
  FavoritesRepository(this._service);

  final FavoritesService _service;

  Future<PaginatedResponse<PropertyModel>> fetchFavorites({
    int page = 1,
    int perPage = 20,
  }) async {
    final json = await _service.list(page: page, perPage: perPage);
    return PaginatedResponse<PropertyModel>.fromJson(
      json,
      PropertyModel.fromJson,
    );
  }

  Future<void> add(int listingId) => _service.add(listingId);
  Future<void> remove(int listingId) => _service.remove(listingId);
}
