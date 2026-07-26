import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'app_loading_indicator.dart';

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
                child: const Center(
                  child: AppLoadingIndicator(
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
