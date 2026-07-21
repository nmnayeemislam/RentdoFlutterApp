import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

/// Animated shimmer sweep used by all skeleton placeholders. Dependency-free:
/// a single looping controller drives a translating gradient via [ShaderMask],
/// so a whole list of skeletons shares one animation.
class Shimmer extends StatefulWidget {
  const Shimmer({super.key, required this.child});

  final Widget child;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1250),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color base = isDark ? AppColors.surfaceAltDark : AppColors.surfaceAltLight;
    final Color highlight =
        isDark ? AppColors.borderDark : const Color(0xFFFAFBFE);

    // Isolated so the looping shimmer repaint doesn't dirty sibling widgets.
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _c,
        child: widget.child,
        builder: (context, child) {
          return ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              final double dx = bounds.width * (_c.value * 2 - 1);
              return LinearGradient(
                colors: [base, highlight, base],
                stops: const [0.35, 0.5, 0.65],
                transform: _SlideGradient(dx),
              ).createShader(bounds);
            },
            child: child,
          );
        },
      ),
    );
  }
}

/// Horizontal translation applied to the shimmer gradient each frame.
class _SlideGradient extends GradientTransform {
  const _SlideGradient(this.dx);
  final double dx;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(dx, 0, 0);
}

/// A single rounded placeholder block. Wrap a tree of these in one [Shimmer].
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 14,
    this.radius = AppRadius.brSm,
  });

  final double? width;
  final double height;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceAltDark : AppColors.surfaceAltLight,
        borderRadius: radius,
      ),
    );
  }
}

/// Skeleton mirroring [PropertyCard]'s layout — image, price, title, meta row.
class PropertyCardSkeleton extends StatelessWidget {
  const PropertyCardSkeleton({super.key, this.width});

  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Shimmer(
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.brLg,
          border: Border.all(color: theme.colorScheme.outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: SkeletonBox(height: double.infinity, radius: BorderRadius.zero),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(width: 110, height: 18),
                  SizedBox(height: 10),
                  SkeletonBox(width: double.infinity),
                  SizedBox(height: 8),
                  SkeletonBox(width: 140, height: 12),
                  SizedBox(height: 16),
                  SkeletonBox(width: double.infinity, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A vertical list of full-width property-card skeletons.
class PropertyListSkeleton extends StatelessWidget {
  const PropertyListSkeleton({super.key, this.count = 4});

  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: count,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, _) => const PropertyCardSkeleton(),
    );
  }
}

/// A horizontal rail of card skeletons for the Home featured section.
class PropertyRailSkeleton extends StatelessWidget {
  const PropertyRailSkeleton({super.key, this.height = 320, this.cardWidth = 280});

  final double height;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, _) => PropertyCardSkeleton(width: cardWidth),
      ),
    );
  }
}
