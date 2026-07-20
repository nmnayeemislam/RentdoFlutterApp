// Smoke test: the app boots and renders its first frame without throwing.
//
// The startup bootstrap call is overridden so the test doesn't touch the
// network (which would leave a pending Dio timeout timer).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rentdo/app.dart';
import 'package:rentdo/features/config/models/bootstrap.dart';
import 'package:rentdo/features/config/providers/config_providers.dart';

void main() {
  testWidgets('RentdoApp builds without error', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bootstrapProvider.overrideWith((ref) async => Bootstrap.fromJson(const {})),
        ],
        child: const RentdoApp(),
      ),
    );

    // Advance past the splash entrance animation's staggered delay so no
    // one-shot timer is left pending when the test ends.
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
