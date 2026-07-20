import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/core_providers.dart';

/// Report reasons accepted by `POST /reports`.
enum ReportReason {
  spam('spam', 'Spam'),
  inappropriate('inappropriate_content', 'Inappropriate content'),
  fakeListing('fake_listing', 'Fake listing'),
  scam('scam', 'Scam'),
  wrongInfo('wrong_information', 'Wrong information'),
  harassment('harassment', 'Harassment'),
  other('other', 'Other');

  const ReportReason(this.value, this.label);
  final String value;
  final String label;
}

/// Reports + user blocking.
class CommunityService {
  CommunityService(this._api);
  final ApiClient _api;

  Future<void> report({
    required String reportableType,
    required int reportableId,
    required ReportReason reason,
    String? details,
  }) =>
      _api.post<dynamic>(ApiEndpoints.reports, data: {
        'reportable_type': reportableType,
        'reportable_id': reportableId,
        'reason': reason.value,
        if (details != null && details.isNotEmpty) 'details': details,
      });

  Future<void> reportListing(int listingId, ReportReason reason,
          {String? details}) =>
      report(
        reportableType: 'listing',
        reportableId: listingId,
        reason: reason,
        details: details,
      );

  Future<void> blockUser(int userId) =>
      _api.post<dynamic>(ApiEndpoints.blockUser(userId));

  Future<void> unblockUser(int userId) =>
      _api.delete<dynamic>(ApiEndpoints.blockUser(userId));

  /// Reports a user for abuse.
  Future<void> reportUser(int userId, ReportReason reason, {String? details}) =>
      report(
        reportableType: 'user',
        reportableId: userId,
        reason: reason,
        details: details,
      );

  /// Users the signed-in account has blocked.
  Future<List<BlockedUser>> blockedUsers() async {
    final res = await _api.get<Map<String, dynamic>>(ApiEndpoints.block);
    return (res.data?['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(BlockedUser.fromJson)
        .toList(growable: false);
  }
}

/// A user on the block list.
class BlockedUser {
  const BlockedUser({required this.id, this.name, this.avatar});

  /// The blocked user's id.
  final int id;
  final String? name;
  final String? avatar;

  factory BlockedUser.fromJson(Map<String, dynamic> j) {
    final blocked = j['blocked'] ?? j['user'];
    return BlockedUser(
      id: (blocked is Map
              ? (blocked['id'] as num?)
              : (j['blocked_id'] as num?))
              ?.toInt() ??
          0,
      name: blocked is Map ? blocked['name'] as String? : null,
      avatar: blocked is Map ? blocked['avatar'] as String? : null,
    );
  }
}

final blockedUsersProvider = FutureProvider.autoDispose<List<BlockedUser>>(
  (ref) => ref.watch(communityServiceProvider).blockedUsers(),
);

final communityServiceProvider = Provider<CommunityService>(
  (ref) => CommunityService(ref.watch(apiClientProvider)),
);
