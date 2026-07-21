/// Centralized REST endpoint paths (relative to [AppConfig.apiBaseUrl], which
/// already includes the `/api/v1` prefix).
///
/// Keep every backend route here so URL changes never touch feature code.
/// Mirrors `routes/api.php` on the Laravel backend.
abstract final class ApiEndpoints {
  ApiEndpoints._();

  // ── Config / bootstrap (public) ─────────────────────────────────────────
  static const String bootstrap = '/config/bootstrap';
  static String translations(String locale) => '/translations/$locale';
  static const String customFields = '/custom-fields';
  static const String propertyTypes = '/property-types';
  static const String amenities = '/amenities';

  // ── Content / support (public) ──────────────────────────────────────────
  static String page(String slug) => '/pages/$slug';
  static const String faqs = '/faqs';
  static const String contact = '/contact';

  // ── Blog (public) ───────────────────────────────────────────────────────
  static const String blog = '/blog';
  static const String blogCategories = '/blog/categories';
  static String blogPost(String slug) => '/blog/$slug';

  // ── Auth (public) ───────────────────────────────────────────────────────
  static const String registerStart = '/auth/register/start';
  static const String registerVerify = '/auth/register/verify';
  static const String login = '/auth/login';
  static const String social = '/auth/social';
  static const String forgotPassword = '/auth/forgot';
  static const String resetPassword = '/auth/reset';
  static const String logout = '/auth/logout';

  // ── Zones (public) ──────────────────────────────────────────────────────
  static const String zones = '/zones';
  static const String zoneCountries = '/zones/countries';
  static const String zoneResolve = '/zones/resolve';
  static String zone(int id) => '/zones/$id';
  static String zoneAreas(int id) => '/zones/$id/areas';

  // ── Listings (public reads) ─────────────────────────────────────────────
  static const String listings = '/listings';
  static String listing(int id) => '/listings/$id';
  static String listingDistance(int id) => '/listings/$id/distance';
  static String listingShare(int id) => '/listings/$id/share';
  static String listingAvailability(int id) => '/listings/$id/availability';
  static String listingSuggestedTechnicians(int id) =>
      '/listings/$id/suggested-technicians';

  // Listing writes (owner)
  static String listingMedia(int id) => '/listings/$id/media';
  static String listingStatus(int id) => '/listings/$id/status';
  static String listingRevealContact(int id) => '/listings/$id/reveal-contact';
  static String listingVisits(int id) => '/listings/$id/visits';

  // Owner leads & analytics
  static const String ownerLeads = '/owner/leads';
  static const String ownerLeadsSummary = '/owner/leads/summary';

  // ── Engagement ──────────────────────────────────────────────────────────
  static const String favorites = '/favorites';
  static String favorite(int listingId) => '/favorites/$listingId';
  static const String savedSearches = '/saved-searches';
  static String savedSearch(int id) => '/saved-searches/$id';
  static const String compare = '/compare';
  static const String compareMine = '/compare/my';
  static String compareItem(int listingId) => '/compare/$listingId';

  // ── Profile (/me) ───────────────────────────────────────────────────────
  static const String me = '/me';
  static const String mePhoto = '/me/photo';
  static const String mePassword = '/me/password';
  static const String meVerification = '/me/verification';
  static const String meNotificationPreferences = '/me/notification-preferences';
  static const String meExport = '/me/export';
  static const String meSubscription = '/me/subscription';
  static const String meSubscriptionCancel = '/me/subscription/cancel';
  static const String meLimits = '/me/limits';

  // ── Reviews ─────────────────────────────────────────────────────────────
  static const String reviews = '/reviews';
  static String reviewReport(int id) => '/reviews/$id/report';

  // ── Visits ──────────────────────────────────────────────────────────────
  static const String visits = '/visits';
  static String visit(int id) => '/visits/$id';

  // ── Bookings (hotel / short-stay) ───────────────────────────────────────
  static const String bookings = '/bookings';
  static String booking(int id) => '/bookings/$id';
  static String bookingCancel(int id) => '/bookings/$id/cancel';

  // ── Chat ────────────────────────────────────────────────────────────────
  static const String conversations = '/conversations';
  static String conversationMessages(int id) => '/conversations/$id/messages';
  static String conversationRead(int id) => '/conversations/$id/read';

  // ── Notifications ───────────────────────────────────────────────────────
  static const String notifications = '/notifications';
  static const String notificationsUnreadCount = '/notifications/unread-count';
  static const String notificationsReadAll = '/notifications/read-all';
  static String notificationRead(int id) => '/notifications/$id/read';
  static const String devices = '/devices';
  static String device(int id) => '/devices/$id';

  // ── Wallet / payments / coupons ─────────────────────────────────────────
  static const String wallet = '/wallet';
  static const String walletTransactions = '/wallet/transactions';
  static const String walletTopup = '/wallet/topup';
  static const String couponsApply = '/coupons/apply';
  static String payment(int id) => '/payments/$id';
  static String paymentInitiate(int id) => '/payments/$id/initiate';

  // ── Plans / packages / subscriptions ────────────────────────────────────
  static const String plans = '/plans';
  static String plan(int id) => '/plans/$id';
  static const String packages = '/packages';
  static String packageBuy(int id) => '/packages/$id/buy';
  static const String subscriptions = '/subscriptions';

  // ── Technicians ─────────────────────────────────────────────────────────
  static const String technicians = '/technicians';
  static const String techniciansSuggest = '/technicians/suggest';
  static String technician(int id) => '/technicians/$id';
  static const String technicianCategories = '/technician-categories';
  static const String technicianApply = '/technician/apply';
  static const String technicianBookings = '/technician-bookings';
  static const String maintenanceRequests = '/maintenance-requests';

  // ── Community ───────────────────────────────────────────────────────────
  static const String block = '/block';
  static String blockUser(int id) => '/block/$id';
  static const String reports = '/reports';
}
