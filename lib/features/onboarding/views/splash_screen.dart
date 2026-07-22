import 'package:flutter/material.dart';

/// Branded splash shown while the auth session is restored. The router redirects
/// away once [AuthStatus] resolves, so this screen has no timers of its own.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.expand(
        child: Image(
          image: AssetImage('assets/images/onboarding/splash.gif'),
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
      ),
    );
  }
}
