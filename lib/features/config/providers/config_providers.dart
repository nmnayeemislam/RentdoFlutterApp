import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/providers/core_providers.dart';
import '../models/bootstrap.dart';

/// Loads the public app-config bootstrap once and caches it. Also seeds the
/// request context's currency/locale so subsequent calls are localized.
final bootstrapProvider = FutureProvider<Bootstrap>((ref) async {
  final api = ref.watch(apiClientProvider);
  final res = await api.get<Map<String, dynamic>>(
    ApiEndpoints.bootstrap,
    requiresAuth: false,
  );
  final data = (res.data?['data'] as Map<String, dynamic>?) ?? const {};
  final bootstrap = Bootstrap.fromJson(data);

  // Seed default currency/locale for the SetLocaleAndCurrency middleware.
  final ctx = ref.read(requestContextProvider);
  ctx.currency = bootstrap.defaultCurrency;
  ctx.locale = bootstrap.defaultLanguage;

  return bootstrap;
});

/// Convenience: the supported property types (falls back to empty while loading).
final propertyTypeOptionsProvider = Provider<List<LabeledOption>>((ref) {
  return ref.watch(bootstrapProvider).valueOrNull?.propertyTypes ?? const [];
});

/// Convenience: the supported currencies.
final currencyOptionsProvider = Provider<List<CurrencyOption>>((ref) {
  return ref.watch(bootstrapProvider).valueOrNull?.currencies ?? const [];
});

/// Server-driven feature switches. Falls back to safe defaults while the
/// bootstrap loads so core UI is never hidden mid-fetch.
final featureFlagsProvider = Provider<FeatureFlags>((ref) {
  return ref.watch(bootstrapProvider).valueOrNull?.features ??
      FeatureFlags.defaults;
});

/// Convenience: the supported languages.
final languageOptionsProvider = Provider<List<LanguageOption>>((ref) {
  return ref.watch(bootstrapProvider).valueOrNull?.languages ?? const [];
});

/// Translation strings for a locale (`GET /translations/{locale}`).
final translationsProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>((ref, locale) async {
  final api = ref.watch(apiClientProvider);
  final res = await api.get<Map<String, dynamic>>(
    ApiEndpoints.translations(locale),
    requiresAuth: false,
  );
  return (res.data?['data'] as Map<String, dynamic>?) ?? const {};
});

/// Owner-definable custom fields shown on the listing form.
final customFieldsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final api = ref.watch(apiClientProvider);
  final res = await api.get<Map<String, dynamic>>(
    ApiEndpoints.customFields,
    requiresAuth: false,
  );
  return (res.data?['data'] as List? ?? const [])
      .whereType<Map<String, dynamic>>()
      .toList(growable: false);
});

/// Amenity reference list (`GET /amenities`).
final amenityOptionsProvider =
    FutureProvider.autoDispose<List<LabeledOption>>((ref) async {
  final api = ref.watch(apiClientProvider);
  final res = await api.get<Map<String, dynamic>>(
    ApiEndpoints.amenities,
    requiresAuth: false,
  );
  return (res.data?['data'] as List? ?? const [])
      .whereType<Map<String, dynamic>>()
      .map(LabeledOption.fromJson)
      .toList(growable: false);
});

/// Sets the active language + currency for subsequent API calls (the backend's
/// `SetLocaleAndCurrency` middleware reads these headers).
class LocaleController extends Notifier<({String locale, String currency})> {
  @override
  ({String locale, String currency}) build() {
    final ctx = ref.read(requestContextProvider);
    return (locale: ctx.locale, currency: ctx.currency);
  }

  void setLocale(String locale) {
    ref.read(requestContextProvider).locale = locale;
    state = (locale: locale, currency: state.currency);
    _invalidateContent();
  }

  void setCurrency(String currency) {
    ref.read(requestContextProvider).currency = currency;
    state = (locale: state.locale, currency: currency);
    _invalidateContent();
  }

  /// Currency/locale change alters prices + copy, so refetch content.
  void _invalidateContent() => ref.invalidate(bootstrapProvider);
}

final localeControllerProvider =
    NotifierProvider<LocaleController, ({String locale, String currency})>(
        LocaleController.new);
