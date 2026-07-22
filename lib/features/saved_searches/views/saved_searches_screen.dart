import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../properties/models/property_filter.dart';
import '../../properties/viewmodels/property_list_viewmodel.dart';
import '../models/saved_search.dart';
import '../viewmodels/saved_search_viewmodel.dart';

class SavedSearchesScreen extends ConsumerWidget {
  const SavedSearchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.watch(authViewModelProvider.select((s) => s.isAuthenticated));
    final searches = ref.watch(savedSearchViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.savedSearchesTitle)),
      body: !isAuthed
          ? const _GuestPrompt()
          : searches.when(
              loading: () => const LoadingWidget(),
              error: (e, _) => AppErrorWidget(
                message: '$e',
                onRetry: () => ref
                    .read(savedSearchViewModelProvider.notifier)
                    .refresh(),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return EmptyState(
                    icon: Icons.bookmark_border_rounded,
                    title: context.l10n.savedSearchesNone,
                    subtitle: context.l10n.savedSearchesEmptyDesc,
                  );
                }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => ref
                      .read(savedSearchViewModelProvider.notifier)
                      .refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, i) => _SearchTile(search: items[i]),
                  ),
                );
              },
            ),
    );
  }
}

class _SearchTile extends ConsumerWidget {
  const _SearchTile({required this.search});
  final SavedSearch search;

  void _apply(BuildContext context, WidgetRef ref) {
    final filter = PropertyFilter.fromCriteria(search.criteria);
    ref.read(propertyListViewModelProvider.notifier).applyFilter(filter);
    context.go(AppRoutes.properties);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: AppRadius.brLg,
      onTap: () => _apply(context, ref),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: AppRadius.brLg,
          border: Border.all(color: context.colors.outline),
        ),
        child: Row(
          children: [
            const Icon(Icons.bookmark_rounded, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(search.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMd),
                  const SizedBox(height: 2),
                  Text(search.summary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySm),
                  Row(
                    children: [
                      Icon(
                        search.alertOn
                            ? Icons.notifications_active_rounded
                            : Icons.notifications_off_outlined,
                        size: 15,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(context.l10n.savedSearchesMatchAlerts,
                          style: AppTextStyles.caption),
                      Switch.adaptive(
                        value: search.alertOn,
                        activeThumbColor: AppColors.primary,
                        onChanged: (v) => ref
                            .read(savedSearchViewModelProvider.notifier)
                            .setAlert(search.id, v),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.textTertiary),
              onPressed: () => ref
                  .read(savedSearchViewModelProvider.notifier)
                  .delete(search.id),
            ),
          ],
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
      icon: Icons.bookmark_border_rounded,
      title: context.l10n.savedSearchesSignInTitle,
      subtitle: context.l10n.savedSearchesLogInDesc,
      action: SizedBox(
        width: 200,
        child: PrimaryButton(
          label: context.l10n.login,
          onPressed: () => context.push(AppRoutes.login),
        ),
      ),
    );
  }
}
