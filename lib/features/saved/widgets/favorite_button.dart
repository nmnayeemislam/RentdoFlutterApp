import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/favorites_controller.dart';

/// A heart toggle that adds/removes a listing from favorites with optimistic
/// UI. Guests are prompted to sign in. Keeps its own state so it can live in a
/// long list without rebuilding the whole card.
class FavoriteButton extends ConsumerStatefulWidget {
  const FavoriteButton({
    super.key,
    required this.listingId,
    required this.initialIsFavorite,
    this.size = 20,
    this.filledBackground = true,
  });

  final int listingId;
  final bool initialIsFavorite;
  final double size;

  /// When true the icon sits on a translucent circular background (for use over
  /// images); otherwise it's a bare icon.
  final bool filledBackground;

  @override
  ConsumerState<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends ConsumerState<FavoriteButton> {
  late bool _isFavorite = widget.initialIsFavorite;
  bool _busy = false;

  Future<void> _toggle() async {
    if (_busy) return;
    final isAuthed =
        ref.read(authControllerProvider.select((s) => s.isAuthenticated));
    if (!isAuthed) {
      context.showSnack('Log in to save properties.');
      unawaited(context.push(AppRoutes.login));
      return;
    }

    final desired = !_isFavorite;
    unawaited(HapticFeedback.lightImpact());
    setState(() {
      _isFavorite = desired;
      _busy = true;
    });

    final repo = ref.read(favoritesRepositoryProvider);
    try {
      if (desired) {
        await repo.add(widget.listingId);
      } else {
        await repo.remove(widget.listingId);
        ref.read(savedControllerProvider.notifier).removeLocally(widget.listingId);
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isFavorite = !desired); // revert
      context.showSnack(e.message, error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
      size: widget.size,
      color: _isFavorite ? AppColors.error : null,
    );

    return Semantics(
      button: true,
      label: _isFavorite ? 'Remove from saved' : 'Save property',
      child: InkResponse(
      onTap: _toggle,
      radius: widget.size + 8,
      child: widget.filledBackground
          ? Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: IconTheme.merge(
                data: const IconThemeData(color: AppColors.ink),
                child: icon,
              ),
            )
          : icon,
      ),
    );
  }
}
