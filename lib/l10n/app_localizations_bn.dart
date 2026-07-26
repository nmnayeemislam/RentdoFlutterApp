// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'Rentdo';

  @override
  String get tagline => 'সঠিক প্রপার্টি, সঠিক জায়গা, সঠিক দামে খুঁজুন।';

  @override
  String get heroSubtitle =>
      'ভাড়া, বিক্রয় বা বিনিয়োগের জন্য যাচাইকৃত প্রপার্টি খুঁজে নিন। হাজারো মানুষের আস্থার প্ল্যাটফর্ম।';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get somethingWentWrong => 'কিছু একটা সমস্যা হয়েছে';

  @override
  String get noInternet =>
      'ইন্টারনেট সংযোগ নেই। নেটওয়ার্ক চেক করে আবার চেষ্টা করুন।';

  @override
  String get noInternetTitle => 'ইন্টারনেট সংযোগ নেই';

  @override
  String get noInternetSubtitle =>
      'মনে হচ্ছে আপনি অফলাইনে আছেন। দয়া করে আপনার ইন্টারনেট সংযোগ চেক করে আবার চেষ্টা করুন।';

  @override
  String get openSettings => 'সেটিংস খুলুন';

  @override
  String get profileThemeMode => 'থিম মোড';

  @override
  String validatorRequired(String field) {
    return '$field আবশ্যক';
  }

  @override
  String get validatorEmailRequired => 'ইমেইল আবশ্যক';

  @override
  String get validatorEmailInvalid => 'সঠিক ইমেইল দিন';

  @override
  String get validatorPasswordRequired => 'পাসওয়ার্ড আবশ্যক';

  @override
  String validatorPasswordMinLength(int min) {
    return 'পাসওয়ার্ড কমপক্ষে $min অক্ষরের হতে হবে';
  }

  @override
  String get validatorPasswordMismatch => 'পাসওয়ার্ড মিলছে না';

  @override
  String get validatorPhoneRequired => 'ফোন নম্বর আবশ্যক';

  @override
  String get validatorPhoneInvalid => 'সঠিক ফোন নম্বর দিন';

  @override
  String get validatorCodeRequired => 'কোড আবশ্যক';

  @override
  String get validatorCodeInvalid => '৬-সংখ্যার কোড দিন';

  @override
  String get noResults => 'কোনো ফলাফল পাওয়া যায়নি';

  @override
  String get seeAll => 'সব দেখুন';

  @override
  String get explore => 'প্রপার্টি খুঁজুন';

  @override
  String get login => 'লগইন';

  @override
  String get register => 'রেজিস্ট্রেশন';

  @override
  String get email => 'ইমেইল';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get fullName => 'পূর্ণ নাম';

  @override
  String get phone => 'ফোন';

  @override
  String get forgotPassword => 'পাসওয়ার্ড ভুলে গেছেন?';

  @override
  String get dontHaveAccount => 'অ্যাকাউন্ট নেই?';

  @override
  String get alreadyHaveAccount => 'আগে থেকেই অ্যাকাউন্ট আছে?';

  @override
  String get welcomeBack => 'আবার স্বাগতম';

  @override
  String get createAccount => 'আপনার অ্যাকাউন্ট তৈরি করুন';

  @override
  String get usePhoneInstead => 'ফোন নম্বর দিয়ে করুন';

  @override
  String get useEmailInstead => 'ইমেইল দিয়ে করুন';

  @override
  String get sendOtp => 'ওটিপি পাঠান';

  @override
  String get resendOtp => 'ওটিপি আবার পাঠান';

  @override
  String get verifyAndContinue => 'ভেরিফাই করে এগিয়ে যান';

  @override
  String get continueAsGuest => 'গেস্ট হিসেবে চালিয়ে যান';

  @override
  String get otpCode => 'ভেরিফিকেশন কোড';

  @override
  String get otpHint => '৬-সংখ্যার কোড';

  @override
  String get resetPassword => 'পাসওয়ার্ড রিসেট করুন';

  @override
  String get forgotPasswordTitle => 'পাসওয়ার্ড ভুলে গেছেন';

  @override
  String get forgotPasswordSubtitle =>
      'ইমেইল অথবা ফোন দিয়ে পাসওয়ার্ড রিসেট করুন।';

  @override
  String get newPassword => 'নতুন পাসওয়ার্ড';

  @override
  String get createAccountCta => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get changeDetails => 'তথ্য পরিবর্তন করুন';

  @override
  String get checkEmailForReset => 'রিসেট লিংকের জন্য আপনার ইমেইল চেক করুন';

  @override
  String get passwordUpdated =>
      'পাসওয়ার্ড পরিবর্তন হয়েছে। নতুন পাসওয়ার্ড দিয়ে লগইন করুন।';

  @override
  String get home => 'হোম';

  @override
  String get search => 'খুঁজুন';

  @override
  String get saved => 'সংরক্ষিত';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get messages => 'মেসেজ';

  @override
  String get cancel => 'বাতিল';

  @override
  String get delete => 'ডিলিট';

  @override
  String get accountNotificationSettingsTitle => 'নোটিফিকেশন সেটিংস';

  @override
  String get accountPreferencesSaved => 'পছন্দ সংরক্ষণ করা হয়েছে';

  @override
  String get accountSaveChanges => 'পরিবর্তন সংরক্ষণ করুন';

  @override
  String get accountSignInToManageNotifications =>
      'নোটিফিকেশন ম্যানেজ করতে সাইন ইন করুন';

  @override
  String get accountLogInToChooseContact =>
      'আমরা কীভাবে ও কখন যোগাযোগ করব তা বাছাই করতে লগইন করুন।';

  @override
  String get accountPrivacyDataTitle => 'প্রাইভেসি ও ডেটা';

  @override
  String get accountDeleteAccountTitle => 'অ্যাকাউন্ট ডিলিট করুন';

  @override
  String get accountDeleteAccountConfirm =>
      'এটি আপনার অ্যাকাউন্ট ডিলিটের জন্য শিডিউল করবে। এগিয়ে যাবেন?';

  @override
  String get accountExportRequested => 'এক্সপোর্ট রিকোয়েস্ট করা হয়েছে';

  @override
  String get accountDeletionScheduled =>
      'অ্যাকাউন্ট ডিলিটের জন্য শিডিউল করা হয়েছে';

  @override
  String accountDeletionScheduledOn(String date) {
    return 'অ্যাকাউন্ট $date তারিখে ডিলিটের জন্য শিডিউল করা হয়েছে';
  }

  @override
  String get accountExportMyData => 'আমার ডেটা এক্সপোর্ট করুন';

  @override
  String get accountExportDataDesc =>
      'আপনার অ্যাকাউন্ট ডেটা, লিস্টিং, মেসেজ ও বুকিংয়ের একটি কপি চান। আমরা আপনার জন্য একটি ডাউনলোড লিংক তৈরি করি।';

  @override
  String get accountRequestExport => 'এক্সপোর্ট রিকোয়েস্ট করুন';

  @override
  String get accountDeleteAccountDesc =>
      'আপনার অ্যাকাউন্ট ডিলিট করা স্থায়ী। আপনার লিস্টিং, মেসেজ, বুকিং ও সংরক্ষিত সার্চ মুছে যাবে এবং তা আর ফিরিয়ে আনা যাবে না।';

  @override
  String get accountDeleteMyAccount => 'আমার অ্যাকাউন্ট ডিলিট করুন';

  @override
  String get accountSignInToManageData =>
      'আপনার ডেটা ম্যানেজ করতে সাইন ইন করুন';

  @override
  String get accountLogInToExportOrDelete =>
      'আপনার ডেটা এক্সপোর্ট বা অ্যাকাউন্ট ডিলিট করতে লগইন করুন।';

  @override
  String get accountUsageLimitsTitle => 'ব্যবহার ও সীমা';

  @override
  String get accountPlanFeatures => 'প্ল্যান ফিচার';

  @override
  String get accountNoPlanFeatures => 'দেখানোর মতো কোনো প্ল্যান ফিচার নেই।';

  @override
  String get accountPostsUsed => 'ব্যবহৃত পোস্ট';

  @override
  String get accountUnlimited => 'সীমাহীন';

  @override
  String get accountRemainingSuffix => 'বাকি আছে';

  @override
  String get accountSignInToSeeLimits => 'আপনার সীমা দেখতে সাইন ইন করুন';

  @override
  String get accountLogInToTrackUsage =>
      'আপনার পোস্টিং ব্যবহার ও প্ল্যান ফিচার দেখতে লগইন করুন।';

  @override
  String get accountOwnerVerificationTitle => 'মালিক ভেরিফিকেশন';

  @override
  String get accountDocumentSubmitted =>
      'ডকুমেন্ট রিভিউয়ের জন্য জমা দেওয়া হয়েছে';

  @override
  String get accountUploadIdDesc =>
      'ভেরিফায়েড ব্যাজ পেতে সরকারি আইডি বা ব্যবসায়িক ডকুমেন্ট আপলোড করুন।';

  @override
  String get accountUploadDocument => 'ডকুমেন্ট আপলোড করুন';

  @override
  String get accountVerificationStatus => 'ভেরিফিকেশন স্ট্যাটাস';

  @override
  String accountReviewedOn(String date) {
    return '$date তারিখে রিভিউ করা হয়েছে';
  }

  @override
  String get accountSignInToGetVerified => 'ভেরিফাইড হতে সাইন ইন করুন';

  @override
  String get accountLogInToSubmitDocs =>
      'আপনার ডকুমেন্ট জমা দিয়ে ভেরিফাইড ব্যাজ পেতে লগইন করুন।';

  @override
  String get buy => 'কিনুন';

  @override
  String get skip => 'বাদ দিন';

  @override
  String get apply => 'প্রয়োগ করুন';

  @override
  String get billingPostPackagesTitle => 'পোস্ট প্যাকেজ';

  @override
  String get billingNoPackagesAvailable => 'কোনো প্যাকেজ পাওয়া যায়নি';

  @override
  String get billingCheckBackLaterPackages =>
      'পোস্ট প্যাকেজের জন্য পরে আবার দেখুন।';

  @override
  String get billingPackagePurchased => 'প্যাকেজ কেনা হয়েছে';

  @override
  String billingPostsAndDays(int posts, int days) {
    return '$postsটি পোস্ট · $days দিন';
  }

  @override
  String get billingSignInToBuyPackages => 'প্যাকেজ কিনতে সাইন ইন করুন';

  @override
  String get billingLogInToPurchasePackages => 'পোস্ট প্যাকেজ কিনতে লগইন করুন।';

  @override
  String get billingMembershipTitle => 'মেম্বারশিপ';

  @override
  String get billingSubscriptionCancelled => 'সাবস্ক্রিপশন বাতিল হয়েছে';

  @override
  String get billingYourPlan => 'আপনার প্ল্যান';

  @override
  String get billingCancelPlan => 'প্ল্যান বাতিল করুন';

  @override
  String get billingRenews => 'নবায়ন হবে';

  @override
  String get billingEnds => 'শেষ হবে';

  @override
  String billingPostsUsedOf(String used, String limit) {
    return 'ব্যবহৃত পোস্ট $used/$limit';
  }

  @override
  String get billingNoPlansAvailable => 'কোনো প্ল্যান পাওয়া যায়নি';

  @override
  String get billingCheckBackLaterPlans => 'মেম্বারশিপের জন্য পরে আবার দেখুন।';

  @override
  String get billingFree => 'ফ্রি';

  @override
  String billingPriceDuration(String price, int days) {
    return '$price / $days দিন';
  }

  @override
  String get billingHaveCoupon => 'কুপন আছে?';

  @override
  String get billingCouponHint => 'কুপন কোড (ঐচ্ছিক)';

  @override
  String get billingInvalidCoupon => 'অবৈধ কুপন';

  @override
  String billingCouponAppliedSavings(String amount) {
    return 'কুপন প্রয়োগ হয়েছে — আপনি $amount সাশ্রয় করলেন';
  }

  @override
  String get billingCouponApplied => 'কুপন প্রয়োগ হয়েছে';

  @override
  String billingSubscribedTo(String plan) {
    return '$plan এ সাবস্ক্রাইব করা হয়েছে';
  }

  @override
  String get billingPopular => 'জনপ্রিয়';

  @override
  String billingListingsCount(String limit) {
    return '$limitটি লিস্টিং';
  }

  @override
  String get billingCurrentPlan => 'বর্তমান প্ল্যান';

  @override
  String get billingChooseFree => 'ফ্রি বেছে নিন';

  @override
  String get billingSubscribe => 'সাবস্ক্রাইব করুন';

  @override
  String get billingSignInToViewMemberships => 'মেম্বারশিপ দেখতে সাইন ইন করুন';

  @override
  String get billingLogInToSubscribe =>
      'মেম্বারশিপ প্ল্যানে সাবস্ক্রাইব করতে লগইন করুন।';

  @override
  String get all => 'সব';

  @override
  String get blogTitle => 'ব্লগ';

  @override
  String get blogCouldntLoadPosts => 'পোস্ট লোড করা যায়নি।';

  @override
  String get blogNoPostsYet => 'এখনো কোনো পোস্ট নেই';

  @override
  String blogMinRead(int minutes) {
    return '$minutes মিনিটের পড়া';
  }

  @override
  String get blogArticleTitle => 'আর্টিকেল';

  @override
  String get blogCouldntLoadArticle => 'এই আর্টিকেলটি লোড করা যায়নি।';

  @override
  String blogByAuthor(String author) {
    return 'লিখেছেন $author';
  }

  @override
  String get blogRelatedArticles => 'সম্পর্কিত আর্টিকেল';

  @override
  String get browseProperties => 'প্রপার্টি দেখুন';

  @override
  String get night => 'রাত';

  @override
  String get nights => 'রাত';

  @override
  String get guest => 'অতিথি';

  @override
  String get guests => 'অতিথি';

  @override
  String get bookingsTitle => 'আমার বুকিং';

  @override
  String get bookingsNoBookingsYet => 'এখনো কোনো বুকিং নেই';

  @override
  String get bookingsBookStayDesc =>
      'কোনো হোটেল লিস্টিং থেকে থাকার ব্যবস্থা বুক করুন।';

  @override
  String bookingsNumberFallback(int id) {
    return 'বুকিং #$id';
  }

  @override
  String get bookingsSignInToSeeBookings => 'আপনার বুকিং দেখতে সাইন ইন করুন';

  @override
  String get bookingsLogInToManageReservations =>
      'থাকার ব্যবস্থা বুক ও রিজার্ভেশন ম্যানেজ করতে লগইন করুন।';

  @override
  String get chatTitle => 'চ্যাট';

  @override
  String get chatNoMessagesYet => 'এখনো কোনো মেসেজ নেই';

  @override
  String get chatStartConversationDesc =>
      'যেকোনো লিস্টিং থেকে কথোপকথন শুরু করুন।';

  @override
  String get chatSayHelloDesc => 'কথোপকথন শুরু করতে হ্যালো বলুন।';

  @override
  String get chatOwnerFallback => 'মালিক';

  @override
  String chatYouPrefix(String body) {
    return 'আপনি: $body';
  }

  @override
  String get chatSignInToSeeMessages => 'আপনার মেসেজ দেখতে সাইন ইন করুন';

  @override
  String get chatLogInToChatWithOwners =>
      'প্রপার্টি মালিকদের সাথে চ্যাট করতে লগইন করুন।';

  @override
  String get chatTypeMessageHint => 'একটি মেসেজ লিখুন…';

  @override
  String get clear => 'মুছুন';

  @override
  String get yes => 'হ্যাঁ';

  @override
  String get no => 'না';

  @override
  String get communityBlockedUsersTitle => 'ব্লকড ব্যবহারকারী';

  @override
  String get communityUserUnblocked => 'ব্যবহারকারী আনব্লক করা হয়েছে';

  @override
  String get communitySignInToManageBlocks => 'ব্লক ম্যানেজ করতে সাইন ইন করুন';

  @override
  String get communityLogInToSeeBlocked =>
      'আপনি কাকে ব্লক করেছেন তা দেখতে লগইন করুন।';

  @override
  String get communityNoBlockedUsers => 'কোনো ব্লকড ব্যবহারকারী নেই';

  @override
  String get communityBlockedUsersEmptyDesc =>
      'আপনি যাদের ব্লক করবেন তারা এখানে দেখা যাবে।';

  @override
  String communityUserFallback(int id) {
    return 'ব্যবহারকারী #$id';
  }

  @override
  String get communityUnblock => 'আনব্লক করুন';

  @override
  String get compareTitle => 'তুলনা করুন';

  @override
  String get compareAttrPrice => 'দাম';

  @override
  String get compareAttrType => 'ধরন';

  @override
  String get compareAttrBedrooms => 'বেডরুম';

  @override
  String get compareAttrBathrooms => 'বাথরুম';

  @override
  String get compareAttrArea => 'আয়তন (বর্গফুট)';

  @override
  String get compareAttrFurnished => 'ফার্নিশড';

  @override
  String get compareAttrParking => 'পার্কিং';

  @override
  String get compareAttrLocation => 'অবস্থান';

  @override
  String get compareNothingToCompare => 'তুলনা করার কিছু নেই';

  @override
  String get compareAddPropertiesDesc =>
      'পাশাপাশি তুলনা করতে প্রপার্টি যোগ করুন।';

  @override
  String get compareSignInToCompare => 'তুলনা করতে সাইন ইন করুন';

  @override
  String get compareLogInToBuildShortlists =>
      'প্রপার্টি শর্টলিস্ট তৈরি ও তুলনা করতে লগইন করুন।';

  @override
  String get configLanguageCurrencyTitle => 'ভাষা ও মুদ্রা';

  @override
  String get configLanguage => 'ভাষা';

  @override
  String get configCurrency => 'মুদ্রা';

  @override
  String get configPricesLocalizedDesc =>
      'আপনার নির্বাচন অনুযায়ী সার্ভার দাম রূপান্তর ও কন্টেন্ট স্থানীয়করণ করে।';

  @override
  String get viewAll => 'সব দেখুন';

  @override
  String get description => 'বিবরণ';

  @override
  String get priority => 'অগ্রাধিকার';

  @override
  String get getStarted => 'শুরু করুন';

  @override
  String get next => 'পরবর্তী';

  @override
  String get submitRequest => 'রিকোয়েস্ট জমা দিন';

  @override
  String get homeCategories => 'ক্যাটাগরি';

  @override
  String get homeFeaturedProperties => 'বাছাইকৃত প্রপার্টি';

  @override
  String get homeHandPickedDesc => 'আপনার জন্য বাছাই করা লিস্টিং';

  @override
  String get homePropertyByLocation => 'অবস্থান অনুযায়ী প্রপার্টি';

  @override
  String get homeExploreTopCities => 'শীর্ষ শহরগুলোতে বাড়ি খুঁজুন';

  @override
  String homeShowingNear(String name) {
    return '$name এর কাছাকাছি প্রপার্টি দেখানো হচ্ছে';
  }

  @override
  String get homeShowingNearYou => 'আপনার কাছাকাছি প্রপার্টি দেখানো হচ্ছে';

  @override
  String get homeCouldNotGetLocation => 'আপনার অবস্থান জানা যায়নি।';

  @override
  String get homeFindingNearYou => 'আপনার কাছাকাছি প্রপার্টি খোঁজা হচ্ছে…';

  @override
  String get homeUseMyLocation => 'আমার বর্তমান অবস্থান ব্যবহার করুন';

  @override
  String get homeNotSureTitle => 'কোথা থেকে শুরু করবেন বুঝতে পারছেন না?';

  @override
  String get homeNotSureDesc =>
      'আপনার জন্য পারফেক্ট জায়গা খুঁজে দিতে আমরা সাহায্য করব।';

  @override
  String get homeExploreNow => 'এখনই খুঁজুন';

  @override
  String get homeCouldntLoadListings => 'লিস্টিং লোড করা যায়নি।';

  @override
  String get homeNoFeaturedListings => 'এখনো কোনো বাছাইকৃত লিস্টিং নেই';

  @override
  String get homeFromBlog => 'ব্লগ থেকে';

  @override
  String get homeBlogTipsDesc => 'ভাড়াটে ও মালিকদের জন্য টিপস ও গাইড';

  @override
  String get maintenanceTitle => 'মেইনটেন্যান্স';

  @override
  String get maintenanceSignInTitle => 'মেইনটেন্যান্সের জন্য সাইন ইন করুন';

  @override
  String get maintenanceLogInDesc =>
      'মেইনটেন্যান্স রিকোয়েস্ট তৈরি ও ট্র্যাক করতে লগইন করুন।';

  @override
  String get maintenanceNoRequests => 'কোনো মেইনটেন্যান্স রিকোয়েস্ট নেই';

  @override
  String get maintenanceTapPlusDesc =>
      'কোনো প্রপার্টির জন্য সমস্যা জানাতে + এ ট্যাপ করুন।';

  @override
  String maintenancePriorityLabel(String priority) {
    return 'অগ্রাধিকার: $priority';
  }

  @override
  String get maintenanceEnterValidListingId => 'একটি সঠিক লিস্টিং আইডি দিন';

  @override
  String get maintenanceAddTitleDesc => 'একটি শিরোনাম ও বিবরণ যোগ করুন';

  @override
  String get maintenanceRequestSubmitted => 'রিকোয়েস্ট জমা দেওয়া হয়েছে';

  @override
  String get maintenanceRaiseIssue => 'সমস্যা জানান';

  @override
  String get maintenanceListingId => 'লিস্টিং আইডি';

  @override
  String get maintenanceListingIdHint => 'এটি যে প্রপার্টির সাথে সম্পর্কিত';

  @override
  String get maintenanceTitleLabel => 'শিরোনাম';

  @override
  String get maintenanceTitleHint => 'যেমন: কল থেকে পানি পড়া';

  @override
  String get maintenanceDescribeHint => 'সমস্যাটি বর্ণনা করুন';

  @override
  String get maintenancePriorityLow => 'কম';

  @override
  String get maintenancePriorityNormal => 'স্বাভাবিক';

  @override
  String get maintenancePriorityHigh => 'বেশি';

  @override
  String get maintenancePriorityUrgent => 'জরুরি';

  @override
  String get onboardingSlide1Title =>
      'আপনার প্রপার্টি ব্যবসা ট্র্যাক, ম্যানেজ ও বড় করুন';

  @override
  String get onboardingSlide1Body =>
      'রিয়েল-টাইম ইনসাইট দেখুন, পারফরম্যান্স ট্র্যাক করুন এবং আত্মবিশ্বাসের সাথে ব্যবসা বাড়ান।';

  @override
  String get onboardingSlide2Title => 'টেন্যান্টদের সাথে সবসময় সংযুক্ত থাকুন';

  @override
  String get onboardingSlide2Body =>
      'টেন্যান্ট তথ্য ম্যানেজ করুন, ভাড়া পেমেন্ট ট্র্যাক করুন এবং সবাইকে আপডেট রাখুন।';

  @override
  String get onboardingSlide3Title => 'সহজে আপনার প্রপার্টি ম্যানেজ করুন';

  @override
  String get onboardingSlide3Body =>
      'সব প্রপার্টি, টেন্যান্ট, পেমেন্ট ও মেইনটেন্যান্স এক জায়গায় রাখুন।';

  @override
  String get post => 'পোস্ট করুন';

  @override
  String get edit => 'এডিট';

  @override
  String get archive => 'আর্কাইভ';

  @override
  String get add => 'যোগ করুন';

  @override
  String get title => 'শিরোনাম';

  @override
  String get price => 'দাম';

  @override
  String get address => 'ঠিকানা';

  @override
  String get ownerMyListingsTitle => 'আমার লিস্টিং';

  @override
  String get ownerSignInToManageListings => 'লিস্টিং ম্যানেজ করতে সাইন ইন করুন';

  @override
  String get ownerLogInToManageListings =>
      'আপনার পোস্ট করা প্রপার্টি দেখতে ও ম্যানেজ করতে লগইন করুন।';

  @override
  String get ownerNoListingsYet => 'এখনো কোনো লিস্টিং নেই';

  @override
  String get ownerListingsEmptyDesc =>
      'আপনার পোস্ট করা প্রপার্টি এখানে দেখা যাবে।';

  @override
  String ownerListingMarked(String status) {
    return 'লিস্টিং $status হিসেবে চিহ্নিত হয়েছে';
  }

  @override
  String get ownerListingDeleted => 'লিস্টিং ডিলিট করা হয়েছে';

  @override
  String get ownerMarkAsRented => 'ভাড়া হয়েছে হিসেবে চিহ্নিত করুন';

  @override
  String get ownerMarkAsSold => 'বিক্রি হয়েছে হিসেবে চিহ্নিত করুন';

  @override
  String get ownerLeadsTitle => 'লিড ও কার্যক্রম';

  @override
  String get ownerSignInToSeeLeads => 'লিড দেখতে সাইন ইন করুন';

  @override
  String get ownerLogInToTrackInterest =>
      'আপনার লিস্টিংয়ে আগ্রহ ট্র্যাক করতে লগইন করুন।';

  @override
  String get ownerRecentActivity => 'সাম্প্রতিক কার্যক্রম';

  @override
  String get ownerCouldNotLoadStats => 'পরিসংখ্যান লোড করা যায়নি';

  @override
  String get ownerViews => 'ভিউ';

  @override
  String get ownerLeads => 'লিড';

  @override
  String get ownerCouldNotLoadActivity => 'কার্যক্রম লোড করা যায়নি।';

  @override
  String get ownerNoActivityYet => 'এখনো কোনো কার্যক্রম নেই।';

  @override
  String get ownerSomeoneFallback => 'কেউ একজন';

  @override
  String get ownerChoosePropertyType => 'একটি প্রপার্টি টাইপ বেছে নিন';

  @override
  String get ownerChooseLocation => 'একটি অবস্থান বেছে নিন';

  @override
  String get ownerChooseLocationPlaceholder => 'অবস্থান বেছে নিন';

  @override
  String get ownerListingUpdated => 'লিস্টিং আপডেট হয়েছে';

  @override
  String get ownerListingSubmittedForReview =>
      'লিস্টিং রিভিউয়ের জন্য জমা দেওয়া হয়েছে';

  @override
  String get ownerEditPropertyTitle => 'প্রপার্টি এডিট করুন';

  @override
  String get ownerPostPropertyTitle => 'প্রপার্টি পোস্ট করুন';

  @override
  String get ownerPropertyTypeLabel => 'প্রপার্টি টাইপ';

  @override
  String get ownerTitleHint => 'যেমন: পার্কের কাছে উজ্জ্বল ২-বেড';

  @override
  String get ownerAtLeast5Chars => 'কমপক্ষে ৫ অক্ষর';

  @override
  String get ownerAmountHint => 'পরিমাণ';

  @override
  String get ownerEnterPrice => 'একটি দাম দিন';

  @override
  String get ownerAreaSqftLabel => 'আয়তন (বর্গফুট)';

  @override
  String get ownerAllowedFor => 'যাদের জন্য অনুমোদিত';

  @override
  String get ownerFamily => 'পরিবার';

  @override
  String get ownerBachelor => 'ব্যাচেলর';

  @override
  String get ownerBoth => 'উভয়';

  @override
  String get ownerAddressHint => 'রাস্তা / এলাকা';

  @override
  String get ownerSubmitListing => 'লিস্টিং জমা দিন';

  @override
  String get ownerPhotosAdded => 'ছবি যোগ করা হয়েছে';

  @override
  String get ownerPhotoRemoved => 'ছবি সরানো হয়েছে';

  @override
  String get notifications => 'নোটিফিকেশন';

  @override
  String get currency => 'মুদ্রা';

  @override
  String get profileTitle => 'প্রোফাইল';

  @override
  String get profileActivity => 'কার্যক্রম';

  @override
  String get profileMyVisits => 'আমার ভিজিট';

  @override
  String get profileFindTechnician => 'টেকনিশিয়ান খুঁজুন';

  @override
  String get profileServiceBookings => 'সার্ভিস বুকিং';

  @override
  String get profileBecomeTechnician => 'টেকনিশিয়ান হন';

  @override
  String get profileMyTechnicianProfile => 'আমার টেকনিশিয়ান প্রোফাইল';

  @override
  String get profileLists => 'তালিকা';

  @override
  String get profileSavedProperties => 'সংরক্ষিত প্রপার্টি';

  @override
  String get profileSavedSearches => 'সংরক্ষিত সার্চ';

  @override
  String get profileOwner => 'মালিক';

  @override
  String get profileRentManagement => 'ভাড়া ব্যবস্থাপনা';

  @override
  String get profileBilling => 'বিলিং';

  @override
  String get profileWallet => 'ওয়ালেট';

  @override
  String get profileAccount => 'অ্যাকাউন্ট';

  @override
  String get profileEditProfile => 'প্রোফাইল এডিট করুন';

  @override
  String get profileChangePassword => 'পাসওয়ার্ড পরিবর্তন করুন';

  @override
  String get profileExplore => 'এক্সপ্লোর';

  @override
  String get profileSupportLegal => 'সাপোর্ট ও আইনি তথ্য';

  @override
  String get profileHelpContact => 'সাহায্য ও যোগাযোগ';

  @override
  String get profilePrivacyPolicy => 'প্রাইভেসি পলিসি';

  @override
  String get profileTermsConditions => 'শর্তাবলী';

  @override
  String get profileDarkMode => 'ডার্ক মোড';

  @override
  String get profileLogOut => 'লগ আউট';

  @override
  String get profileLoginRegister => 'লগইন / রেজিস্ট্রেশন';

  @override
  String get profileAppVersion => 'Rentdo v1.0.0';

  @override
  String get profileGuestName => 'গেস্ট';

  @override
  String get profileGuestDesc => 'আপনার অ্যাকাউন্ট ম্যানেজ করতে সাইন ইন করুন';

  @override
  String get profileComingSoon => 'শীঘ্রই আসছে';

  @override
  String get profilePhoneHint => '+৮৮০ ১৭xx xxxxxx';

  @override
  String profileCurrencyOption(String code, String name) {
    return '$code — $name';
  }

  @override
  String get profileWhoCanSeePhone => 'কে আমার ফোন নম্বর দেখতে পারবে';

  @override
  String get profileVisibilityEveryone => 'সবাই';

  @override
  String get profileVisibilityRegistered => 'রেজিস্টার্ড ব্যবহারকারী';

  @override
  String get profileVisibilityNobody => 'কেউ না';

  @override
  String get profileNothingToUpdate => 'আপডেট করার কিছু নেই';

  @override
  String get profileUpdated => 'প্রোফাইল আপডেট হয়েছে';

  @override
  String get profileUpdateFailed => 'আপডেট ব্যর্থ হয়েছে';

  @override
  String get profilePhotoUpdated => 'ছবি আপডেট হয়েছে';

  @override
  String get profileUploadFailed => 'আপলোড ব্যর্থ হয়েছে';

  @override
  String get profileCurrentPassword => 'বর্তমান পাসওয়ার্ড';

  @override
  String get profileConfirmNewPassword => 'নতুন পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get profileUpdatePassword => 'পাসওয়ার্ড আপডেট করুন';

  @override
  String get profilePasswordChanged => 'পাসওয়ার্ড পরিবর্তন হয়েছে';

  @override
  String get profileCouldNotChangePassword => 'পাসওয়ার্ড পরিবর্তন করা যায়নি';

  @override
  String get map => 'ম্যাপ';

  @override
  String get list => 'তালিকা';

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get reviews => 'রিভিউ';

  @override
  String get write => 'লিখুন';

  @override
  String get share => 'শেয়ার';

  @override
  String get ofWord => 'এর মধ্যে';

  @override
  String get logInToContinue => 'চালিয়ে যেতে লগইন করুন।';

  @override
  String get propertiesNoneFound => 'কোনো প্রপার্টি পাওয়া যায়নি';

  @override
  String get propertiesTryAdjusting =>
      'আপনার ফিল্টার বা সার্চ শব্দ পরিবর্তন করে দেখুন।';

  @override
  String get clearFilters => 'ফিল্টার মুছুন';

  @override
  String get propertiesLogInToSaveSearches => 'সার্চ সংরক্ষণ করতে লগইন করুন।';

  @override
  String get propertiesSearchSaved => 'সার্চ সংরক্ষণ করা হয়েছে';

  @override
  String propertiesCount(int count) {
    return '$countটি প্রপার্টি';
  }

  @override
  String get propertiesSaveSearch => 'সার্চ সংরক্ষণ করুন';

  @override
  String get propertiesCouldntLoadArea => 'এই এলাকাটি লোড করা যায়নি।';

  @override
  String get propertiesNoPropertiesInArea => 'এই এলাকায় কোনো প্রপার্টি নেই';

  @override
  String get propertyDescription => 'বিবরণ';

  @override
  String get propertyDetails => 'প্রপার্টির বিস্তারিত';

  @override
  String get propertyAvailability => 'প্রাপ্যতা';

  @override
  String get propertyAmenities => 'সুযোগ-সুবিধা';

  @override
  String get propertyMortgageCalculator => 'মর্টগেজ ক্যালকুলেটর';

  @override
  String get propertyRentCalculator => 'ভাড়া ক্যালকুলেটর';

  @override
  String get propertyEstimateRepayment => 'আপনার মাসিক কিস্তি হিসাব করুন';

  @override
  String get propertyEstimateMoveInCost => 'আপনার মুভ-ইন খরচ হিসাব করুন';

  @override
  String get propertySqFt => 'বর্গফুট';

  @override
  String get propertyArea => 'আয়তন';

  @override
  String get propertyFloor => 'তলা';

  @override
  String get propertyServiceCharge => 'সার্ভিস চার্জ';

  @override
  String get propertyAdvance => 'অগ্রিম';

  @override
  String propertyMonthsCount(int count) {
    return '$count মাস';
  }

  @override
  String propertyAway(String distance) {
    return '$distance দূরে';
  }

  @override
  String get propertyAvailabilityUnavailable => 'প্রাপ্যতা জানা যায়নি।';

  @override
  String get propertyNoAvailabilityYet => 'এখনো কোনো প্রাপ্যতা প্রকাশিত হয়নি।';

  @override
  String get propertyServicesNearby => 'কাছাকাছি সার্ভিস';

  @override
  String get propertyTechnicianFallback => 'টেকনিশিয়ান';

  @override
  String get propertySimilarProperties => 'একই ধরনের প্রপার্টি';

  @override
  String get propertyListedBy => 'যিনি পোস্ট করেছেন';

  @override
  String get propertyLogInToMessageOwner => 'মালিককে মেসেজ পাঠাতে লগইন করুন।';

  @override
  String get propertyContactNotAvailable =>
      'এই লিস্টিংয়ের জন্য যোগাযোগের তথ্য নেই।';

  @override
  String get propertyContactOwner => 'মালিকের সাথে যোগাযোগ';

  @override
  String get propertyVisitRequested => 'ভিজিট রিকোয়েস্ট করা হয়েছে';

  @override
  String get propertyBookingRequested => 'বুকিং রিকোয়েস্ট করা হয়েছে';

  @override
  String get propertyPriceLabel => 'দাম';

  @override
  String propertyPricePerPeriod(String period) {
    return 'দাম / $period';
  }

  @override
  String get propertyBookNow => 'এখনই বুক করুন';

  @override
  String get propertyScheduleVisit => 'ভিজিটের সময় নির্ধারণ করুন';

  @override
  String get propertyCouldNotLoadReviews => 'রিভিউ লোড করা যায়নি।';

  @override
  String get propertyNoReviewsYet =>
      'এখনো কোনো রিভিউ নেই। প্রথম রিভিউ আপনিই দিন।';

  @override
  String get propertyLogInToWriteReview => 'রিভিউ লিখতে লগইন করুন।';

  @override
  String get propertyReviewSubmitted => 'রিভিউ জমা দেওয়া হয়েছে';

  @override
  String get propertyReportThisReview => 'এই রিভিউ রিপোর্ট করুন';

  @override
  String get propertyReviewReported => 'রিভিউ রিপোর্ট করা হয়েছে';

  @override
  String get propertyGuestFallback => 'গেস্ট';

  @override
  String get propertyReportListing => 'লিস্টিং রিপোর্ট করুন';

  @override
  String get propertyBlockOwner => 'মালিককে ব্লক করুন';

  @override
  String get propertyReportSubmitted => 'রিপোর্ট জমা দেওয়া হয়েছে';

  @override
  String get propertyOwnerBlocked => 'মালিককে ব্লক করা হয়েছে';

  @override
  String get name => 'নাম';

  @override
  String get notes => 'নোট';

  @override
  String get optional => 'ঐচ্ছিক';

  @override
  String get type => 'ধরন';

  @override
  String get amount => 'পরিমাণ';

  @override
  String get date => 'তারিখ';

  @override
  String get generate => 'তৈরি করুন';

  @override
  String get rentManagementTitle => 'ভাড়া ব্যবস্থাপনা';

  @override
  String get rentUnits => 'ইউনিট';

  @override
  String get rentTenancies => 'ভাড়াটে';

  @override
  String get rentPayments => 'ভাড়া পেমেন্ট';

  @override
  String get rentLedger => 'লেজার';

  @override
  String get rentAgreements => 'চুক্তিপত্র';

  @override
  String get rentCouldNotLoadSummary => 'সারাংশ লোড করা যায়নি';

  @override
  String get rentIncome => 'আয়';

  @override
  String get rentExpenses => 'খরচ';

  @override
  String get rentNet => 'নিট';

  @override
  String get rentSignInToManage => 'ভাড়া ব্যবস্থাপনা করতে সাইন ইন করুন';

  @override
  String get rentLogInToTrack =>
      'ইউনিট, ভাড়াটে ও পেমেন্ট ট্র্যাক করতে লগইন করুন।';

  @override
  String get rentAddUnit => 'ইউনিট যোগ করুন';

  @override
  String get rentDeleteUnit => 'ইউনিট ডিলিট করুন';

  @override
  String get rentNoUnitsYet => 'এখনো কোনো ইউনিট নেই';

  @override
  String get rentAddUnitDesc => 'ভাড়া ট্র্যাক করতে একটি ইউনিট যোগ করুন।';

  @override
  String rentFloorValue(String floor) {
    return 'তলা $floor';
  }

  @override
  String get rentPerMonth => '/মাস';

  @override
  String get rentUnitDeleted => 'ইউনিট ডিলিট করা হয়েছে';

  @override
  String get rentListingIdHint => 'আপনার প্রপার্টির লিস্টিং আইডি';

  @override
  String get rentUnitNameHint => 'যেমন: অ্যাপার্টমেন্ট ২বি';

  @override
  String get rentFloorHint => 'যেমন: ২';

  @override
  String get rentRentAmount => 'ভাড়ার পরিমাণ';

  @override
  String get rentMonthlyRentHint => 'মাসিক ভাড়া';

  @override
  String get rentOptionalNotesHint => 'ঐচ্ছিক নোট';

  @override
  String get rentUnitAdded => 'ইউনিট যোগ করা হয়েছে';

  @override
  String get rentEnterUnitName => 'একটি ইউনিটের নাম দিন';

  @override
  String get rentAddTenancy => 'ভাড়াটে যোগ করুন';

  @override
  String get rentNoTenanciesYet => 'এখনো কোনো ভাড়াটে নেই';

  @override
  String get rentAddTenancyDesc =>
      'ভাড়াটে ও তার ভাড়া ট্র্যাক করতে একটি ভাড়াটে যোগ করুন।';

  @override
  String rentTenancyFallback(int id) {
    return 'ভাড়াটে #$id';
  }

  @override
  String get rentOngoing => 'চলমান';

  @override
  String get rentTenantName => 'ভাড়াটের নাম';

  @override
  String get rentTenantPhone => 'ভাড়াটের ফোন';

  @override
  String get rentDeposit => 'জামানত';

  @override
  String get rentDueDayOfMonth => 'মাসের কততম দিনে বাকি';

  @override
  String get rentDueDayHint => '১–৩১';

  @override
  String get rentStartDate => 'শুরুর তারিখ';

  @override
  String get rentSelectStartDate => 'শুরুর তারিখ বেছে নিন';

  @override
  String get rentTenancyAdded => 'ভাড়াটে যোগ করা হয়েছে';

  @override
  String get rentEnterTenantName => 'একটি ভাড়াটের নাম দিন';

  @override
  String get rentEnterRentAmount => 'একটি ভাড়ার পরিমাণ দিন';

  @override
  String get rentPickStartDate => 'একটি শুরুর তারিখ বেছে নিন';

  @override
  String get rentNoPaymentsYet => 'এখনো কোনো ভাড়া পেমেন্ট নেই';

  @override
  String get rentPaymentsEmptyDesc =>
      'ভাড়াটে সক্রিয় হলে পেমেন্ট এখানে দেখা যাবে।';

  @override
  String rentDueDate(String date) {
    return '$date তারিখে বাকি';
  }

  @override
  String get rentMarkPaid => 'পরিশোধিত চিহ্নিত করুন';

  @override
  String get rentMarkedAsPaid => 'পরিশোধিত হিসেবে চিহ্নিত হয়েছে';

  @override
  String get rentAddEntry => 'এন্ট্রি যোগ করুন';

  @override
  String get rentNoLedgerEntriesYet => 'এখনো কোনো লেজার এন্ট্রি নেই';

  @override
  String get rentLedgerEmptyDesc =>
      'আপনার নিট হিসাব রাখতে আয় বা খরচ যোগ করুন।';

  @override
  String get rentIncomeLabel => 'আয়';

  @override
  String get rentExpenseLabel => 'খরচ';

  @override
  String get rentAddLedgerEntry => 'লেজার এন্ট্রি যোগ করুন';

  @override
  String get rentCategory => 'ক্যাটাগরি';

  @override
  String get rentCategoryHint => 'যেমন: ভাড়া, মেইনটেন্যান্স';

  @override
  String get rentListingIdOptionalHint =>
      'ঐচ্ছিক — আপনার প্রপার্টির লিস্টিং আইডি';

  @override
  String get rentEnterCategory => 'একটি ক্যাটাগরি দিন';

  @override
  String get rentEnterAmount => 'একটি পরিমাণ দিন';

  @override
  String get rentEntryAdded => 'এন্ট্রি যোগ করা হয়েছে';

  @override
  String get rentTemplates => 'টেমপ্লেট';

  @override
  String get rentGenerateAgreement => 'চুক্তিপত্র তৈরি করুন';

  @override
  String get rentNoAgreementsYet => 'এখনো কোনো চুক্তিপত্র নেই';

  @override
  String get rentAgreementsEmptyDesc =>
      'একটি ভাড়াটে ও টেমপ্লেট থেকে একটি তৈরি করুন।';

  @override
  String rentAgreementFallback(int id) {
    return 'চুক্তিপত্র #$id';
  }

  @override
  String get rentAgreementTemplates => 'চুক্তিপত্র টেমপ্লেট';

  @override
  String get rentNoTemplatesYet =>
      'এখনো কোনো টেমপ্লেট নেই। নিচে আপনার প্রথমটি তৈরি করুন।';

  @override
  String get rentDeleteTemplate => 'টেমপ্লেট ডিলিট করুন';

  @override
  String get rentNewTemplate => 'নতুন টেমপ্লেট';

  @override
  String get rentTemplateNameHint => 'যেমন: স্ট্যান্ডার্ড ১২-মাসের লিজ';

  @override
  String get rentBody => 'মূল অংশ';

  @override
  String get rentTemplateBodyHint => 'চুক্তিপত্রের লেখা';

  @override
  String get rentIsDefault => 'ডিফল্ট কিনা';

  @override
  String get rentCreateTemplate => 'টেমপ্লেট তৈরি করুন';

  @override
  String get rentDefault => 'ডিফল্ট';

  @override
  String get rentEnterTemplateName => 'একটি টেমপ্লেটের নাম দিন';

  @override
  String get rentEnterTemplateBody => 'টেমপ্লেটের মূল অংশ দিন';

  @override
  String get rentTemplateCreated => 'টেমপ্লেট তৈরি হয়েছে';

  @override
  String get rentTemplateDeleted => 'টেমপ্লেট ডিলিট করা হয়েছে';

  @override
  String get rentChooseTenancy => 'একটি ভাড়াটে বেছে নিন';

  @override
  String get rentChooseTemplate => 'একটি টেমপ্লেট বেছে নিন';

  @override
  String get rentAgreementGenerated => 'চুক্তিপত্র তৈরি হয়েছে';

  @override
  String get rentTenancyLabel => 'ভাড়াটে';

  @override
  String get rentTemplateLabel => 'টেমপ্লেট';

  @override
  String get savedSearchesTitle => 'সংরক্ষিত সার্চ';

  @override
  String get savedSearchesNone => 'কোনো সংরক্ষিত সার্চ নেই';

  @override
  String get savedSearchesEmptyDesc =>
      'নতুন মিল সম্পর্কে জানতে একটি সার্চ সংরক্ষণ করুন।';

  @override
  String get savedSearchesMatchAlerts => 'মিল অ্যালার্ট';

  @override
  String get savedSearchesSignInTitle => 'সংরক্ষিত সার্চের জন্য সাইন ইন করুন';

  @override
  String get savedSearchesLogInDesc =>
      'সার্চ সংরক্ষণ ও মিল অ্যালার্ট পেতে লগইন করুন।';

  @override
  String get helpContactTitle => 'সাহায্য ও যোগাযোগ';

  @override
  String supportCouldNotOpen(String scheme) {
    return '$scheme খোলা যায়নি';
  }

  @override
  String get supportGetInTouch => 'যোগাযোগ করুন';

  @override
  String get supportRespondDesc =>
      'আমরা সাধারণত এক কার্যদিবসের মধ্যে সাড়া দিই।';

  @override
  String get supportEmailUs => 'ইমেইল করুন';

  @override
  String get supportCallUs => 'কল করুন';

  @override
  String get supportVisitUs => 'ভিজিট করুন';

  @override
  String get supportSendMessage => 'আমাদের মেসেজ পাঠান';

  @override
  String get supportYourName => 'আপনার নাম';

  @override
  String get supportSubject => 'বিষয়';

  @override
  String get supportMessage => 'মেসেজ';

  @override
  String get supportSendMessageBtn => 'মেসেজ পাঠান';

  @override
  String get supportThanksMessage =>
      'যোগাযোগ করার জন্য ধন্যবাদ। আমরা শীঘ্রই আপনার সাথে যোগাযোগ করব।';

  @override
  String get supportCouldNotSend =>
      'আপনার মেসেজ পাঠানো যায়নি। আবার চেষ্টা করুন।';

  @override
  String get supportFaqTitle => 'সচরাচর জিজ্ঞাসা';

  @override
  String supportLastUpdated(String date) {
    return 'সর্বশেষ আপডেট $date';
  }

  @override
  String get supportCouldntLoadPage => 'এই পেজটি লোড করা যায়নি।';

  @override
  String get about => 'সম্পর্কে';

  @override
  String get skills => 'দক্ষতা';

  @override
  String get bio => 'বায়ো';

  @override
  String get category => 'ক্যাটাগরি';

  @override
  String get urgent => 'জরুরি';

  @override
  String get reject => 'প্রত্যাখ্যান';

  @override
  String get accept => 'গ্রহণ';

  @override
  String get technicianFindTitle => 'টেকনিশিয়ান খুঁজুন';

  @override
  String get technicianNoneFound => 'কোনো টেকনিশিয়ান পাওয়া যায়নি';

  @override
  String technicianFallback(int id) {
    return 'টেকনিশিয়ান #$id';
  }

  @override
  String get technicianPerHour => '/ঘণ্টা';

  @override
  String get technicianAvailable => 'উপলব্ধ';

  @override
  String get technicianBusy => 'ব্যস্ত';

  @override
  String get technicianRating => 'রেটিং';

  @override
  String get technicianJobs => 'কাজ';

  @override
  String get technicianYrsExp => 'বছর অভিজ্ঞতা';

  @override
  String get technicianLogInToRequest => 'সার্ভিস রিকোয়েস্ট করতে লগইন করুন।';

  @override
  String get technicianRequestSent => 'রিকোয়েস্ট পাঠানো হয়েছে';

  @override
  String get technicianRequestService => 'সার্ভিস রিকোয়েস্ট করুন';

  @override
  String get technicianProfileTitle => 'আমার টেকনিশিয়ান প্রোফাইল';

  @override
  String get technicianProfileDetails => 'প্রোফাইলের বিস্তারিত';

  @override
  String get technicianKeepCurrentDesc =>
      'গ্রাহকরা যেন জানতে পারেন আপনি কী অফার করেন, তাই তথ্য হালনাগাদ রাখুন।';

  @override
  String get technicianBioHint => 'আপনার অভিজ্ঞতা সম্পর্কে সংক্ষিপ্ত পরিচিতি';

  @override
  String get technicianSkillsHint =>
      'কমা দিয়ে আলাদা করুন, যেমন: প্লাম্বিং, ওয়্যারিং';

  @override
  String get technicianExperienceYears => 'অভিজ্ঞতা (বছর)';

  @override
  String get technicianExperienceHint => 'যেমন: ৫';

  @override
  String get technicianHourlyRate => 'ঘণ্টা প্রতি রেট';

  @override
  String get technicianRateHint => 'আপনার ঘণ্টাপ্রতি রেট';

  @override
  String get technicianAvailableForWork => 'কাজের জন্য উপলব্ধ';

  @override
  String get technicianPauseDesc => 'নতুন রিকোয়েস্ট বন্ধ রাখতে এটি বন্ধ করুন।';

  @override
  String get technicianSignInToManage =>
      'আপনার প্রোফাইল ম্যানেজ করতে সাইন ইন করুন';

  @override
  String get technicianLogInToUpdate =>
      'আপনার টেকনিশিয়ান তথ্য আপডেট করতে লগইন করুন।';

  @override
  String get technicianChooseCategory => 'একটি ক্যাটাগরি বেছে নিন';

  @override
  String get technicianApplicationSubmitted =>
      'আবেদন জমা দেওয়া হয়েছে — আমরা শীঘ্রই পর্যালোচনা করব';

  @override
  String get technicianBecomeTitle => 'টেকনিশিয়ান হন';

  @override
  String get technicianTellUsTitle => 'আপনার কাজ সম্পর্কে আমাদের বলুন';

  @override
  String get technicianReviewDesc =>
      'আপনার প্রোফাইল প্রকাশের আগে আমরা প্রতিটি আবেদন পর্যালোচনা করি।';

  @override
  String get technicianSubmitApplication => 'আবেদন জমা দিন';

  @override
  String get technicianSignInToApply => 'আবেদন করতে সাইন ইন করুন';

  @override
  String get technicianLogInToApply =>
      'আপনার টেকনিশিয়ান আবেদন পাঠাতে লগইন করুন।';

  @override
  String get technicianServiceBookingsTitle => 'সার্ভিস বুকিং';

  @override
  String get technicianNoServiceBookings => 'কোনো সার্ভিস বুকিং নেই';

  @override
  String get technicianBookTechDesc =>
      'একজন টেকনিশিয়ান বুক করলে রিকোয়েস্ট এখানে দেখা যাবে।';

  @override
  String get technicianQuotes => 'কোটেশন';

  @override
  String get technicianSubmitQuote => 'একটি কোটেশন দিন';

  @override
  String get technicianSignInToSeeBookings =>
      'আপনার সার্ভিস বুকিং দেখতে সাইন ইন করুন';

  @override
  String get technicianLogInToBookTrack =>
      'টেকনিশিয়ান বুক ও রিকোয়েস্ট ট্র্যাক করতে লগইন করুন।';

  @override
  String get visitsTitle => 'আমার ভিজিট';

  @override
  String get visitsNoneScheduled => 'কোনো ভিজিট নির্ধারিত নেই';

  @override
  String get visitsBookViewingDesc =>
      'যেকোনো লিস্টিং থেকে দেখার সময় বুক করুন।';

  @override
  String visitsPropertyFallback(int id) {
    return 'প্রপার্টি #$id';
  }

  @override
  String get visitsSignInToSeeVisits => 'আপনার ভিজিট দেখতে সাইন ইন করুন';

  @override
  String get visitsLogInToSchedule =>
      'প্রপার্টি ভিজিট নির্ধারণ ও ট্র্যাক করতে লগইন করুন।';

  @override
  String get walletBrandLabel => 'RENTDO WALLET';

  @override
  String get walletAvailableBalance => 'উপলব্ধ ব্যালেন্স';

  @override
  String get walletUnableToLoad => 'ব্যালেন্স লোড করা যায়নি';

  @override
  String get walletTopUpComingSoon => 'কার্ড টপ-আপ শীঘ্রই আসছে';

  @override
  String get walletTopUp => 'টপ আপ';

  @override
  String get walletTransactions => 'লেনদেন';

  @override
  String get walletNoTransactionsYet => 'এখনো কোনো লেনদেন নেই';

  @override
  String get walletSignInToView => 'আপনার ওয়ালেট দেখতে সাইন ইন করুন';

  @override
  String get walletLogInToSeeBalance =>
      'আপনার ব্যালেন্স ও লেনদেন দেখতে লগইন করুন।';

  @override
  String get reset => 'রিসেট';

  @override
  String get any => 'যেকোনো';

  @override
  String get reason => 'কারণ';

  @override
  String get selectDate => 'তারিখ বেছে নিন';

  @override
  String get selectTime => 'সময় বেছে নিন';

  @override
  String get clearDate => 'তারিখ মুছুন';

  @override
  String get bookNowSelectDatesError => 'আপনার চেক-ইন ও চেক-আউট তারিখ বেছে নিন';

  @override
  String get bookNowNightsUnavailable => 'সেই রাতগুলোর কিছু উপলব্ধ নেই';

  @override
  String get bookNowSelectDates => 'তারিখ বেছে নিন';

  @override
  String get bookNowTitle => 'আপনার থাকা বুক করুন';

  @override
  String get bookNowAllAvailable => 'পরবর্তী ৬০ দিনের সব তারিখ উপলব্ধ';

  @override
  String bookNowSomeUnavailable(int count) {
    return '$countটি তারিখ উপলব্ধ নেই — সেগুলো ব্লক করা';
  }

  @override
  String get bookNowSpecialRequests => 'বিশেষ অনুরোধ (ঐচ্ছিক)';

  @override
  String get bookNowSpecialRequestsHint => 'আগে চেক-ইন, অতিরিক্ত বিছানা…';

  @override
  String get bookNowRequestBooking => 'বুকিং রিকোয়েস্ট করুন';

  @override
  String get chatDefaultMessage =>
      'হাই, আমি এই প্রপার্টিতে আগ্রহী। এটি কি এখনো উপলব্ধ?';

  @override
  String get chatWriteMessageFirst => 'প্রথমে একটি মেসেজ লিখুন';

  @override
  String get chatMessageOwnerTitle => 'মালিককে মেসেজ করুন';

  @override
  String get chatYourMessageHint => 'আপনার মেসেজ';

  @override
  String get reportDetailsOptional => 'বিস্তারিত (ঐচ্ছিক)';

  @override
  String get reportDetailsHint => 'আমাদের টিমের জন্য কোনো প্রেক্ষাপট যোগ করুন';

  @override
  String get reportSubmitReport => 'রিপোর্ট জমা দিন';

  @override
  String get compareLogInToCompare => 'প্রপার্টি তুলনা করতে লগইন করুন।';

  @override
  String get compareRemoveFromCompare => 'তুলনা থেকে সরান';

  @override
  String get compareAddToCompare => 'তুলনায় যোগ করুন';

  @override
  String get compareAddedToCompare => 'তুলনায় যোগ করা হয়েছে';

  @override
  String get compareRemovedFromCompare => 'তুলনা থেকে সরানো হয়েছে';

  @override
  String get homeWelcome => 'স্বাগতম 👋';

  @override
  String homeHiName(String name) {
    return 'হাই, $name 👋';
  }

  @override
  String get homeFindNextHome => 'আপনার পরবর্তী বাড়ি খুঁজুন';

  @override
  String notificationsUnreadLabel(int count) {
    return 'নোটিফিকেশন, $countটি অপঠিত';
  }

  @override
  String get favoriteLogInToSave => 'প্রপার্টি সংরক্ষণ করতে লগইন করুন।';

  @override
  String get favoriteRemoveFromSaved => 'সংরক্ষিত থেকে সরান';

  @override
  String get favoriteSaveProperty => 'প্রপার্টি সংরক্ষণ করুন';

  @override
  String get reviewTapStarToRate => 'রেট দিতে একটি তারায় ট্যাপ করুন';

  @override
  String get reviewWriteTitle => 'একটি রিভিউ লিখুন';

  @override
  String get reviewYourReviewOptional => 'আপনার রিভিউ (ঐচ্ছিক)';

  @override
  String get reviewShareDetailsHint => 'আপনার অভিজ্ঞতার বিস্তারিত শেয়ার করুন';

  @override
  String get reviewSubmitReview => 'রিভিউ জমা দিন';

  @override
  String get technicianDescribeJobAddress => 'কাজের বিবরণ ও একটি ঠিকানা দিন';

  @override
  String get technicianPickDateAndTime => 'একটি তারিখ ও সময় বেছে নিন';

  @override
  String get technicianChooseFutureTime => 'একটি ভবিষ্যতের সময় বেছে নিন';

  @override
  String get technicianSelectDateTime => 'তারিখ ও সময় বেছে নিন';

  @override
  String get technicianRequestTitle => 'একজন টেকনিশিয়ান রিকোয়েস্ট করুন';

  @override
  String get technicianWhatNeedDone => 'আপনার কী কাজ দরকার?';

  @override
  String get technicianDescribeJobHint => 'কাজটি বর্ণনা করুন';

  @override
  String get technicianServiceAddress => 'সার্ভিসের ঠিকানা';

  @override
  String get technicianWhereComeHint => 'তারা কোথায় আসবে?';

  @override
  String get technicianMarkUrgent => 'জরুরি হিসেবে চিহ্নিত করুন';

  @override
  String get technicianSendRequest => 'রিকোয়েস্ট পাঠান';

  @override
  String get quoteEnterValidAmount => 'একটি সঠিক পরিমাণ দিন';

  @override
  String get quoteValidUntilOptional => 'মেয়াদ (ঐচ্ছিক)';

  @override
  String quoteValidUntil(String date) {
    return 'মেয়াদ $date পর্যন্ত';
  }

  @override
  String get quoteSubmitTitle => 'একটি কোটেশন জমা দিন';

  @override
  String get quoteAmountHint => 'এই কাজের খরচ কত হবে?';

  @override
  String get quoteDescriptionHint => 'এই কোটেশনে কী অন্তর্ভুক্ত?';

  @override
  String get quoteSendQuote => 'কোটেশন পাঠান';

  @override
  String get visitScheduleTitle => 'একটি ভিজিট নির্ধারণ করুন';

  @override
  String get visitNoteOptional => 'নোট (ঐচ্ছিক)';

  @override
  String get visitNoteHint => 'মালিকের জানা দরকার এমন কিছু';

  @override
  String get visitRequestVisit => 'ভিজিট রিকোয়েস্ট করুন';

  @override
  String get affordEstimateRepayment => 'আপনার মাসিক কিস্তি হিসাব করুন।';

  @override
  String get affordEstimateMoveIn =>
      'আপনার মুভ-ইন খরচ ও আয়ের গাইডলাইন হিসাব করুন।';

  @override
  String get affordPropertyPrice => 'প্রপার্টির দাম';

  @override
  String get affordMonthlyRent => 'মাসিক ভাড়া';

  @override
  String get affordDownPayment => 'ডাউন পেমেন্ট';

  @override
  String get affordInterestRate => 'সুদের হার';

  @override
  String get affordLoanTenure => 'ঋণের মেয়াদ';

  @override
  String get affordYr => 'বছর';

  @override
  String get affordMonthlyPayment => 'মাসিক কিস্তি';

  @override
  String get affordLoanAmount => 'ঋণের পরিমাণ';

  @override
  String get affordTotalInterest => 'মোট সুদ';

  @override
  String get affordTotalPayable => 'মোট পরিশোধযোগ্য';

  @override
  String get affordAdvanceDeposit => 'অগ্রিম / জামানত';

  @override
  String get affordMonthSingular => '১ মাস';

  @override
  String affordMonthsPlural(int count) {
    return '$count মাস';
  }

  @override
  String get affordMoveInCost => 'মুভ-ইন খরচ';

  @override
  String affordDepositMo(int months) {
    return 'জামানত ($months মাস)';
  }

  @override
  String get affordFirstMonthRent => 'প্রথম মাসের ভাড়া';

  @override
  String get affordSuggestedIncome => 'প্রস্তাবিত মাসিক আয়';

  @override
  String get affordEstimatesDisclaimer =>
      'শুধুমাত্র আনুমানিক হিসাব। প্রকৃত অঙ্ক ভিন্ন হতে পারে।';

  @override
  String get filtersTitle => 'ফিল্টার';

  @override
  String get filterPropertyType => 'প্রপার্টি টাইপ';

  @override
  String get filterAnyLocation => 'যেকোনো অবস্থান';

  @override
  String get filterPriceRange => 'দামের সীমা';

  @override
  String get filterVerifiedOnly => 'শুধু যাচাইকৃত লিস্টিং';

  @override
  String get filterFeaturedOnly => 'শুধু বাছাইকৃত';

  @override
  String get filterSortBy => 'সাজান';

  @override
  String get filterShowResults => 'ফলাফল দেখুন';

  @override
  String get mapViewMap => 'ম্যাপ দেখুন';

  @override
  String get mapLocationFallback => 'অবস্থান';

  @override
  String get zoneSearchHint => 'দেশ বা শহর খুঁজুন';

  @override
  String get zoneNoLocationsFound => 'কোনো অবস্থান পাওয়া যায়নি';

  @override
  String get verified => 'যাচাইকৃত';

  @override
  String get featured => 'বাছাইকৃত';

  @override
  String get newLabel => 'নতুন';

  @override
  String get searchLocationHint => 'অবস্থান, প্রপার্টি খুঁজুন...';

  @override
  String get searchCountryHint => 'দেশ বা কোড খুঁজুন';

  @override
  String get noCountriesFound => 'কোনো দেশ পাওয়া যায়নি';

  @override
  String get savedNoProperties => 'কোনো সংরক্ষিত প্রপার্টি নেই';

  @override
  String get savedTapHeartDesc =>
      'সংরক্ষণ করতে যেকোনো লিস্টিংয়ের হার্ট আইকনে ট্যাপ করুন।';

  @override
  String get savedSignInTitle => 'আপনার সংরক্ষিত বাড়ি দেখতে সাইন ইন করুন';

  @override
  String get savedSignInDesc =>
      'পছন্দের প্রপার্টি সংরক্ষণ করুন এবং এখানে খুঁজে পান।';

  @override
  String get authContinueLoginDesc => 'প্রপার্টি খোঁজা চালিয়ে যেতে লগইন করুন।';

  @override
  String get authJoinRentdoDesc =>
      'পছন্দ সংরক্ষণ ও এজেন্টদের সাথে যোগাযোগ করতে Rentdo-তে যোগ দিন।';

  @override
  String get authFullNameHint => 'জেন ডো';

  @override
  String get authEnterCodeDesc => 'আপনার ফোনে পাঠানো কোডটি লিখুন।';

  @override
  String authVerifyingPhone(String phone) {
    return '$phone যাচাই করা হচ্ছে';
  }

  @override
  String get notificationsSignInTitle => 'নোটিফিকেশন দেখতে সাইন ইন করুন';

  @override
  String get notificationsLogInDesc =>
      'আপনার ভিজিট ও সংরক্ষিত সার্চের আপডেট পেতে লগইন করুন।';

  @override
  String get notificationsMarkAllRead => 'সব পঠিত হিসেবে চিহ্নিত করুন';

  @override
  String get notificationsNoneYet => 'এখনো কোনো নোটিফিকেশন নেই';

  @override
  String get notificationsWillNotify => 'কিছু নতুন এলে আমরা আপনাকে জানাব।';

  @override
  String get categoryForSale => 'বিক্রয়ের জন্য';

  @override
  String get categoryForRent => 'ভাড়ার জন্য';

  @override
  String get categoryShortStay => 'অল্প সময়ের থাকা';

  @override
  String get categoryLand => 'জমি';

  @override
  String get categoryOffice => 'অফিস';

  @override
  String get categoryRooms => 'রুম';
}
