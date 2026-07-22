import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/core_providers.dart';

class MaintenanceRequest {
  const MaintenanceRequest({
    required this.id,
    required this.title,
    this.description,
    this.priority,
    this.status,
    this.listingTitle,
    this.technicianName,
    this.createdAt,
  });

  final int id;
  final String title;
  final String? description;
  final String? priority;
  final String? status;
  final String? listingTitle;
  final String? technicianName;
  final DateTime? createdAt;

  factory MaintenanceRequest.fromJson(Map<String, dynamic> j) {
    final listing = j['listing'];
    final technician = j['technician'];
    return MaintenanceRequest(
      id: (j['id'] as num?)?.toInt() ?? 0,
      title: j['title'] as String? ?? '',
      description: j['description'] as String?,
      priority: j['priority'] as String?,
      status: j['status'] as String?,
      listingTitle: listing is Map ? listing['title'] as String? : null,
      technicianName: technician is Map ? technician['name'] as String? : null,
      createdAt: DateTime.tryParse('${j['created_at']}')?.toLocal(),
    );
  }
}

class MaintenanceService {
  MaintenanceService(this._api);
  final ApiClient _api;

  Future<List<MaintenanceRequest>> list() async {
    final res =
        await _api.get<Map<String, dynamic>>(ApiEndpoints.maintenanceRequests);
    return (res.data?['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(MaintenanceRequest.fromJson)
        .toList(growable: false);
  }

  Future<void> create({
    required int propertyListingId,
    required String title,
    required String description,
    String priority = 'normal',
  }) =>
      _api.post<dynamic>(ApiEndpoints.maintenanceRequests, data: {
        'property_listing_id': propertyListingId,
        'title': title,
        'description': description,
        'priority': priority,
      });
}

final maintenanceServiceProvider = Provider<MaintenanceService>(
  (ref) => MaintenanceService(ref.watch(apiClientProvider)),
);

class MaintenanceViewModel
    extends AutoDisposeAsyncNotifier<List<MaintenanceRequest>> {
  @override
  Future<List<MaintenanceRequest>> build() =>
      ref.read(maintenanceServiceProvider).list();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(maintenanceServiceProvider).list());
  }

  Future<void> create({
    required int propertyListingId,
    required String title,
    required String description,
    String priority = 'normal',
  }) async {
    await ref.read(maintenanceServiceProvider).create(
          propertyListingId: propertyListingId,
          title: title,
          description: description,
          priority: priority,
        );
    await refresh();
  }
}

final maintenanceViewModelProvider = AutoDisposeAsyncNotifierProvider<
    MaintenanceViewModel,
    List<MaintenanceRequest>>(MaintenanceViewModel.new);
