import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';
import '../network/request_context.dart';
import '../services/token_storage.dart';

/// Root dependency-injection providers shared across features.
///
/// Layering: [tokenStorageProvider] → [apiClientProvider] → feature services →
/// repositories → controllers → UI.

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

/// Holds the active locale + currency attached to every request.
final requestContextProvider = Provider<RequestContext>((ref) => RequestContext());

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(
    tokenStorage: ref.read(tokenStorageProvider),
    requestContext: ref.read(requestContextProvider),
  );
  ref.onDispose(() => client.raw.close(force: true));
  return client;
});
