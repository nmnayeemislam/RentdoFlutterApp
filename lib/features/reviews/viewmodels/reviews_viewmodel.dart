import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/core_providers.dart';

/// A review (`ReviewResource`).
class ReviewModel {
  const ReviewModel({
    required this.id,
    required this.rating,
    this.body,
    this.ownerReply,
    this.reviewerName,
    this.reviewerAvatar,
    this.createdAt,
  });

  final int id;
  final int rating;
  final String? body;
  final String? ownerReply;
  final String? reviewerName;
  final String? reviewerAvatar;
  final DateTime? createdAt;

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final reviewer = json['reviewer'];
    return ReviewModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      body: json['body'] as String?,
      ownerReply: json['owner_reply'] as String?,
      reviewerName: reviewer is Map ? reviewer['name'] as String? : null,
      reviewerAvatar: reviewer is Map ? reviewer['avatar'] as String? : null,
      createdAt: DateTime.tryParse('${json['created_at']}')?.toLocal(),
    );
  }
}

class ReviewService {
  ReviewService(this._api);
  final ApiClient _api;

  Future<List<ReviewModel>> forListing(int listingId) async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.reviews,
      query: {'reviewable_type': 'listing', 'reviewable_id': listingId},
      requiresAuth: false,
    );
    return (res.data?['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(ReviewModel.fromJson)
        .toList(growable: false);
  }

  /// Reports an abusive/spam review.
  Future<void> report(int reviewId, String reason) => _api.post<dynamic>(
        ApiEndpoints.reviewReport(reviewId),
        data: {'reason': reason},
      );

  Future<void> submit(int listingId, int rating, String? body) => _api.post<dynamic>(
        ApiEndpoints.reviews,
        data: {
          'reviewable_type': 'listing',
          'reviewable_id': listingId,
          'rating': rating,
          if (body != null && body.isNotEmpty) 'body': body,
        },
      );
}

final reviewServiceProvider = Provider<ReviewService>(
  (ref) => ReviewService(ref.watch(apiClientProvider)),
);

/// Visible reviews for a listing.
final listingReviewsProvider =
    FutureProvider.autoDispose.family<List<ReviewModel>, int>((ref, listingId) {
  return ref.watch(reviewServiceProvider).forListing(listingId);
});
