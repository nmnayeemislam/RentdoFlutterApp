import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../properties/models/property_model.dart';
import '../controllers/compare_controller.dart';

/// Toggles a listing in/out of the compare set. Used on the detail screen.
/// Guests are prompted to sign in; for authed users it reflects live
/// membership from [compareControllerProvider].
class CompareButton extends ConsumerWidget {
  const CompareButton({super.key, required this.property});

  final PropertyModel property;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthed =
        ref.watch(authControllerProvider.select((s) => s.isAuthenticated));

    if (!isAuthed) {
      return IconButton(
        icon: const Icon(Icons.compare_arrows_rounded, color: AppColors.ink),
        tooltip: 'Compare',
        onPressed: () {
          context.showSnack('Log in to compare properties.');
          context.push(AppRoutes.login);
        },
      );
    }

    final isIn = ref.watch(compareControllerProvider
        .select((s) => s.valueOrNull?.any((p) => p.id == property.id) ?? false));

    return IconButton(
      icon: Icon(
        Icons.compare_arrows_rounded,
        color: isIn ? AppColors.primary : AppColors.ink,
      ),
      tooltip: isIn ? 'Remove from compare' : 'Add to compare',
      onPressed: () async {
        try {
          final added =
              await ref.read(compareControllerProvider.notifier).toggle(property);
          if (!context.mounted) return;
          context.showSnack(added ? 'Added to compare' : 'Removed from compare');
        } on ApiException catch (e) {
          if (!context.mounted) return;
          context.showSnack(e.message, error: true);
        }
      },
    );
  }
}
