import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/account/screens/notification_preferences_screen.dart';
import '../features/account/screens/privacy_data_screen.dart';
import '../features/account/screens/usage_limits_screen.dart';
import '../features/account/screens/verification_screen.dart';
import '../features/auth/controllers/auth_controller.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/billing/screens/packages_screen.dart';
import '../features/billing/screens/plans_screen.dart';
import '../features/blog/screens/blog_detail_screen.dart';
import '../features/blog/screens/blog_list_screen.dart';
import '../features/bookings/screens/my_bookings_screen.dart';
import '../features/chat/screens/chat_screen.dart';
import '../features/chat/screens/conversations_screen.dart';
import '../features/community/screens/blocked_users_screen.dart';
import '../features/compare/screens/compare_screen.dart';
import '../features/config/screens/language_currency_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/maintenance/screens/maintenance_screen.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/onboarding/screens/splash_screen.dart';
import '../features/owner/screens/create_listing_screen.dart';
import '../features/owner/screens/my_listings_screen.dart';
import '../features/owner/screens/owner_leads_screen.dart';
import '../features/profile/screens/change_password_screen.dart';
import '../features/profile/screens/edit_profile_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/properties/models/property_model.dart';
import '../features/properties/screens/map_search_screen.dart';
import '../features/properties/screens/property_detail_screen.dart';
import '../features/properties/screens/property_list_screen.dart';
import '../features/rent_management/screens/agreements_screen.dart';
import '../features/rent_management/screens/ledger_screen.dart';
import '../features/rent_management/screens/rent_dashboard_screen.dart';
import '../features/rent_management/screens/rent_payments_screen.dart';
import '../features/rent_management/screens/tenancies_screen.dart';
import '../features/rent_management/screens/units_screen.dart';
import '../features/saved/screens/saved_screen.dart';
import '../features/saved_searches/screens/saved_searches_screen.dart';
import '../features/support/screens/cms_page_screen.dart';
import '../features/support/screens/help_contact_screen.dart';
import '../features/technicians/screens/become_technician_screen.dart';
import '../features/technicians/screens/my_service_bookings_screen.dart';
import '../features/technicians/screens/technician_detail_screen.dart';
import '../features/technicians/screens/technician_profile_screen.dart';
import '../features/technicians/screens/technicians_screen.dart';
import '../features/visits/screens/my_visits_screen.dart';
import '../features/wallet/screens/wallet_screen.dart';
import '../shared/widgets/app_shell.dart';
import 'app_routes.dart';

/// Bridges a Riverpod provider to a [Listenable] so GoRouter re-evaluates
/// redirects whenever auth state changes.
class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(Ref ref) {
    ref.listen(
      authControllerProvider.select((s) => s.status),
      (_, _) => notifyListeners(),
    );
  }
}

final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

/// Centralized GoRouter configuration.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthRefresh(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final loc = state.matchedLocation;

      // Wait on splash while session is being restored.
      if (auth.status == AuthStatus.unknown) {
        return loc == AppRoutes.splash ? null : AppRoutes.splash;
      }

      final loggedIn = auth.isAuthenticated;
      final onAuthPage = loc == AppRoutes.login ||
          loc == AppRoutes.register ||
          loc == AppRoutes.forgotPassword;
      final onEntry = loc == AppRoutes.splash || loc == AppRoutes.onboarding;

      if (!loggedIn) {
        // Guests may browse everything; Saved/Profile render their own
        // sign-in prompts. Only redirect away from the entry/splash pages.
        if (onAuthPage || loc == AppRoutes.onboarding) return null;
        if (onEntry) return AppRoutes.home;
        return null;
      }

      // Logged in: keep users out of the auth/splash pages.
      if (onAuthPage || onEntry) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, _) => const LoginScreen(),
      ),
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
            pageBuilder: (_, _) =>
                const NoTransitionPage(child: SavedScreen()),
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
        path: AppRoutes.conversations,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const ConversationsScreen(),
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
        builder: (_, _) => const CmsPageScreen(
          slug: AppRoutes.privacyPolicySlug,
          title: 'Privacy Policy',
        ),
      ),
      GoRoute(
        path: AppRoutes.termsConditions,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const CmsPageScreen(
          slug: AppRoutes.termsConditionsSlug,
          title: 'Terms & Conditions',
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
