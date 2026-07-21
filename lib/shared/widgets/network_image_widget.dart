import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Cached network image with graceful loading/error placeholders.
///
/// Centralizing this means every remote image in the app has consistent
/// shimmer/fallback behavior and caching.
class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color placeholder =
        isDark ? AppColors.surfaceAltDark : AppColors.surfaceAltLight;

    Widget child;
    if (url == null || url!.isEmpty) {
      child = _fallback(placeholder);
    } else {
      final double dpr = MediaQuery.devicePixelRatioOf(context);
      // Decode each image at its on-screen size instead of the source's full
      // resolution. This is the single biggest memory/scroll-jank win: a 4000px
      // photo shown in a 280px card otherwise decodes a ~30 MB bitmap.
      child = LayoutBuilder(
        builder: (context, constraints) {
          final double target = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : (width ?? 400);
          final int memW = (target * dpr).clamp(64, 2000).round();
          return CachedNetworkImage(
            imageUrl: url!,
            width: width,
            height: height,
            fit: fit,
            memCacheWidth: memW,
            fadeInDuration: const Duration(milliseconds: 180),
            placeholder: (_, _) => Container(color: placeholder),
            errorWidget: (_, _, _) => _fallback(placeholder),
          );
        },
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }

  Widget _fallback(Color bg) => Container(
        width: width,
        height: height,
        color: bg,
        alignment: Alignment.center,
        child: const Icon(Icons.image_outlined,
            color: AppColors.textTertiary, size: 32),
      );
}
