import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Rentdo'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Find the right property. Right place. Right price.'**
  String get tagline;

  /// No description provided for @heroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover verified properties for rent, sale or investment. Trusted by thousands.'**
  String get heroSubtitle;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and try again.'**
  String get noInternet;

  /// No description provided for @noInternetTitle.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetTitle;

  /// No description provided for @noInternetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'It looks like you\'re offline. Please check your internet connection and try again.'**
  String get noInternetSubtitle;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @profileThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme mode'**
  String get profileThemeMode;

  /// No description provided for @validatorRequired.
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String validatorRequired(String field);

  /// No description provided for @validatorEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get validatorEmailRequired;

  /// No description provided for @validatorEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get validatorEmailInvalid;

  /// No description provided for @validatorPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validatorPasswordRequired;

  /// No description provided for @validatorPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {min} characters'**
  String validatorPasswordMinLength(int min);

  /// No description provided for @validatorPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validatorPasswordMismatch;

  /// No description provided for @validatorPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone is required'**
  String get validatorPhoneRequired;

  /// No description provided for @validatorPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get validatorPhoneInvalid;

  /// No description provided for @validatorCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Code is required'**
  String get validatorCodeRequired;

  /// No description provided for @validatorCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get validatorCodeInvalid;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore Properties'**
  String get explore;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createAccount;

  /// No description provided for @usePhoneInstead.
  ///
  /// In en, this message translates to:
  /// **'Use phone instead'**
  String get usePhoneInstead;

  /// No description provided for @useEmailInstead.
  ///
  /// In en, this message translates to:
  /// **'Use email instead'**
  String get useEmailInstead;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @verifyAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Verify & continue'**
  String get verifyAndContinue;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get continueAsGuest;

  /// No description provided for @otpCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get otpCode;

  /// No description provided for @otpHint.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get otpHint;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password by email or phone.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @createAccountCta.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountCta;

  /// No description provided for @changeDetails.
  ///
  /// In en, this message translates to:
  /// **'Change details'**
  String get changeDetails;

  /// No description provided for @checkEmailForReset.
  ///
  /// In en, this message translates to:
  /// **'Check your email for a reset link'**
  String get checkEmailForReset;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated. Please log in with your new password.'**
  String get passwordUpdated;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @accountNotificationSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get accountNotificationSettingsTitle;

  /// No description provided for @accountPreferencesSaved.
  ///
  /// In en, this message translates to:
  /// **'Preferences saved'**
  String get accountPreferencesSaved;

  /// No description provided for @accountSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get accountSaveChanges;

  /// No description provided for @accountSignInToManageNotifications.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage notifications'**
  String get accountSignInToManageNotifications;

  /// No description provided for @accountLogInToChooseContact.
  ///
  /// In en, this message translates to:
  /// **'Log in to choose how and when we contact you.'**
  String get accountLogInToChooseContact;

  /// No description provided for @accountPrivacyDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Data'**
  String get accountPrivacyDataTitle;

  /// No description provided for @accountDeleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get accountDeleteAccountTitle;

  /// No description provided for @accountDeleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'This schedules your account for deletion. Continue?'**
  String get accountDeleteAccountConfirm;

  /// No description provided for @accountExportRequested.
  ///
  /// In en, this message translates to:
  /// **'Export requested'**
  String get accountExportRequested;

  /// No description provided for @accountDeletionScheduled.
  ///
  /// In en, this message translates to:
  /// **'Account scheduled for deletion'**
  String get accountDeletionScheduled;

  /// No description provided for @accountDeletionScheduledOn.
  ///
  /// In en, this message translates to:
  /// **'Account scheduled for deletion on {date}'**
  String accountDeletionScheduledOn(String date);

  /// No description provided for @accountExportMyData.
  ///
  /// In en, this message translates to:
  /// **'Export my data'**
  String get accountExportMyData;

  /// No description provided for @accountExportDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Request a copy of your account data, listings, messages and bookings. We prepare a download link for you.'**
  String get accountExportDataDesc;

  /// No description provided for @accountRequestExport.
  ///
  /// In en, this message translates to:
  /// **'Request export'**
  String get accountRequestExport;

  /// No description provided for @accountDeleteAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account is permanent. Your listings, messages, bookings and saved searches will be removed and cannot be restored.'**
  String get accountDeleteAccountDesc;

  /// No description provided for @accountDeleteMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get accountDeleteMyAccount;

  /// No description provided for @accountSignInToManageData.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your data'**
  String get accountSignInToManageData;

  /// No description provided for @accountLogInToExportOrDelete.
  ///
  /// In en, this message translates to:
  /// **'Log in to export your data or delete your account.'**
  String get accountLogInToExportOrDelete;

  /// No description provided for @accountUsageLimitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Usage & Limits'**
  String get accountUsageLimitsTitle;

  /// No description provided for @accountPlanFeatures.
  ///
  /// In en, this message translates to:
  /// **'Plan features'**
  String get accountPlanFeatures;

  /// No description provided for @accountNoPlanFeatures.
  ///
  /// In en, this message translates to:
  /// **'No plan features to show.'**
  String get accountNoPlanFeatures;

  /// No description provided for @accountPostsUsed.
  ///
  /// In en, this message translates to:
  /// **'Posts used'**
  String get accountPostsUsed;

  /// No description provided for @accountUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get accountUnlimited;

  /// No description provided for @accountRemainingSuffix.
  ///
  /// In en, this message translates to:
  /// **'remaining'**
  String get accountRemainingSuffix;

  /// No description provided for @accountSignInToSeeLimits.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your limits'**
  String get accountSignInToSeeLimits;

  /// No description provided for @accountLogInToTrackUsage.
  ///
  /// In en, this message translates to:
  /// **'Log in to track your posting usage and plan features.'**
  String get accountLogInToTrackUsage;

  /// No description provided for @accountOwnerVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Owner Verification'**
  String get accountOwnerVerificationTitle;

  /// No description provided for @accountDocumentSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Document submitted for review'**
  String get accountDocumentSubmitted;

  /// No description provided for @accountUploadIdDesc.
  ///
  /// In en, this message translates to:
  /// **'Upload a government ID or business document to get the verified badge.'**
  String get accountUploadIdDesc;

  /// No description provided for @accountUploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload document'**
  String get accountUploadDocument;

  /// No description provided for @accountVerificationStatus.
  ///
  /// In en, this message translates to:
  /// **'Verification status'**
  String get accountVerificationStatus;

  /// No description provided for @accountReviewedOn.
  ///
  /// In en, this message translates to:
  /// **'Reviewed {date}'**
  String accountReviewedOn(String date);

  /// No description provided for @accountSignInToGetVerified.
  ///
  /// In en, this message translates to:
  /// **'Sign in to get verified'**
  String get accountSignInToGetVerified;

  /// No description provided for @accountLogInToSubmitDocs.
  ///
  /// In en, this message translates to:
  /// **'Log in to submit your documents and earn the verified badge.'**
  String get accountLogInToSubmitDocs;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @billingPostPackagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Post Packages'**
  String get billingPostPackagesTitle;

  /// No description provided for @billingNoPackagesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No packages available'**
  String get billingNoPackagesAvailable;

  /// No description provided for @billingCheckBackLaterPackages.
  ///
  /// In en, this message translates to:
  /// **'Check back later for post packages.'**
  String get billingCheckBackLaterPackages;

  /// No description provided for @billingPackagePurchased.
  ///
  /// In en, this message translates to:
  /// **'Package purchased'**
  String get billingPackagePurchased;

  /// No description provided for @billingPostsAndDays.
  ///
  /// In en, this message translates to:
  /// **'{posts} posts · {days} days'**
  String billingPostsAndDays(int posts, int days);

  /// No description provided for @billingSignInToBuyPackages.
  ///
  /// In en, this message translates to:
  /// **'Sign in to buy packages'**
  String get billingSignInToBuyPackages;

  /// No description provided for @billingLogInToPurchasePackages.
  ///
  /// In en, this message translates to:
  /// **'Log in to purchase post packages.'**
  String get billingLogInToPurchasePackages;

  /// No description provided for @billingMembershipTitle.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get billingMembershipTitle;

  /// No description provided for @billingSubscriptionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Subscription cancelled'**
  String get billingSubscriptionCancelled;

  /// No description provided for @billingYourPlan.
  ///
  /// In en, this message translates to:
  /// **'Your plan'**
  String get billingYourPlan;

  /// No description provided for @billingCancelPlan.
  ///
  /// In en, this message translates to:
  /// **'Cancel plan'**
  String get billingCancelPlan;

  /// No description provided for @billingRenews.
  ///
  /// In en, this message translates to:
  /// **'Renews'**
  String get billingRenews;

  /// No description provided for @billingEnds.
  ///
  /// In en, this message translates to:
  /// **'Ends'**
  String get billingEnds;

  /// No description provided for @billingPostsUsedOf.
  ///
  /// In en, this message translates to:
  /// **'Posts used {used}/{limit}'**
  String billingPostsUsedOf(String used, String limit);

  /// No description provided for @billingNoPlansAvailable.
  ///
  /// In en, this message translates to:
  /// **'No plans available'**
  String get billingNoPlansAvailable;

  /// No description provided for @billingCheckBackLaterPlans.
  ///
  /// In en, this message translates to:
  /// **'Check back later for membership options.'**
  String get billingCheckBackLaterPlans;

  /// No description provided for @billingFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get billingFree;

  /// No description provided for @billingPriceDuration.
  ///
  /// In en, this message translates to:
  /// **'{price} / {days} days'**
  String billingPriceDuration(String price, int days);

  /// No description provided for @billingHaveCoupon.
  ///
  /// In en, this message translates to:
  /// **'Have a coupon?'**
  String get billingHaveCoupon;

  /// No description provided for @billingCouponHint.
  ///
  /// In en, this message translates to:
  /// **'Coupon code (optional)'**
  String get billingCouponHint;

  /// No description provided for @billingInvalidCoupon.
  ///
  /// In en, this message translates to:
  /// **'Invalid coupon'**
  String get billingInvalidCoupon;

  /// No description provided for @billingCouponAppliedSavings.
  ///
  /// In en, this message translates to:
  /// **'Coupon applied — you save {amount}'**
  String billingCouponAppliedSavings(String amount);

  /// No description provided for @billingCouponApplied.
  ///
  /// In en, this message translates to:
  /// **'Coupon applied'**
  String get billingCouponApplied;

  /// No description provided for @billingSubscribedTo.
  ///
  /// In en, this message translates to:
  /// **'Subscribed to {plan}'**
  String billingSubscribedTo(String plan);

  /// No description provided for @billingPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get billingPopular;

  /// No description provided for @billingListingsCount.
  ///
  /// In en, this message translates to:
  /// **'{limit} listings'**
  String billingListingsCount(String limit);

  /// No description provided for @billingCurrentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current plan'**
  String get billingCurrentPlan;

  /// No description provided for @billingChooseFree.
  ///
  /// In en, this message translates to:
  /// **'Choose Free'**
  String get billingChooseFree;

  /// No description provided for @billingSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get billingSubscribe;

  /// No description provided for @billingSignInToViewMemberships.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view memberships'**
  String get billingSignInToViewMemberships;

  /// No description provided for @billingLogInToSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Log in to subscribe to a membership plan.'**
  String get billingLogInToSubscribe;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @blogTitle.
  ///
  /// In en, this message translates to:
  /// **'Blog'**
  String get blogTitle;

  /// No description provided for @blogCouldntLoadPosts.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load posts.'**
  String get blogCouldntLoadPosts;

  /// No description provided for @blogNoPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get blogNoPostsYet;

  /// No description provided for @blogMinRead.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min read'**
  String blogMinRead(int minutes);

  /// No description provided for @blogArticleTitle.
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get blogArticleTitle;

  /// No description provided for @blogCouldntLoadArticle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this article.'**
  String get blogCouldntLoadArticle;

  /// No description provided for @blogByAuthor.
  ///
  /// In en, this message translates to:
  /// **'By {author}'**
  String blogByAuthor(String author);

  /// No description provided for @blogRelatedArticles.
  ///
  /// In en, this message translates to:
  /// **'Related articles'**
  String get blogRelatedArticles;

  /// No description provided for @browseProperties.
  ///
  /// In en, this message translates to:
  /// **'Browse properties'**
  String get browseProperties;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'night'**
  String get night;

  /// No description provided for @nights.
  ///
  /// In en, this message translates to:
  /// **'nights'**
  String get nights;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'guest'**
  String get guest;

  /// No description provided for @guests.
  ///
  /// In en, this message translates to:
  /// **'guests'**
  String get guests;

  /// No description provided for @bookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get bookingsTitle;

  /// No description provided for @bookingsNoBookingsYet.
  ///
  /// In en, this message translates to:
  /// **'No bookings yet'**
  String get bookingsNoBookingsYet;

  /// No description provided for @bookingsBookStayDesc.
  ///
  /// In en, this message translates to:
  /// **'Book a stay from a hotel listing.'**
  String get bookingsBookStayDesc;

  /// No description provided for @bookingsNumberFallback.
  ///
  /// In en, this message translates to:
  /// **'Booking #{id}'**
  String bookingsNumberFallback(int id);

  /// No description provided for @bookingsSignInToSeeBookings.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your bookings'**
  String get bookingsSignInToSeeBookings;

  /// No description provided for @bookingsLogInToManageReservations.
  ///
  /// In en, this message translates to:
  /// **'Log in to book stays and manage reservations.'**
  String get bookingsLogInToManageReservations;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chatTitle;

  /// No description provided for @chatNoMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get chatNoMessagesYet;

  /// No description provided for @chatStartConversationDesc.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation from any listing.'**
  String get chatStartConversationDesc;

  /// No description provided for @chatSayHelloDesc.
  ///
  /// In en, this message translates to:
  /// **'Say hello to start the conversation.'**
  String get chatSayHelloDesc;

  /// No description provided for @chatOwnerFallback.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get chatOwnerFallback;

  /// No description provided for @chatYouPrefix.
  ///
  /// In en, this message translates to:
  /// **'You: {body}'**
  String chatYouPrefix(String body);

  /// No description provided for @chatSignInToSeeMessages.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your messages'**
  String get chatSignInToSeeMessages;

  /// No description provided for @chatLogInToChatWithOwners.
  ///
  /// In en, this message translates to:
  /// **'Log in to chat with property owners.'**
  String get chatLogInToChatWithOwners;

  /// No description provided for @chatTypeMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Type a message…'**
  String get chatTypeMessageHint;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @communityBlockedUsersTitle.
  ///
  /// In en, this message translates to:
  /// **'Blocked Users'**
  String get communityBlockedUsersTitle;

  /// No description provided for @communityUserUnblocked.
  ///
  /// In en, this message translates to:
  /// **'User unblocked'**
  String get communityUserUnblocked;

  /// No description provided for @communitySignInToManageBlocks.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage blocks'**
  String get communitySignInToManageBlocks;

  /// No description provided for @communityLogInToSeeBlocked.
  ///
  /// In en, this message translates to:
  /// **'Log in to see who you have blocked.'**
  String get communityLogInToSeeBlocked;

  /// No description provided for @communityNoBlockedUsers.
  ///
  /// In en, this message translates to:
  /// **'No blocked users'**
  String get communityNoBlockedUsers;

  /// No description provided for @communityBlockedUsersEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'People you block will appear here.'**
  String get communityBlockedUsersEmptyDesc;

  /// No description provided for @communityUserFallback.
  ///
  /// In en, this message translates to:
  /// **'User #{id}'**
  String communityUserFallback(int id);

  /// No description provided for @communityUnblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get communityUnblock;

  /// No description provided for @compareTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get compareTitle;

  /// No description provided for @compareAttrPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get compareAttrPrice;

  /// No description provided for @compareAttrType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get compareAttrType;

  /// No description provided for @compareAttrBedrooms.
  ///
  /// In en, this message translates to:
  /// **'Bedrooms'**
  String get compareAttrBedrooms;

  /// No description provided for @compareAttrBathrooms.
  ///
  /// In en, this message translates to:
  /// **'Bathrooms'**
  String get compareAttrBathrooms;

  /// No description provided for @compareAttrArea.
  ///
  /// In en, this message translates to:
  /// **'Area (sqft)'**
  String get compareAttrArea;

  /// No description provided for @compareAttrFurnished.
  ///
  /// In en, this message translates to:
  /// **'Furnished'**
  String get compareAttrFurnished;

  /// No description provided for @compareAttrParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get compareAttrParking;

  /// No description provided for @compareAttrLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get compareAttrLocation;

  /// No description provided for @compareNothingToCompare.
  ///
  /// In en, this message translates to:
  /// **'Nothing to compare'**
  String get compareNothingToCompare;

  /// No description provided for @compareAddPropertiesDesc.
  ///
  /// In en, this message translates to:
  /// **'Add properties to compare them side by side.'**
  String get compareAddPropertiesDesc;

  /// No description provided for @compareSignInToCompare.
  ///
  /// In en, this message translates to:
  /// **'Sign in to compare'**
  String get compareSignInToCompare;

  /// No description provided for @compareLogInToBuildShortlists.
  ///
  /// In en, this message translates to:
  /// **'Log in to build and compare property shortlists.'**
  String get compareLogInToBuildShortlists;

  /// No description provided for @configLanguageCurrencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Language & Currency'**
  String get configLanguageCurrencyTitle;

  /// No description provided for @configLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get configLanguage;

  /// No description provided for @configCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get configCurrency;

  /// No description provided for @configPricesLocalizedDesc.
  ///
  /// In en, this message translates to:
  /// **'Prices are converted and content localized by the server using your selection.'**
  String get configPricesLocalizedDesc;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit request'**
  String get submitRequest;

  /// No description provided for @homeCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get homeCategories;

  /// No description provided for @homeFeaturedProperties.
  ///
  /// In en, this message translates to:
  /// **'Featured Properties'**
  String get homeFeaturedProperties;

  /// No description provided for @homeHandPickedDesc.
  ///
  /// In en, this message translates to:
  /// **'Hand-picked listings for you'**
  String get homeHandPickedDesc;

  /// No description provided for @homePropertyByLocation.
  ///
  /// In en, this message translates to:
  /// **'Property by Location'**
  String get homePropertyByLocation;

  /// No description provided for @homeExploreTopCities.
  ///
  /// In en, this message translates to:
  /// **'Explore homes in top cities'**
  String get homeExploreTopCities;

  /// No description provided for @homeShowingNear.
  ///
  /// In en, this message translates to:
  /// **'Showing properties near {name}'**
  String homeShowingNear(String name);

  /// No description provided for @homeShowingNearYou.
  ///
  /// In en, this message translates to:
  /// **'Showing properties near you'**
  String get homeShowingNearYou;

  /// No description provided for @homeCouldNotGetLocation.
  ///
  /// In en, this message translates to:
  /// **'Could not get your location.'**
  String get homeCouldNotGetLocation;

  /// No description provided for @homeFindingNearYou.
  ///
  /// In en, this message translates to:
  /// **'Finding properties near you…'**
  String get homeFindingNearYou;

  /// No description provided for @homeUseMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get homeUseMyLocation;

  /// No description provided for @homeNotSureTitle.
  ///
  /// In en, this message translates to:
  /// **'Not sure where to start?'**
  String get homeNotSureTitle;

  /// No description provided for @homeNotSureDesc.
  ///
  /// In en, this message translates to:
  /// **'Let us help you find the perfect place.'**
  String get homeNotSureDesc;

  /// No description provided for @homeExploreNow.
  ///
  /// In en, this message translates to:
  /// **'Explore Now'**
  String get homeExploreNow;

  /// No description provided for @homeCouldntLoadListings.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load listings.'**
  String get homeCouldntLoadListings;

  /// No description provided for @homeNoFeaturedListings.
  ///
  /// In en, this message translates to:
  /// **'No featured listings yet'**
  String get homeNoFeaturedListings;

  /// No description provided for @homeFromBlog.
  ///
  /// In en, this message translates to:
  /// **'From the Blog'**
  String get homeFromBlog;

  /// No description provided for @homeBlogTipsDesc.
  ///
  /// In en, this message translates to:
  /// **'Tips & guides for renters and owners'**
  String get homeBlogTipsDesc;

  /// No description provided for @maintenanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenanceTitle;

  /// No description provided for @maintenanceSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in for maintenance'**
  String get maintenanceSignInTitle;

  /// No description provided for @maintenanceLogInDesc.
  ///
  /// In en, this message translates to:
  /// **'Log in to raise and track maintenance requests.'**
  String get maintenanceLogInDesc;

  /// No description provided for @maintenanceNoRequests.
  ///
  /// In en, this message translates to:
  /// **'No maintenance requests'**
  String get maintenanceNoRequests;

  /// No description provided for @maintenanceTapPlusDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap + to raise an issue for a property.'**
  String get maintenanceTapPlusDesc;

  /// No description provided for @maintenancePriorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority: {priority}'**
  String maintenancePriorityLabel(String priority);

  /// No description provided for @maintenanceEnterValidListingId.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid listing ID'**
  String get maintenanceEnterValidListingId;

  /// No description provided for @maintenanceAddTitleDesc.
  ///
  /// In en, this message translates to:
  /// **'Add a title and description'**
  String get maintenanceAddTitleDesc;

  /// No description provided for @maintenanceRequestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Request submitted'**
  String get maintenanceRequestSubmitted;

  /// No description provided for @maintenanceRaiseIssue.
  ///
  /// In en, this message translates to:
  /// **'Raise an issue'**
  String get maintenanceRaiseIssue;

  /// No description provided for @maintenanceListingId.
  ///
  /// In en, this message translates to:
  /// **'Listing ID'**
  String get maintenanceListingId;

  /// No description provided for @maintenanceListingIdHint.
  ///
  /// In en, this message translates to:
  /// **'The property this relates to'**
  String get maintenanceListingIdHint;

  /// No description provided for @maintenanceTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get maintenanceTitleLabel;

  /// No description provided for @maintenanceTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Leaking tap'**
  String get maintenanceTitleHint;

  /// No description provided for @maintenanceDescribeHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the problem'**
  String get maintenanceDescribeHint;

  /// No description provided for @maintenancePriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get maintenancePriorityLow;

  /// No description provided for @maintenancePriorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get maintenancePriorityNormal;

  /// No description provided for @maintenancePriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get maintenancePriorityHigh;

  /// No description provided for @maintenancePriorityUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get maintenancePriorityUrgent;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Track, Manage & Grow Your Property Business'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Body.
  ///
  /// In en, this message translates to:
  /// **'Get real-time insights, track performance and grow your business with confidence.'**
  String get onboardingSlide1Body;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Stay Connected with Your Tenants'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Body.
  ///
  /// In en, this message translates to:
  /// **'Manage tenant information, track rent payments and keep everyone informed.'**
  String get onboardingSlide2Body;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Manage Your Properties Effortlessly'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Body.
  ///
  /// In en, this message translates to:
  /// **'All your properties, tenants, payments and maintenance in one place.'**
  String get onboardingSlide3Body;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @ownerMyListingsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Listings'**
  String get ownerMyListingsTitle;

  /// No description provided for @ownerSignInToManageListings.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage listings'**
  String get ownerSignInToManageListings;

  /// No description provided for @ownerLogInToManageListings.
  ///
  /// In en, this message translates to:
  /// **'Log in to see and manage the properties you posted.'**
  String get ownerLogInToManageListings;

  /// No description provided for @ownerNoListingsYet.
  ///
  /// In en, this message translates to:
  /// **'No listings yet'**
  String get ownerNoListingsYet;

  /// No description provided for @ownerListingsEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Properties you post will appear here.'**
  String get ownerListingsEmptyDesc;

  /// No description provided for @ownerListingMarked.
  ///
  /// In en, this message translates to:
  /// **'Listing marked {status}'**
  String ownerListingMarked(String status);

  /// No description provided for @ownerListingDeleted.
  ///
  /// In en, this message translates to:
  /// **'Listing deleted'**
  String get ownerListingDeleted;

  /// No description provided for @ownerMarkAsRented.
  ///
  /// In en, this message translates to:
  /// **'Mark as rented'**
  String get ownerMarkAsRented;

  /// No description provided for @ownerMarkAsSold.
  ///
  /// In en, this message translates to:
  /// **'Mark as sold'**
  String get ownerMarkAsSold;

  /// No description provided for @ownerLeadsTitle.
  ///
  /// In en, this message translates to:
  /// **'Leads & Activity'**
  String get ownerLeadsTitle;

  /// No description provided for @ownerSignInToSeeLeads.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see leads'**
  String get ownerSignInToSeeLeads;

  /// No description provided for @ownerLogInToTrackInterest.
  ///
  /// In en, this message translates to:
  /// **'Log in to track interest in your listings.'**
  String get ownerLogInToTrackInterest;

  /// No description provided for @ownerRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get ownerRecentActivity;

  /// No description provided for @ownerCouldNotLoadStats.
  ///
  /// In en, this message translates to:
  /// **'Could not load stats'**
  String get ownerCouldNotLoadStats;

  /// No description provided for @ownerViews.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get ownerViews;

  /// No description provided for @ownerLeads.
  ///
  /// In en, this message translates to:
  /// **'Leads'**
  String get ownerLeads;

  /// No description provided for @ownerCouldNotLoadActivity.
  ///
  /// In en, this message translates to:
  /// **'Could not load activity.'**
  String get ownerCouldNotLoadActivity;

  /// No description provided for @ownerNoActivityYet.
  ///
  /// In en, this message translates to:
  /// **'No activity yet.'**
  String get ownerNoActivityYet;

  /// No description provided for @ownerSomeoneFallback.
  ///
  /// In en, this message translates to:
  /// **'Someone'**
  String get ownerSomeoneFallback;

  /// No description provided for @ownerChoosePropertyType.
  ///
  /// In en, this message translates to:
  /// **'Choose a property type'**
  String get ownerChoosePropertyType;

  /// No description provided for @ownerChooseLocation.
  ///
  /// In en, this message translates to:
  /// **'Choose a location'**
  String get ownerChooseLocation;

  /// No description provided for @ownerChooseLocationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Choose location'**
  String get ownerChooseLocationPlaceholder;

  /// No description provided for @ownerListingUpdated.
  ///
  /// In en, this message translates to:
  /// **'Listing updated'**
  String get ownerListingUpdated;

  /// No description provided for @ownerListingSubmittedForReview.
  ///
  /// In en, this message translates to:
  /// **'Listing submitted for review'**
  String get ownerListingSubmittedForReview;

  /// No description provided for @ownerEditPropertyTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Property'**
  String get ownerEditPropertyTitle;

  /// No description provided for @ownerPostPropertyTitle.
  ///
  /// In en, this message translates to:
  /// **'Post a Property'**
  String get ownerPostPropertyTitle;

  /// No description provided for @ownerPropertyTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Property type'**
  String get ownerPropertyTypeLabel;

  /// No description provided for @ownerTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Bright 2-bed near the park'**
  String get ownerTitleHint;

  /// No description provided for @ownerAtLeast5Chars.
  ///
  /// In en, this message translates to:
  /// **'At least 5 characters'**
  String get ownerAtLeast5Chars;

  /// No description provided for @ownerAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get ownerAmountHint;

  /// No description provided for @ownerEnterPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a price'**
  String get ownerEnterPrice;

  /// No description provided for @ownerAreaSqftLabel.
  ///
  /// In en, this message translates to:
  /// **'Area (sq ft)'**
  String get ownerAreaSqftLabel;

  /// No description provided for @ownerAllowedFor.
  ///
  /// In en, this message translates to:
  /// **'Allowed for'**
  String get ownerAllowedFor;

  /// No description provided for @ownerFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get ownerFamily;

  /// No description provided for @ownerBachelor.
  ///
  /// In en, this message translates to:
  /// **'Bachelor'**
  String get ownerBachelor;

  /// No description provided for @ownerBoth.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get ownerBoth;

  /// No description provided for @ownerAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Street / area'**
  String get ownerAddressHint;

  /// No description provided for @ownerSubmitListing.
  ///
  /// In en, this message translates to:
  /// **'Submit listing'**
  String get ownerSubmitListing;

  /// No description provided for @ownerPhotosAdded.
  ///
  /// In en, this message translates to:
  /// **'Photos added'**
  String get ownerPhotosAdded;

  /// No description provided for @ownerPhotoRemoved.
  ///
  /// In en, this message translates to:
  /// **'Photo removed'**
  String get ownerPhotoRemoved;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get profileActivity;

  /// No description provided for @profileMyVisits.
  ///
  /// In en, this message translates to:
  /// **'My Visits'**
  String get profileMyVisits;

  /// No description provided for @profileFindTechnician.
  ///
  /// In en, this message translates to:
  /// **'Find a Technician'**
  String get profileFindTechnician;

  /// No description provided for @profileServiceBookings.
  ///
  /// In en, this message translates to:
  /// **'Service Bookings'**
  String get profileServiceBookings;

  /// No description provided for @profileBecomeTechnician.
  ///
  /// In en, this message translates to:
  /// **'Become a Technician'**
  String get profileBecomeTechnician;

  /// No description provided for @profileMyTechnicianProfile.
  ///
  /// In en, this message translates to:
  /// **'My Technician Profile'**
  String get profileMyTechnicianProfile;

  /// No description provided for @profileLists.
  ///
  /// In en, this message translates to:
  /// **'Lists'**
  String get profileLists;

  /// No description provided for @profileSavedProperties.
  ///
  /// In en, this message translates to:
  /// **'Saved Properties'**
  String get profileSavedProperties;

  /// No description provided for @profileSavedSearches.
  ///
  /// In en, this message translates to:
  /// **'Saved Searches'**
  String get profileSavedSearches;

  /// No description provided for @profileOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get profileOwner;

  /// No description provided for @profileRentManagement.
  ///
  /// In en, this message translates to:
  /// **'Rent Management'**
  String get profileRentManagement;

  /// No description provided for @profileBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get profileBilling;

  /// No description provided for @profileWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get profileWallet;

  /// No description provided for @profileAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileAccount;

  /// No description provided for @profileEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditProfile;

  /// No description provided for @profileChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get profileChangePassword;

  /// No description provided for @profileExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get profileExplore;

  /// No description provided for @profileSupportLegal.
  ///
  /// In en, this message translates to:
  /// **'Support & Legal'**
  String get profileSupportLegal;

  /// No description provided for @profileHelpContact.
  ///
  /// In en, this message translates to:
  /// **'Help & Contact'**
  String get profileHelpContact;

  /// No description provided for @profilePrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get profilePrivacyPolicy;

  /// No description provided for @profileTermsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get profileTermsConditions;

  /// No description provided for @profileDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get profileDarkMode;

  /// No description provided for @profileLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profileLogOut;

  /// No description provided for @profileLoginRegister.
  ///
  /// In en, this message translates to:
  /// **'Log in / Register'**
  String get profileLoginRegister;

  /// No description provided for @profileAppVersion.
  ///
  /// In en, this message translates to:
  /// **'Rentdo v1.0.0'**
  String get profileAppVersion;

  /// No description provided for @profileGuestName.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get profileGuestName;

  /// No description provided for @profileGuestDesc.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your account'**
  String get profileGuestDesc;

  /// No description provided for @profileComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get profileComingSoon;

  /// No description provided for @profilePhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+1 415 555 0100'**
  String get profilePhoneHint;

  /// No description provided for @profileCurrencyOption.
  ///
  /// In en, this message translates to:
  /// **'{code} — {name}'**
  String profileCurrencyOption(String code, String name);

  /// No description provided for @profileWhoCanSeePhone.
  ///
  /// In en, this message translates to:
  /// **'Who can see my phone'**
  String get profileWhoCanSeePhone;

  /// No description provided for @profileVisibilityEveryone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get profileVisibilityEveryone;

  /// No description provided for @profileVisibilityRegistered.
  ///
  /// In en, this message translates to:
  /// **'Registered users'**
  String get profileVisibilityRegistered;

  /// No description provided for @profileVisibilityNobody.
  ///
  /// In en, this message translates to:
  /// **'Nobody'**
  String get profileVisibilityNobody;

  /// No description provided for @profileNothingToUpdate.
  ///
  /// In en, this message translates to:
  /// **'Nothing to update'**
  String get profileNothingToUpdate;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed'**
  String get profileUpdateFailed;

  /// No description provided for @profilePhotoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Photo updated'**
  String get profilePhotoUpdated;

  /// No description provided for @profileUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get profileUploadFailed;

  /// No description provided for @profileCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get profileCurrentPassword;

  /// No description provided for @profileConfirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get profileConfirmNewPassword;

  /// No description provided for @profileUpdatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get profileUpdatePassword;

  /// No description provided for @profilePasswordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed'**
  String get profilePasswordChanged;

  /// No description provided for @profileCouldNotChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Could not change password'**
  String get profileCouldNotChangePassword;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @write.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get write;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @ofWord.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofWord;

  /// No description provided for @logInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Log in to continue.'**
  String get logInToContinue;

  /// No description provided for @propertiesNoneFound.
  ///
  /// In en, this message translates to:
  /// **'No properties found'**
  String get propertiesNoneFound;

  /// No description provided for @propertiesTryAdjusting.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or search terms.'**
  String get propertiesTryAdjusting;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @propertiesLogInToSaveSearches.
  ///
  /// In en, this message translates to:
  /// **'Log in to save searches.'**
  String get propertiesLogInToSaveSearches;

  /// No description provided for @propertiesSearchSaved.
  ///
  /// In en, this message translates to:
  /// **'Search saved'**
  String get propertiesSearchSaved;

  /// No description provided for @propertiesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} properties'**
  String propertiesCount(int count);

  /// No description provided for @propertiesSaveSearch.
  ///
  /// In en, this message translates to:
  /// **'Save search'**
  String get propertiesSaveSearch;

  /// No description provided for @propertiesCouldntLoadArea.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this area.'**
  String get propertiesCouldntLoadArea;

  /// No description provided for @propertiesNoPropertiesInArea.
  ///
  /// In en, this message translates to:
  /// **'No properties in this area'**
  String get propertiesNoPropertiesInArea;

  /// No description provided for @propertyDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get propertyDescription;

  /// No description provided for @propertyDetails.
  ///
  /// In en, this message translates to:
  /// **'Property details'**
  String get propertyDetails;

  /// No description provided for @propertyAvailability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get propertyAvailability;

  /// No description provided for @propertyAmenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get propertyAmenities;

  /// No description provided for @propertyMortgageCalculator.
  ///
  /// In en, this message translates to:
  /// **'Mortgage calculator'**
  String get propertyMortgageCalculator;

  /// No description provided for @propertyRentCalculator.
  ///
  /// In en, this message translates to:
  /// **'Rent calculator'**
  String get propertyRentCalculator;

  /// No description provided for @propertyEstimateRepayment.
  ///
  /// In en, this message translates to:
  /// **'Estimate your monthly repayment'**
  String get propertyEstimateRepayment;

  /// No description provided for @propertyEstimateMoveInCost.
  ///
  /// In en, this message translates to:
  /// **'Estimate your move-in cost'**
  String get propertyEstimateMoveInCost;

  /// No description provided for @propertySqFt.
  ///
  /// In en, this message translates to:
  /// **'Sq ft'**
  String get propertySqFt;

  /// No description provided for @propertyArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get propertyArea;

  /// No description provided for @propertyFloor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get propertyFloor;

  /// No description provided for @propertyServiceCharge.
  ///
  /// In en, this message translates to:
  /// **'Service charge'**
  String get propertyServiceCharge;

  /// No description provided for @propertyAdvance.
  ///
  /// In en, this message translates to:
  /// **'Advance'**
  String get propertyAdvance;

  /// No description provided for @propertyMonthsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} month(s)'**
  String propertyMonthsCount(int count);

  /// No description provided for @propertyAway.
  ///
  /// In en, this message translates to:
  /// **'{distance} away'**
  String propertyAway(String distance);

  /// No description provided for @propertyAvailabilityUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Availability unavailable.'**
  String get propertyAvailabilityUnavailable;

  /// No description provided for @propertyNoAvailabilityYet.
  ///
  /// In en, this message translates to:
  /// **'No availability published yet.'**
  String get propertyNoAvailabilityYet;

  /// No description provided for @propertyServicesNearby.
  ///
  /// In en, this message translates to:
  /// **'Services nearby'**
  String get propertyServicesNearby;

  /// No description provided for @propertyTechnicianFallback.
  ///
  /// In en, this message translates to:
  /// **'Technician'**
  String get propertyTechnicianFallback;

  /// No description provided for @propertySimilarProperties.
  ///
  /// In en, this message translates to:
  /// **'Similar properties'**
  String get propertySimilarProperties;

  /// No description provided for @propertyListedBy.
  ///
  /// In en, this message translates to:
  /// **'Listed by'**
  String get propertyListedBy;

  /// No description provided for @propertyLogInToMessageOwner.
  ///
  /// In en, this message translates to:
  /// **'Log in to message the owner.'**
  String get propertyLogInToMessageOwner;

  /// No description provided for @propertyContactNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Contact not available for this listing.'**
  String get propertyContactNotAvailable;

  /// No description provided for @propertyContactOwner.
  ///
  /// In en, this message translates to:
  /// **'Contact owner'**
  String get propertyContactOwner;

  /// No description provided for @propertyVisitRequested.
  ///
  /// In en, this message translates to:
  /// **'Visit requested'**
  String get propertyVisitRequested;

  /// No description provided for @propertyBookingRequested.
  ///
  /// In en, this message translates to:
  /// **'Booking requested'**
  String get propertyBookingRequested;

  /// No description provided for @propertyPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get propertyPriceLabel;

  /// No description provided for @propertyPricePerPeriod.
  ///
  /// In en, this message translates to:
  /// **'Price / {period}'**
  String propertyPricePerPeriod(String period);

  /// No description provided for @propertyBookNow.
  ///
  /// In en, this message translates to:
  /// **'Book now'**
  String get propertyBookNow;

  /// No description provided for @propertyScheduleVisit.
  ///
  /// In en, this message translates to:
  /// **'Schedule visit'**
  String get propertyScheduleVisit;

  /// No description provided for @propertyCouldNotLoadReviews.
  ///
  /// In en, this message translates to:
  /// **'Could not load reviews.'**
  String get propertyCouldNotLoadReviews;

  /// No description provided for @propertyNoReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet. Be the first to review.'**
  String get propertyNoReviewsYet;

  /// No description provided for @propertyLogInToWriteReview.
  ///
  /// In en, this message translates to:
  /// **'Log in to write a review.'**
  String get propertyLogInToWriteReview;

  /// No description provided for @propertyReviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Review submitted'**
  String get propertyReviewSubmitted;

  /// No description provided for @propertyReportThisReview.
  ///
  /// In en, this message translates to:
  /// **'Report this review'**
  String get propertyReportThisReview;

  /// No description provided for @propertyReviewReported.
  ///
  /// In en, this message translates to:
  /// **'Review reported'**
  String get propertyReviewReported;

  /// No description provided for @propertyGuestFallback.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get propertyGuestFallback;

  /// No description provided for @propertyReportListing.
  ///
  /// In en, this message translates to:
  /// **'Report listing'**
  String get propertyReportListing;

  /// No description provided for @propertyBlockOwner.
  ///
  /// In en, this message translates to:
  /// **'Block owner'**
  String get propertyBlockOwner;

  /// No description provided for @propertyReportSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Report submitted'**
  String get propertyReportSubmitted;

  /// No description provided for @propertyOwnerBlocked.
  ///
  /// In en, this message translates to:
  /// **'Owner blocked'**
  String get propertyOwnerBlocked;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @rentManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Rent Management'**
  String get rentManagementTitle;

  /// No description provided for @rentUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get rentUnits;

  /// No description provided for @rentTenancies.
  ///
  /// In en, this message translates to:
  /// **'Tenancies'**
  String get rentTenancies;

  /// No description provided for @rentPayments.
  ///
  /// In en, this message translates to:
  /// **'Rent Payments'**
  String get rentPayments;

  /// No description provided for @rentLedger.
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get rentLedger;

  /// No description provided for @rentAgreements.
  ///
  /// In en, this message translates to:
  /// **'Agreements'**
  String get rentAgreements;

  /// No description provided for @rentCouldNotLoadSummary.
  ///
  /// In en, this message translates to:
  /// **'Could not load summary'**
  String get rentCouldNotLoadSummary;

  /// No description provided for @rentIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get rentIncome;

  /// No description provided for @rentExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get rentExpenses;

  /// No description provided for @rentNet.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get rentNet;

  /// No description provided for @rentSignInToManage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage rent'**
  String get rentSignInToManage;

  /// No description provided for @rentLogInToTrack.
  ///
  /// In en, this message translates to:
  /// **'Log in to track units, tenancies and payments.'**
  String get rentLogInToTrack;

  /// No description provided for @rentAddUnit.
  ///
  /// In en, this message translates to:
  /// **'Add unit'**
  String get rentAddUnit;

  /// No description provided for @rentDeleteUnit.
  ///
  /// In en, this message translates to:
  /// **'Delete unit'**
  String get rentDeleteUnit;

  /// No description provided for @rentNoUnitsYet.
  ///
  /// In en, this message translates to:
  /// **'No units yet'**
  String get rentNoUnitsYet;

  /// No description provided for @rentAddUnitDesc.
  ///
  /// In en, this message translates to:
  /// **'Add a unit to start tracking rent.'**
  String get rentAddUnitDesc;

  /// No description provided for @rentFloorValue.
  ///
  /// In en, this message translates to:
  /// **'Floor {floor}'**
  String rentFloorValue(String floor);

  /// No description provided for @rentPerMonth.
  ///
  /// In en, this message translates to:
  /// **'/mo'**
  String get rentPerMonth;

  /// No description provided for @rentUnitDeleted.
  ///
  /// In en, this message translates to:
  /// **'Unit deleted'**
  String get rentUnitDeleted;

  /// No description provided for @rentListingIdHint.
  ///
  /// In en, this message translates to:
  /// **'Your property\'s listing ID'**
  String get rentListingIdHint;

  /// No description provided for @rentUnitNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Apartment 2B'**
  String get rentUnitNameHint;

  /// No description provided for @rentFloorHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2'**
  String get rentFloorHint;

  /// No description provided for @rentRentAmount.
  ///
  /// In en, this message translates to:
  /// **'Rent amount'**
  String get rentRentAmount;

  /// No description provided for @rentMonthlyRentHint.
  ///
  /// In en, this message translates to:
  /// **'Monthly rent'**
  String get rentMonthlyRentHint;

  /// No description provided for @rentOptionalNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Optional notes'**
  String get rentOptionalNotesHint;

  /// No description provided for @rentUnitAdded.
  ///
  /// In en, this message translates to:
  /// **'Unit added'**
  String get rentUnitAdded;

  /// No description provided for @rentEnterUnitName.
  ///
  /// In en, this message translates to:
  /// **'Enter a unit name'**
  String get rentEnterUnitName;

  /// No description provided for @rentAddTenancy.
  ///
  /// In en, this message translates to:
  /// **'Add tenancy'**
  String get rentAddTenancy;

  /// No description provided for @rentNoTenanciesYet.
  ///
  /// In en, this message translates to:
  /// **'No tenancies yet'**
  String get rentNoTenanciesYet;

  /// No description provided for @rentAddTenancyDesc.
  ///
  /// In en, this message translates to:
  /// **'Add a tenancy to track a tenant and their rent.'**
  String get rentAddTenancyDesc;

  /// No description provided for @rentTenancyFallback.
  ///
  /// In en, this message translates to:
  /// **'Tenancy #{id}'**
  String rentTenancyFallback(int id);

  /// No description provided for @rentOngoing.
  ///
  /// In en, this message translates to:
  /// **'ongoing'**
  String get rentOngoing;

  /// No description provided for @rentTenantName.
  ///
  /// In en, this message translates to:
  /// **'Tenant name'**
  String get rentTenantName;

  /// No description provided for @rentTenantPhone.
  ///
  /// In en, this message translates to:
  /// **'Tenant phone'**
  String get rentTenantPhone;

  /// No description provided for @rentDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get rentDeposit;

  /// No description provided for @rentDueDayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Due day of month'**
  String get rentDueDayOfMonth;

  /// No description provided for @rentDueDayHint.
  ///
  /// In en, this message translates to:
  /// **'1–31'**
  String get rentDueDayHint;

  /// No description provided for @rentStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get rentStartDate;

  /// No description provided for @rentSelectStartDate.
  ///
  /// In en, this message translates to:
  /// **'Select start date'**
  String get rentSelectStartDate;

  /// No description provided for @rentTenancyAdded.
  ///
  /// In en, this message translates to:
  /// **'Tenancy added'**
  String get rentTenancyAdded;

  /// No description provided for @rentEnterTenantName.
  ///
  /// In en, this message translates to:
  /// **'Enter a tenant name'**
  String get rentEnterTenantName;

  /// No description provided for @rentEnterRentAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a rent amount'**
  String get rentEnterRentAmount;

  /// No description provided for @rentPickStartDate.
  ///
  /// In en, this message translates to:
  /// **'Pick a start date'**
  String get rentPickStartDate;

  /// No description provided for @rentNoPaymentsYet.
  ///
  /// In en, this message translates to:
  /// **'No rent payments yet'**
  String get rentNoPaymentsYet;

  /// No description provided for @rentPaymentsEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Payments appear here once tenancies are active.'**
  String get rentPaymentsEmptyDesc;

  /// No description provided for @rentDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String rentDueDate(String date);

  /// No description provided for @rentMarkPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark paid'**
  String get rentMarkPaid;

  /// No description provided for @rentMarkedAsPaid.
  ///
  /// In en, this message translates to:
  /// **'Marked as paid'**
  String get rentMarkedAsPaid;

  /// No description provided for @rentAddEntry.
  ///
  /// In en, this message translates to:
  /// **'Add entry'**
  String get rentAddEntry;

  /// No description provided for @rentNoLedgerEntriesYet.
  ///
  /// In en, this message translates to:
  /// **'No ledger entries yet'**
  String get rentNoLedgerEntriesYet;

  /// No description provided for @rentLedgerEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Add income or expenses to track your net.'**
  String get rentLedgerEmptyDesc;

  /// No description provided for @rentIncomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get rentIncomeLabel;

  /// No description provided for @rentExpenseLabel.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get rentExpenseLabel;

  /// No description provided for @rentAddLedgerEntry.
  ///
  /// In en, this message translates to:
  /// **'Add ledger entry'**
  String get rentAddLedgerEntry;

  /// No description provided for @rentCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get rentCategory;

  /// No description provided for @rentCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Rent, Maintenance'**
  String get rentCategoryHint;

  /// No description provided for @rentListingIdOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'Optional — your property\'s listing ID'**
  String get rentListingIdOptionalHint;

  /// No description provided for @rentEnterCategory.
  ///
  /// In en, this message translates to:
  /// **'Enter a category'**
  String get rentEnterCategory;

  /// No description provided for @rentEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get rentEnterAmount;

  /// No description provided for @rentEntryAdded.
  ///
  /// In en, this message translates to:
  /// **'Entry added'**
  String get rentEntryAdded;

  /// No description provided for @rentTemplates.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get rentTemplates;

  /// No description provided for @rentGenerateAgreement.
  ///
  /// In en, this message translates to:
  /// **'Generate agreement'**
  String get rentGenerateAgreement;

  /// No description provided for @rentNoAgreementsYet.
  ///
  /// In en, this message translates to:
  /// **'No agreements yet'**
  String get rentNoAgreementsYet;

  /// No description provided for @rentAgreementsEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate one from a tenancy and template.'**
  String get rentAgreementsEmptyDesc;

  /// No description provided for @rentAgreementFallback.
  ///
  /// In en, this message translates to:
  /// **'Agreement #{id}'**
  String rentAgreementFallback(int id);

  /// No description provided for @rentAgreementTemplates.
  ///
  /// In en, this message translates to:
  /// **'Agreement templates'**
  String get rentAgreementTemplates;

  /// No description provided for @rentNoTemplatesYet.
  ///
  /// In en, this message translates to:
  /// **'No templates yet. Create your first one below.'**
  String get rentNoTemplatesYet;

  /// No description provided for @rentDeleteTemplate.
  ///
  /// In en, this message translates to:
  /// **'Delete template'**
  String get rentDeleteTemplate;

  /// No description provided for @rentNewTemplate.
  ///
  /// In en, this message translates to:
  /// **'New template'**
  String get rentNewTemplate;

  /// No description provided for @rentTemplateNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Standard 12-month lease'**
  String get rentTemplateNameHint;

  /// No description provided for @rentBody.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get rentBody;

  /// No description provided for @rentTemplateBodyHint.
  ///
  /// In en, this message translates to:
  /// **'The agreement text'**
  String get rentTemplateBodyHint;

  /// No description provided for @rentIsDefault.
  ///
  /// In en, this message translates to:
  /// **'Is default'**
  String get rentIsDefault;

  /// No description provided for @rentCreateTemplate.
  ///
  /// In en, this message translates to:
  /// **'Create template'**
  String get rentCreateTemplate;

  /// No description provided for @rentDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get rentDefault;

  /// No description provided for @rentEnterTemplateName.
  ///
  /// In en, this message translates to:
  /// **'Enter a template name'**
  String get rentEnterTemplateName;

  /// No description provided for @rentEnterTemplateBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the template body'**
  String get rentEnterTemplateBody;

  /// No description provided for @rentTemplateCreated.
  ///
  /// In en, this message translates to:
  /// **'Template created'**
  String get rentTemplateCreated;

  /// No description provided for @rentTemplateDeleted.
  ///
  /// In en, this message translates to:
  /// **'Template deleted'**
  String get rentTemplateDeleted;

  /// No description provided for @rentChooseTenancy.
  ///
  /// In en, this message translates to:
  /// **'Choose a tenancy'**
  String get rentChooseTenancy;

  /// No description provided for @rentChooseTemplate.
  ///
  /// In en, this message translates to:
  /// **'Choose a template'**
  String get rentChooseTemplate;

  /// No description provided for @rentAgreementGenerated.
  ///
  /// In en, this message translates to:
  /// **'Agreement generated'**
  String get rentAgreementGenerated;

  /// No description provided for @rentTenancyLabel.
  ///
  /// In en, this message translates to:
  /// **'Tenancy'**
  String get rentTenancyLabel;

  /// No description provided for @rentTemplateLabel.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get rentTemplateLabel;

  /// No description provided for @savedSearchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved Searches'**
  String get savedSearchesTitle;

  /// No description provided for @savedSearchesNone.
  ///
  /// In en, this message translates to:
  /// **'No saved searches'**
  String get savedSearchesNone;

  /// No description provided for @savedSearchesEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Save a search to get notified about new matches.'**
  String get savedSearchesEmptyDesc;

  /// No description provided for @savedSearchesMatchAlerts.
  ///
  /// In en, this message translates to:
  /// **'Match alerts'**
  String get savedSearchesMatchAlerts;

  /// No description provided for @savedSearchesSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in for saved searches'**
  String get savedSearchesSignInTitle;

  /// No description provided for @savedSearchesLogInDesc.
  ///
  /// In en, this message translates to:
  /// **'Log in to save searches and get match alerts.'**
  String get savedSearchesLogInDesc;

  /// No description provided for @helpContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Contact'**
  String get helpContactTitle;

  /// No description provided for @supportCouldNotOpen.
  ///
  /// In en, this message translates to:
  /// **'Could not open {scheme}'**
  String supportCouldNotOpen(String scheme);

  /// No description provided for @supportGetInTouch.
  ///
  /// In en, this message translates to:
  /// **'Get in touch'**
  String get supportGetInTouch;

  /// No description provided for @supportRespondDesc.
  ///
  /// In en, this message translates to:
  /// **'We usually respond within one business day.'**
  String get supportRespondDesc;

  /// No description provided for @supportEmailUs.
  ///
  /// In en, this message translates to:
  /// **'Email us'**
  String get supportEmailUs;

  /// No description provided for @supportCallUs.
  ///
  /// In en, this message translates to:
  /// **'Call us'**
  String get supportCallUs;

  /// No description provided for @supportVisitUs.
  ///
  /// In en, this message translates to:
  /// **'Visit us'**
  String get supportVisitUs;

  /// No description provided for @supportSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send us a message'**
  String get supportSendMessage;

  /// No description provided for @supportYourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get supportYourName;

  /// No description provided for @supportSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get supportSubject;

  /// No description provided for @supportMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get supportMessage;

  /// No description provided for @supportSendMessageBtn.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get supportSendMessageBtn;

  /// No description provided for @supportThanksMessage.
  ///
  /// In en, this message translates to:
  /// **'Thanks for reaching out. We\'ll get back to you shortly.'**
  String get supportThanksMessage;

  /// No description provided for @supportCouldNotSend.
  ///
  /// In en, this message translates to:
  /// **'Could not send your message. Please try again.'**
  String get supportCouldNotSend;

  /// No description provided for @supportFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get supportFaqTitle;

  /// No description provided for @supportLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated {date}'**
  String supportLastUpdated(String date);

  /// No description provided for @supportCouldntLoadPage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this page.'**
  String get supportCouldntLoadPage;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @skills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skills;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @technicianFindTitle.
  ///
  /// In en, this message translates to:
  /// **'Find a Technician'**
  String get technicianFindTitle;

  /// No description provided for @technicianNoneFound.
  ///
  /// In en, this message translates to:
  /// **'No technicians found'**
  String get technicianNoneFound;

  /// No description provided for @technicianFallback.
  ///
  /// In en, this message translates to:
  /// **'Technician #{id}'**
  String technicianFallback(int id);

  /// No description provided for @technicianPerHour.
  ///
  /// In en, this message translates to:
  /// **'/hr'**
  String get technicianPerHour;

  /// No description provided for @technicianAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get technicianAvailable;

  /// No description provided for @technicianBusy.
  ///
  /// In en, this message translates to:
  /// **'Busy'**
  String get technicianBusy;

  /// No description provided for @technicianRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get technicianRating;

  /// No description provided for @technicianJobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get technicianJobs;

  /// No description provided for @technicianYrsExp.
  ///
  /// In en, this message translates to:
  /// **'Yrs exp'**
  String get technicianYrsExp;

  /// No description provided for @technicianLogInToRequest.
  ///
  /// In en, this message translates to:
  /// **'Log in to request a service.'**
  String get technicianLogInToRequest;

  /// No description provided for @technicianRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Request sent'**
  String get technicianRequestSent;

  /// No description provided for @technicianRequestService.
  ///
  /// In en, this message translates to:
  /// **'Request service'**
  String get technicianRequestService;

  /// No description provided for @technicianProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'My Technician Profile'**
  String get technicianProfileTitle;

  /// No description provided for @technicianProfileDetails.
  ///
  /// In en, this message translates to:
  /// **'Profile details'**
  String get technicianProfileDetails;

  /// No description provided for @technicianKeepCurrentDesc.
  ///
  /// In en, this message translates to:
  /// **'Keep your details current so customers know what you offer.'**
  String get technicianKeepCurrentDesc;

  /// No description provided for @technicianBioHint.
  ///
  /// In en, this message translates to:
  /// **'A short intro about your experience'**
  String get technicianBioHint;

  /// No description provided for @technicianSkillsHint.
  ///
  /// In en, this message translates to:
  /// **'Comma separated, e.g. Plumbing, Wiring'**
  String get technicianSkillsHint;

  /// No description provided for @technicianExperienceYears.
  ///
  /// In en, this message translates to:
  /// **'Experience (years)'**
  String get technicianExperienceYears;

  /// No description provided for @technicianExperienceHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5'**
  String get technicianExperienceHint;

  /// No description provided for @technicianHourlyRate.
  ///
  /// In en, this message translates to:
  /// **'Hourly rate'**
  String get technicianHourlyRate;

  /// No description provided for @technicianRateHint.
  ///
  /// In en, this message translates to:
  /// **'Your rate per hour'**
  String get technicianRateHint;

  /// No description provided for @technicianAvailableForWork.
  ///
  /// In en, this message translates to:
  /// **'Available for work'**
  String get technicianAvailableForWork;

  /// No description provided for @technicianPauseDesc.
  ///
  /// In en, this message translates to:
  /// **'Turn this off to pause new requests.'**
  String get technicianPauseDesc;

  /// No description provided for @technicianSignInToManage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your profile'**
  String get technicianSignInToManage;

  /// No description provided for @technicianLogInToUpdate.
  ///
  /// In en, this message translates to:
  /// **'Log in to update your technician details.'**
  String get technicianLogInToUpdate;

  /// No description provided for @technicianChooseCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose a category'**
  String get technicianChooseCategory;

  /// No description provided for @technicianApplicationSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Application submitted — we\'ll review it shortly'**
  String get technicianApplicationSubmitted;

  /// No description provided for @technicianBecomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Become a Technician'**
  String get technicianBecomeTitle;

  /// No description provided for @technicianTellUsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your work'**
  String get technicianTellUsTitle;

  /// No description provided for @technicianReviewDesc.
  ///
  /// In en, this message translates to:
  /// **'We review every application before your profile goes live.'**
  String get technicianReviewDesc;

  /// No description provided for @technicianSubmitApplication.
  ///
  /// In en, this message translates to:
  /// **'Submit application'**
  String get technicianSubmitApplication;

  /// No description provided for @technicianSignInToApply.
  ///
  /// In en, this message translates to:
  /// **'Sign in to apply'**
  String get technicianSignInToApply;

  /// No description provided for @technicianLogInToApply.
  ///
  /// In en, this message translates to:
  /// **'Log in to send us your technician application.'**
  String get technicianLogInToApply;

  /// No description provided for @technicianServiceBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Bookings'**
  String get technicianServiceBookingsTitle;

  /// No description provided for @technicianNoServiceBookings.
  ///
  /// In en, this message translates to:
  /// **'No service bookings'**
  String get technicianNoServiceBookings;

  /// No description provided for @technicianBookTechDesc.
  ///
  /// In en, this message translates to:
  /// **'Book a technician to see requests here.'**
  String get technicianBookTechDesc;

  /// No description provided for @technicianQuotes.
  ///
  /// In en, this message translates to:
  /// **'Quotes'**
  String get technicianQuotes;

  /// No description provided for @technicianSubmitQuote.
  ///
  /// In en, this message translates to:
  /// **'Submit a quote'**
  String get technicianSubmitQuote;

  /// No description provided for @technicianSignInToSeeBookings.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your service bookings'**
  String get technicianSignInToSeeBookings;

  /// No description provided for @technicianLogInToBookTrack.
  ///
  /// In en, this message translates to:
  /// **'Log in to book technicians and track requests.'**
  String get technicianLogInToBookTrack;

  /// No description provided for @visitsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Visits'**
  String get visitsTitle;

  /// No description provided for @visitsNoneScheduled.
  ///
  /// In en, this message translates to:
  /// **'No visits scheduled'**
  String get visitsNoneScheduled;

  /// No description provided for @visitsBookViewingDesc.
  ///
  /// In en, this message translates to:
  /// **'Book a viewing from any listing.'**
  String get visitsBookViewingDesc;

  /// No description provided for @visitsPropertyFallback.
  ///
  /// In en, this message translates to:
  /// **'Property #{id}'**
  String visitsPropertyFallback(int id);

  /// No description provided for @visitsSignInToSeeVisits.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your visits'**
  String get visitsSignInToSeeVisits;

  /// No description provided for @visitsLogInToSchedule.
  ///
  /// In en, this message translates to:
  /// **'Log in to schedule and track property viewings.'**
  String get visitsLogInToSchedule;

  /// No description provided for @walletBrandLabel.
  ///
  /// In en, this message translates to:
  /// **'RENTDO WALLET'**
  String get walletBrandLabel;

  /// No description provided for @walletAvailableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available balance'**
  String get walletAvailableBalance;

  /// No description provided for @walletUnableToLoad.
  ///
  /// In en, this message translates to:
  /// **'Unable to load balance'**
  String get walletUnableToLoad;

  /// No description provided for @walletTopUpComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Card top-up is coming soon'**
  String get walletTopUpComingSoon;

  /// No description provided for @walletTopUp.
  ///
  /// In en, this message translates to:
  /// **'Top up'**
  String get walletTopUp;

  /// No description provided for @walletTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get walletTransactions;

  /// No description provided for @walletNoTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get walletNoTransactionsYet;

  /// No description provided for @walletSignInToView.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view your wallet'**
  String get walletSignInToView;

  /// No description provided for @walletLogInToSeeBalance.
  ///
  /// In en, this message translates to:
  /// **'Log in to see your balance and transactions.'**
  String get walletLogInToSeeBalance;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @any.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get any;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTime;

  /// No description provided for @clearDate.
  ///
  /// In en, this message translates to:
  /// **'Clear date'**
  String get clearDate;

  /// No description provided for @bookNowSelectDatesError.
  ///
  /// In en, this message translates to:
  /// **'Select your check-in and check-out dates'**
  String get bookNowSelectDatesError;

  /// No description provided for @bookNowNightsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Some of those nights are unavailable'**
  String get bookNowNightsUnavailable;

  /// No description provided for @bookNowSelectDates.
  ///
  /// In en, this message translates to:
  /// **'Select dates'**
  String get bookNowSelectDates;

  /// No description provided for @bookNowTitle.
  ///
  /// In en, this message translates to:
  /// **'Book your stay'**
  String get bookNowTitle;

  /// No description provided for @bookNowAllAvailable.
  ///
  /// In en, this message translates to:
  /// **'All dates available in the next 60 days'**
  String get bookNowAllAvailable;

  /// No description provided for @bookNowSomeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'{count} date(s) unavailable — they are blocked'**
  String bookNowSomeUnavailable(int count);

  /// No description provided for @bookNowSpecialRequests.
  ///
  /// In en, this message translates to:
  /// **'Special requests (optional)'**
  String get bookNowSpecialRequests;

  /// No description provided for @bookNowSpecialRequestsHint.
  ///
  /// In en, this message translates to:
  /// **'Early check-in, extra bed…'**
  String get bookNowSpecialRequestsHint;

  /// No description provided for @bookNowRequestBooking.
  ///
  /// In en, this message translates to:
  /// **'Request booking'**
  String get bookNowRequestBooking;

  /// No description provided for @chatDefaultMessage.
  ///
  /// In en, this message translates to:
  /// **'Hi, I\'m interested in this property. Is it still available?'**
  String get chatDefaultMessage;

  /// No description provided for @chatWriteMessageFirst.
  ///
  /// In en, this message translates to:
  /// **'Write a message first'**
  String get chatWriteMessageFirst;

  /// No description provided for @chatMessageOwnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Message the owner'**
  String get chatMessageOwnerTitle;

  /// No description provided for @chatYourMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get chatYourMessageHint;

  /// No description provided for @reportDetailsOptional.
  ///
  /// In en, this message translates to:
  /// **'Details (optional)'**
  String get reportDetailsOptional;

  /// No description provided for @reportDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'Add any context for our team'**
  String get reportDetailsHint;

  /// No description provided for @reportSubmitReport.
  ///
  /// In en, this message translates to:
  /// **'Submit report'**
  String get reportSubmitReport;

  /// No description provided for @compareLogInToCompare.
  ///
  /// In en, this message translates to:
  /// **'Log in to compare properties.'**
  String get compareLogInToCompare;

  /// No description provided for @compareRemoveFromCompare.
  ///
  /// In en, this message translates to:
  /// **'Remove from compare'**
  String get compareRemoveFromCompare;

  /// No description provided for @compareAddToCompare.
  ///
  /// In en, this message translates to:
  /// **'Add to compare'**
  String get compareAddToCompare;

  /// No description provided for @compareAddedToCompare.
  ///
  /// In en, this message translates to:
  /// **'Added to compare'**
  String get compareAddedToCompare;

  /// No description provided for @compareRemovedFromCompare.
  ///
  /// In en, this message translates to:
  /// **'Removed from compare'**
  String get compareRemovedFromCompare;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome 👋'**
  String get homeWelcome;

  /// No description provided for @homeHiName.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name} 👋'**
  String homeHiName(String name);

  /// No description provided for @homeFindNextHome.
  ///
  /// In en, this message translates to:
  /// **'Find your next home'**
  String get homeFindNextHome;

  /// No description provided for @notificationsUnreadLabel.
  ///
  /// In en, this message translates to:
  /// **'Notifications, {count} unread'**
  String notificationsUnreadLabel(int count);

  /// No description provided for @favoriteLogInToSave.
  ///
  /// In en, this message translates to:
  /// **'Log in to save properties.'**
  String get favoriteLogInToSave;

  /// No description provided for @favoriteRemoveFromSaved.
  ///
  /// In en, this message translates to:
  /// **'Remove from saved'**
  String get favoriteRemoveFromSaved;

  /// No description provided for @favoriteSaveProperty.
  ///
  /// In en, this message translates to:
  /// **'Save property'**
  String get favoriteSaveProperty;

  /// No description provided for @reviewTapStarToRate.
  ///
  /// In en, this message translates to:
  /// **'Tap a star to rate'**
  String get reviewTapStarToRate;

  /// No description provided for @reviewWriteTitle.
  ///
  /// In en, this message translates to:
  /// **'Write a review'**
  String get reviewWriteTitle;

  /// No description provided for @reviewYourReviewOptional.
  ///
  /// In en, this message translates to:
  /// **'Your review (optional)'**
  String get reviewYourReviewOptional;

  /// No description provided for @reviewShareDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'Share details of your experience'**
  String get reviewShareDetailsHint;

  /// No description provided for @reviewSubmitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit review'**
  String get reviewSubmitReview;

  /// No description provided for @technicianDescribeJobAddress.
  ///
  /// In en, this message translates to:
  /// **'Describe the job and enter an address'**
  String get technicianDescribeJobAddress;

  /// No description provided for @technicianPickDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Pick a date and time'**
  String get technicianPickDateAndTime;

  /// No description provided for @technicianChooseFutureTime.
  ///
  /// In en, this message translates to:
  /// **'Choose a future time'**
  String get technicianChooseFutureTime;

  /// No description provided for @technicianSelectDateTime.
  ///
  /// In en, this message translates to:
  /// **'Select date & time'**
  String get technicianSelectDateTime;

  /// No description provided for @technicianRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Request a technician'**
  String get technicianRequestTitle;

  /// No description provided for @technicianWhatNeedDone.
  ///
  /// In en, this message translates to:
  /// **'What do you need done?'**
  String get technicianWhatNeedDone;

  /// No description provided for @technicianDescribeJobHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the job'**
  String get technicianDescribeJobHint;

  /// No description provided for @technicianServiceAddress.
  ///
  /// In en, this message translates to:
  /// **'Service address'**
  String get technicianServiceAddress;

  /// No description provided for @technicianWhereComeHint.
  ///
  /// In en, this message translates to:
  /// **'Where should they come?'**
  String get technicianWhereComeHint;

  /// No description provided for @technicianMarkUrgent.
  ///
  /// In en, this message translates to:
  /// **'Mark as urgent'**
  String get technicianMarkUrgent;

  /// No description provided for @technicianSendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get technicianSendRequest;

  /// No description provided for @quoteEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get quoteEnterValidAmount;

  /// No description provided for @quoteValidUntilOptional.
  ///
  /// In en, this message translates to:
  /// **'Valid until (optional)'**
  String get quoteValidUntilOptional;

  /// No description provided for @quoteValidUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until {date}'**
  String quoteValidUntil(String date);

  /// No description provided for @quoteSubmitTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit a quote'**
  String get quoteSubmitTitle;

  /// No description provided for @quoteAmountHint.
  ///
  /// In en, this message translates to:
  /// **'What will this job cost?'**
  String get quoteAmountHint;

  /// No description provided for @quoteDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'What\'s included in this quote?'**
  String get quoteDescriptionHint;

  /// No description provided for @quoteSendQuote.
  ///
  /// In en, this message translates to:
  /// **'Send quote'**
  String get quoteSendQuote;

  /// No description provided for @visitScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule a visit'**
  String get visitScheduleTitle;

  /// No description provided for @visitNoteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get visitNoteOptional;

  /// No description provided for @visitNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Anything the owner should know'**
  String get visitNoteHint;

  /// No description provided for @visitRequestVisit.
  ///
  /// In en, this message translates to:
  /// **'Request visit'**
  String get visitRequestVisit;

  /// No description provided for @affordEstimateRepayment.
  ///
  /// In en, this message translates to:
  /// **'Estimate your monthly repayment.'**
  String get affordEstimateRepayment;

  /// No description provided for @affordEstimateMoveIn.
  ///
  /// In en, this message translates to:
  /// **'Estimate your move-in cost and income guideline.'**
  String get affordEstimateMoveIn;

  /// No description provided for @affordPropertyPrice.
  ///
  /// In en, this message translates to:
  /// **'Property price'**
  String get affordPropertyPrice;

  /// No description provided for @affordMonthlyRent.
  ///
  /// In en, this message translates to:
  /// **'Monthly rent'**
  String get affordMonthlyRent;

  /// No description provided for @affordDownPayment.
  ///
  /// In en, this message translates to:
  /// **'Down payment'**
  String get affordDownPayment;

  /// No description provided for @affordInterestRate.
  ///
  /// In en, this message translates to:
  /// **'Interest rate'**
  String get affordInterestRate;

  /// No description provided for @affordLoanTenure.
  ///
  /// In en, this message translates to:
  /// **'Loan tenure'**
  String get affordLoanTenure;

  /// No description provided for @affordYr.
  ///
  /// In en, this message translates to:
  /// **'yr'**
  String get affordYr;

  /// No description provided for @affordMonthlyPayment.
  ///
  /// In en, this message translates to:
  /// **'Monthly payment'**
  String get affordMonthlyPayment;

  /// No description provided for @affordLoanAmount.
  ///
  /// In en, this message translates to:
  /// **'Loan amount'**
  String get affordLoanAmount;

  /// No description provided for @affordTotalInterest.
  ///
  /// In en, this message translates to:
  /// **'Total interest'**
  String get affordTotalInterest;

  /// No description provided for @affordTotalPayable.
  ///
  /// In en, this message translates to:
  /// **'Total payable'**
  String get affordTotalPayable;

  /// No description provided for @affordAdvanceDeposit.
  ///
  /// In en, this message translates to:
  /// **'Advance / deposit'**
  String get affordAdvanceDeposit;

  /// No description provided for @affordMonthSingular.
  ///
  /// In en, this message translates to:
  /// **'1 month'**
  String get affordMonthSingular;

  /// No description provided for @affordMonthsPlural.
  ///
  /// In en, this message translates to:
  /// **'{count} months'**
  String affordMonthsPlural(int count);

  /// No description provided for @affordMoveInCost.
  ///
  /// In en, this message translates to:
  /// **'Move-in cost'**
  String get affordMoveInCost;

  /// No description provided for @affordDepositMo.
  ///
  /// In en, this message translates to:
  /// **'Deposit ({months} mo)'**
  String affordDepositMo(int months);

  /// No description provided for @affordFirstMonthRent.
  ///
  /// In en, this message translates to:
  /// **'First month rent'**
  String get affordFirstMonthRent;

  /// No description provided for @affordSuggestedIncome.
  ///
  /// In en, this message translates to:
  /// **'Suggested income /mo'**
  String get affordSuggestedIncome;

  /// No description provided for @affordEstimatesDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Estimates only. Actual figures may vary.'**
  String get affordEstimatesDisclaimer;

  /// No description provided for @filtersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersTitle;

  /// No description provided for @filterPropertyType.
  ///
  /// In en, this message translates to:
  /// **'Property type'**
  String get filterPropertyType;

  /// No description provided for @filterAnyLocation.
  ///
  /// In en, this message translates to:
  /// **'Any location'**
  String get filterAnyLocation;

  /// No description provided for @filterPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Price range'**
  String get filterPriceRange;

  /// No description provided for @filterVerifiedOnly.
  ///
  /// In en, this message translates to:
  /// **'Verified listings only'**
  String get filterVerifiedOnly;

  /// No description provided for @filterFeaturedOnly.
  ///
  /// In en, this message translates to:
  /// **'Featured only'**
  String get filterFeaturedOnly;

  /// No description provided for @filterSortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get filterSortBy;

  /// No description provided for @filterShowResults.
  ///
  /// In en, this message translates to:
  /// **'Show results'**
  String get filterShowResults;

  /// No description provided for @mapViewMap.
  ///
  /// In en, this message translates to:
  /// **'View map'**
  String get mapViewMap;

  /// No description provided for @mapLocationFallback.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get mapLocationFallback;

  /// No description provided for @zoneSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search countries or cities'**
  String get zoneSearchHint;

  /// No description provided for @zoneNoLocationsFound.
  ///
  /// In en, this message translates to:
  /// **'No locations found'**
  String get zoneNoLocationsFound;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @featured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featured;

  /// No description provided for @newLabel.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newLabel;

  /// No description provided for @searchLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Search location, property...'**
  String get searchLocationHint;

  /// No description provided for @searchCountryHint.
  ///
  /// In en, this message translates to:
  /// **'Search country or code'**
  String get searchCountryHint;

  /// No description provided for @noCountriesFound.
  ///
  /// In en, this message translates to:
  /// **'No countries found'**
  String get noCountriesFound;

  /// No description provided for @savedNoProperties.
  ///
  /// In en, this message translates to:
  /// **'No saved properties'**
  String get savedNoProperties;

  /// No description provided for @savedTapHeartDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on any listing to save it here.'**
  String get savedTapHeartDesc;

  /// No description provided for @savedSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your saved homes'**
  String get savedSignInTitle;

  /// No description provided for @savedSignInDesc.
  ///
  /// In en, this message translates to:
  /// **'Save properties you love and find them here.'**
  String get savedSignInDesc;

  /// No description provided for @authContinueLoginDesc.
  ///
  /// In en, this message translates to:
  /// **'Log in to continue exploring properties.'**
  String get authContinueLoginDesc;

  /// No description provided for @authJoinRentdoDesc.
  ///
  /// In en, this message translates to:
  /// **'Join Rentdo to save favorites and contact agents.'**
  String get authJoinRentdoDesc;

  /// No description provided for @authFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Jane Doe'**
  String get authFullNameHint;

  /// No description provided for @authEnterCodeDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter the code we sent to your phone.'**
  String get authEnterCodeDesc;

  /// No description provided for @authVerifyingPhone.
  ///
  /// In en, this message translates to:
  /// **'Verifying {phone}'**
  String authVerifyingPhone(String phone);

  /// No description provided for @notificationsSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see notifications'**
  String get notificationsSignInTitle;

  /// No description provided for @notificationsLogInDesc.
  ///
  /// In en, this message translates to:
  /// **'Log in to get updates on your visits and saved searches.'**
  String get notificationsLogInDesc;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsNoneYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationsNoneYet;

  /// No description provided for @notificationsWillNotify.
  ///
  /// In en, this message translates to:
  /// **'We\'ll let you know when something comes up.'**
  String get notificationsWillNotify;

  /// No description provided for @categoryForSale.
  ///
  /// In en, this message translates to:
  /// **'For Sale'**
  String get categoryForSale;

  /// No description provided for @categoryForRent.
  ///
  /// In en, this message translates to:
  /// **'For Rent'**
  String get categoryForRent;

  /// No description provided for @categoryShortStay.
  ///
  /// In en, this message translates to:
  /// **'Short Stay'**
  String get categoryShortStay;

  /// No description provided for @categoryLand.
  ///
  /// In en, this message translates to:
  /// **'Land'**
  String get categoryLand;

  /// No description provided for @categoryOffice.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get categoryOffice;

  /// No description provided for @categoryRooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get categoryRooms;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
