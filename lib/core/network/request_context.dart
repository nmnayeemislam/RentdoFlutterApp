import '../constants/app_config.dart';

/// Process-wide locale + currency the API client attaches to every request via
/// the `Accept-Language` and `X-Currency` headers (the backend's
/// `SetLocaleAndCurrency` middleware reads them). Updated once the user picks a
/// language/currency, or from the bootstrap defaults.
class RequestContext {
  RequestContext();

  String locale = AppConfig.defaultLocale;
  String currency = AppConfig.defaultCurrency;
}
