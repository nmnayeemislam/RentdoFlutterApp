import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/core_providers.dart';

class WalletBalance {
  const WalletBalance({required this.balance, this.currency});
  final num balance;
  final String? currency;

  factory WalletBalance.fromJson(Map<String, dynamic> json) => WalletBalance(
        balance: (json['balance'] as num?) ?? 0,
        currency: json['currency'] as String?,
      );
}

class WalletTransaction {
  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    this.balanceAfter,
    this.description,
    this.createdAt,
  });

  final int id;

  /// `credit` | `debit` (and variants).
  final String type;
  final num amount;
  final num? balanceAfter;
  final String? description;
  final DateTime? createdAt;

  bool get isCredit => type.contains('credit') || type.contains('topup');

  factory WalletTransaction.fromJson(Map<String, dynamic> json) =>
      WalletTransaction(
        id: (json['id'] as num?)?.toInt() ?? 0,
        type: json['type'] as String? ?? '',
        amount: (json['amount'] as num?) ?? 0,
        balanceAfter: json['balance_after'] as num?,
        description: json['description'] as String?,
        createdAt: DateTime.tryParse('${json['created_at']}')?.toLocal(),
      );
}

class WalletService {
  WalletService(this._api);
  final ApiClient _api;

  Future<WalletBalance> balance() async {
    final res = await _api.get<Map<String, dynamic>>(ApiEndpoints.wallet);
    return WalletBalance.fromJson(
        (res.data?['data'] as Map<String, dynamic>?) ?? const {});
  }

  Future<List<WalletTransaction>> transactions() async {
    final res =
        await _api.get<Map<String, dynamic>>(ApiEndpoints.walletTransactions);
    return (res.data?['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(WalletTransaction.fromJson)
        .toList(growable: false);
  }

  Future<void> topup(int amount, String gateway) => _api.post<dynamic>(
        ApiEndpoints.walletTopup,
        data: {'amount': amount, 'gateway': gateway},
      );
}

final walletServiceProvider = Provider<WalletService>(
  (ref) => WalletService(ref.watch(apiClientProvider)),
);

final walletBalanceProvider = FutureProvider.autoDispose<WalletBalance>(
  (ref) => ref.watch(walletServiceProvider).balance(),
);

final walletTransactionsProvider =
    FutureProvider.autoDispose<List<WalletTransaction>>(
  (ref) => ref.watch(walletServiceProvider).transactions(),
);
