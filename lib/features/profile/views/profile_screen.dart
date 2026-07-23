import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/theme_provider.dart';
import '../../../core/providers/theme_reveal_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../auth/models/user_model.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../config/providers/config_providers.dart';

/// Profile tab: account header, settings menu and logout. Falls back to a
/// sign-in prompt for guests.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch only the slices this screen renders so unrelated auth changes
    // (e.g. isSubmitting during a login elsewhere) don't rebuild it.
    final isAuthenticated = ref.watch(
      authViewModelProvider.select((s) => s.isAuthenticated),
    );
    final user = ref.watch(authViewModelProvider.select((s) => s.user));
    final flags = ref.watch(featureFlagsProvider);

    final l10n = context.l10n;

    // Activity entries gated by server feature flags (chat / hotel bookings /
    // technician marketplace) so a disabled module never shows a dead button.
    final activityItems = <(IconData, String, String?)>[
      if (flags.chat)
        (
          Icons.chat_bubble_outline_rounded,
          l10n.messages,
          AppRoutes.conversations,
        ),
      if (flags.hotelBooking)
        (Icons.hotel_outlined, l10n.bookingsTitle, AppRoutes.myBookings),
      (Icons.calendar_today_outlined, l10n.profileMyVisits, AppRoutes.myVisits),
      if (flags.technicianMarketplace) ...[
        (
          Icons.handyman_outlined,
          l10n.profileFindTechnician,
          AppRoutes.technicians,
        ),
        (
          Icons.build_outlined,
          l10n.profileServiceBookings,
          AppRoutes.serviceBookings,
        ),
        (
          Icons.engineering_outlined,
          l10n.profileBecomeTechnician,
          AppRoutes.becomeTechnician,
        ),
        (
          Icons.badge_outlined,
          l10n.profileMyTechnicianProfile,
          AppRoutes.technicianProfile,
        ),
      ],
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            if (isAuthenticated && user != null)
              _ProfileHeader(user: user)
            else
              const _GuestHeader(),
            AppSpacing.vGapXl,
            _MenuGroup(title: l10n.profileActivity, items: activityItems),
            AppSpacing.vGapLg,
            _MenuGroup(
              title: l10n.profileLists,
              items: [
                (
                  Icons.favorite_border_rounded,
                  l10n.profileSavedProperties,
                  AppRoutes.saved,
                ),
                (
                  Icons.bookmark_border_rounded,
                  l10n.profileSavedSearches,
                  AppRoutes.savedSearches,
                ),
                (
                  Icons.compare_arrows_rounded,
                  l10n.compareTitle,
                  AppRoutes.compare,
                ),
              ],
            ),
            AppSpacing.vGapLg,
            _MenuGroup(
              title: l10n.profileOwner,
              items: [
                (
                  Icons.home_work_outlined,
                  l10n.ownerMyListingsTitle,
                  AppRoutes.myListings,
                ),
                (
                  Icons.insights_outlined,
                  l10n.ownerLeadsTitle,
                  AppRoutes.ownerLeads,
                ),
                (
                  Icons.apartment_outlined,
                  l10n.profileRentManagement,
                  AppRoutes.rentManagement,
                ),
                (
                  Icons.build_outlined,
                  l10n.maintenanceTitle,
                  AppRoutes.maintenance,
                ),
                (
                  Icons.verified_user_outlined,
                  l10n.accountOwnerVerificationTitle,
                  AppRoutes.verification,
                ),
                (
                  Icons.speed_outlined,
                  l10n.accountUsageLimitsTitle,
                  AppRoutes.usageLimits,
                ),
              ],
            ),
            AppSpacing.vGapLg,
            _MenuGroup(
              title: l10n.profileBilling,
              items: [
                (
                  Icons.account_balance_wallet_outlined,
                  l10n.profileWallet,
                  AppRoutes.wallet,
                ),
                (
                  Icons.workspace_premium_outlined,
                  l10n.billingMembershipTitle,
                  AppRoutes.plans,
                ),
                (
                  Icons.inventory_2_outlined,
                  l10n.billingPostPackagesTitle,
                  AppRoutes.packages,
                ),
              ],
            ),
            AppSpacing.vGapLg,
            _MenuGroup(
              title: l10n.profileAccount,
              items: [
                (
                  Icons.person_outline_rounded,
                  l10n.profileEditProfile,
                  AppRoutes.editProfile,
                ),
                (
                  Icons.notifications_none_rounded,
                  l10n.notifications,
                  AppRoutes.notifications,
                ),
                (
                  Icons.tune_rounded,
                  l10n.accountNotificationSettingsTitle,
                  AppRoutes.notificationPreferences,
                ),
                (
                  Icons.language_rounded,
                  l10n.configLanguageCurrencyTitle,
                  AppRoutes.languageCurrency,
                ),
                (
                  Icons.lock_outline_rounded,
                  l10n.profileChangePassword,
                  AppRoutes.changePassword,
                ),
                (
                  Icons.block_rounded,
                  l10n.communityBlockedUsersTitle,
                  AppRoutes.blockedUsers,
                ),
                (
                  Icons.privacy_tip_outlined,
                  l10n.accountPrivacyDataTitle,
                  AppRoutes.privacyData,
                ),
              ],
            ),
            AppSpacing.vGapLg,
            _MenuGroup(
              title: l10n.profileExplore,
              items: [(Icons.article_outlined, l10n.blogTitle, AppRoutes.blog)],
            ),
            AppSpacing.vGapLg,
            _MenuGroup(
              title: l10n.profileSupportLegal,
              items: [
                (
                  Icons.help_outline_rounded,
                  l10n.profileHelpContact,
                  AppRoutes.helpContact,
                ),
                (
                  Icons.shield_outlined,
                  l10n.profilePrivacyPolicy,
                  AppRoutes.privacyPolicy,
                ),
                (
                  Icons.description_outlined,
                  l10n.profileTermsConditions,
                  AppRoutes.termsConditions,
                ),
              ],
            ),
            AppSpacing.vGapLg,
            const _LanguageToggle(),
            AppSpacing.vGapLg,
            const _AppearanceToggle(),
            AppSpacing.vGapXl,
            if (isAuthenticated)
              OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(authViewModelProvider.notifier).logout();
                  if (context.mounted) context.go(AppRoutes.login);
                },
                icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                label: Text(
                  l10n.profileLogOut,
                  style: const TextStyle(color: AppColors.error),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                ),
              )
            else
              PrimaryButton(
                label: l10n.profileLoginRegister,
                onPressed: () => context.go(AppRoutes.login),
              ),
            if (isAuthenticated) ...[
              AppSpacing.vGapMd,
              SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.push(AppRoutes.privacyData),
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: Text(l10n.accountDeleteAccountTitle),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
            AppSpacing.vGapLg,
            Center(
              child: Text(l10n.profileAppVersion, style: AppTextStyles.caption),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: AppRadius.brXl,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
            ),
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white24,
              backgroundImage: user.avatarUrl != null
                  ? CachedNetworkImageProvider(user.avatarUrl!)
                  : null,
              child: user.avatarUrl == null
                  ? Text(
                      user.initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headingMd.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  user.email ?? user.phone ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySm.copyWith(
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.editProfile),
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.white,
              size: 20,
            ),
            tooltip: context.l10n.profileEditProfile,
          ),
        ],
      ),
    );
  }
}

class _GuestHeader extends StatelessWidget {
  const _GuestHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: context.colors.outline),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primarySurface,
            child: Icon(
              Icons.person_outline_rounded,
              color: AppColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.profileGuestName,
                  style: AppTextStyles.headingMd,
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.profileGuestDesc,
                  style: AppTextStyles.bodySm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Languages the UI can actually render (matches the translated `.arb` files).
const _supportedLanguages = <(String code, String label)>[
  ('en', 'English'),
  ('bn', 'বাংলা'),
  ('ar', 'العربية'),
];

class _LanguageToggle extends ConsumerWidget {
  const _LanguageToggle();

  Future<void> _pickLanguage(BuildContext context, WidgetRef ref) async {
    final active = ref.read(localeControllerProvider).locale;
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Material(
          color: Theme.of(sheetContext).colorScheme.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              for (final (code, label) in _supportedLanguages)
                ListTile(
                  title: Text(label),
                  trailing: code == active
                      ? const Icon(
                          Icons.check_rounded,
                          color: AppColors.primary,
                        )
                      : null,
                  onTap: () => Navigator.pop(sheetContext, code),
                ),
            ],
          ),
        ),
      ),
    );
    if (picked != null && picked != active) {
      ref.read(localeControllerProvider.notifier).setLocale(picked);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(localeControllerProvider.select((s) => s.locale));
    final activeLabel = _supportedLanguages
        .firstWhere(
          (l) => l.$1 == active,
          orElse: () => _supportedLanguages.first,
        )
        .$2;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: context.colors.outline),
      ),
      child: ListTile(
        leading: const Icon(Icons.language_rounded, color: AppColors.primary),
        title: Text(context.l10n.configLanguage, style: AppTextStyles.titleSm),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(activeLabel, style: AppTextStyles.bodyMd),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
            ),
          ],
        ),
        onTap: () => unawaited(_pickLanguage(context, ref)),
      ),
    );
  }
}

class _AppearanceToggle extends ConsumerWidget {
  const _AppearanceToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final tileKey = GlobalKey();

    void changeTheme(ThemeMode targetMode) {
      if (targetMode == mode) return;
      final renderObject = tileKey.currentContext?.findRenderObject();
      if (renderObject is RenderBox) {
        final offset = renderObject.localToGlobal(Offset.zero);
        final center = Offset(
          offset.dx + renderObject.size.width / 2,
          offset.dy + renderObject.size.height / 2,
        );
        ref
            .read(themeRevealProvider.notifier)
            .start(center: center, targetMode: targetMode);
      }
      ref.read(themeModeProvider.notifier).set(targetMode);
    }

    IconData iconFor(ThemeMode mode) => switch (mode) {
      ThemeMode.light => Icons.light_mode_rounded,
      ThemeMode.dark => Icons.dark_mode_rounded,
      ThemeMode.system => Icons.settings_suggest_rounded,
    };

    String labelFor(ThemeMode mode) => switch (mode) {
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
      ThemeMode.system => 'System',
    };

    return Container(
      key: tileKey,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: context.colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(iconFor(mode), color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              const Text('Theme mode', style: AppTextStyles.titleSm),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<ThemeMode>(
            segments: [
              for (final option in ThemeMode.values)
                ButtonSegment<ThemeMode>(
                  value: option,
                  icon: Icon(iconFor(option), size: 18),
                  label: Text(labelFor(option)),
                ),
            ],
            selected: {mode},
            showSelectedIcon: false,
            onSelectionChanged: (selection) => changeTheme(selection.first),
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                return states.contains(WidgetState.selected)
                    ? Colors.white
                    : context.colors.onSurface;
              }),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                return states.contains(WidgetState.selected)
                    ? AppColors.primary
                    : Colors.transparent;
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({this.title, required this.items});

  final String? title;

  /// `(icon, label, route?)` — a null route shows a "coming soon" note.
  final List<(IconData, String, String?)> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4, bottom: 8),
            child: Text(
              title!.toUpperCase(),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: AppRadius.brLg,
            border: Border.all(color: context.colors.outline),
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                ListTile(
                  leading: Container(
                    height: 38,
                    width: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: AppRadius.brSm,
                    ),
                    child: Icon(
                      items[i].$1,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  title: Text(items[i].$2, style: AppTextStyles.titleSm),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textTertiary,
                  ),
                  onTap: () {
                    final route = items[i].$3;
                    if (route == null) {
                      context.showSnack(context.l10n.profileComingSoon);
                    } else {
                      context.push(route);
                    }
                  },
                ),
                if (i != items.length - 1)
                  const Divider(height: 1, indent: 66, endIndent: 16),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
