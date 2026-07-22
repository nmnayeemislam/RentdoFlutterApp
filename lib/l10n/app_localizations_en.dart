// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Rentdo';

  @override
  String get tagline => 'Find the right property. Right place. Right price.';

  @override
  String get heroSubtitle =>
      'Discover verified properties for rent, sale or investment. Trusted by thousands.';

  @override
  String get retry => 'Retry';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get noInternet =>
      'No internet connection. Check your network and try again.';

  @override
  String get noResults => 'No results found';

  @override
  String get seeAll => 'See all';

  @override
  String get explore => 'Explore Properties';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get fullName => 'Full name';

  @override
  String get phone => 'Phone';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get createAccount => 'Create your account';

  @override
  String get usePhoneInstead => 'Use phone instead';

  @override
  String get useEmailInstead => 'Use email instead';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get verifyAndContinue => 'Verify & continue';

  @override
  String get continueAsGuest => 'Continue as guest';

  @override
  String get otpCode => 'Verification code';

  @override
  String get otpHint => '6-digit code';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get forgotPasswordTitle => 'Forgot password';

  @override
  String get forgotPasswordSubtitle => 'Reset your password by email or phone.';

  @override
  String get newPassword => 'New password';

  @override
  String get createAccountCta => 'Create account';

  @override
  String get changeDetails => 'Change details';

  @override
  String get checkEmailForReset => 'Check your email for a reset link';

  @override
  String get passwordUpdated =>
      'Password updated. Please log in with your new password.';

  @override
  String get home => 'Home';

  @override
  String get search => 'Search';

  @override
  String get saved => 'Saved';

  @override
  String get profile => 'Profile';

  @override
  String get messages => 'Messages';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get accountNotificationSettingsTitle => 'Notification Settings';

  @override
  String get accountPreferencesSaved => 'Preferences saved';

  @override
  String get accountSaveChanges => 'Save changes';

  @override
  String get accountSignInToManageNotifications =>
      'Sign in to manage notifications';

  @override
  String get accountLogInToChooseContact =>
      'Log in to choose how and when we contact you.';

  @override
  String get accountPrivacyDataTitle => 'Privacy & Data';

  @override
  String get accountDeleteAccountTitle => 'Delete account';

  @override
  String get accountDeleteAccountConfirm =>
      'This schedules your account for deletion. Continue?';

  @override
  String get accountExportRequested => 'Export requested';

  @override
  String get accountDeletionScheduled => 'Account scheduled for deletion';

  @override
  String accountDeletionScheduledOn(String date) {
    return 'Account scheduled for deletion on $date';
  }

  @override
  String get accountExportMyData => 'Export my data';

  @override
  String get accountExportDataDesc =>
      'Request a copy of your account data, listings, messages and bookings. We prepare a download link for you.';

  @override
  String get accountRequestExport => 'Request export';

  @override
  String get accountDeleteAccountDesc =>
      'Deleting your account is permanent. Your listings, messages, bookings and saved searches will be removed and cannot be restored.';

  @override
  String get accountDeleteMyAccount => 'Delete my account';

  @override
  String get accountSignInToManageData => 'Sign in to manage your data';

  @override
  String get accountLogInToExportOrDelete =>
      'Log in to export your data or delete your account.';

  @override
  String get accountUsageLimitsTitle => 'Usage & Limits';

  @override
  String get accountPlanFeatures => 'Plan features';

  @override
  String get accountNoPlanFeatures => 'No plan features to show.';

  @override
  String get accountPostsUsed => 'Posts used';

  @override
  String get accountUnlimited => 'Unlimited';

  @override
  String get accountRemainingSuffix => 'remaining';

  @override
  String get accountSignInToSeeLimits => 'Sign in to see your limits';

  @override
  String get accountLogInToTrackUsage =>
      'Log in to track your posting usage and plan features.';

  @override
  String get accountOwnerVerificationTitle => 'Owner Verification';

  @override
  String get accountDocumentSubmitted => 'Document submitted for review';

  @override
  String get accountUploadIdDesc =>
      'Upload a government ID or business document to get the verified badge.';

  @override
  String get accountUploadDocument => 'Upload document';

  @override
  String get accountVerificationStatus => 'Verification status';

  @override
  String accountReviewedOn(String date) {
    return 'Reviewed $date';
  }

  @override
  String get accountSignInToGetVerified => 'Sign in to get verified';

  @override
  String get accountLogInToSubmitDocs =>
      'Log in to submit your documents and earn the verified badge.';

  @override
  String get buy => 'Buy';

  @override
  String get skip => 'Skip';

  @override
  String get apply => 'Apply';

  @override
  String get billingPostPackagesTitle => 'Post Packages';

  @override
  String get billingNoPackagesAvailable => 'No packages available';

  @override
  String get billingCheckBackLaterPackages =>
      'Check back later for post packages.';

  @override
  String get billingPackagePurchased => 'Package purchased';

  @override
  String billingPostsAndDays(int posts, int days) {
    return '$posts posts · $days days';
  }

  @override
  String get billingSignInToBuyPackages => 'Sign in to buy packages';

  @override
  String get billingLogInToPurchasePackages =>
      'Log in to purchase post packages.';

  @override
  String get billingMembershipTitle => 'Membership';

  @override
  String get billingSubscriptionCancelled => 'Subscription cancelled';

  @override
  String get billingYourPlan => 'Your plan';

  @override
  String get billingCancelPlan => 'Cancel plan';

  @override
  String get billingRenews => 'Renews';

  @override
  String get billingEnds => 'Ends';

  @override
  String billingPostsUsedOf(String used, String limit) {
    return 'Posts used $used/$limit';
  }

  @override
  String get billingNoPlansAvailable => 'No plans available';

  @override
  String get billingCheckBackLaterPlans =>
      'Check back later for membership options.';

  @override
  String get billingFree => 'Free';

  @override
  String billingPriceDuration(String price, int days) {
    return '$price / $days days';
  }

  @override
  String get billingHaveCoupon => 'Have a coupon?';

  @override
  String get billingCouponHint => 'Coupon code (optional)';

  @override
  String get billingInvalidCoupon => 'Invalid coupon';

  @override
  String billingCouponAppliedSavings(String amount) {
    return 'Coupon applied — you save $amount';
  }

  @override
  String get billingCouponApplied => 'Coupon applied';

  @override
  String billingSubscribedTo(String plan) {
    return 'Subscribed to $plan';
  }

  @override
  String get billingPopular => 'Popular';

  @override
  String billingListingsCount(String limit) {
    return '$limit listings';
  }

  @override
  String get billingCurrentPlan => 'Current plan';

  @override
  String get billingChooseFree => 'Choose Free';

  @override
  String get billingSubscribe => 'Subscribe';

  @override
  String get billingSignInToViewMemberships => 'Sign in to view memberships';

  @override
  String get billingLogInToSubscribe =>
      'Log in to subscribe to a membership plan.';

  @override
  String get all => 'All';

  @override
  String get blogTitle => 'Blog';

  @override
  String get blogCouldntLoadPosts => 'Couldn\'t load posts.';

  @override
  String get blogNoPostsYet => 'No posts yet';

  @override
  String blogMinRead(int minutes) {
    return '$minutes min read';
  }

  @override
  String get blogArticleTitle => 'Article';

  @override
  String get blogCouldntLoadArticle => 'Couldn\'t load this article.';

  @override
  String blogByAuthor(String author) {
    return 'By $author';
  }

  @override
  String get blogRelatedArticles => 'Related articles';

  @override
  String get browseProperties => 'Browse properties';

  @override
  String get night => 'night';

  @override
  String get nights => 'nights';

  @override
  String get guest => 'guest';

  @override
  String get guests => 'guests';

  @override
  String get bookingsTitle => 'My Bookings';

  @override
  String get bookingsNoBookingsYet => 'No bookings yet';

  @override
  String get bookingsBookStayDesc => 'Book a stay from a hotel listing.';

  @override
  String bookingsNumberFallback(int id) {
    return 'Booking #$id';
  }

  @override
  String get bookingsSignInToSeeBookings => 'Sign in to see your bookings';

  @override
  String get bookingsLogInToManageReservations =>
      'Log in to book stays and manage reservations.';

  @override
  String get chatTitle => 'Chat';

  @override
  String get chatNoMessagesYet => 'No messages yet';

  @override
  String get chatStartConversationDesc =>
      'Start a conversation from any listing.';

  @override
  String get chatSayHelloDesc => 'Say hello to start the conversation.';

  @override
  String get chatOwnerFallback => 'Owner';

  @override
  String chatYouPrefix(String body) {
    return 'You: $body';
  }

  @override
  String get chatSignInToSeeMessages => 'Sign in to see your messages';

  @override
  String get chatLogInToChatWithOwners =>
      'Log in to chat with property owners.';

  @override
  String get chatTypeMessageHint => 'Type a message…';

  @override
  String get clear => 'Clear';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get communityBlockedUsersTitle => 'Blocked Users';

  @override
  String get communityUserUnblocked => 'User unblocked';

  @override
  String get communitySignInToManageBlocks => 'Sign in to manage blocks';

  @override
  String get communityLogInToSeeBlocked =>
      'Log in to see who you have blocked.';

  @override
  String get communityNoBlockedUsers => 'No blocked users';

  @override
  String get communityBlockedUsersEmptyDesc =>
      'People you block will appear here.';

  @override
  String communityUserFallback(int id) {
    return 'User #$id';
  }

  @override
  String get communityUnblock => 'Unblock';

  @override
  String get compareTitle => 'Compare';

  @override
  String get compareAttrPrice => 'Price';

  @override
  String get compareAttrType => 'Type';

  @override
  String get compareAttrBedrooms => 'Bedrooms';

  @override
  String get compareAttrBathrooms => 'Bathrooms';

  @override
  String get compareAttrArea => 'Area (sqft)';

  @override
  String get compareAttrFurnished => 'Furnished';

  @override
  String get compareAttrParking => 'Parking';

  @override
  String get compareAttrLocation => 'Location';

  @override
  String get compareNothingToCompare => 'Nothing to compare';

  @override
  String get compareAddPropertiesDesc =>
      'Add properties to compare them side by side.';

  @override
  String get compareSignInToCompare => 'Sign in to compare';

  @override
  String get compareLogInToBuildShortlists =>
      'Log in to build and compare property shortlists.';

  @override
  String get configLanguageCurrencyTitle => 'Language & Currency';

  @override
  String get configLanguage => 'Language';

  @override
  String get configCurrency => 'Currency';

  @override
  String get configPricesLocalizedDesc =>
      'Prices are converted and content localized by the server using your selection.';

  @override
  String get viewAll => 'View all';

  @override
  String get description => 'Description';

  @override
  String get priority => 'Priority';

  @override
  String get getStarted => 'Get started';

  @override
  String get next => 'Next';

  @override
  String get submitRequest => 'Submit request';

  @override
  String get homeCategories => 'Categories';

  @override
  String get homeFeaturedProperties => 'Featured Properties';

  @override
  String get homeHandPickedDesc => 'Hand-picked listings for you';

  @override
  String get homePropertyByLocation => 'Property by Location';

  @override
  String get homeExploreTopCities => 'Explore homes in top cities';

  @override
  String homeShowingNear(String name) {
    return 'Showing properties near $name';
  }

  @override
  String get homeShowingNearYou => 'Showing properties near you';

  @override
  String get homeCouldNotGetLocation => 'Could not get your location.';

  @override
  String get homeFindingNearYou => 'Finding properties near you…';

  @override
  String get homeUseMyLocation => 'Use my current location';

  @override
  String get homeNotSureTitle => 'Not sure where to start?';

  @override
  String get homeNotSureDesc => 'Let us help you find the perfect place.';

  @override
  String get homeExploreNow => 'Explore Now';

  @override
  String get homeCouldntLoadListings => 'Couldn\'t load listings.';

  @override
  String get homeNoFeaturedListings => 'No featured listings yet';

  @override
  String get homeFromBlog => 'From the Blog';

  @override
  String get homeBlogTipsDesc => 'Tips & guides for renters and owners';

  @override
  String get maintenanceTitle => 'Maintenance';

  @override
  String get maintenanceSignInTitle => 'Sign in for maintenance';

  @override
  String get maintenanceLogInDesc =>
      'Log in to raise and track maintenance requests.';

  @override
  String get maintenanceNoRequests => 'No maintenance requests';

  @override
  String get maintenanceTapPlusDesc =>
      'Tap + to raise an issue for a property.';

  @override
  String maintenancePriorityLabel(String priority) {
    return 'Priority: $priority';
  }

  @override
  String get maintenanceEnterValidListingId => 'Enter a valid listing ID';

  @override
  String get maintenanceAddTitleDesc => 'Add a title and description';

  @override
  String get maintenanceRequestSubmitted => 'Request submitted';

  @override
  String get maintenanceRaiseIssue => 'Raise an issue';

  @override
  String get maintenanceListingId => 'Listing ID';

  @override
  String get maintenanceListingIdHint => 'The property this relates to';

  @override
  String get maintenanceTitleLabel => 'Title';

  @override
  String get maintenanceTitleHint => 'e.g. Leaking tap';

  @override
  String get maintenanceDescribeHint => 'Describe the problem';

  @override
  String get maintenancePriorityLow => 'Low';

  @override
  String get maintenancePriorityNormal => 'Normal';

  @override
  String get maintenancePriorityHigh => 'High';

  @override
  String get maintenancePriorityUrgent => 'Urgent';

  @override
  String get onboardingSlide1Title =>
      'Track, Manage & Grow Your Property Business';

  @override
  String get onboardingSlide1Body =>
      'Get real-time insights, track performance and grow your business with confidence.';

  @override
  String get onboardingSlide2Title => 'Stay Connected with Your Tenants';

  @override
  String get onboardingSlide2Body =>
      'Manage tenant information, track rent payments and keep everyone informed.';

  @override
  String get onboardingSlide3Title => 'Manage Your Properties Effortlessly';

  @override
  String get onboardingSlide3Body =>
      'All your properties, tenants, payments and maintenance in one place.';

  @override
  String get post => 'Post';

  @override
  String get edit => 'Edit';

  @override
  String get archive => 'Archive';

  @override
  String get add => 'Add';

  @override
  String get title => 'Title';

  @override
  String get price => 'Price';

  @override
  String get address => 'Address';

  @override
  String get ownerMyListingsTitle => 'My Listings';

  @override
  String get ownerSignInToManageListings => 'Sign in to manage listings';

  @override
  String get ownerLogInToManageListings =>
      'Log in to see and manage the properties you posted.';

  @override
  String get ownerNoListingsYet => 'No listings yet';

  @override
  String get ownerListingsEmptyDesc => 'Properties you post will appear here.';

  @override
  String ownerListingMarked(String status) {
    return 'Listing marked $status';
  }

  @override
  String get ownerListingDeleted => 'Listing deleted';

  @override
  String get ownerMarkAsRented => 'Mark as rented';

  @override
  String get ownerMarkAsSold => 'Mark as sold';

  @override
  String get ownerLeadsTitle => 'Leads & Activity';

  @override
  String get ownerSignInToSeeLeads => 'Sign in to see leads';

  @override
  String get ownerLogInToTrackInterest =>
      'Log in to track interest in your listings.';

  @override
  String get ownerRecentActivity => 'Recent activity';

  @override
  String get ownerCouldNotLoadStats => 'Could not load stats';

  @override
  String get ownerViews => 'Views';

  @override
  String get ownerLeads => 'Leads';

  @override
  String get ownerCouldNotLoadActivity => 'Could not load activity.';

  @override
  String get ownerNoActivityYet => 'No activity yet.';

  @override
  String get ownerSomeoneFallback => 'Someone';

  @override
  String get ownerChoosePropertyType => 'Choose a property type';

  @override
  String get ownerChooseLocation => 'Choose a location';

  @override
  String get ownerChooseLocationPlaceholder => 'Choose location';

  @override
  String get ownerListingUpdated => 'Listing updated';

  @override
  String get ownerListingSubmittedForReview => 'Listing submitted for review';

  @override
  String get ownerEditPropertyTitle => 'Edit Property';

  @override
  String get ownerPostPropertyTitle => 'Post a Property';

  @override
  String get ownerPropertyTypeLabel => 'Property type';

  @override
  String get ownerTitleHint => 'e.g. Bright 2-bed near the park';

  @override
  String get ownerAtLeast5Chars => 'At least 5 characters';

  @override
  String get ownerAmountHint => 'Amount';

  @override
  String get ownerEnterPrice => 'Enter a price';

  @override
  String get ownerAreaSqftLabel => 'Area (sq ft)';

  @override
  String get ownerAllowedFor => 'Allowed for';

  @override
  String get ownerFamily => 'Family';

  @override
  String get ownerBachelor => 'Bachelor';

  @override
  String get ownerBoth => 'Both';

  @override
  String get ownerAddressHint => 'Street / area';

  @override
  String get ownerSubmitListing => 'Submit listing';

  @override
  String get ownerPhotosAdded => 'Photos added';

  @override
  String get ownerPhotoRemoved => 'Photo removed';

  @override
  String get notifications => 'Notifications';

  @override
  String get currency => 'Currency';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileActivity => 'Activity';

  @override
  String get profileMyVisits => 'My Visits';

  @override
  String get profileFindTechnician => 'Find a Technician';

  @override
  String get profileServiceBookings => 'Service Bookings';

  @override
  String get profileBecomeTechnician => 'Become a Technician';

  @override
  String get profileMyTechnicianProfile => 'My Technician Profile';

  @override
  String get profileLists => 'Lists';

  @override
  String get profileSavedProperties => 'Saved Properties';

  @override
  String get profileSavedSearches => 'Saved Searches';

  @override
  String get profileOwner => 'Owner';

  @override
  String get profileRentManagement => 'Rent Management';

  @override
  String get profileBilling => 'Billing';

  @override
  String get profileWallet => 'Wallet';

  @override
  String get profileAccount => 'Account';

  @override
  String get profileEditProfile => 'Edit Profile';

  @override
  String get profileChangePassword => 'Change Password';

  @override
  String get profileExplore => 'Explore';

  @override
  String get profileSupportLegal => 'Support & Legal';

  @override
  String get profileHelpContact => 'Help & Contact';

  @override
  String get profilePrivacyPolicy => 'Privacy Policy';

  @override
  String get profileTermsConditions => 'Terms & Conditions';

  @override
  String get profileDarkMode => 'Dark mode';

  @override
  String get profileLogOut => 'Log out';

  @override
  String get profileLoginRegister => 'Log in / Register';

  @override
  String get profileAppVersion => 'Rentdo v1.0.0';

  @override
  String get profileGuestName => 'Guest';

  @override
  String get profileGuestDesc => 'Sign in to manage your account';

  @override
  String get profileComingSoon => 'Coming soon';

  @override
  String get profilePhoneHint => '+1 415 555 0100';

  @override
  String profileCurrencyOption(String code, String name) {
    return '$code — $name';
  }

  @override
  String get profileWhoCanSeePhone => 'Who can see my phone';

  @override
  String get profileVisibilityEveryone => 'Everyone';

  @override
  String get profileVisibilityRegistered => 'Registered users';

  @override
  String get profileVisibilityNobody => 'Nobody';

  @override
  String get profileNothingToUpdate => 'Nothing to update';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get profileUpdateFailed => 'Update failed';

  @override
  String get profilePhotoUpdated => 'Photo updated';

  @override
  String get profileUploadFailed => 'Upload failed';

  @override
  String get profileCurrentPassword => 'Current password';

  @override
  String get profileConfirmNewPassword => 'Confirm new password';

  @override
  String get profileUpdatePassword => 'Update password';

  @override
  String get profilePasswordChanged => 'Password changed';

  @override
  String get profileCouldNotChangePassword => 'Could not change password';

  @override
  String get map => 'Map';

  @override
  String get list => 'List';

  @override
  String get close => 'Close';

  @override
  String get reviews => 'Reviews';

  @override
  String get write => 'Write';

  @override
  String get share => 'Share';

  @override
  String get ofWord => 'of';

  @override
  String get logInToContinue => 'Log in to continue.';

  @override
  String get propertiesNoneFound => 'No properties found';

  @override
  String get propertiesTryAdjusting =>
      'Try adjusting your filters or search terms.';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get propertiesLogInToSaveSearches => 'Log in to save searches.';

  @override
  String get propertiesSearchSaved => 'Search saved';

  @override
  String propertiesCount(int count) {
    return '$count properties';
  }

  @override
  String get propertiesSaveSearch => 'Save search';

  @override
  String get propertiesCouldntLoadArea => 'Couldn\'t load this area.';

  @override
  String get propertiesNoPropertiesInArea => 'No properties in this area';

  @override
  String get propertyDescription => 'Description';

  @override
  String get propertyDetails => 'Property details';

  @override
  String get propertyAvailability => 'Availability';

  @override
  String get propertyAmenities => 'Amenities';

  @override
  String get propertyMortgageCalculator => 'Mortgage calculator';

  @override
  String get propertyRentCalculator => 'Rent calculator';

  @override
  String get propertyEstimateRepayment => 'Estimate your monthly repayment';

  @override
  String get propertyEstimateMoveInCost => 'Estimate your move-in cost';

  @override
  String get propertySqFt => 'Sq ft';

  @override
  String get propertyArea => 'Area';

  @override
  String get propertyFloor => 'Floor';

  @override
  String get propertyServiceCharge => 'Service charge';

  @override
  String get propertyAdvance => 'Advance';

  @override
  String propertyMonthsCount(int count) {
    return '$count month(s)';
  }

  @override
  String propertyAway(String distance) {
    return '$distance away';
  }

  @override
  String get propertyAvailabilityUnavailable => 'Availability unavailable.';

  @override
  String get propertyNoAvailabilityYet => 'No availability published yet.';

  @override
  String get propertyServicesNearby => 'Services nearby';

  @override
  String get propertyTechnicianFallback => 'Technician';

  @override
  String get propertySimilarProperties => 'Similar properties';

  @override
  String get propertyListedBy => 'Listed by';

  @override
  String get propertyLogInToMessageOwner => 'Log in to message the owner.';

  @override
  String get propertyContactNotAvailable =>
      'Contact not available for this listing.';

  @override
  String get propertyContactOwner => 'Contact owner';

  @override
  String get propertyVisitRequested => 'Visit requested';

  @override
  String get propertyBookingRequested => 'Booking requested';

  @override
  String get propertyPriceLabel => 'Price';

  @override
  String propertyPricePerPeriod(String period) {
    return 'Price / $period';
  }

  @override
  String get propertyBookNow => 'Book now';

  @override
  String get propertyScheduleVisit => 'Schedule visit';

  @override
  String get propertyCouldNotLoadReviews => 'Could not load reviews.';

  @override
  String get propertyNoReviewsYet => 'No reviews yet. Be the first to review.';

  @override
  String get propertyLogInToWriteReview => 'Log in to write a review.';

  @override
  String get propertyReviewSubmitted => 'Review submitted';

  @override
  String get propertyReportThisReview => 'Report this review';

  @override
  String get propertyReviewReported => 'Review reported';

  @override
  String get propertyGuestFallback => 'Guest';

  @override
  String get propertyReportListing => 'Report listing';

  @override
  String get propertyBlockOwner => 'Block owner';

  @override
  String get propertyReportSubmitted => 'Report submitted';

  @override
  String get propertyOwnerBlocked => 'Owner blocked';

  @override
  String get name => 'Name';

  @override
  String get notes => 'Notes';

  @override
  String get optional => 'Optional';

  @override
  String get type => 'Type';

  @override
  String get amount => 'Amount';

  @override
  String get date => 'Date';

  @override
  String get generate => 'Generate';

  @override
  String get rentManagementTitle => 'Rent Management';

  @override
  String get rentUnits => 'Units';

  @override
  String get rentTenancies => 'Tenancies';

  @override
  String get rentPayments => 'Rent Payments';

  @override
  String get rentLedger => 'Ledger';

  @override
  String get rentAgreements => 'Agreements';

  @override
  String get rentCouldNotLoadSummary => 'Could not load summary';

  @override
  String get rentIncome => 'Income';

  @override
  String get rentExpenses => 'Expenses';

  @override
  String get rentNet => 'Net';

  @override
  String get rentSignInToManage => 'Sign in to manage rent';

  @override
  String get rentLogInToTrack =>
      'Log in to track units, tenancies and payments.';

  @override
  String get rentAddUnit => 'Add unit';

  @override
  String get rentDeleteUnit => 'Delete unit';

  @override
  String get rentNoUnitsYet => 'No units yet';

  @override
  String get rentAddUnitDesc => 'Add a unit to start tracking rent.';

  @override
  String rentFloorValue(String floor) {
    return 'Floor $floor';
  }

  @override
  String get rentPerMonth => '/mo';

  @override
  String get rentUnitDeleted => 'Unit deleted';

  @override
  String get rentListingIdHint => 'Your property\'s listing ID';

  @override
  String get rentUnitNameHint => 'e.g. Apartment 2B';

  @override
  String get rentFloorHint => 'e.g. 2';

  @override
  String get rentRentAmount => 'Rent amount';

  @override
  String get rentMonthlyRentHint => 'Monthly rent';

  @override
  String get rentOptionalNotesHint => 'Optional notes';

  @override
  String get rentUnitAdded => 'Unit added';

  @override
  String get rentEnterUnitName => 'Enter a unit name';

  @override
  String get rentAddTenancy => 'Add tenancy';

  @override
  String get rentNoTenanciesYet => 'No tenancies yet';

  @override
  String get rentAddTenancyDesc =>
      'Add a tenancy to track a tenant and their rent.';

  @override
  String rentTenancyFallback(int id) {
    return 'Tenancy #$id';
  }

  @override
  String get rentOngoing => 'ongoing';

  @override
  String get rentTenantName => 'Tenant name';

  @override
  String get rentTenantPhone => 'Tenant phone';

  @override
  String get rentDeposit => 'Deposit';

  @override
  String get rentDueDayOfMonth => 'Due day of month';

  @override
  String get rentDueDayHint => '1–31';

  @override
  String get rentStartDate => 'Start date';

  @override
  String get rentSelectStartDate => 'Select start date';

  @override
  String get rentTenancyAdded => 'Tenancy added';

  @override
  String get rentEnterTenantName => 'Enter a tenant name';

  @override
  String get rentEnterRentAmount => 'Enter a rent amount';

  @override
  String get rentPickStartDate => 'Pick a start date';

  @override
  String get rentNoPaymentsYet => 'No rent payments yet';

  @override
  String get rentPaymentsEmptyDesc =>
      'Payments appear here once tenancies are active.';

  @override
  String rentDueDate(String date) {
    return 'Due $date';
  }

  @override
  String get rentMarkPaid => 'Mark paid';

  @override
  String get rentMarkedAsPaid => 'Marked as paid';

  @override
  String get rentAddEntry => 'Add entry';

  @override
  String get rentNoLedgerEntriesYet => 'No ledger entries yet';

  @override
  String get rentLedgerEmptyDesc => 'Add income or expenses to track your net.';

  @override
  String get rentIncomeLabel => 'Income';

  @override
  String get rentExpenseLabel => 'Expense';

  @override
  String get rentAddLedgerEntry => 'Add ledger entry';

  @override
  String get rentCategory => 'Category';

  @override
  String get rentCategoryHint => 'e.g. Rent, Maintenance';

  @override
  String get rentListingIdOptionalHint =>
      'Optional — your property\'s listing ID';

  @override
  String get rentEnterCategory => 'Enter a category';

  @override
  String get rentEnterAmount => 'Enter an amount';

  @override
  String get rentEntryAdded => 'Entry added';

  @override
  String get rentTemplates => 'Templates';

  @override
  String get rentGenerateAgreement => 'Generate agreement';

  @override
  String get rentNoAgreementsYet => 'No agreements yet';

  @override
  String get rentAgreementsEmptyDesc =>
      'Generate one from a tenancy and template.';

  @override
  String rentAgreementFallback(int id) {
    return 'Agreement #$id';
  }

  @override
  String get rentAgreementTemplates => 'Agreement templates';

  @override
  String get rentNoTemplatesYet =>
      'No templates yet. Create your first one below.';

  @override
  String get rentDeleteTemplate => 'Delete template';

  @override
  String get rentNewTemplate => 'New template';

  @override
  String get rentTemplateNameHint => 'e.g. Standard 12-month lease';

  @override
  String get rentBody => 'Body';

  @override
  String get rentTemplateBodyHint => 'The agreement text';

  @override
  String get rentIsDefault => 'Is default';

  @override
  String get rentCreateTemplate => 'Create template';

  @override
  String get rentDefault => 'Default';

  @override
  String get rentEnterTemplateName => 'Enter a template name';

  @override
  String get rentEnterTemplateBody => 'Enter the template body';

  @override
  String get rentTemplateCreated => 'Template created';

  @override
  String get rentTemplateDeleted => 'Template deleted';

  @override
  String get rentChooseTenancy => 'Choose a tenancy';

  @override
  String get rentChooseTemplate => 'Choose a template';

  @override
  String get rentAgreementGenerated => 'Agreement generated';

  @override
  String get rentTenancyLabel => 'Tenancy';

  @override
  String get rentTemplateLabel => 'Template';

  @override
  String get savedSearchesTitle => 'Saved Searches';

  @override
  String get savedSearchesNone => 'No saved searches';

  @override
  String get savedSearchesEmptyDesc =>
      'Save a search to get notified about new matches.';

  @override
  String get savedSearchesMatchAlerts => 'Match alerts';

  @override
  String get savedSearchesSignInTitle => 'Sign in for saved searches';

  @override
  String get savedSearchesLogInDesc =>
      'Log in to save searches and get match alerts.';

  @override
  String get helpContactTitle => 'Help & Contact';

  @override
  String supportCouldNotOpen(String scheme) {
    return 'Could not open $scheme';
  }

  @override
  String get supportGetInTouch => 'Get in touch';

  @override
  String get supportRespondDesc =>
      'We usually respond within one business day.';

  @override
  String get supportEmailUs => 'Email us';

  @override
  String get supportCallUs => 'Call us';

  @override
  String get supportVisitUs => 'Visit us';

  @override
  String get supportSendMessage => 'Send us a message';

  @override
  String get supportYourName => 'Your name';

  @override
  String get supportSubject => 'Subject';

  @override
  String get supportMessage => 'Message';

  @override
  String get supportSendMessageBtn => 'Send message';

  @override
  String get supportThanksMessage =>
      'Thanks for reaching out. We\'ll get back to you shortly.';

  @override
  String get supportCouldNotSend =>
      'Could not send your message. Please try again.';

  @override
  String get supportFaqTitle => 'Frequently asked questions';

  @override
  String supportLastUpdated(String date) {
    return 'Last updated $date';
  }

  @override
  String get supportCouldntLoadPage => 'Couldn\'t load this page.';

  @override
  String get about => 'About';

  @override
  String get skills => 'Skills';

  @override
  String get bio => 'Bio';

  @override
  String get category => 'Category';

  @override
  String get urgent => 'Urgent';

  @override
  String get reject => 'Reject';

  @override
  String get accept => 'Accept';

  @override
  String get technicianFindTitle => 'Find a Technician';

  @override
  String get technicianNoneFound => 'No technicians found';

  @override
  String technicianFallback(int id) {
    return 'Technician #$id';
  }

  @override
  String get technicianPerHour => '/hr';

  @override
  String get technicianAvailable => 'Available';

  @override
  String get technicianBusy => 'Busy';

  @override
  String get technicianRating => 'Rating';

  @override
  String get technicianJobs => 'Jobs';

  @override
  String get technicianYrsExp => 'Yrs exp';

  @override
  String get technicianLogInToRequest => 'Log in to request a service.';

  @override
  String get technicianRequestSent => 'Request sent';

  @override
  String get technicianRequestService => 'Request service';

  @override
  String get technicianProfileTitle => 'My Technician Profile';

  @override
  String get technicianProfileDetails => 'Profile details';

  @override
  String get technicianKeepCurrentDesc =>
      'Keep your details current so customers know what you offer.';

  @override
  String get technicianBioHint => 'A short intro about your experience';

  @override
  String get technicianSkillsHint => 'Comma separated, e.g. Plumbing, Wiring';

  @override
  String get technicianExperienceYears => 'Experience (years)';

  @override
  String get technicianExperienceHint => 'e.g. 5';

  @override
  String get technicianHourlyRate => 'Hourly rate';

  @override
  String get technicianRateHint => 'Your rate per hour';

  @override
  String get technicianAvailableForWork => 'Available for work';

  @override
  String get technicianPauseDesc => 'Turn this off to pause new requests.';

  @override
  String get technicianSignInToManage => 'Sign in to manage your profile';

  @override
  String get technicianLogInToUpdate =>
      'Log in to update your technician details.';

  @override
  String get technicianChooseCategory => 'Choose a category';

  @override
  String get technicianApplicationSubmitted =>
      'Application submitted — we\'ll review it shortly';

  @override
  String get technicianBecomeTitle => 'Become a Technician';

  @override
  String get technicianTellUsTitle => 'Tell us about your work';

  @override
  String get technicianReviewDesc =>
      'We review every application before your profile goes live.';

  @override
  String get technicianSubmitApplication => 'Submit application';

  @override
  String get technicianSignInToApply => 'Sign in to apply';

  @override
  String get technicianLogInToApply =>
      'Log in to send us your technician application.';

  @override
  String get technicianServiceBookingsTitle => 'Service Bookings';

  @override
  String get technicianNoServiceBookings => 'No service bookings';

  @override
  String get technicianBookTechDesc =>
      'Book a technician to see requests here.';

  @override
  String get technicianQuotes => 'Quotes';

  @override
  String get technicianSubmitQuote => 'Submit a quote';

  @override
  String get technicianSignInToSeeBookings =>
      'Sign in to see your service bookings';

  @override
  String get technicianLogInToBookTrack =>
      'Log in to book technicians and track requests.';

  @override
  String get visitsTitle => 'My Visits';

  @override
  String get visitsNoneScheduled => 'No visits scheduled';

  @override
  String get visitsBookViewingDesc => 'Book a viewing from any listing.';

  @override
  String visitsPropertyFallback(int id) {
    return 'Property #$id';
  }

  @override
  String get visitsSignInToSeeVisits => 'Sign in to see your visits';

  @override
  String get visitsLogInToSchedule =>
      'Log in to schedule and track property viewings.';

  @override
  String get walletBrandLabel => 'RENTDO WALLET';

  @override
  String get walletAvailableBalance => 'Available balance';

  @override
  String get walletUnableToLoad => 'Unable to load balance';

  @override
  String get walletTopUpComingSoon => 'Card top-up is coming soon';

  @override
  String get walletTopUp => 'Top up';

  @override
  String get walletTransactions => 'Transactions';

  @override
  String get walletNoTransactionsYet => 'No transactions yet';

  @override
  String get walletSignInToView => 'Sign in to view your wallet';

  @override
  String get walletLogInToSeeBalance =>
      'Log in to see your balance and transactions.';

  @override
  String get reset => 'Reset';

  @override
  String get any => 'Any';

  @override
  String get reason => 'Reason';

  @override
  String get selectDate => 'Select date';

  @override
  String get selectTime => 'Select time';

  @override
  String get clearDate => 'Clear date';

  @override
  String get bookNowSelectDatesError =>
      'Select your check-in and check-out dates';

  @override
  String get bookNowNightsUnavailable => 'Some of those nights are unavailable';

  @override
  String get bookNowSelectDates => 'Select dates';

  @override
  String get bookNowTitle => 'Book your stay';

  @override
  String get bookNowAllAvailable => 'All dates available in the next 60 days';

  @override
  String bookNowSomeUnavailable(int count) {
    return '$count date(s) unavailable — they are blocked';
  }

  @override
  String get bookNowSpecialRequests => 'Special requests (optional)';

  @override
  String get bookNowSpecialRequestsHint => 'Early check-in, extra bed…';

  @override
  String get bookNowRequestBooking => 'Request booking';

  @override
  String get chatDefaultMessage =>
      'Hi, I\'m interested in this property. Is it still available?';

  @override
  String get chatWriteMessageFirst => 'Write a message first';

  @override
  String get chatMessageOwnerTitle => 'Message the owner';

  @override
  String get chatYourMessageHint => 'Your message';

  @override
  String get reportDetailsOptional => 'Details (optional)';

  @override
  String get reportDetailsHint => 'Add any context for our team';

  @override
  String get reportSubmitReport => 'Submit report';

  @override
  String get compareLogInToCompare => 'Log in to compare properties.';

  @override
  String get compareRemoveFromCompare => 'Remove from compare';

  @override
  String get compareAddToCompare => 'Add to compare';

  @override
  String get compareAddedToCompare => 'Added to compare';

  @override
  String get compareRemovedFromCompare => 'Removed from compare';

  @override
  String get homeWelcome => 'Welcome 👋';

  @override
  String homeHiName(String name) {
    return 'Hi, $name 👋';
  }

  @override
  String get homeFindNextHome => 'Find your next home';

  @override
  String notificationsUnreadLabel(int count) {
    return 'Notifications, $count unread';
  }

  @override
  String get favoriteLogInToSave => 'Log in to save properties.';

  @override
  String get favoriteRemoveFromSaved => 'Remove from saved';

  @override
  String get favoriteSaveProperty => 'Save property';

  @override
  String get reviewTapStarToRate => 'Tap a star to rate';

  @override
  String get reviewWriteTitle => 'Write a review';

  @override
  String get reviewYourReviewOptional => 'Your review (optional)';

  @override
  String get reviewShareDetailsHint => 'Share details of your experience';

  @override
  String get reviewSubmitReview => 'Submit review';

  @override
  String get technicianDescribeJobAddress =>
      'Describe the job and enter an address';

  @override
  String get technicianPickDateAndTime => 'Pick a date and time';

  @override
  String get technicianChooseFutureTime => 'Choose a future time';

  @override
  String get technicianSelectDateTime => 'Select date & time';

  @override
  String get technicianRequestTitle => 'Request a technician';

  @override
  String get technicianWhatNeedDone => 'What do you need done?';

  @override
  String get technicianDescribeJobHint => 'Describe the job';

  @override
  String get technicianServiceAddress => 'Service address';

  @override
  String get technicianWhereComeHint => 'Where should they come?';

  @override
  String get technicianMarkUrgent => 'Mark as urgent';

  @override
  String get technicianSendRequest => 'Send request';

  @override
  String get quoteEnterValidAmount => 'Enter a valid amount';

  @override
  String get quoteValidUntilOptional => 'Valid until (optional)';

  @override
  String quoteValidUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String get quoteSubmitTitle => 'Submit a quote';

  @override
  String get quoteAmountHint => 'What will this job cost?';

  @override
  String get quoteDescriptionHint => 'What\'s included in this quote?';

  @override
  String get quoteSendQuote => 'Send quote';

  @override
  String get visitScheduleTitle => 'Schedule a visit';

  @override
  String get visitNoteOptional => 'Note (optional)';

  @override
  String get visitNoteHint => 'Anything the owner should know';

  @override
  String get visitRequestVisit => 'Request visit';

  @override
  String get affordEstimateRepayment => 'Estimate your monthly repayment.';

  @override
  String get affordEstimateMoveIn =>
      'Estimate your move-in cost and income guideline.';

  @override
  String get affordPropertyPrice => 'Property price';

  @override
  String get affordMonthlyRent => 'Monthly rent';

  @override
  String get affordDownPayment => 'Down payment';

  @override
  String get affordInterestRate => 'Interest rate';

  @override
  String get affordLoanTenure => 'Loan tenure';

  @override
  String get affordYr => 'yr';

  @override
  String get affordMonthlyPayment => 'Monthly payment';

  @override
  String get affordLoanAmount => 'Loan amount';

  @override
  String get affordTotalInterest => 'Total interest';

  @override
  String get affordTotalPayable => 'Total payable';

  @override
  String get affordAdvanceDeposit => 'Advance / deposit';

  @override
  String get affordMonthSingular => '1 month';

  @override
  String affordMonthsPlural(int count) {
    return '$count months';
  }

  @override
  String get affordMoveInCost => 'Move-in cost';

  @override
  String affordDepositMo(int months) {
    return 'Deposit ($months mo)';
  }

  @override
  String get affordFirstMonthRent => 'First month rent';

  @override
  String get affordSuggestedIncome => 'Suggested income /mo';

  @override
  String get affordEstimatesDisclaimer =>
      'Estimates only. Actual figures may vary.';

  @override
  String get filtersTitle => 'Filters';

  @override
  String get filterPropertyType => 'Property type';

  @override
  String get filterAnyLocation => 'Any location';

  @override
  String get filterPriceRange => 'Price range';

  @override
  String get filterVerifiedOnly => 'Verified listings only';

  @override
  String get filterFeaturedOnly => 'Featured only';

  @override
  String get filterSortBy => 'Sort by';

  @override
  String get filterShowResults => 'Show results';

  @override
  String get mapViewMap => 'View map';

  @override
  String get mapLocationFallback => 'Location';

  @override
  String get zoneSearchHint => 'Search countries or cities';

  @override
  String get zoneNoLocationsFound => 'No locations found';

  @override
  String get verified => 'Verified';

  @override
  String get featured => 'Featured';

  @override
  String get newLabel => 'New';

  @override
  String get searchLocationHint => 'Search location, property...';

  @override
  String get searchCountryHint => 'Search country or code';

  @override
  String get noCountriesFound => 'No countries found';

  @override
  String get savedNoProperties => 'No saved properties';

  @override
  String get savedTapHeartDesc =>
      'Tap the heart on any listing to save it here.';

  @override
  String get savedSignInTitle => 'Sign in to see your saved homes';

  @override
  String get savedSignInDesc => 'Save properties you love and find them here.';

  @override
  String get authContinueLoginDesc =>
      'Log in to continue exploring properties.';

  @override
  String get authJoinRentdoDesc =>
      'Join Rentdo to save favorites and contact agents.';

  @override
  String get authFullNameHint => 'Jane Doe';

  @override
  String get authEnterCodeDesc => 'Enter the code we sent to your phone.';

  @override
  String authVerifyingPhone(String phone) {
    return 'Verifying $phone';
  }

  @override
  String get notificationsSignInTitle => 'Sign in to see notifications';

  @override
  String get notificationsLogInDesc =>
      'Log in to get updates on your visits and saved searches.';

  @override
  String get notificationsMarkAllRead => 'Mark all read';

  @override
  String get notificationsNoneYet => 'No notifications yet';

  @override
  String get notificationsWillNotify =>
      'We\'ll let you know when something comes up.';

  @override
  String get categoryForSale => 'For Sale';

  @override
  String get categoryForRent => 'For Rent';

  @override
  String get categoryShortStay => 'Short Stay';

  @override
  String get categoryLand => 'Land';

  @override
  String get categoryOffice => 'Office';

  @override
  String get categoryRooms => 'Rooms';
}
