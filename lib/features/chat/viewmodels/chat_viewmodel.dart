import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/core_providers.dart';

/// A conversation summary (`ConversationResource`).
class ConversationModel {
  const ConversationModel({
    required this.id,
    this.listingId,
    this.listingTitle,
    this.otherPartyName,
    this.otherPartyAvatar,
    this.lastMessageBody,
    this.lastMessageIsMine = false,
    this.unreadCount = 0,
    this.lastMessageAt,
  });

  final int id;
  final int? listingId;
  final String? listingTitle;
  final String? otherPartyName;
  final String? otherPartyAvatar;
  final String? lastMessageBody;
  final bool lastMessageIsMine;
  final int unreadCount;
  final DateTime? lastMessageAt;

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final listing = json['listing'];
    final other = json['other_party'];
    final last = json['last_message'];
    return ConversationModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      listingId: listing is Map ? (listing['id'] as num?)?.toInt() : null,
      listingTitle: listing is Map ? listing['title'] as String? : null,
      otherPartyName: other is Map ? other['name'] as String? : null,
      otherPartyAvatar: other is Map ? other['avatar'] as String? : null,
      lastMessageBody: last is Map ? last['body'] as String? : null,
      lastMessageIsMine: last is Map && last['is_mine'] == true,
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
      lastMessageAt: DateTime.tryParse('${json['last_message_at']}')?.toLocal(),
    );
  }
}

/// A chat message (`MessageResource`).
class MessageModel {
  const MessageModel({
    required this.id,
    required this.body,
    required this.isMine,
    this.senderName,
    this.createdAt,
  });

  final int id;
  final String body;
  final bool isMine;
  final String? senderName;
  final DateTime? createdAt;

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final sender = json['sender'];
    return MessageModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      body: json['body'] as String? ?? '',
      isMine: json['is_mine'] == true,
      senderName: sender is Map ? sender['name'] as String? : null,
      createdAt: DateTime.tryParse('${json['created_at']}')?.toLocal(),
    );
  }
}

class ChatService {
  ChatService(this._api);
  final ApiClient _api;

  Future<List<ConversationModel>> conversations() async {
    final res = await _api.get<Map<String, dynamic>>(ApiEndpoints.conversations);
    return (res.data?['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(ConversationModel.fromJson)
        .toList(growable: false);
  }

  /// Starts (or reuses) a conversation about a listing. Returns its id.
  Future<int> start(int listingId, String message) async {
    final res = await _api.post<Map<String, dynamic>>(
      ApiEndpoints.conversations,
      data: {'listing_id': listingId, 'message': message},
    );
    final data = res.data?['data'] as Map<String, dynamic>?;
    return (data?['id'] as num?)?.toInt() ?? 0;
  }

  Future<List<MessageModel>> messages(int conversationId) async {
    final res = await _api.get<Map<String, dynamic>>(
      ApiEndpoints.conversationMessages(conversationId),
    );
    final list = (res.data?['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(MessageModel.fromJson)
        .toList();
    // API returns newest-first; show oldest-first in the thread.
    return list.reversed.toList(growable: false);
  }

  Future<void> send(int conversationId, String message) => _api.post<dynamic>(
        ApiEndpoints.conversationMessages(conversationId),
        data: {'message': message},
      );

  Future<void> markRead(int conversationId) =>
      _api.post<dynamic>(ApiEndpoints.conversationRead(conversationId));
}

final chatServiceProvider = Provider<ChatService>(
  (ref) => ChatService(ref.watch(apiClientProvider)),
);

/// The user's conversations, newest activity first.
class ConversationsViewModel
    extends AutoDisposeAsyncNotifier<List<ConversationModel>> {
  @override
  Future<List<ConversationModel>> build() =>
      ref.read(chatServiceProvider).conversations();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(chatServiceProvider).conversations(),
    );
  }
}

final conversationsViewModelProvider = AutoDisposeAsyncNotifierProvider<
    ConversationsViewModel, List<ConversationModel>>(ConversationsViewModel.new);

/// Messages for a single conversation.
final conversationMessagesProvider = FutureProvider.autoDispose
    .family<List<MessageModel>, int>((ref, conversationId) async {
  final messages =
      await ref.watch(chatServiceProvider).messages(conversationId);
  // Best-effort mark-as-read when the thread is opened.
  await ref.read(chatServiceProvider).markRead(conversationId);
  return messages;
});
