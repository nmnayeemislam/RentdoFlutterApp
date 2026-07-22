import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/viewmodels/auth_viewmodel.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

/// Unread badge count — only fetched for authenticated users.
final unreadNotificationsProvider = FutureProvider.autoDispose<int>((ref) async {
  final isAuthed =
      ref.watch(authViewModelProvider.select((s) => s.isAuthenticated));
  if (!isAuthed) return 0;
  return ref.watch(notificationServiceProvider).unreadCount();
});

/// ViewModel backing [NotificationsScreen]: fetches, refreshes, and applies
/// read-state mutations for the current user's notification list.
class NotificationsViewModel
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
        for (final n in current) n.id == id ? n.copyWith(isRead: true) : n,
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

final notificationsViewModelProvider = AutoDisposeAsyncNotifierProvider<
    NotificationsViewModel, List<NotificationModel>>(NotificationsViewModel.new);
