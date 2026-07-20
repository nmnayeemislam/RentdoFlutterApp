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
  const SiteInfo({required this.name, this.tagline, this.logo, this.phone, this.email});

  final String name;
  final String? tagline;
  final String? logo;
  final String? phone;
  final String? email;

  factory SiteInfo.fromJson(Map<String, dynamic> json) => SiteInfo(
        name: '${json['name'] ?? 'Rentdo'}',
        tagline: json['tagline'] as String?,
        logo: json['logo'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
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
    required this.defaultCurrency,
    required this.defaultLanguage,
  });

  final SiteInfo siteInfo;
  final List<CurrencyOption> currencies;
  final List<LanguageOption> languages;
  final List<LabeledOption> propertyTypes;
  final List<LabeledOption> technicianCategories;
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
      defaultCurrency: '${json['default_currency'] ?? 'USD'}',
      defaultLanguage: '${json['default_language'] ?? 'en'}',
    );
  }
}
