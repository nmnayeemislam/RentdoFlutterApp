import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/account/views/notification_preferences_screen.dart';
import '../features/account/views/privacy_data_screen.dart';
import '../features/account/views/usage_limits_screen.dart';
import '../features/account/views/verification_screen.dart';
import '../features/auth/viewmodels/auth_viewmodel.dart';
import '../features/auth/views/forgot_password_screen.dart';
import '../features/auth/views/login_screen.dart';
import '../features/auth/views/register_screen.dart';
import '../features/billing/views/packages_screen.dart';
import '../features/billing/views/plans_screen.dart';
import '../features/blog/views/blog_detail_screen.dart';
import '../features/blog/views/blog_list_screen.dart';
import '../features/bookings/views/my_bookings_screen.dart';
import '../features/chat/views/chat_screen.dart';
import '../features/chat/views/conversations_screen.dart';
import '../features/community/views/blocked_users_screen.dart';
import '../features/compare/views/compare_screen.dart';
import '../features/config/views/language_currency_screen.dart';
import '../features/home/views/home_screen.dart';
import '../features/maintenance/views/maintenance_screen.dart';
import '../features/notifications/views/notifications_screen.dart';
import '../features/onboarding/providers/onboarding_provider.dart';
import '../features/onboarding/views/onboarding_screen.dart';
import '../features/onboarding/views/splash_screen.dart';
import '../features/owner/views/create_listing_screen.dart';
import '../features/owner/views/my_listings_screen.dart';
import '../features/owner/views/owner_leads_screen.dart';
import '../features/profile/views/change_password_screen.dart';
import '../features/profile/views/edit_profile_screen.dart';
import '../features/profile/views/profile_screen.dart';
import '../features/properties/models/property_model.dart';
import '../features/properties/views/map_search_screen.dart';
import '../features/properties/views/property_detail_screen.dart';
import '../features/properties/views/property_list_screen.dart';
import '../features/rent_management/views/agreements_screen.dart';
import '../features/rent_management/views/ledger_screen.dart';
import '../features/rent_management/views/rent_dashboard_screen.dart';
import '../features/rent_management/views/rent_payments_screen.dart';
import '../features/rent_management/views/tenancies_screen.dart';
import '../features/rent_management/views/units_screen.dart';
import '../features/saved/views/saved_screen.dart';
import '../features/saved_searches/views/saved_searches_screen.dart';
import '../features/support/views/cms_page_screen.dart';
import '../features/support/views/help_contact_screen.dart';
import '../features/technicians/views/become_technician_screen.dart';
import '../features/technicians/views/my_service_bookings_screen.dart';
import '../features/technicians/views/technician_detail_screen.dart';
import '../features/technicians/views/technician_profile_screen.dart';
import '../features/technicians/views/technicians_screen.dart';
import '../features/visits/views/my_visits_screen.dart';
import '../features/wallet/views/wallet_screen.dart';
import '../shared/extensions/context_extensions.dart';
import '../shared/widgets/app_shell.dart';
import 'app_routes.dart';

/// Bridges a Riverpod provider to a [Listenable] so GoRouter re-evaluates
/// redirects whenever auth/onboarding state changes.
class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    ref.listen(
      authViewModelProvider.select((s) => s.status),
      (_, _) => notifyListeners(),
    );
    ref.listen(onboardingSeenProvider, (_, _) => notifyListeners());
  }
}

final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

/// Centralized GoRouter configuration.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authViewModelProvider);
      final onboardingSeen = ref.read(onboardingSeenProvider);
      final loc = state.matchedLocation;

      // Wait on splash while session and first-run preference are restored.
      if (auth.status == AuthStatus.unknown || onboardingSeen.isLoading) {
        return loc == AppRoutes.splash ? null : AppRoutes.splash;
      }

      final loggedIn = auth.isAuthenticated;
      final onAuthPage =
          loc == AppRoutes.login ||
          loc == AppRoutes.register ||
          loc == AppRoutes.forgotPassword;
      final onEntry = loc == AppRoutes.splash || loc == AppRoutes.onboarding;

      if (!loggedIn) {
        // Guests may browse everything; Saved/Profile render their own
        // sign-in prompts. Show onboarding only once after install.
        final seenOnboarding = onboardingSeen.valueOrNull ?? false;
        if (loc == AppRoutes.onboarding) {
          return seenOnboarding ? AppRoutes.home : null;
        }
        if (onAuthPage) return null;
        if (onEntry) {
          return seenOnboarding ? AppRoutes.home : AppRoutes.onboarding;
        }
        return null;
      }

      // Logged in: keep users out of the auth/splash pages.
      if (onAuthPage || onEntry) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, _) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, _) => const ForgotPasswordScreen(),
      ),

      // Bottom-navigation shell.
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (_, _, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (_, _) => const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: AppRoutes.properties,
            pageBuilder: (_, _) =>
                const NoTransitionPage(child: PropertyListScreen()),
          ),
          GoRoute(
            path: AppRoutes.saved,
            pageBuilder: (_, _) => const NoTransitionPage(child: SavedScreen()),
          ),
          GoRoute(
            path: AppRoutes.conversations,
            pageBuilder: (_, _) =>
                const NoTransitionPage(child: ConversationsScreen()),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (_, _) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),

      // Full-screen routes outside the bottom-nav shell.
      GoRoute(
        path: AppRoutes.editProfile,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.compare,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const CompareScreen(),
      ),
      GoRoute(
        path: AppRoutes.savedSearches,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const SavedSearchesScreen(),
      ),
      GoRoute(
        path: AppRoutes.myVisits,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const MyVisitsScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/conversations/:id',
        name: AppRoutes.chatName,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => ChatScreen(
          conversationId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: AppRoutes.myBookings,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const MyBookingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.wallet,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const WalletScreen(),
      ),
      GoRoute(
        path: AppRoutes.plans,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const PlansScreen(),
      ),
      GoRoute(
        path: AppRoutes.packages,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const PackagesScreen(),
      ),
      GoRoute(
        path: AppRoutes.technicians,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const TechniciansScreen(),
      ),
      GoRoute(
        path: '/technicians/:id',
        name: AppRoutes.technicianDetailName,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => TechnicianDetailScreen(
          id: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: AppRoutes.serviceBookings,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const MyServiceBookingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.myListings,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const MyListingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.createListing,
        parentNavigatorKey: _rootKey,
        builder: (_, state) =>
            CreateListingScreen(existing: state.extra as PropertyModel?),
      ),
      GoRoute(
        path: AppRoutes.ownerLeads,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const OwnerLeadsScreen(),
      ),
      GoRoute(
        path: AppRoutes.rentManagement,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const RentDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.maintenance,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const MaintenanceScreen(),
      ),
      GoRoute(
        path: AppRoutes.verification,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const VerificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.notificationPreferences,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const NotificationPreferencesScreen(),
      ),
      GoRoute(
        path: AppRoutes.privacyData,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const PrivacyDataScreen(),
      ),
      GoRoute(
        path: AppRoutes.usageLimits,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const UsageLimitsScreen(),
      ),
      GoRoute(
        path: AppRoutes.privacyPolicy,
        parentNavigatorKey: _rootKey,
        builder: (context, _) => CmsPageScreen(
          slug: AppRoutes.privacyPolicySlug,
          title: context.l10n.profilePrivacyPolicy,
        ),
      ),
      GoRoute(
        path: AppRoutes.termsConditions,
        parentNavigatorKey: _rootKey,
        builder: (context, _) => CmsPageScreen(
          slug: AppRoutes.termsConditionsSlug,
          title: context.l10n.profileTermsConditions,
        ),
      ),
      GoRoute(
        path: AppRoutes.helpContact,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const HelpContactScreen(),
      ),
      GoRoute(
        path: AppRoutes.mapSearch,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const MapSearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.blog,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const BlogListScreen(),
      ),
      GoRoute(
        path: '/blog/:slug',
        name: AppRoutes.blogDetailName,
        parentNavigatorKey: _rootKey,
        builder: (_, state) =>
            BlogDetailScreen(slug: state.pathParameters['slug'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.blockedUsers,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const BlockedUsersScreen(),
      ),
      GoRoute(
        path: AppRoutes.languageCurrency,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const LanguageCurrencyScreen(),
      ),
      GoRoute(
        path: AppRoutes.becomeTechnician,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const BecomeTechnicianScreen(),
      ),
      GoRoute(
        path: AppRoutes.technicianProfile,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const TechnicianProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.agreements,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const AgreementsScreen(),
      ),
      GoRoute(
        path: AppRoutes.rentUnits,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const UnitsScreen(),
      ),
      GoRoute(
        path: AppRoutes.tenancies,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const TenanciesScreen(),
      ),
      GoRoute(
        path: AppRoutes.rentPayments,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const RentPaymentsScreen(),
      ),
      GoRoute(
        path: AppRoutes.ledger,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const LedgerScreen(),
      ),

      // Detail lives outside the shell (full-screen).
      GoRoute(
        path: '/properties/:id',
        name: AppRoutes.propertyDetailName,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => PropertyDetailScreen(
          id: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
        ),
      ),
    ],
  );
});
