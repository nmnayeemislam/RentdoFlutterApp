import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure persistence for the Sanctum bearer token.
///
/// The backend issues a single long-lived personal-access token (no refresh
/// token), so this only tracks the access token.
class TokenStorage {
  TokenStorage([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device,
          ),
        );

  final FlutterSecureStorage _storage;

  static const _kAccess = 'rentdo_access_token';

  Future<String?> readAccessToken() => _storage.read(key: _kAccess);

  Future<void> saveToken(String accessToken) =>
      _storage.write(key: _kAccess, value: accessToken);

  Future<void> clear() => _storage.delete(key: _kAccess);

  Future<bool> get hasSession async =>
      (await readAccessToken())?.isNotEmpty ?? false;
}
