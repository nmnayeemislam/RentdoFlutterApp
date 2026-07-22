/// A user notification (`UserNotificationResource`).
class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    this.type,
    this.body,
    this.data,
    this.isRead = false,
    this.createdAt,
  });

  final int id;
  final String title;
  final String? type;
  final String? body;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime? createdAt;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        title: json['title'] as String? ?? '',
        type: json['type'] as String?,
        body: json['body'] as String?,
        data: json['data'] as Map<String, dynamic>?,
        isRead: json['is_read'] == true,
        createdAt: DateTime.tryParse('${json['created_at']}')?.toLocal(),
      );

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
        id: id,
        title: title,
        type: type,
        body: body,
        data: data,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt,
      );
}
