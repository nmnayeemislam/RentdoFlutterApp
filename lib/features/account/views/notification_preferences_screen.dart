import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/account_viewmodel.dart';

/// Per-event × per-channel notification switches
/// (`GET|PUT /me/notification-preferences`).
class NotificationPreferencesScreen extends ConsumerStatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  ConsumerState<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends ConsumerState<NotificationPreferencesScreen> {
  NotificationPreferences? _prefs;
  bool _saving = false;

  Future<void> _save() async {
    final prefs = _prefs;
    if (prefs == null) return;

    setState(() => _saving = true);
    try {
      await ref
          .read(accountServiceProvider)
          .updateNotificationPreferences(prefs);
      if (!mounted) return;
      context.showSnack('Preferences saved');
    } on ApiException catch (e) {
      if (!mounted) return;
      context.showSnack(e.message, error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAuthed = ref.watch(
      authViewModelProvider.select((s) => s.isAuthenticated),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: !isAuthed
          ? const _GuestPrompt()
          : ref.watch(notificationPreferencesProvider).when(
                loading: () => const LoadingWidget(),
                error: (e, _) => AppErrorWidget(
                  message: e is ApiException ? e.message : '$e',
                  onRetry: () =>
                      ref.invalidate(notificationPreferencesProvider),
                ),
                data: (loaded) {
                  final prefs = _prefs ??= loaded;
                  return ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      for (final event in NotificationPreferences.events) ...[
                        _EventCard(
                          event: event,
                          prefs: prefs,
                          onChanged: (channel, value) => setState(
                            () => _prefs = prefs.withValue(
                              event,
                              channel,
                              value,
                            ),
                          ),
                        ),
                        AppSpacing.vGapMd,
                      ],
                      AppSpacing.vGapSm,
                      PrimaryButton(
                        label: 'Save changes',
                        isLoading: _saving,
                        onPressed: () => unawaited(_save()),
                      ),
                    ],
                  );
                },
              ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({
    required this.event,
    required this.prefs,
    required this.onChanged,
  });

  final String event;
  final NotificationPreferences prefs;
  final void Function(String channel, bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: context.colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            NotificationPreferences.eventLabels[event] ?? event,
            style: AppTextStyles.titleMd,
          ),
          for (final channel in NotificationPreferences.channels)
            SwitchListTile.adaptive(
              dense: true,
              contentPadding: EdgeInsets.zero,
              activeThumbColor: AppColors.primary,
              title: Text(
                NotificationPreferences.channelLabels[channel] ?? channel,
                style: AppTextStyles.bodyMd,
              ),
              value: prefs.enabled(event, channel),
              onChanged: (v) => onChanged(channel, v),
            ),
        ],
      ),
    );
  }
}

class _GuestPrompt extends StatelessWidget {
  const _GuestPrompt();

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.notifications_none_rounded,
      title: 'Sign in to manage notifications',
      subtitle: 'Log in to choose how and when we contact you.',
      action: SizedBox(
        width: 200,
        child: PrimaryButton(
          label: 'Log in',
          onPressed: () => context.push(AppRoutes.login),
        ),
      ),
    );
  }
}
