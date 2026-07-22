import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/community_viewmodel.dart';

/// Users the signed-in account has blocked, with unblock.
class BlockedUsersScreen extends ConsumerWidget {
  const BlockedUsersScreen({super.key});

  Future<void> _unblock(BuildContext context, WidgetRef ref, int userId) async {
    try {
      await ref.read(communityServiceProvider).unblockUser(userId);
      ref.invalidate(blockedUsersProvider);
      if (context.mounted) {
        context.showSnack(context.l10n.communityUserUnblocked);
      }
    } on ApiException catch (e) {
      if (context.mounted) context.showSnack(e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.watch(authViewModelProvider.select((s) => s.isAuthenticated));

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.communityBlockedUsersTitle)),
      body: !isAuthed
          ? EmptyState(
              icon: Icons.block_rounded,
              title: context.l10n.communitySignInToManageBlocks,
              subtitle: context.l10n.communityLogInToSeeBlocked,
              action: SizedBox(
                width: 200,
                child: PrimaryButton(
                  label: context.l10n.login,
                  onPressed: () => context.push(AppRoutes.login),
                ),
              ),
            )
          : ref.watch(blockedUsersProvider).when(
                loading: () => const LoadingWidget(),
                error: (e, _) => AppErrorWidget(
                  message: '$e',
                  onRetry: () => ref.invalidate(blockedUsersProvider),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return EmptyState(
                      icon: Icons.block_rounded,
                      title: context.l10n.communityNoBlockedUsers,
                      subtitle: context.l10n.communityBlockedUsersEmptyDesc,
                    );
                  }
                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async => ref.invalidate(blockedUsersProvider),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final user = items[i];
                        return Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: context.colors.surface,
                            borderRadius: AppRadius.brLg,
                            border: Border.all(color: context.colors.outline),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundColor: AppColors.primarySurface,
                                child: Icon(Icons.person_outline_rounded,
                                    color: AppColors.primary),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  user.name ??
                                      context.l10n.communityUserFallback(user.id),
                                  style: AppTextStyles.titleSm,
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    unawaited(_unblock(context, ref, user.id)),
                                child: Text(context.l10n.communityUnblock),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
