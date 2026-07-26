import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// The app's spinner, swapped per locale: Arabic gets `staggeredDotsWave`
/// (reads better right-to-left), every other language keeps `dotsTriangle`.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return isArabic
        ? LoadingAnimationWidget.staggeredDotsWave(color: color, size: size)
        : LoadingAnimationWidget.dotsTriangle(color: color, size: size);
  }
}
