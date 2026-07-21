import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/core_providers.dart';
import '../models/blog_post.dart';

/// Data source for the public blog endpoints.
class BlogRepository {
  BlogRepository(this._api);

  final ApiClient _api;

  /// `GET /blog` — published posts, optionally filtered by category slug/search.
  Future<List<BlogPost>> feed({String? category, String? query}) async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.blog,
      requiresAuth: false,
      query: {
        if (category != null && category.isNotEmpty) 'category': category,
        if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
        'per_page': 30,
      },
    );
    return (res.data?['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(BlogPost.fromJson)
        .toList(growable: false);
  }

  /// `GET /blog/categories` — active categories with post counts.
  Future<List<BlogCategory>> categories() async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.blogCategories,
      requiresAuth: false,
    );
    return (res.data?['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(BlogCategory.fromJson)
        .toList(growable: false);
  }

  /// `GET /blog/{slug}` — a single post with full content and related posts.
  Future<BlogPost> post(String slug) async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.blogPost(slug),
      requiresAuth: false,
    );
    final data = (res.data?['data'] as Map<String, dynamic>?) ?? const {};
    return BlogPost.fromJson(data);
  }
}

final blogRepositoryProvider = Provider<BlogRepository>(
  (ref) => BlogRepository(ref.watch(apiClientProvider)),
);

/// The active category-slug filter for the blog feed (`null` = all).
final blogCategoryFilterProvider = StateProvider<String?>((_) => null);

/// The blog feed, keyed by the current category filter.
final blogFeedProvider = FutureProvider.autoDispose<List<BlogPost>>((ref) {
  final category = ref.watch(blogCategoryFilterProvider);
  return ref.watch(blogRepositoryProvider).feed(category: category);
});

/// Blog categories for the filter bar.
final blogCategoriesProvider =
    FutureProvider.autoDispose<List<BlogCategory>>((ref) {
  return ref.watch(blogRepositoryProvider).categories();
});

/// A single blog post by slug.
final blogPostProvider =
    FutureProvider.autoDispose.family<BlogPost, String>((ref, slug) {
  return ref.watch(blogRepositoryProvider).post(slug);
});
