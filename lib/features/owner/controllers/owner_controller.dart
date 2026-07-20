import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/core_providers.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../properties/controllers/property_providers.dart';
import '../../properties/models/property_model.dart';

/// A single owner "lead" (a visit request, contact reveal, or new message).
class OwnerLead {
  const OwnerLead({
    required this.type,
    this.listingTitle,
    this.userName,
    this.note,
    this.occurredAt,
  });

  /// `visit` | `contact_reveal` | `message`.
  final String type;
  final String? listingTitle;
  final String? userName;
  final String? note;
  final DateTime? occurredAt;

  String get typeLabel => switch (type) {
        'visit' => 'Visit request',
        'contact_reveal' => 'Contact revealed',
        'message' => 'New message',
        _ => type,
      };

  factory OwnerLead.fromJson(Map<String, dynamic> j) => OwnerLead(
        type: j['type'] as String? ?? '',
        listingTitle: j['listing_title'] as String?,
        userName: j['user_name'] as String?,
        note: j['note'] as String?,
        occurredAt: DateTime.tryParse('${j['occurred_at']}')?.toLocal(),
      );
}

class OwnerLeadsSummary {
  const OwnerLeadsSummary({this.totalViews = 0, this.totalLeads = 0});
  final int totalViews;
  final int totalLeads;

  factory OwnerLeadsSummary.fromJson(Map<String, dynamic> j) => OwnerLeadsSummary(
        totalViews: (j['total_views'] as num?)?.toInt() ?? 0,
        totalLeads: (j['total_leads'] as num?)?.toInt() ?? 0,
      );
}

class OwnerService {
  OwnerService(this._api);
  final ApiClient _api;

  Future<List<OwnerLead>> leads() async {
    final res = await _api.get<Map<String, dynamic>>(ApiEndpoints.ownerLeads);
    return (res.data?['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(OwnerLead.fromJson)
        .toList(growable: false);
  }

  Future<OwnerLeadsSummary> leadsSummary() async {
    final res =
        await _api.get<Map<String, dynamic>>(ApiEndpoints.ownerLeadsSummary);
    return OwnerLeadsSummary.fromJson(
        (res.data?['data'] as Map<String, dynamic>?) ?? const {});
  }
}

final ownerServiceProvider = Provider<OwnerService>(
  (ref) => OwnerService(ref.watch(apiClientProvider)),
);

final ownerLeadsProvider = FutureProvider.autoDispose<List<OwnerLead>>(
  (ref) => ref.watch(ownerServiceProvider).leads(),
);

final ownerLeadsSummaryProvider = FutureProvider.autoDispose<OwnerLeadsSummary>(
  (ref) => ref.watch(ownerServiceProvider).leadsSummary(),
);

/// The authenticated owner's own listings (any status).
final myListingsProvider =
    FutureProvider.autoDispose<List<PropertyModel>>((ref) async {
  final userId = ref.watch(authControllerProvider.select((s) => s.user?.id));
  if (userId == null) return const [];
  final json = await ref.watch(propertyServiceProvider).ownerListings(userId);
  return (json['data'] as List? ?? const [])
      .whereType<Map<String, dynamic>>()
      .map(PropertyModel.fromJson)
      .toList(growable: false);
});

/// Updates a listing status then refreshes the owner's list.
final listingStatusUpdater = Provider<Future<void> Function(int, String)>((ref) {
  return (int id, String status) async {
    await ref.read(propertyServiceProvider).updateStatus(id, status);
    ref.invalidate(myListingsProvider);
  };
});

/// Deletes a listing then refreshes the owner's list.
final listingDeleter = Provider<Future<void> Function(int)>((ref) {
  return (int id) async {
    await ref.read(propertyServiceProvider).deleteListing(id);
    ref.invalidate(myListingsProvider);
  };
});
