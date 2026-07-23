import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeRevealRequest {
  const ThemeRevealRequest({
    required this.id,
    required this.center,
    required this.targetMode,
  });

  final int id;
  final Offset center;
  final ThemeMode targetMode;
}

class ThemeRevealController extends Notifier<ThemeRevealRequest?> {
  int _id = 0;

  @override
  ThemeRevealRequest? build() => null;

  void start({required Offset center, required ThemeMode targetMode}) {
    state = ThemeRevealRequest(
      id: ++_id,
      center: center,
      targetMode: targetMode,
    );
  }
}

final themeRevealProvider =
    NotifierProvider<ThemeRevealController, ThemeRevealRequest?>(
      ThemeRevealController.new,
    );
