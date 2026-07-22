import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../properties/models/property_model.dart';
import '../viewmodels/compare_viewmodel.dart';

/// Toggles a listing in/out of the compare set. Used on the detail screen.
/// Guests are prompted to sign in; for authed users it reflects live
/// membership from [compareViewModelProvider].
class CompareButton extends ConsumerWidget {
  const CompareButton({super.key, required this.property});

  final PropertyModel property;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.watch(authViewModelProvider.select((s) => s.isAuthenticated));

    if (!isAuthed) {
      return IconButton(
        icon: const Icon(Icons.compare_arrows_rounded, color: AppColors.ink),
        tooltip: context.l10n.compareTitle,
        onPressed: () {
          context.showSnack(context.l10n.compareLogInToCompare);
          context.push(AppRoutes.login);
        },
      );
    }

    final isIn = ref.watch(compareViewModelProvider
        .select((s) => s.valueOrNull?.any((p) => p.id == property.id) ?? false));

    return IconButton(
      icon: Icon(
        Icons.compare_arrows_rounded,
        color: isIn ? AppColors.primary : AppColors.ink,
      ),
      tooltip: isIn
          ? context.l10n.compareRemoveFromCompare
          : context.l10n.compareAddToCompare,
      onPressed: () async {
        try {
          final added =
              await ref.read(compareViewModelProvider.notifier).toggle(property);
          if (!context.mounted) return;
          context.showSnack(added
              ? context.l10n.compareAddedToCompare
              : context.l10n.compareRemovedFromCompare);
        } on ApiException catch (e) {
          if (!context.mounted) return;
          context.showSnack(e.message, error: true);
        }
      },
    );
  }
}
