import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/core_providers.dart';

/// Registers/removes this device's push token with the backend
/// (`POST /devices`, `DELETE /devices/{id}`).
///
/// The token itself must come from a push SDK (FCM/APNs). Wire
/// `firebase_messaging`'s `getToken()` / `onTokenRefresh` to [register] once a
/// Firebase project is configured — everything server-side is ready.
class DeviceService {
  DeviceService(this._api);
  final ApiClient _api;

  static String get _platform {
    if (kIsWeb) return 'web';
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    return 'unknown';
  }

  Future<void> register(String token, {String? platform}) =>
      _api.post<dynamic>(ApiEndpoints.devices, data: {
        'token': token,
        'platform': platform ?? _platform,
      });

  Future<void> unregister(int deviceId) =>
      _api.delete<dynamic>(ApiEndpoints.device(deviceId));
}

final deviceServiceProvider = Provider<DeviceService>(
  (ref) => DeviceService(ref.watch(apiClientProvider)),
);
