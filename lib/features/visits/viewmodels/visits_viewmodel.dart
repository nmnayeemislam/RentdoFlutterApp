import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/core_providers.dart';

/// A scheduled property visit (`VisitResource`).
class VisitModel {
  const VisitModel({
    required this.id,
    required this.status,
    required this.scheduledAt,
    this.note,
    this.listingId,
    this.listingTitle,
    this.listingAddress,
  });

  final int id;

  /// `pending` | `confirmed` | `cancelled` | `completed`.
  final String status;
  final DateTime scheduledAt;
  final String? note;
  final int? listingId;
  final String? listingTitle;
  final String? listingAddress;

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    final listing = json['listing'];
    return VisitModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'pending',
      scheduledAt:
          DateTime.tryParse('${json['scheduled_at']}')?.toLocal() ??
              DateTime.fromMillisecondsSinceEpoch(0),
      note: json['note'] as String?,
      listingId: listing is Map ? (listing['id'] as num?)?.toInt() : null,
      listingTitle: listing is Map ? listing['title'] as String? : null,
      listingAddress: listing is Map ? listing['address'] as String? : null,
    );
  }
}

/// API layer for visits.
class VisitService {
  VisitService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> list() async {
    final res = await _api.get<Map<String, dynamic>>(ApiEndpoints.visits);
    return res.data ?? const {};
  }

  Future<void> schedule(int listingId, DateTime scheduledAt, {String? note}) =>
      _api.post<dynamic>(
        ApiEndpoints.listingVisits(listingId),
        data: {
          'scheduled_at': scheduledAt.toUtc().toIso8601String(),
          if (note != null && note.isNotEmpty) 'note': note,
        },
      );

  Future<void> cancel(int visitId) => _api.patch<dynamic>(
        ApiEndpoints.visit(visitId),
        data: {'status': 'cancelled'},
      );
}

final visitServiceProvider = Provider<VisitService>(
  (ref) => VisitService(ref.watch(apiClientProvider)),
);

class VisitsViewModel extends AutoDisposeAsyncNotifier<List<VisitModel>> {
  VisitService get _service => ref.read(visitServiceProvider);

  @override
  Future<List<VisitModel>> build() => _fetch();

  Future<List<VisitModel>> _fetch() async {
    final json = await _service.list();
    return (json['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(VisitModel.fromJson)
        .toList(growable: false);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  /// Schedules a visit for a listing, then refreshes the list.
  Future<void> schedule(int listingId, DateTime scheduledAt, {String? note}) async {
    await _service.schedule(listingId, scheduledAt, note: note);
    await refresh();
  }

  Future<void> cancel(int visitId) async {
    await _service.cancel(visitId);
    await refresh();
  }
}

final visitsViewModelProvider =
    AutoDisposeAsyncNotifierProvider<VisitsViewModel, List<VisitModel>>(
        VisitsViewModel.new);
