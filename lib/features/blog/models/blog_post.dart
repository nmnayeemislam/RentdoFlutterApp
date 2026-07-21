/// A blog post from `GET /blog` (list, no [content]) or `GET /blog/{slug}`
/// (detail, with [content] and [related]).
class BlogPost {
  const BlogPost({
    required this.id,
    required this.slug,
    required this.title,
    required this.excerpt,
    required this.featuredImage,
    required this.tags,
    required this.readMinutes,
    required this.viewCount,
    this.publishedAt,
    this.categoryName,
    this.categorySlug,
    this.authorName,
    this.authorAvatar,
    this.content,
    this.related = const [],
  });

  final int id;
  final String slug;
  final String title;
  final String excerpt;
  final String featuredImage;
  final List<String> tags;
  final int readMinutes;
  final int viewCount;
  final DateTime? publishedAt;
  final String? categoryName;
  final String? categorySlug;
  final String? authorName;
  final String? authorAvatar;

  /// Full HTML body — only present on the detail response.
  final String? content;
  final List<BlogPost> related;

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    final category = json['category'] as Map<String, dynamic>?;
    final author = json['author'] as Map<String, dynamic>?;
    return BlogPost(
      id: (json['id'] as num?)?.toInt() ?? 0,
      slug: '${json['slug'] ?? ''}',
      title: '${json['title'] ?? ''}',
      excerpt: '${json['excerpt'] ?? ''}',
      featuredImage: '${json['featured_image'] ?? ''}',
      tags: (json['tags'] as List? ?? const [])
          .map((e) => '$e')
          .toList(growable: false),
      readMinutes: (json['read_minutes'] as num?)?.toInt() ?? 1,
      viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
      publishedAt: DateTime.tryParse('${json['published_at'] ?? ''}'),
      categoryName: category?['name'] as String?,
      categorySlug: category?['slug'] as String?,
      authorName: author?['name'] as String?,
      authorAvatar: author?['avatar'] as String?,
      content: json['content'] as String?,
      related: (json['related'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(BlogPost.fromJson)
          .toList(growable: false),
    );
  }
}

/// A blog category from `GET /blog/categories`.
class BlogCategory {
  const BlogCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.postsCount,
  });

  final int id;
  final String name;
  final String slug;
  final int postsCount;

  factory BlogCategory.fromJson(Map<String, dynamic> json) => BlogCategory(
        id: (json['id'] as num?)?.toInt() ?? 0,
        name: '${json['name'] ?? ''}',
        slug: '${json['slug'] ?? ''}',
        postsCount: (json['posts_count'] as num?)?.toInt() ?? 0,
      );
}
