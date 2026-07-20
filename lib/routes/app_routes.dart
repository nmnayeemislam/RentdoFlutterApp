/// Centralized route names and paths. Reference these constants everywhere
/// instead of string literals so paths change in one place.
abstract final class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';

  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  static const String home = '/home';
  static const String properties = '/properties';
  static const String saved = '/saved';
  static const String profile = '/profile';

  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  static const String compare = '/compare';
  static const String savedSearches = '/saved-searches';
  static const String myVisits = '/my-visits';
  static const String notifications = '/notifications';
  static const String conversations = '/conversations';
  static const String myBookings = '/my-bookings';
  static const String wallet = '/wallet';
  static const String plans = '/plans';
  static const String packages = '/packages';
  static const String technicians = '/technicians';
  static const String serviceBookings = '/service-bookings';

  // Technician detail: `/technicians/:id`
  static const String technicianDetailName = 'technician-detail';
  static String technicianDetail(int id) => '/technicians/$id';

  static const String myListings = '/my-listings';
  static const String createListing = '/create-listing';
  static const String ownerLeads = '/owner/leads';
  static const String maintenance = '/maintenance';

  // Account & settings
  static const String verification = '/verification';
  static const String notificationPreferences = '/notification-preferences';
  static const String privacyData = '/privacy';
  static const String usageLimits = '/usage-limits';
  static const String blockedUsers = '/blocked-users';
  static const String languageCurrency = '/language-currency';

  // Technician self-service
  static const String becomeTechnician = '/become-technician';
  static const String technicianProfile = '/technician-profile';

  // Rent management (owner suite)
  static const String rentManagement = '/rent-management';
  static const String agreements = '/rent-management/agreements';
  static const String rentUnits = '/rent-management/units';
  static const String tenancies = '/rent-management/tenancies';
  static const String rentPayments = '/rent-management/payments';
  static const String ledger = '/rent-management/ledger';

  // Chat thread: `/conversations/:id`
  static const String chatName = 'chat';
  static String chat(int id) => '/conversations/$id';

  // Property detail: `/properties/:id`
  static const String propertyDetailName = 'property-detail';
  static String propertyDetail(int id) => '/properties/$id';
}
