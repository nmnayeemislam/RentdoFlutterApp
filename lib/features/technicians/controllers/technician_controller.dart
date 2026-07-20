import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/core_providers.dart';

/// A technician-service category.
class TechnicianCategory {
  const TechnicianCategory({
    required this.id,
    required this.name,
    this.slug,
    this.icon,
  });

  final int id;
  final String name;
  final String? slug;
  final String? icon;

  factory TechnicianCategory.fromJson(Map<String, dynamic> json) =>
      TechnicianCategory(
        id: (json['id'] as num?)?.toInt() ?? 0,
        name: json['name'] as String? ?? '',
        slug: json['slug'] as String?,
        icon: json['icon'] as String?,
      );
}

/// A technician (list + detail; detail-only fields are nullable).
class TechnicianModel {
  const TechnicianModel({
    required this.id,
    this.name,
    this.avatar,
    this.categoryName,
    this.zoneName,
    this.rating = 0,
    this.hourlyRate,
    this.experienceYears,
    this.isAvailable = false,
    this.isVerified = false,
    this.bio,
    this.skills = const [],
    this.jobsDone,
  });

  final int id;
  final String? name;
  final String? avatar;
  final String? categoryName;
  final String? zoneName;
  final double rating;
  final num? hourlyRate;
  final int? experienceYears;
  final bool isAvailable;
  final bool isVerified;
  final String? bio;
  final List<String> skills;
  final int? jobsDone;

  factory TechnicianModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'];
    final zone = json['zone'];
    return TechnicianModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      categoryName: category is Map ? category['name'] as String? : null,
      zoneName: zone is Map ? zone['name'] as String? : null,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      hourlyRate: json['hourly_rate'] as num?,
      experienceYears: (json['experience_years'] as num?)?.toInt(),
      isAvailable: json['is_available'] == true,
      isVerified: json['is_verified'] == true,
      bio: json['bio'] as String?,
      skills: (json['skills'] as List? ?? const [])
          .map((e) => '$e')
          .toList(growable: false),
      jobsDone: (json['jobs_done'] as num?)?.toInt(),
    );
  }
}

/// A quote offered on a technician booking.
class QuoteModel {
  const QuoteModel({
    required this.id,
    required this.amount,
    this.currency,
    this.description,
    this.status,
    this.validUntil,
  });

  final int id;
  final num amount;
  final String? currency;
  final String? description;
  final String? status;
  final DateTime? validUntil;

  factory QuoteModel.fromJson(Map<String, dynamic> json) => QuoteModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        amount: (json['amount'] as num?) ?? 0,
        currency: json['currency'] as String?,
        description: json['description'] as String?,
        status: json['status'] as String?,
        validUntil: DateTime.tryParse('${json['valid_until']}')?.toLocal(),
      );
}

/// A technician service booking.
class TechnicianBooking {
  const TechnicianBooking({
    required this.id,
    required this.status,
    this.description,
    this.address,
    this.scheduledAt,
    this.isUrgent = false,
    this.agreedAmount,
    this.currency,
    this.technicianName,
    this.quotes = const [],
  });

  final int id;
  final String status;
  final String? description;
  final String? address;
  final DateTime? scheduledAt;
  final bool isUrgent;
  final num? agreedAmount;
  final String? currency;
  final String? technicianName;
  final List<QuoteModel> quotes;

  factory TechnicianBooking.fromJson(Map<String, dynamic> json) {
    final technician = json['technician'];
    return TechnicianBooking(
      id: (json['id'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'pending',
      description: json['description'] as String?,
      address: json['address'] as String?,
      scheduledAt: DateTime.tryParse('${json['scheduled_at']}')?.toLocal(),
      isUrgent: json['is_urgent'] == true,
      agreedAmount: json['agreed_amount'] as num?,
      currency: json['currency'] as String?,
      technicianName: technician is Map ? technician['name'] as String? : null,
      quotes: (json['quotes'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(QuoteModel.fromJson)
          .toList(growable: false),
    );
  }
}

class TechnicianService {
  TechnicianService(this._api);
  final ApiClient _api;

  Future<List<TechnicianCategory>> categories() async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.technicianCategories,
      requiresAuth: false,
    );
    return (res.data?['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(TechnicianCategory.fromJson)
        .toList(growable: false);
  }

  Future<List<TechnicianModel>> list({int? categoryId, String? sort}) async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.technicians,
      requiresAuth: false,
      query: {
        'category_id': ?categoryId,
        'sort': ?sort,
        'per_page': 30,
      },
    );
    return (res.data?['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(TechnicianModel.fromJson)
        .toList(growable: false);
  }

  Future<TechnicianModel> detail(int id) async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.technician(id),
      requiresAuth: false,
    );
    return TechnicianModel.fromJson(
        (res.data?['data'] as Map<String, dynamic>?) ?? const {});
  }

  Future<List<TechnicianBooking>> bookings() async {
    final res =
        await _api.get<Map<String, dynamic>>(ApiEndpoints.technicianBookings);
    return (res.data?['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(TechnicianBooking.fromJson)
        .toList(growable: false);
  }

  Future<void> book({
    required int technicianId,
    required String description,
    required DateTime scheduledAt,
    required String address,
    bool isUrgent = false,
  }) =>
      _api.post<dynamic>(ApiEndpoints.technicianBookings, data: {
        'technician_id': technicianId,
        'description': description,
        'scheduled_at': scheduledAt.toUtc().toIso8601String(),
        'address': address,
        'is_urgent': isUrgent,
      });

  /// Algorithmically suggested technicians (global).
  Future<List<TechnicianModel>> suggested() async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.techniciansSuggest,
      requiresAuth: false,
    );
    return (res.data?['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(TechnicianModel.fromJson)
        .toList(growable: false);
  }

  /// Technicians suggested for a specific listing (zone/category aware).
  Future<List<TechnicianModel>> suggestedForListing(int listingId) async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.listingSuggestedTechnicians(listingId),
      requiresAuth: false,
    );
    return (res.data?['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(TechnicianModel.fromJson)
        .toList(growable: false);
  }

  /// Apply to become a technician.
  Future<void> apply({
    required int categoryId,
    int? zoneId,
    String? bio,
    List<String> skills = const [],
    int? experienceYears,
    num? hourlyRate,
  }) =>
      _api.post<dynamic>(ApiEndpoints.technicianApply, data: {
        'technician_category_id': categoryId,
        'zone_id': ?zoneId,
        'bio': ?bio,
        if (skills.isNotEmpty) 'skills': skills,
        'experience_years': ?experienceYears,
        'hourly_rate': ?hourlyRate,
      });

  /// Update the signed-in technician's own profile.
  Future<void> updateProfile({
    String? bio,
    List<String>? skills,
    int? experienceYears,
    num? hourlyRate,
    bool? isAvailable,
    int? zoneId,
  }) =>
      _api.put<dynamic>('/technician/profile', data: {
        'bio': ?bio,
        'skills': ?skills,
        'experience_years': ?experienceYears,
        'hourly_rate': ?hourlyRate,
        'is_available': ?isAvailable,
        'zone_id': ?zoneId,
      });

  /// Technician submits a quote for a job.
  Future<void> submitQuote(
    int bookingId, {
    required num amount,
    String? description,
    DateTime? validUntil,
  }) =>
      _api.post<dynamic>(
        '${ApiEndpoints.technicianBookings}/$bookingId/quote',
        data: {
          'amount': amount,
          'description': ?description,
          if (validUntil != null)
            'valid_until': validUntil.toUtc().toIso8601String(),
        },
      );

  Future<void> acceptQuote(int bookingId) => _api.post<dynamic>(
        '${ApiEndpoints.technicianBookings}/$bookingId/quote/accept',
      );

  Future<void> rejectQuote(int bookingId) => _api.post<dynamic>(
        '${ApiEndpoints.technicianBookings}/$bookingId/quote/reject',
      );
}

final technicianServiceProvider = Provider<TechnicianService>(
  (ref) => TechnicianService(ref.watch(apiClientProvider)),
);

final technicianCategoriesProvider =
    FutureProvider.autoDispose<List<TechnicianCategory>>(
  (ref) => ref.watch(technicianServiceProvider).categories(),
);

/// Technician list filtered by category id (0 = all).
final techniciansProvider = FutureProvider.autoDispose
    .family<List<TechnicianModel>, int>((ref, categoryId) {
  return ref
      .watch(technicianServiceProvider)
      .list(categoryId: categoryId == 0 ? null : categoryId, sort: 'rating');
});

final technicianDetailProvider =
    FutureProvider.autoDispose.family<TechnicianModel, int>((ref, id) {
  return ref.watch(technicianServiceProvider).detail(id);
});

/// Suggested technicians (global).
final suggestedTechniciansProvider =
    FutureProvider.autoDispose<List<TechnicianModel>>(
  (ref) => ref.watch(technicianServiceProvider).suggested(),
);

/// Technicians suggested for a listing (shown on the property detail page).
final listingTechniciansProvider = FutureProvider.autoDispose
    .family<List<TechnicianModel>, int>((ref, listingId) {
  return ref.watch(technicianServiceProvider).suggestedForListing(listingId);
});

class TechnicianBookingsController
    extends AutoDisposeAsyncNotifier<List<TechnicianBooking>> {
  TechnicianService get _service => ref.read(technicianServiceProvider);

  @override
  Future<List<TechnicianBooking>> build() => _service.bookings();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _service.bookings());
  }

  Future<void> acceptQuote(int bookingId) async {
    await _service.acceptQuote(bookingId);
    await refresh();
  }

  Future<void> rejectQuote(int bookingId) async {
    await _service.rejectQuote(bookingId);
    await refresh();
  }
}

final technicianBookingsControllerProvider = AutoDisposeAsyncNotifierProvider<
    TechnicianBookingsController,
    List<TechnicianBooking>>(TechnicianBookingsController.new);
