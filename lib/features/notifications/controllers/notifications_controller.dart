import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/core_providers.dart';
import '../../auth/controllers/auth_controller.dart';

/// A user notification (`UserNotificationResource`).
class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    this.type,
    this.body,
    this.data,
    this.isRead = false,
    this.createdAt,
  });

  final int id;
  final String title;
  final String? type;
  final String? body;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime? createdAt;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        title: json['title'] as String? ?? '',
        type: json['type'] as String?,
        body: json['body'] as String?,
        data: json['data'] as Map<String, dynamic>?,
        isRead: json['is_read'] == true,
        createdAt: DateTime.tryParse('${json['created_at']}')?.toLocal(),
      );
}

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

/// Unread badge count — only fetched for authenticated users.
final unreadNotificationsProvider = FutureProvider.autoDispose<int>((ref) async {
  final isAuthed =
      ref.watch(authControllerProvider.select((s) => s.isAuthenticated));
  if (!isAuthed) return 0;
  return ref.watch(notificationServiceProvider).unreadCount();
});

class NotificationsController
    extends AutoDisposeAsyncNotifier<List<NotificationModel>> {
  NotificationService get _service => ref.read(notificationServiceProvider);

  @override
  Future<List<NotificationModel>> build() => _fetch();

  Future<List<NotificationModel>> _fetch() async {
    final json = await _service.list();
    return (json['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(NotificationModel.fromJson)
        .toList(growable: false);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> markRead(int id) async {
    await _service.markRead(id);
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData([
        for (final n in current)
          n.id == id
              ? NotificationModel(
                  id: n.id,
                  title: n.title,
                  type: n.type,
                  body: n.body,
                  data: n.data,
                  isRead: true,
                  createdAt: n.createdAt,
                )
              : n,
      ]);
    }
    ref.invalidate(unreadNotificationsProvider);
  }

  Future<void> markAllRead() async {
    await _service.markAllRead();
    await refresh();
    ref.invalidate(unreadNotificationsProvider);
  }
}

final notificationsControllerProvider = AutoDisposeAsyncNotifierProvider<
    NotificationsController, List<NotificationModel>>(NotificationsController.new);
