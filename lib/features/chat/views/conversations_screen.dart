import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/chat_viewmodel.dart';

/// Lists the user's chat conversations, or a sign-in prompt for guests.
class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.watch(authViewModelProvider.select((s) => s.isAuthenticated));

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: !isAuthed
          ? const _GuestPrompt()
          : ref.watch(conversationsViewModelProvider).when(
                loading: () => const LoadingWidget(),
                error: (e, _) => AppErrorWidget(
                  message: '$e',
                  onRetry: () => ref
                      .read(conversationsViewModelProvider.notifier)
                      .refresh(),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return const EmptyState(
                      icon: Icons.chat_bubble_outline,
                      title: 'No messages yet',
                      subtitle: 'Start a conversation from any listing.',
                    );
                  }
                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () => ref
                        .read(conversationsViewModelProvider.notifier)
                        .refresh(),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: items.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, i) =>
                          _ConversationTile(conversation: items[i]),
                    ),
                  );
                },
              ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.conversation});
  final ConversationModel conversation;

  String get _initials {
    final name = conversation.otherPartyName?.trim() ?? '';
    if (name.isEmpty) return '';
    final parts = name.split(RegExp(r'\s+'));
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
    return '$first$last'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final name = (conversation.otherPartyName != null &&
            conversation.otherPartyName!.isNotEmpty)
        ? conversation.otherPartyName!
        : 'Owner';
    final avatar = conversation.otherPartyAvatar;
    final body = conversation.lastMessageBody ?? '';
    final preview = conversation.lastMessageIsMine ? 'You: $body' : body;
    final hasUnread = conversation.unreadCount > 0;

    return InkWell(
      borderRadius: AppRadius.brLg,
      onTap: () => context.push(AppRoutes.chat(conversation.id)),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: AppRadius.brLg,
          border: Border.all(color: context.colors.outline),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Avatar(url: avatar, initials: _initials),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMd,
                  ),
                  if (conversation.listingTitle != null &&
                      conversation.listingTitle!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      conversation.listingTitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption,
                    ),
                  ],
                  if (preview.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySm.copyWith(
                        fontWeight:
                            hasUnread ? FontWeight.w600 : FontWeight.w400,
                        color: hasUnread
                            ? Theme.of(context).colorScheme.onSurface
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formatters.relative(conversation.lastMessageAt),
                  style: AppTextStyles.caption,
                ),
                if (hasUnread) ...[
                  const SizedBox(height: AppSpacing.xs),
                  _UnreadBadge(count: conversation.unreadCount),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url, required this.initials});
  final String? url;
  final String initials;

  @override
  Widget build(BuildContext context) {
    if (url != null && url!.isNotEmpty) {
      return NetworkImageWidget(
        url: url,
        width: 48,
        height: 48,
        borderRadius: BorderRadius.circular(24),
      );
    }
    return CircleAvatar(
      radius: 24,
      backgroundColor: AppColors.primarySurface,
      child: initials.isEmpty
          ? const Icon(Icons.person, color: AppColors.primary)
          : Text(
              initials,
              style: AppTextStyles.titleSm.copyWith(color: AppColors.primary),
            ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 20),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppRadius.brPill,
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _GuestPrompt extends StatelessWidget {
  const _GuestPrompt();

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.chat_bubble_outline,
      title: 'Sign in to see your messages',
      subtitle: 'Log in to chat with property owners.',
      action: SizedBox(
        width: 200,
        child: PrimaryButton(
          label: 'Log in',
          onPressed: () => context.push(AppRoutes.login),
        ),
      ),
    );
  }
}
