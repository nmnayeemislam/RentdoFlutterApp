import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/providers/core_providers.dart';

/// A subscription plan (`PlanResource`).
class PlanModel {
  const PlanModel({
    required this.id,
    required this.name,
    this.description,
    this.price = 0,
    this.currency,
    this.durationDays = 0,
    this.postLimitLabel,
    this.features = const {},
    this.isFeatured = false,
  });

  final int id;
  final String name;
  final String? description;
  final num price;
  final String? currency;
  final int durationDays;
  final String? postLimitLabel;

  /// feature-key → enabled.
  final Map<String, dynamic> features;
  final bool isFeatured;

  bool get isFree => price <= 0;

  /// The enabled feature keys, humanized.
  List<String> get enabledFeatures => features.entries
      .where((e) => e.value == true)
      .map((e) => e.key.replaceAll('_', ' '))
      .toList(growable: false);

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        name: json['name'] as String? ?? '',
        description: json['description'] as String?,
        price: (json['price'] as num?) ?? 0,
        currency: json['currency'] as String?,
        durationDays: (json['duration_days'] as num?)?.toInt() ?? 0,
        postLimitLabel: json['post_limit_label'] as String?,
        features: (json['unlocked_features'] as Map<String, dynamic>?) ?? const {},
        isFeatured: json['is_featured'] == true,
      );
}

/// The user's active subscription (`SubscriptionResource`).
class SubscriptionModel {
  const SubscriptionModel({
    required this.id,
    required this.status,
    this.autoRenew = false,
    this.planName,
    this.endsAt,
    this.postsUsed = 0,
    this.postsLimit,
  });

  final int id;
  final String status;
  final bool autoRenew;
  final String? planName;
  final DateTime? endsAt;
  final int postsUsed;
  final int? postsLimit;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    final plan = json['plan'];
    return SubscriptionModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      autoRenew: json['auto_renew'] == true,
      planName: plan is Map ? plan['name'] as String? : null,
      endsAt: DateTime.tryParse('${json['ends_at']}')?.toLocal(),
      postsUsed: (json['posts_used'] as num?)?.toInt() ?? 0,
      postsLimit: (json['posts_limit'] as num?)?.toInt(),
    );
  }
}

/// A post-quota package (`PackageResource`).
class PackageModel {
  const PackageModel({
    required this.id,
    required this.name,
    this.price = 0,
    this.currency,
    this.postQuota = 0,
    this.durationDays = 0,
    this.features = const [],
  });

  final int id;
  final String name;
  final num price;
  final String? currency;
  final int postQuota;
  final int durationDays;
  final List<String> features;

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        name: json['name'] as String? ?? '',
        price: (json['price'] as num?) ?? 0,
        currency: json['currency'] as String?,
        postQuota: (json['post_quota'] as num?)?.toInt() ?? 0,
        durationDays: (json['duration_days'] as num?)?.toInt() ?? 0,
        features: (json['features'] as List? ?? const [])
            .map((e) => '$e')
            .toList(growable: false),
      );
}

class BillingService {
  BillingService(this._api);
  final ApiClient _api;

  Future<List<PlanModel>> plans() async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.plans,
      requiresAuth: false,
    );
    return (res.data?['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(PlanModel.fromJson)
        .toList(growable: false);
  }

  Future<List<PackageModel>> packages() async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.packages,
      requiresAuth: false,
    );
    return (res.data?['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(PackageModel.fromJson)
        .toList(growable: false);
  }

  Future<SubscriptionModel?> mySubscription() async {
    final res = await _api.get<Map<String, dynamic>>(ApiEndpoints.meSubscription);
    final data = res.data?['data'] as Map<String, dynamic>?;
    return data == null || data.isEmpty ? null : SubscriptionModel.fromJson(data);
  }

  Future<void> subscribe(
    int planId, {
    bool autoRenew = false,
    String? couponCode,
  }) =>
      _api.post<dynamic>(ApiEndpoints.subscriptions, data: {
        'plan_id': planId,
        'payment_method': 'wallet',
        'auto_renew': autoRenew,
        if (couponCode != null && couponCode.isNotEmpty)
          'coupon_code': couponCode,
      });

  Future<void> cancelSubscription() =>
      _api.post<dynamic>(ApiEndpoints.meSubscriptionCancel);

  Future<void> buyPackage(int packageId) => _api.post<dynamic>(
        ApiEndpoints.packageBuy(packageId),
        data: {'payment_method': 'wallet'},
      );
}

final billingServiceProvider = Provider<BillingService>(
  (ref) => BillingService(ref.watch(apiClientProvider)),
);

final plansProvider = FutureProvider.autoDispose<List<PlanModel>>(
  (ref) => ref.watch(billingServiceProvider).plans(),
);

final packagesProvider = FutureProvider.autoDispose<List<PackageModel>>(
  (ref) => ref.watch(billingServiceProvider).packages(),
);

final mySubscriptionProvider = FutureProvider.autoDispose<SubscriptionModel?>(
  (ref) => ref.watch(billingServiceProvider).mySubscription(),
);

/// Tracks in-flight subscribe/buy/cancel actions and refreshes on success.
class BillingActions extends AutoDisposeNotifier<bool> {
  @override
  bool build() => false; // isSubmitting

  Future<bool> _run(Future<void> Function() action) async {
    state = true;
    try {
      await action();
      ref.invalidate(mySubscriptionProvider);
      state = false;
      return true;
    } on ApiException {
      state = false;
      rethrow;
    }
  }

  Future<bool> subscribe(
    int planId, {
    bool autoRenew = false,
    String? couponCode,
  }) =>
      _run(() => ref.read(billingServiceProvider).subscribe(
            planId,
            autoRenew: autoRenew,
            couponCode: couponCode,
          ));

  Future<bool> cancel() =>
      _run(() => ref.read(billingServiceProvider).cancelSubscription());

  Future<bool> buyPackage(int packageId) =>
      _run(() => ref.read(billingServiceProvider).buyPackage(packageId));
}

final billingActionsProvider =
    AutoDisposeNotifierProvider<BillingActions, bool>(BillingActions.new);
