import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/models/user_model.dart';

/// Profile tab: account header, settings menu and logout. Falls back to a
/// sign-in prompt for guests.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch only the slices this screen renders so unrelated auth changes
    // (e.g. isSubmitting during a login elsewhere) don't rebuild it.
    final isAuthenticated =
        ref.watch(authControllerProvider.select((s) => s.isAuthenticated));
    final user = ref.watch(authControllerProvider.select((s) => s.user));

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            if (isAuthenticated && user != null)
              _ProfileHeader(user: user)
            else
              const _GuestHeader(),
            AppSpacing.vGapXl,
            const _MenuGroup(
              title: 'Activity',
              items: [
                (Icons.chat_bubble_outline_rounded, 'Messages', AppRoutes.conversations),
                (Icons.hotel_outlined, 'My Bookings', AppRoutes.myBookings),
                (Icons.calendar_today_outlined, 'My Visits', AppRoutes.myVisits),
                (Icons.handyman_outlined, 'Find a Technician', AppRoutes.technicians),
                (Icons.build_outlined, 'Service Bookings', AppRoutes.serviceBookings),
                (Icons.engineering_outlined, 'Become a Technician', AppRoutes.becomeTechnician),
                (Icons.badge_outlined, 'My Technician Profile', AppRoutes.technicianProfile),
              ],
            ),
            AppSpacing.vGapLg,
            const _MenuGroup(
              title: 'Lists',
              items: [
                (Icons.favorite_border_rounded, 'Saved Properties', AppRoutes.saved),
                (Icons.bookmark_border_rounded, 'Saved Searches', AppRoutes.savedSearches),
                (Icons.compare_arrows_rounded, 'Compare', AppRoutes.compare),
              ],
            ),
            AppSpacing.vGapLg,
            const _MenuGroup(
              title: 'Owner',
              items: [
                (Icons.home_work_outlined, 'My Listings', AppRoutes.myListings),
                (Icons.insights_outlined, 'Leads & Activity', AppRoutes.ownerLeads),
                (Icons.apartment_outlined, 'Rent Management', AppRoutes.rentManagement),
                (Icons.build_outlined, 'Maintenance', AppRoutes.maintenance),
                (Icons.verified_user_outlined, 'Owner Verification', AppRoutes.verification),
                (Icons.speed_outlined, 'Usage & Limits', AppRoutes.usageLimits),
              ],
            ),
            AppSpacing.vGapLg,
            const _MenuGroup(
              title: 'Billing',
              items: [
                (Icons.account_balance_wallet_outlined, 'Wallet', AppRoutes.wallet),
                (Icons.workspace_premium_outlined, 'Membership', AppRoutes.plans),
                (Icons.inventory_2_outlined, 'Post Packages', AppRoutes.packages),
              ],
            ),
            AppSpacing.vGapLg,
            const _MenuGroup(
              title: 'Account',
              items: [
                (Icons.person_outline_rounded, 'Edit Profile', AppRoutes.editProfile),
                (Icons.notifications_none_rounded, 'Notifications', AppRoutes.notifications),
                (Icons.tune_rounded, 'Notification Settings', AppRoutes.notificationPreferences),
                (Icons.language_rounded, 'Language & Currency', AppRoutes.languageCurrency),
                (Icons.lock_outline_rounded, 'Change Password', AppRoutes.changePassword),
                (Icons.block_rounded, 'Blocked Users', AppRoutes.blockedUsers),
                (Icons.privacy_tip_outlined, 'Privacy & Data', AppRoutes.privacyData),
                (Icons.help_outline_rounded, 'Help & Support', null),
              ],
            ),
            AppSpacing.vGapLg,
            const _AppearanceToggle(),
            AppSpacing.vGapXl,
            if (isAuthenticated)
              OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(authControllerProvider.notifier).logout();
                  if (context.mounted) context.go(AppRoutes.login);
                },
                icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                label: const Text('Log out',
                    style: TextStyle(color: AppColors.error)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                ),
              )
            else
              PrimaryButton(
                label: 'Log in / Register',
                onPressed: () => context.go(AppRoutes.login),
              ),
            AppSpacing.vGapLg,
            const Center(
              child: Text('Rentdo v1.0.0', style: AppTextStyles.caption),
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
                  ? Text(user.initials,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700))
                  : null,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headingMd
                        .copyWith(color: Colors.white)),
                const SizedBox(height: 2),
                Text(user.email ?? user.phone ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySm
                        .copyWith(color: Colors.white.withValues(alpha: 0.75))),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.editProfile),
            icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
            tooltip: 'Edit profile',
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
      child: const Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primarySurface,
            child: Icon(Icons.person_outline_rounded,
                color: AppColors.primary, size: 30),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Guest', style: AppTextStyles.headingMd),
                SizedBox(height: 2),
                Text('Sign in to manage your account',
                    style: AppTextStyles.bodySm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppearanceToggle extends ConsumerWidget {
  const _AppearanceToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: context.colors.outline),
      ),
      child: SwitchListTile.adaptive(
        value: isDark,
        activeThumbColor: AppColors.primary,
        secondary: Icon(
          isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
          color: AppColors.primary,
        ),
        title: const Text('Dark mode', style: AppTextStyles.titleSm),
        onChanged: (v) => ref
            .read(themeModeProvider.notifier)
            .set(v ? ThemeMode.dark : ThemeMode.light),
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
                    child: Icon(items[i].$1, color: AppColors.primary, size: 20),
                  ),
                  title: Text(items[i].$2, style: AppTextStyles.titleSm),
                  trailing: const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textTertiary),
                  onTap: () {
                    final route = items[i].$3;
                    if (route == null) {
                      context.showSnack('Coming soon');
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
