/// Environment-configurable application settings.
///
/// All base URLs and toggles live here so deployments only change one file
/// (or `--dart-define` overrides). Nothing else in the app should hardcode a
/// host or endpoint root.
enum Flavor { dev, staging, prod }

abstract final class AppConfig {
  AppConfig._();

  /// Current flavor. Override with:
  /// `flutter run --dart-define=FLAVOR=prod`
  static const String _flavorName =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  static Flavor get flavor => switch (_flavorName) {
        'prod' => Flavor.prod,
        'staging' => Flavor.staging,
        _ => Flavor.dev,
      };

  /// Base host of the Laravel backend. Override with:
  /// `flutter run --dart-define=API_BASE_URL=https://api.example.com`
  static const String baseUrl = String.fromEnvironment('API_BASE_URL',
    defaultValue: 'https://rentdonew.razinsoft.com',
  );

  /// REST API prefix appended after [baseUrl] (Laravel Sanctum API v1).
  static const String apiPrefix = '/api/v1';

  /// Default locale + currency sent via the `Accept-Language` / `X-Currency`
  /// headers the backend's `SetLocaleAndCurrency` middleware reads. These are
  /// overridden at runtime once the user picks a language/currency.
  static const String defaultLocale = 'en';
  static const String defaultCurrency = 'USD';

  /// Full API root used by [ApiClient].
  static String get apiBaseUrl => '$baseUrl$apiPrefix';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);

  static const int defaultPageSize = 15;

  static bool get enableLogging => flavor != Flavor.prod;
}
