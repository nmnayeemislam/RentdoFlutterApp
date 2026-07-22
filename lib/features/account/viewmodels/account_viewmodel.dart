import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/core_providers.dart';

/// Owner-verification state (`GET /me/verification`).
class VerificationStatus {
  const VerificationStatus({required this.status, this.note, this.reviewedAt});

  /// `unverified` | `pending` | `verified` | `rejected`.
  final String status;
  final String? note;
  final DateTime? reviewedAt;

  bool get isVerified => status == 'verified';
  bool get isPending => status == 'pending';

  factory VerificationStatus.fromJson(Map<String, dynamic> j) =>
      VerificationStatus(
        status: j['status'] as String? ?? 'unverified',
        note: j['note'] as String?,
        reviewedAt: DateTime.tryParse('${j['reviewed_at']}')?.toLocal(),
      );
}

/// Posting entitlements (`GET /me/limits`).
class UsageLimits {
  const UsageLimits({
    this.postLimit,
    this.postsUsed = 0,
    this.postsRemaining,
    this.unlockedFeatures = const [],
    this.featureGates = const {},
  });

  /// `null` means unlimited.
  final int? postLimit;
  final int postsUsed;
  final int? postsRemaining;
  final List<String> unlockedFeatures;
  final Map<String, dynamic> featureGates;

  factory UsageLimits.fromJson(Map<String, dynamic> j) => UsageLimits(
        postLimit: (j['post_limit'] as num?)?.toInt(),
        postsUsed: (j['posts_used'] as num?)?.toInt() ?? 0,
        postsRemaining: (j['posts_remaining'] as num?)?.toInt(),
        unlockedFeatures: (j['unlocked_features'] as List? ?? const [])
            .map((e) => '$e')
            .toList(growable: false),
        featureGates: (j['feature_gates'] as Map<String, dynamic>?) ?? const {},
      );
}

/// Per-event × per-channel notification switches.
class NotificationPreferences {
  const NotificationPreferences(this.values);

  /// event -> { channel -> enabled }.
  final Map<String, Map<String, bool>> values;

  static const events = ['chat', 'alert', 'booking', 'lead'];
  static const channels = ['email', 'sms', 'push', 'in_app'];

  static const eventLabels = {
    'chat': 'Messages',
    'alert': 'Saved-search alerts',
    'booking': 'Bookings',
    'lead': 'Leads',
  };
  static const channelLabels = {
    'email': 'Email',
    'sms': 'SMS',
    'push': 'Push',
    'in_app': 'In-app',
  };

  bool enabled(String event, String channel) =>
      values[event]?[channel] ?? false;

  NotificationPreferences withValue(String event, String channel, bool v) {
    final next = {
      for (final e in values.entries) e.key: Map<String, bool>.from(e.value),
    };
    (next[event] ??= {})[channel] = v;
    return NotificationPreferences(next);
  }

  Map<String, dynamic> toJson() => values;

  factory NotificationPreferences.fromJson(Map<String, dynamic> j) {
    final out = <String, Map<String, bool>>{};
    for (final event in events) {
      final raw = j[event];
      out[event] = {
        for (final c in channels)
          c: raw is Map ? raw[c] == true : false,
      };
    }
    return NotificationPreferences(out);
  }
}

class AccountService {
  AccountService(this._api);
  final ApiClient _api;

  Future<VerificationStatus> verificationStatus() async {
    final res =
        await _api.get<Map<String, dynamic>>(ApiEndpoints.meVerification);
    return VerificationStatus.fromJson(
        (res.data?['data'] as Map<String, dynamic>?) ?? const {});
  }

  Future<void> submitVerification(String filePath) async {
    final formData = FormData.fromMap({
      'document': await MultipartFile.fromFile(filePath),
    });
    await _api.upload<dynamic>(ApiEndpoints.meVerification, formData: formData);
  }

  Future<UsageLimits> limits() async {
    final res = await _api.get<Map<String, dynamic>>(ApiEndpoints.meLimits);
    return UsageLimits.fromJson(
        (res.data?['data'] as Map<String, dynamic>?) ?? const {});
  }

  Future<NotificationPreferences> notificationPreferences() async {
    final res = await _api
        .get<Map<String, dynamic>>(ApiEndpoints.meNotificationPreferences);
    return NotificationPreferences.fromJson(
        (res.data?['data'] as Map<String, dynamic>?) ?? const {});
  }

  Future<void> updateNotificationPreferences(NotificationPreferences prefs) =>
      _api.put<dynamic>(ApiEndpoints.meNotificationPreferences,
          data: prefs.toJson());

  /// Requests a GDPR data export; returns the signed download URL.
  Future<String?> requestExport() async {
    final res = await _api.get<Map<String, dynamic>>(ApiEndpoints.meExport);
    final data = res.data?['data'] as Map<String, dynamic>?;
    return data?['download_url'] as String?;
  }

  /// Schedules account deletion; returns the scheduled date, if given.
  Future<String?> requestDeletion() async {
    final res = await _api.delete<Map<String, dynamic>>(ApiEndpoints.me);
    final data = res.data?['data'] as Map<String, dynamic>?;
    return data?['scheduled_deletion_date']?.toString();
  }
}

final accountServiceProvider = Provider<AccountService>(
  (ref) => AccountService(ref.watch(apiClientProvider)),
);

final verificationStatusProvider =
    FutureProvider.autoDispose<VerificationStatus>(
  (ref) => ref.watch(accountServiceProvider).verificationStatus(),
);

final usageLimitsProvider = FutureProvider.autoDispose<UsageLimits>(
  (ref) => ref.watch(accountServiceProvider).limits(),
);

final notificationPreferencesProvider =
    FutureProvider.autoDispose<NotificationPreferences>(
  (ref) => ref.watch(accountServiceProvider).notificationPreferences(),
);
