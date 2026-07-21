/// A published CMS page fetched from `GET /pages/{slug}` (privacy policy,
/// terms of service, …). [content] is sanitized HTML rendered natively.
class CmsPage {
  const CmsPage({
    required this.slug,
    required this.title,
    required this.content,
    this.updatedAt,
  });

  final String slug;
  final String title;
  final String content;
  final DateTime? updatedAt;

  factory CmsPage.fromJson(Map<String, dynamic> json) => CmsPage(
        slug: '${json['slug'] ?? ''}',
        title: '${json['title'] ?? ''}',
        content: '${json['content'] ?? ''}',
        updatedAt: DateTime.tryParse('${json['updated_at'] ?? ''}'),
      );
}

/// A single FAQ entry within a [FaqSection].
class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;

  factory FaqItem.fromJson(Map<String, dynamic> json) => FaqItem(
        question: '${json['question'] ?? ''}',
        answer: '${json['answer'] ?? ''}',
      );
}

/// FAQs grouped by category, from `GET /faqs`.
class FaqSection {
  const FaqSection({required this.category, required this.items});

  final String category;
  final List<FaqItem> items;

  factory FaqSection.fromJson(Map<String, dynamic> json) => FaqSection(
        category: '${json['category'] ?? 'General'}',
        items: (json['items'] as List? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(FaqItem.fromJson)
            .toList(growable: false),
      );
}
