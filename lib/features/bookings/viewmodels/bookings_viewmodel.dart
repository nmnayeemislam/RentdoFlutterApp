import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/core_providers.dart';

/// A hotel/short-stay booking (`BookingResource`).
class BookingModel {
  const BookingModel({
    required this.id,
    required this.status,
    required this.checkIn,
    required this.checkOut,
    this.nights = 0,
    this.guests = 1,
    this.amount,
    this.currency,
    this.listingId,
    this.listingTitle,
    this.listingAddress,
    this.specialRequests,
  });

  final int id;

  /// `pending` | `confirmed` | `cancelled` | `completed`.
  final String status;
  final DateTime checkIn;
  final DateTime checkOut;
  final int nights;
  final int guests;
  final num? amount;
  final String? currency;
  final int? listingId;
  final String? listingTitle;
  final String? listingAddress;
  final String? specialRequests;

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final listing = json['listing'];
    DateTime date(String key) =>
        DateTime.tryParse('${json[key]}') ?? DateTime.fromMillisecondsSinceEpoch(0);
    return BookingModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'pending',
      checkIn: date('check_in'),
      checkOut: date('check_out'),
      nights: (json['nights'] as num?)?.toInt() ?? 0,
      guests: (json['guests'] as num?)?.toInt() ?? 1,
      amount: json['amount'] as num?,
      currency: json['currency'] as String?,
      listingId: listing is Map ? (listing['id'] as num?)?.toInt() : null,
      listingTitle: listing is Map ? listing['title'] as String? : null,
      listingAddress: listing is Map ? listing['address'] as String? : null,
      specialRequests: json['special_requests'] as String?,
    );
  }
}

class BookingService {
  BookingService(this._api);
  final ApiClient _api;

  static String _ymd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<List<BookingModel>> list() async {
    final res = await _api.get<Map<String, dynamic>>(ApiEndpoints.bookings);
    return (res.data?['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(BookingModel.fromJson)
        .toList(growable: false);
  }

  Future<void> create({
    required int listingId,
    required DateTime checkIn,
    required DateTime checkOut,
    int guests = 1,
    String? specialRequests,
  }) =>
      _api.post<dynamic>(
        ApiEndpoints.bookings,
        data: {
          'listing_id': listingId,
          'check_in': _ymd(checkIn),
          'check_out': _ymd(checkOut),
          'guests': guests,
          if (specialRequests != null && specialRequests.isNotEmpty)
            'special_requests': specialRequests,
        },
      );

  Future<void> cancel(int bookingId) =>
      _api.post<dynamic>(ApiEndpoints.bookingCancel(bookingId));
}

final bookingServiceProvider = Provider<BookingService>(
  (ref) => BookingService(ref.watch(apiClientProvider)),
);

class BookingsViewModel extends AutoDisposeAsyncNotifier<List<BookingModel>> {
  @override
  Future<List<BookingModel>> build() => ref.read(bookingServiceProvider).list();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state =
        await AsyncValue.guard(() => ref.read(bookingServiceProvider).list());
  }

  Future<void> cancel(int bookingId) async {
    await ref.read(bookingServiceProvider).cancel(bookingId);
    await refresh();
  }
}

final bookingsViewModelProvider =
    AutoDisposeAsyncNotifierProvider<BookingsViewModel, List<BookingModel>>(
        BookingsViewModel.new);
