import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../core/theme/app_colors.dart';

class ScreenLoadingOverlay extends StatelessWidget {
  const ScreenLoadingOverlay({
    super.key,
    required this.loading,
    required this.child,
  });

  final bool loading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (loading)
          Positioned.fill(
            child: AbsorbPointer(
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.08),
                child: Center(
                  child: LoadingAnimationWidget.dotsTriangle(
                    color: AppColors.primary,
                    size: 54,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
