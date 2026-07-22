import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/providers/core_providers.dart';

// ── Models ─────────────────────────────────────────────────────────────────

class RentUnit {
  const RentUnit({
    required this.id,
    required this.name,
    this.propertyListingId,
    this.floor,
    this.rentAmount,
    this.status,
    this.notes,
  });

  final int id;
  final String name;
  final int? propertyListingId;
  final String? floor;
  final num? rentAmount;
  final String? status;
  final String? notes;

  factory RentUnit.fromJson(Map<String, dynamic> j) => RentUnit(
        id: (j['id'] as num?)?.toInt() ?? 0,
        name: j['name'] as String? ?? '',
        propertyListingId: (j['property_listing_id'] as num?)?.toInt(),
        floor: j['floor']?.toString(),
        rentAmount: j['rent_amount'] as num?,
        status: j['status'] as String?,
        notes: j['notes'] as String?,
      );
}

class Tenancy {
  const Tenancy({
    required this.id,
    this.tenantName,
    this.tenantPhone,
    this.rentAmount,
    this.depositAmount,
    this.dueDayOfMonth,
    this.startDate,
    this.endDate,
    this.status,
  });

  final int id;
  final String? tenantName;
  final String? tenantPhone;
  final num? rentAmount;
  final num? depositAmount;
  final int? dueDayOfMonth;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;

  factory Tenancy.fromJson(Map<String, dynamic> j) {
    final tenant = j['tenant'];
    return Tenancy(
      id: (j['id'] as num?)?.toInt() ?? 0,
      tenantName: tenant is Map ? tenant['name'] as String? : null,
      tenantPhone: tenant is Map ? tenant['phone'] as String? : null,
      rentAmount: j['rent_amount'] as num?,
      depositAmount: j['deposit_amount'] as num?,
      dueDayOfMonth: (j['due_day_of_month'] as num?)?.toInt(),
      startDate: DateTime.tryParse('${j['start_date']}'),
      endDate: DateTime.tryParse('${j['end_date']}'),
      status: j['status'] as String?,
    );
  }
}

class RentPayment {
  const RentPayment({
    required this.id,
    required this.status,
    this.amount,
    this.dueDate,
    this.paidAt,
    this.periodStart,
    this.periodEnd,
  });

  final int id;
  final String status;
  final num? amount;
  final DateTime? dueDate;
  final DateTime? paidAt;
  final DateTime? periodStart;
  final DateTime? periodEnd;

  bool get isPaid => status == 'paid';

  factory RentPayment.fromJson(Map<String, dynamic> j) => RentPayment(
        id: (j['id'] as num?)?.toInt() ?? 0,
        status: j['status'] as String? ?? 'due',
        amount: j['amount'] as num?,
        dueDate: DateTime.tryParse('${j['due_date']}'),
        paidAt: DateTime.tryParse('${j['paid_at']}'),
        periodStart: DateTime.tryParse('${j['period_start']}'),
        periodEnd: DateTime.tryParse('${j['period_end']}'),
      );
}

class LedgerEntry {
  const LedgerEntry({
    required this.id,
    required this.type,
    this.category,
    this.amount,
    this.occurredOn,
    this.description,
  });

  final int id;

  /// `income` | `expense`.
  final String type;
  final String? category;
  final num? amount;
  final DateTime? occurredOn;
  final String? description;

  bool get isIncome => type == 'income';

  factory LedgerEntry.fromJson(Map<String, dynamic> j) => LedgerEntry(
        id: (j['id'] as num?)?.toInt() ?? 0,
        type: j['type'] as String? ?? 'expense',
        category: j['category'] as String?,
        amount: j['amount'] as num?,
        occurredOn: DateTime.tryParse('${j['occurred_on']}'),
        description: j['description'] as String?,
      );
}

class Agreement {
  const Agreement({
    required this.id,
    this.tenancyId,
    this.templateId,
    this.content,
    this.status,
    this.generatedAt,
  });

  final int id;
  final int? tenancyId;
  final int? templateId;
  final String? content;
  final String? status;
  final DateTime? generatedAt;

  factory Agreement.fromJson(Map<String, dynamic> j) => Agreement(
        id: (j['id'] as num?)?.toInt() ?? 0,
        tenancyId: (j['tenancy_id'] as num?)?.toInt(),
        templateId: (j['agreement_template_id'] as num?)?.toInt(),
        content: j['content'] as String?,
        status: j['status'] as String?,
        generatedAt: DateTime.tryParse('${j['generated_at']}')?.toLocal(),
      );
}

class AgreementTemplate {
  const AgreementTemplate({
    required this.id,
    required this.name,
    this.body,
    this.isDefault = false,
  });

  final int id;
  final String name;
  final String? body;
  final bool isDefault;

  factory AgreementTemplate.fromJson(Map<String, dynamic> j) =>
      AgreementTemplate(
        id: (j['id'] as num?)?.toInt() ?? 0,
        name: j['name'] as String? ?? '',
        body: j['body'] as String?,
        isDefault: j['is_default'] == true,
      );
}

class LedgerSummary {
  const LedgerSummary({this.income = 0, this.expense = 0, this.net = 0});
  final num income;
  final num expense;
  final num net;

  factory LedgerSummary.fromJson(Map<String, dynamic> j) => LedgerSummary(
        income: (j['income'] as num?) ?? 0,
        expense: (j['expense'] as num?) ?? 0,
        net: (j['net'] as num?) ?? 0,
      );
}

// ── Service ────────────────────────────────────────────────────────────────

class RentManagementService {
  RentManagementService(this._api);
  final ApiClient _api;

  static const _base = '/rent-management';

  List<T> _list<T>(Map<String, dynamic>? data, T Function(Map<String, dynamic>) f) =>
      (data?['data'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(f)
          .toList(growable: false);

  Future<List<RentUnit>> units() async =>
      _list((await _api.get<Map<String, dynamic>>('$_base/units')).data,
          RentUnit.fromJson);

  Future<void> createUnit({
    required int propertyListingId,
    required String name,
    String? floor,
    num? rentAmount,
    String? notes,
  }) =>
      _api.post<dynamic>('$_base/units', data: {
        'property_listing_id': propertyListingId,
        'name': name,
        'floor': ?floor,
        'rent_amount': ?rentAmount,
        'notes': ?notes,
      });

  Future<void> deleteUnit(int id) => _api.delete<dynamic>('$_base/units/$id');

  Future<List<Tenancy>> tenancies() async =>
      _list((await _api.get<Map<String, dynamic>>('$_base/tenancies')).data,
          Tenancy.fromJson);

  Future<void> createTenancy({
    required int propertyListingId,
    int? unitId,
    required String tenantName,
    String? tenantPhone,
    required num rentAmount,
    num? depositAmount,
    int? dueDayOfMonth,
    required DateTime startDate,
    DateTime? endDate,
  }) {
    String ymd(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    return _api.post<dynamic>('$_base/tenancies', data: {
      'property_listing_id': propertyListingId,
      'unit_id': ?unitId,
      'tenant_name': tenantName,
      'tenant_phone': ?tenantPhone,
      'rent_amount': rentAmount,
      'deposit_amount': ?depositAmount,
      'due_day_of_month': ?dueDayOfMonth,
      'start_date': ymd(startDate),
      if (endDate != null) 'end_date': ymd(endDate),
    });
  }

  Future<List<RentPayment>> rentPayments() async =>
      _list((await _api.get<Map<String, dynamic>>('$_base/rent-payments')).data,
          RentPayment.fromJson);

  Future<void> markPaid(int paymentId) =>
      _api.post<dynamic>('$_base/rent-payments/$paymentId/mark-paid');

  // ── Agreements & templates ───────────────────────────────────────────────
  Future<List<Agreement>> agreements() async =>
      _list((await _api.get<Map<String, dynamic>>('$_base/agreements')).data,
          Agreement.fromJson);

  /// Generates an agreement for a tenancy from a template.
  Future<void> createAgreement({
    required int tenancyId,
    required int templateId,
  }) =>
      _api.post<dynamic>('$_base/agreements', data: {
        'tenancy_id': tenancyId,
        'agreement_template_id': templateId,
      });

  Future<List<AgreementTemplate>> agreementTemplates() async => _list(
      (await _api.get<Map<String, dynamic>>('$_base/agreement-templates')).data,
      AgreementTemplate.fromJson);

  Future<void> createAgreementTemplate({
    required String name,
    required String body,
    bool isDefault = false,
  }) =>
      _api.post<dynamic>('$_base/agreement-templates', data: {
        'name': name,
        'body': body,
        'is_default': isDefault,
      });

  Future<void> deleteAgreementTemplate(int id) =>
      _api.delete<dynamic>('$_base/agreement-templates/$id');

  Future<List<LedgerEntry>> ledger() async =>
      _list((await _api.get<Map<String, dynamic>>('$_base/ledger-transactions')).data,
          LedgerEntry.fromJson);

  Future<LedgerSummary> ledgerSummary() async {
    final res =
        await _api.get<Map<String, dynamic>>('$_base/ledger-transactions/summary');
    return LedgerSummary.fromJson(
        (res.data?['data'] as Map<String, dynamic>?) ?? const {});
  }

  Future<void> addLedgerEntry({
    required String type,
    required String category,
    required num amount,
    required DateTime occurredOn,
    int? propertyListingId,
    String? description,
  }) {
    String ymd(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    return _api.post<dynamic>('$_base/ledger-transactions', data: {
      'type': type,
      'category': category,
      'amount': amount,
      'occurred_on': ymd(occurredOn),
      'property_listing_id': ?propertyListingId,
      'description': ?description,
    });
  }
}

final rentManagementServiceProvider = Provider<RentManagementService>(
  (ref) => RentManagementService(ref.watch(apiClientProvider)),
);

final rentUnitsProvider = FutureProvider.autoDispose<List<RentUnit>>(
  (ref) => ref.watch(rentManagementServiceProvider).units(),
);
final tenanciesProvider = FutureProvider.autoDispose<List<Tenancy>>(
  (ref) => ref.watch(rentManagementServiceProvider).tenancies(),
);
final rentPaymentsProvider = FutureProvider.autoDispose<List<RentPayment>>(
  (ref) => ref.watch(rentManagementServiceProvider).rentPayments(),
);
final ledgerProvider = FutureProvider.autoDispose<List<LedgerEntry>>(
  (ref) => ref.watch(rentManagementServiceProvider).ledger(),
);
final ledgerSummaryProvider = FutureProvider.autoDispose<LedgerSummary>(
  (ref) => ref.watch(rentManagementServiceProvider).ledgerSummary(),
);
final agreementsProvider = FutureProvider.autoDispose<List<Agreement>>(
  (ref) => ref.watch(rentManagementServiceProvider).agreements(),
);
final agreementTemplatesProvider =
    FutureProvider.autoDispose<List<AgreementTemplate>>(
  (ref) => ref.watch(rentManagementServiceProvider).agreementTemplates(),
);
