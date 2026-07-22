import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/core_providers.dart';

/// A payment record (`PaymentResource`).
class PaymentModel {
  const PaymentModel({
    required this.id,
    required this.status,
    this.amount,
    this.currency,
    this.gateway,
    this.reference,
    this.redirectUrl,
    this.createdAt,
  });

  final int id;

  /// `pending` | `paid` | `failed` | `refunded`.
  final String status;
  final num? amount;
  final String? currency;
  final String? gateway;
  final String? reference;

  /// Gateway checkout URL returned by `initiate`, when the gateway provides one.
  final String? redirectUrl;
  final DateTime? createdAt;

  bool get isPaid => status == 'paid';

  factory PaymentModel.fromJson(Map<String, dynamic> j) => PaymentModel(
        id: (j['id'] as num?)?.toInt() ?? 0,
        status: j['status'] as String? ?? 'pending',
        amount: j['amount'] as num?,
        currency: j['currency'] as String?,
        gateway: j['gateway'] as String?,
        reference: (j['reference'] ?? j['transaction_id'])?.toString(),
        redirectUrl:
            (j['redirect_url'] ?? j['checkout_url'] ?? j['payment_url']) as String?,
        createdAt: DateTime.tryParse('${j['created_at']}')?.toLocal(),
      );
}

/// Result of validating a coupon code.
class CouponResult {
  const CouponResult({
    required this.valid,
    this.discount,
    this.finalAmount,
    this.message,
  });

  final bool valid;
  final num? discount;
  final num? finalAmount;
  final String? message;

  factory CouponResult.fromJson(Map<String, dynamic> j, {String? message}) =>
      CouponResult(
        valid: true,
        discount: (j['discount'] ?? j['discount_amount']) as num?,
        finalAmount: (j['final_amount'] ?? j['payable']) as num?,
        message: message,
      );
}

class PaymentService {
  PaymentService(this._api);
  final ApiClient _api;

  Future<PaymentModel> show(int id) async {
    final res = await _api.get<Map<String, dynamic>>(ApiEndpoints.payment(id));
    return PaymentModel.fromJson(
        (res.data?['data'] as Map<String, dynamic>?) ?? const {});
  }

  /// Starts gateway processing; returns the payment (with a redirect URL when
  /// the gateway supplies one).
  Future<PaymentModel> initiate(int id, {String gateway = 'stripe'}) async {
    final res = await _api.post<Map<String, dynamic>>(
      ApiEndpoints.paymentInitiate(id),
      data: {'gateway': gateway},
    );
    return PaymentModel.fromJson(
        (res.data?['data'] as Map<String, dynamic>?) ?? const {});
  }

  Future<void> refund(int id, {num? amount, String? reason}) => _api.post<dynamic>(
        '/payments/$id/refund',
        data: {
          'amount': ?amount,
          'reason': ?reason,
        },
      );

  /// Validates a coupon against an amount. `context` scopes it, e.g.
  /// `subscription` | `booking` | `package`.
  Future<CouponResult> applyCoupon({
    required String code,
    required num amount,
    String context = 'subscription',
  }) async {
    final res = await _api.post<Map<String, dynamic>>(
      ApiEndpoints.couponsApply,
      data: {'code': code, 'amount': amount, 'context': context},
    );
    final body = res.data ?? const {};
    return CouponResult.fromJson(
      (body['data'] as Map<String, dynamic>?) ?? const {},
      message: body['message'] as String?,
    );
  }
}

final paymentServiceProvider = Provider<PaymentService>(
  (ref) => PaymentService(ref.watch(apiClientProvider)),
);

final paymentProvider =
    FutureProvider.autoDispose.family<PaymentModel, int>((ref, id) {
  return ref.watch(paymentServiceProvider).show(id);
});
