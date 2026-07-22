import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/core_providers.dart';

class NotificationService {
  NotificationService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> list() async {
    final res = await _api.get<Map<String, dynamic>>(ApiEndpoints.notifications);
    return res.data ?? const {};
  }

  Future<int> unreadCount() async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.notificationsUnreadCount,
    );
    final data = res.data?['data'] as Map<String, dynamic>?;
    return (data?['unread_count'] as num?)?.toInt() ?? 0;
  }

  Future<void> markRead(int id) =>
      _api.post<dynamic>(ApiEndpoints.notificationRead(id));

  Future<void> markAllRead() =>
      _api.post<dynamic>(ApiEndpoints.notificationsReadAll);
}

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(ref.watch(apiClientProvider)),
);
