import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../properties/widgets/property_card.dart';
import '../viewmodels/favorites_viewmodel.dart';

/// Saved / favorite listings tab. Shows the user's favorites, or a sign-in
/// prompt for guests.
class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.watch(authViewModelProvider.select((s) => s.isAuthenticated));

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.saved)),
      body: isAuthed ? const _SavedList() : const _GuestPrompt(),
    );
  }
}

class _SavedList extends ConsumerWidget {
  const _SavedList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedViewModelProvider);

    return saved.when(
      loading: () => const LoadingWidget(),
      error: (e, _) => AppErrorWidget(
        message: '$e',
        onRetry: () => ref.read(savedViewModelProvider.notifier).refresh(),
      ),
      data: (items) {
        if (items.isEmpty) {
          return EmptyState(
            icon: Icons.favorite_border_rounded,
            title: context.l10n.savedNoProperties,
            subtitle: context.l10n.savedTapHeartDesc,
            action: SizedBox(
              width: 200,
              child: PrimaryButton(
                label: context.l10n.explore,
                onPressed: () => context.go(AppRoutes.properties),
              ),
            ),
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => ref.read(savedViewModelProvider.notifier).refresh(),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final property = items[index];
              return PropertyCard(
                property: property,
                onTap: () => context.pushNamed(
                  AppRoutes.propertyDetailName,
                  pathParameters: {'id': '${property.id}'},
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _GuestPrompt extends StatelessWidget {
  const _GuestPrompt();

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.favorite_border_rounded,
      title: context.l10n.savedSignInTitle,
      subtitle: context.l10n.savedSignInDesc,
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
