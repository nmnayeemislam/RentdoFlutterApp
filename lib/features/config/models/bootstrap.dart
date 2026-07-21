/// A `{key, label}` reference option (property types, technician categories…).
class LabeledOption {
  const LabeledOption({required this.key, required this.label});

  final String key;
  final String label;

  factory LabeledOption.fromJson(Map<String, dynamic> json) => LabeledOption(
        key: '${json['key'] ?? ''}',
        label: '${json['label'] ?? json['name'] ?? json['key'] ?? ''}',
      );
}

/// A currency the backend supports, with formatting metadata.
class CurrencyOption {
  const CurrencyOption({
    required this.code,
    required this.name,
    required this.symbol,
    this.symbolBefore = true,
    this.isDefault = false,
  });

  final String code;
  final String name;
  final String symbol;
  final bool symbolBefore;
  final bool isDefault;

  factory CurrencyOption.fromJson(Map<String, dynamic> json) => CurrencyOption(
        code: '${json['code'] ?? ''}',
        name: '${json['name'] ?? ''}',
        symbol: '${json['symbol'] ?? ''}',
        symbolBefore: json['symbol_position'] != 'after',
        isDefault: json['is_default'] == true,
      );
}

/// A language the backend supports.
class LanguageOption {
  const LanguageOption({
    required this.code,
    required this.name,
    this.nativeName,
    this.isRtl = false,
    this.isDefault = false,
  });

  final String code;
  final String name;
  final String? nativeName;
  final bool isRtl;
  final bool isDefault;

  factory LanguageOption.fromJson(Map<String, dynamic> json) => LanguageOption(
        code: '${json['code'] ?? ''}',
        name: '${json['name'] ?? ''}',
        nativeName: json['native_name'] as String?,
        isRtl: json['direction'] == 'rtl',
        isDefault: json['is_default'] == true,
      );
}

/// Basic site branding/contact info.
class SiteInfo {
  const SiteInfo({
    required this.name,
    this.tagline,
    this.logo,
    this.phone,
    this.email,
    this.address,
  });

  final String name;
  final String? tagline;
  final String? logo;
  final String? phone;
  final String? email;
  final String? address;

  factory SiteInfo.fromJson(Map<String, dynamic> json) => SiteInfo(
        name: '${json['name'] ?? 'Rentdo'}',
        tagline: json['tagline'] as String?,
        logo: json['logo'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        address: json['address'] as String?,
      );
}

/// Server-driven feature switches (`feature_toggles` in the bootstrap payload).
/// The app hides the corresponding UI when a feature is off, so admins can
/// disable a module without a client release.
class FeatureFlags {
  const FeatureFlags({
    this.hotelBooking = true,
    this.technicianMarketplace = true,
    this.reviews = true,
    this.chat = true,
    this.savedSearchAlerts = true,
    this.referral = false,
  });

  final bool hotelBooking;
  final bool technicianMarketplace;
  final bool reviews;
  final bool chat;
  final bool savedSearchAlerts;
  final bool referral;

  /// Safe defaults used until the bootstrap resolves (everything on except
  /// referral) so the UI never hides core features while loading.
  static const FeatureFlags defaults = FeatureFlags();

  factory FeatureFlags.fromJson(Map<String, dynamic> json) => FeatureFlags(
        hotelBooking: json['hotel_booking'] != false,
        technicianMarketplace: json['technician_marketplace'] != false,
        reviews: json['reviews'] != false,
        chat: json['chat'] != false,
        savedSearchAlerts: json['saved_search_alerts'] != false,
        referral: json['referral'] == true,
      );
}

/// The app-config payload from `GET /config/bootstrap`.
class Bootstrap {
  const Bootstrap({
    required this.siteInfo,
    required this.currencies,
    required this.languages,
    required this.propertyTypes,
    required this.technicianCategories,
    required this.features,
    required this.defaultCurrency,
    required this.defaultLanguage,
  });

  final SiteInfo siteInfo;
  final List<CurrencyOption> currencies;
  final List<LanguageOption> languages;
  final List<LabeledOption> propertyTypes;
  final List<LabeledOption> technicianCategories;
  final FeatureFlags features;
  final String defaultCurrency;
  final String defaultLanguage;

  factory Bootstrap.fromJson(Map<String, dynamic> json) {
    List<T> mapList<T>(String key, T Function(Map<String, dynamic>) f) =>
        (json[key] as List? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(f)
            .toList(growable: false);

    return Bootstrap(
      siteInfo: SiteInfo.fromJson(
          (json['site_info'] as Map<String, dynamic>?) ?? const {}),
      currencies: mapList('currencies', CurrencyOption.fromJson),
      languages: mapList('languages', LanguageOption.fromJson),
      propertyTypes: mapList('property_types', LabeledOption.fromJson),
      technicianCategories:
          mapList('technician_categories', LabeledOption.fromJson),
      features: FeatureFlags.fromJson(
          (json['feature_toggles'] as Map<String, dynamic>?) ?? const {}),
      defaultCurrency: '${json['default_currency'] ?? 'USD'}',
      defaultLanguage: '${json['default_language'] ?? 'en'}',
    );
  }
}
