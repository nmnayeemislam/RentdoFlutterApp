import 'package:flutter/material.dart';

/// Centralized elevation/shadow tokens.
abstract final class AppShadows {
  AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x120E1424),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x0C0E1424),
      blurRadius: 10,
      offset: Offset(0, 3),
    ),
  ];

  /// Indigo-tinted lift used for primary/floating elements.
  static const List<BoxShadow> raised = [
    BoxShadow(
      color: Color(0x2E4F52E8),
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
  ];

  static const List<BoxShadow> bottomBar = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 20,
      offset: Offset(0, -4),
    ),
  ];
}
