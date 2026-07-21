import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/core_providers.dart';
import '../models/cms_page.dart';

/// Thin data source for the public content/support endpoints.
class SupportRepository {
  SupportRepository(this._api);

  final ApiClient _api;

  /// `GET /pages/{slug}` — a published CMS page (privacy policy, terms, …).
  Future<CmsPage> page(String slug) async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.page(slug),
      requiresAuth: false,
    );
    final data = (res.data?['data'] as Map<String, dynamic>?) ?? const {};
    return CmsPage.fromJson(data);
  }

  /// `GET /faqs` — active FAQs grouped by category.
  Future<List<FaqSection>> faqs() async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.faqs,
      requiresAuth: false,
    );
    return (res.data?['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(FaqSection.fromJson)
        .toList(growable: false);
  }

  /// `POST /contact` — submit a contact-us message.
  Future<void> sendContactMessage({
    required String name,
    required String email,
    String? phone,
    required String subject,
    required String message,
  }) async {
    await _api.post<Map<String, dynamic>>(
      ApiEndpoints.contact,
      requiresAuth: false,
      data: {
        'name': name,
        'email': email,
        if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
        'subject': subject,
        'message': message,
      },
    );
  }
}

final supportRepositoryProvider = Provider<SupportRepository>(
  (ref) => SupportRepository(ref.watch(apiClientProvider)),
);

/// A CMS page by slug (e.g. `privacy-policy`, `terms-of-service`).
final cmsPageProvider =
    FutureProvider.autoDispose.family<CmsPage, String>((ref, slug) {
  return ref.watch(supportRepositoryProvider).page(slug);
});

/// Active FAQs grouped by category.
final faqsProvider = FutureProvider.autoDispose<List<FaqSection>>((ref) {
  return ref.watch(supportRepositoryProvider).faqs();
});
