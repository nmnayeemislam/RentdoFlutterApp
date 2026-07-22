// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Rentdo';

  @override
  String get tagline =>
      'اعثر على العقار المناسب. في المكان المناسب. بالسعر المناسب.';

  @override
  String get heroSubtitle =>
      'اكتشف عقارات موثقة للإيجار أو البيع أو الاستثمار. يثق بنا الآلاف.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get noInternet =>
      'لا يوجد اتصال بالإنترنت. تحقق من الشبكة وحاول مرة أخرى.';

  @override
  String get noResults => 'لم يتم العثور على نتائج';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get explore => 'استكشف العقارات';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'إنشاء حساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get phone => 'الهاتف';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String get createAccount => 'أنشئ حسابك';

  @override
  String get usePhoneInstead => 'استخدم الهاتف بدلًا من ذلك';

  @override
  String get useEmailInstead => 'استخدم البريد الإلكتروني بدلًا من ذلك';

  @override
  String get sendOtp => 'إرسال رمز التحقق';

  @override
  String get resendOtp => 'إعادة إرسال رمز التحقق';

  @override
  String get verifyAndContinue => 'تحقق والمتابعة';

  @override
  String get continueAsGuest => 'المتابعة كضيف';

  @override
  String get otpCode => 'رمز التحقق';

  @override
  String get otpHint => 'رمز من 6 أرقام';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get forgotPasswordTitle => 'نسيت كلمة المرور';

  @override
  String get forgotPasswordSubtitle =>
      'أعد تعيين كلمة المرور عبر البريد الإلكتروني أو الهاتف.';

  @override
  String get newPassword => 'كلمة مرور جديدة';

  @override
  String get createAccountCta => 'إنشاء حساب';

  @override
  String get changeDetails => 'تغيير البيانات';

  @override
  String get checkEmailForReset =>
      'تحقق من بريدك الإلكتروني لرابط إعادة التعيين';

  @override
  String get passwordUpdated =>
      'تم تحديث كلمة المرور. يرجى تسجيل الدخول بكلمة المرور الجديدة.';

  @override
  String get home => 'الرئيسية';

  @override
  String get search => 'بحث';

  @override
  String get saved => 'المحفوظة';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get messages => 'الرسائل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get accountNotificationSettingsTitle => 'إعدادات الإشعارات';

  @override
  String get accountPreferencesSaved => 'تم حفظ التفضيلات';

  @override
  String get accountSaveChanges => 'حفظ التغييرات';

  @override
  String get accountSignInToManageNotifications =>
      'سجّل الدخول لإدارة الإشعارات';

  @override
  String get accountLogInToChooseContact =>
      'سجّل الدخول لاختيار كيف ومتى نتواصل معك.';

  @override
  String get accountPrivacyDataTitle => 'الخصوصية والبيانات';

  @override
  String get accountDeleteAccountTitle => 'حذف الحساب';

  @override
  String get accountDeleteAccountConfirm =>
      'سيتم جدولة حذف حسابك. هل تريد المتابعة؟';

  @override
  String get accountExportRequested => 'تم طلب التصدير';

  @override
  String get accountDeletionScheduled => 'تمت جدولة حذف الحساب';

  @override
  String accountDeletionScheduledOn(String date) {
    return 'تمت جدولة حذف الحساب في $date';
  }

  @override
  String get accountExportMyData => 'تصدير بياناتي';

  @override
  String get accountExportDataDesc =>
      'اطلب نسخة من بيانات حسابك والإعلانات والرسائل والحجوزات. سنجهز لك رابط تنزيل.';

  @override
  String get accountRequestExport => 'طلب التصدير';

  @override
  String get accountDeleteAccountDesc =>
      'حذف حسابك دائم. سيتم حذف إعلاناتك ورسائلك وحجوزاتك وعمليات البحث المحفوظة ولا يمكن استعادتها.';

  @override
  String get accountDeleteMyAccount => 'حذف حسابي';

  @override
  String get accountSignInToManageData => 'سجّل الدخول لإدارة بياناتك';

  @override
  String get accountLogInToExportOrDelete =>
      'سجّل الدخول لتصدير بياناتك أو حذف حسابك.';

  @override
  String get accountUsageLimitsTitle => 'الاستخدام والحدود';

  @override
  String get accountPlanFeatures => 'مزايا الخطة';

  @override
  String get accountNoPlanFeatures => 'لا توجد مزايا خطة لعرضها.';

  @override
  String get accountPostsUsed => 'المنشورات المستخدمة';

  @override
  String get accountUnlimited => 'غير محدود';

  @override
  String get accountRemainingSuffix => 'متبقي';

  @override
  String get accountSignInToSeeLimits => 'سجّل الدخول لعرض حدودك';

  @override
  String get accountLogInToTrackUsage =>
      'سجّل الدخول لتتبع استخدامك للنشر ومزايا خطتك.';

  @override
  String get accountOwnerVerificationTitle => 'توثيق المالك';

  @override
  String get accountDocumentSubmitted => 'تم إرسال المستند للمراجعة';

  @override
  String get accountUploadIdDesc =>
      'ارفع بطاقة هوية حكومية أو مستندًا تجاريًا للحصول على شارة التوثيق.';

  @override
  String get accountUploadDocument => 'رفع المستند';

  @override
  String get accountVerificationStatus => 'حالة التوثيق';

  @override
  String accountReviewedOn(String date) {
    return 'تمت المراجعة في $date';
  }

  @override
  String get accountSignInToGetVerified => 'سجّل الدخول للحصول على التوثيق';

  @override
  String get accountLogInToSubmitDocs =>
      'سجّل الدخول لإرسال مستنداتك والحصول على شارة التوثيق.';

  @override
  String get buy => 'شراء';

  @override
  String get skip => 'تخطي';

  @override
  String get apply => 'تطبيق';

  @override
  String get billingPostPackagesTitle => 'باقات النشر';

  @override
  String get billingNoPackagesAvailable => 'لا توجد باقات متاحة';

  @override
  String get billingCheckBackLaterPackages => 'تحقق لاحقًا من باقات النشر.';

  @override
  String get billingPackagePurchased => 'تم شراء الباقة';

  @override
  String billingPostsAndDays(int posts, int days) {
    return '$posts منشورات · $days أيام';
  }

  @override
  String get billingSignInToBuyPackages => 'سجّل الدخول لشراء الباقات';

  @override
  String get billingLogInToPurchasePackages => 'سجّل الدخول لشراء باقات النشر.';

  @override
  String get billingMembershipTitle => 'العضوية';

  @override
  String get billingSubscriptionCancelled => 'تم إلغاء الاشتراك';

  @override
  String get billingYourPlan => 'خطتك';

  @override
  String get billingCancelPlan => 'إلغاء الخطة';

  @override
  String get billingRenews => 'يتجدد';

  @override
  String get billingEnds => 'ينتهي';

  @override
  String billingPostsUsedOf(String used, String limit) {
    return 'المنشورات المستخدمة $used/$limit';
  }

  @override
  String get billingNoPlansAvailable => 'لا توجد خطط متاحة';

  @override
  String get billingCheckBackLaterPlans => 'تحقق لاحقًا من خيارات العضوية.';

  @override
  String get billingFree => 'مجاني';

  @override
  String billingPriceDuration(String price, int days) {
    return '$price / $days أيام';
  }

  @override
  String get billingHaveCoupon => 'هل لديك كوبون؟';

  @override
  String get billingCouponHint => 'رمز الكوبون (اختياري)';

  @override
  String get billingInvalidCoupon => 'كوبون غير صالح';

  @override
  String billingCouponAppliedSavings(String amount) {
    return 'تم تطبيق الكوبون - وفرت $amount';
  }

  @override
  String get billingCouponApplied => 'تم تطبيق الكوبون';

  @override
  String billingSubscribedTo(String plan) {
    return 'تم الاشتراك في $plan';
  }

  @override
  String get billingPopular => 'الأكثر شيوعًا';

  @override
  String billingListingsCount(String limit) {
    return '$limit إعلان';
  }

  @override
  String get billingCurrentPlan => 'الخطة الحالية';

  @override
  String get billingChooseFree => 'اختيار المجاني';

  @override
  String get billingSubscribe => 'اشتراك';

  @override
  String get billingSignInToViewMemberships => 'سجّل الدخول لعرض العضويات';

  @override
  String get billingLogInToSubscribe => 'سجّل الدخول للاشتراك في خطة عضوية.';

  @override
  String get all => 'الكل';

  @override
  String get blogTitle => 'المدونة';

  @override
  String get blogCouldntLoadPosts => 'تعذر تحميل المنشورات.';

  @override
  String get blogNoPostsYet => 'لا توجد منشورات بعد';

  @override
  String blogMinRead(int minutes) {
    return '$minutes دقائق قراءة';
  }

  @override
  String get blogArticleTitle => 'مقال';

  @override
  String get blogCouldntLoadArticle => 'تعذر تحميل هذا المقال.';

  @override
  String blogByAuthor(String author) {
    return 'بواسطة $author';
  }

  @override
  String get blogRelatedArticles => 'مقالات ذات صلة';

  @override
  String get browseProperties => 'تصفح العقارات';

  @override
  String get night => 'ليلة';

  @override
  String get nights => 'ليالٍ';

  @override
  String get guest => 'ضيف';

  @override
  String get guests => 'ضيوف';

  @override
  String get bookingsTitle => 'حجوزاتي';

  @override
  String get bookingsNoBookingsYet => 'لا توجد حجوزات بعد';

  @override
  String get bookingsBookStayDesc => 'احجز إقامة من إعلان فندقي.';

  @override
  String bookingsNumberFallback(int id) {
    return 'الحجز رقم $id';
  }

  @override
  String get bookingsSignInToSeeBookings => 'سجّل الدخول لعرض حجوزاتك';

  @override
  String get bookingsLogInToManageReservations =>
      'سجّل الدخول لحجز الإقامات وإدارة الحجوزات.';

  @override
  String get chatTitle => 'المحادثة';

  @override
  String get chatNoMessagesYet => 'لا توجد رسائل بعد';

  @override
  String get chatStartConversationDesc => 'ابدأ محادثة من أي إعلان.';

  @override
  String get chatSayHelloDesc => 'قل مرحبًا لبدء المحادثة.';

  @override
  String get chatOwnerFallback => 'المالك';

  @override
  String chatYouPrefix(String body) {
    return 'أنت: $body';
  }

  @override
  String get chatSignInToSeeMessages => 'سجّل الدخول لعرض رسائلك';

  @override
  String get chatLogInToChatWithOwners =>
      'سجّل الدخول للدردشة مع مالكي العقارات.';

  @override
  String get chatTypeMessageHint => 'اكتب رسالة…';

  @override
  String get clear => 'مسح';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get communityBlockedUsersTitle => 'المستخدمون المحظورون';

  @override
  String get communityUserUnblocked => 'تم إلغاء حظر المستخدم';

  @override
  String get communitySignInToManageBlocks => 'سجّل الدخول لإدارة الحظر';

  @override
  String get communityLogInToSeeBlocked => 'سجّل الدخول لمعرفة من قمت بحظره.';

  @override
  String get communityNoBlockedUsers => 'لا يوجد مستخدمون محظورون';

  @override
  String get communityBlockedUsersEmptyDesc =>
      'سيظهر الأشخاص الذين تحظرهم هنا.';

  @override
  String communityUserFallback(int id) {
    return 'المستخدم رقم $id';
  }

  @override
  String get communityUnblock => 'إلغاء الحظر';

  @override
  String get compareTitle => 'مقارنة';

  @override
  String get compareAttrPrice => 'السعر';

  @override
  String get compareAttrType => 'النوع';

  @override
  String get compareAttrBedrooms => 'غرف النوم';

  @override
  String get compareAttrBathrooms => 'الحمامات';

  @override
  String get compareAttrArea => 'المساحة (قدم²)';

  @override
  String get compareAttrFurnished => 'مفروش';

  @override
  String get compareAttrParking => 'موقف سيارات';

  @override
  String get compareAttrLocation => 'الموقع';

  @override
  String get compareNothingToCompare => 'لا يوجد شيء للمقارنة';

  @override
  String get compareAddPropertiesDesc => 'أضف عقارات لمقارنتها جنبًا إلى جنب.';

  @override
  String get compareSignInToCompare => 'سجّل الدخول للمقارنة';

  @override
  String get compareLogInToBuildShortlists =>
      'سجّل الدخول لإنشاء قوائم عقارات مختصرة ومقارنتها.';

  @override
  String get configLanguageCurrencyTitle => 'اللغة والعملة';

  @override
  String get configLanguage => 'اللغة';

  @override
  String get configCurrency => 'العملة';

  @override
  String get configPricesLocalizedDesc =>
      'يحوّل الخادم الأسعار ويترجم المحتوى حسب اختيارك.';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get description => 'الوصف';

  @override
  String get priority => 'الأولوية';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get next => 'التالي';

  @override
  String get submitRequest => 'إرسال الطلب';

  @override
  String get homeCategories => 'الفئات';

  @override
  String get homeFeaturedProperties => 'العقارات المميزة';

  @override
  String get homeHandPickedDesc => 'إعلانات مختارة لك';

  @override
  String get homePropertyByLocation => 'العقارات حسب الموقع';

  @override
  String get homeExploreTopCities => 'استكشف المنازل في أهم المدن';

  @override
  String homeShowingNear(String name) {
    return 'عرض العقارات بالقرب من $name';
  }

  @override
  String get homeShowingNearYou => 'عرض العقارات بالقرب منك';

  @override
  String get homeCouldNotGetLocation => 'تعذر الحصول على موقعك.';

  @override
  String get homeFindingNearYou => 'جارٍ البحث عن عقارات بالقرب منك…';

  @override
  String get homeUseMyLocation => 'استخدم موقعي الحالي';

  @override
  String get homeNotSureTitle => 'لست متأكدًا من أين تبدأ؟';

  @override
  String get homeNotSureDesc => 'دعنا نساعدك في العثور على المكان المثالي.';

  @override
  String get homeExploreNow => 'استكشف الآن';

  @override
  String get homeCouldntLoadListings => 'تعذر تحميل الإعلانات.';

  @override
  String get homeNoFeaturedListings => 'لا توجد إعلانات مميزة بعد';

  @override
  String get homeFromBlog => 'من المدونة';

  @override
  String get homeBlogTipsDesc => 'نصائح وأدلة للمستأجرين والمالكين';

  @override
  String get maintenanceTitle => 'الصيانة';

  @override
  String get maintenanceSignInTitle => 'سجّل الدخول للصيانة';

  @override
  String get maintenanceLogInDesc =>
      'سجّل الدخول لإنشاء طلبات الصيانة وتتبعها.';

  @override
  String get maintenanceNoRequests => 'لا توجد طلبات صيانة';

  @override
  String get maintenanceTapPlusDesc => 'اضغط + لإنشاء مشكلة لعقار.';

  @override
  String maintenancePriorityLabel(String priority) {
    return 'الأولوية: $priority';
  }

  @override
  String get maintenanceEnterValidListingId => 'أدخل رقم إعلان صالحًا';

  @override
  String get maintenanceAddTitleDesc => 'أضف عنوانًا ووصفًا';

  @override
  String get maintenanceRequestSubmitted => 'تم إرسال الطلب';

  @override
  String get maintenanceRaiseIssue => 'إنشاء مشكلة';

  @override
  String get maintenanceListingId => 'رقم الإعلان';

  @override
  String get maintenanceListingIdHint => 'العقار المرتبط بهذا الطلب';

  @override
  String get maintenanceTitleLabel => 'العنوان';

  @override
  String get maintenanceTitleHint => 'مثال: تسرب في الصنبور';

  @override
  String get maintenanceDescribeHint => 'صف المشكلة';

  @override
  String get maintenancePriorityLow => 'منخفضة';

  @override
  String get maintenancePriorityNormal => 'عادية';

  @override
  String get maintenancePriorityHigh => 'عالية';

  @override
  String get maintenancePriorityUrgent => 'عاجلة';

  @override
  String get onboardingSlide1Title => 'تتبع وأدر وطوّر أعمالك العقارية';

  @override
  String get onboardingSlide1Body =>
      'احصل على رؤى فورية، وتتبع الأداء، وطوّر عملك بثقة.';

  @override
  String get onboardingSlide2Title => 'ابقَ على اتصال مع المستأجرين';

  @override
  String get onboardingSlide2Body =>
      'أدر معلومات المستأجرين، وتتبع مدفوعات الإيجار، وأبقِ الجميع على اطلاع.';

  @override
  String get onboardingSlide3Title => 'أدر عقاراتك بسهولة';

  @override
  String get onboardingSlide3Body =>
      'كل عقاراتك ومستأجريك ومدفوعاتك وصيانتك في مكان واحد.';

  @override
  String get post => 'نشر';

  @override
  String get edit => 'تعديل';

  @override
  String get archive => 'أرشفة';

  @override
  String get add => 'إضافة';

  @override
  String get title => 'العنوان';

  @override
  String get price => 'السعر';

  @override
  String get address => 'العنوان';

  @override
  String get ownerMyListingsTitle => 'إعلاناتي';

  @override
  String get ownerSignInToManageListings => 'سجّل الدخول لإدارة الإعلانات';

  @override
  String get ownerLogInToManageListings =>
      'سجّل الدخول لعرض وإدارة العقارات التي نشرتها.';

  @override
  String get ownerNoListingsYet => 'لا توجد إعلانات بعد';

  @override
  String get ownerListingsEmptyDesc => 'ستظهر العقارات التي تنشرها هنا.';

  @override
  String ownerListingMarked(String status) {
    return 'تم تمييز الإعلان كـ $status';
  }

  @override
  String get ownerListingDeleted => 'تم حذف الإعلان';

  @override
  String get ownerMarkAsRented => 'تمييز كمؤجر';

  @override
  String get ownerMarkAsSold => 'تمييز كمباع';

  @override
  String get ownerLeadsTitle => 'العملاء المحتملون والنشاط';

  @override
  String get ownerSignInToSeeLeads => 'سجّل الدخول لعرض العملاء المحتملين';

  @override
  String get ownerLogInToTrackInterest =>
      'سجّل الدخول لتتبع الاهتمام بإعلاناتك.';

  @override
  String get ownerRecentActivity => 'النشاط الأخير';

  @override
  String get ownerCouldNotLoadStats => 'تعذر تحميل الإحصاءات';

  @override
  String get ownerViews => 'المشاهدات';

  @override
  String get ownerLeads => 'العملاء المحتملون';

  @override
  String get ownerCouldNotLoadActivity => 'تعذر تحميل النشاط.';

  @override
  String get ownerNoActivityYet => 'لا يوجد نشاط بعد.';

  @override
  String get ownerSomeoneFallback => 'شخص ما';

  @override
  String get ownerChoosePropertyType => 'اختر نوع العقار';

  @override
  String get ownerChooseLocation => 'اختر موقعًا';

  @override
  String get ownerChooseLocationPlaceholder => 'اختر الموقع';

  @override
  String get ownerListingUpdated => 'تم تحديث الإعلان';

  @override
  String get ownerListingSubmittedForReview => 'تم إرسال الإعلان للمراجعة';

  @override
  String get ownerEditPropertyTitle => 'تعديل العقار';

  @override
  String get ownerPostPropertyTitle => 'نشر عقار';

  @override
  String get ownerPropertyTypeLabel => 'نوع العقار';

  @override
  String get ownerTitleHint => 'مثال: شقة مشرقة بغرفتين قرب الحديقة';

  @override
  String get ownerAtLeast5Chars => '5 أحرف على الأقل';

  @override
  String get ownerAmountHint => 'المبلغ';

  @override
  String get ownerEnterPrice => 'أدخل السعر';

  @override
  String get ownerAreaSqftLabel => 'المساحة (قدم²)';

  @override
  String get ownerAllowedFor => 'مسموح لـ';

  @override
  String get ownerFamily => 'عائلة';

  @override
  String get ownerBachelor => 'أعزب';

  @override
  String get ownerBoth => 'كلاهما';

  @override
  String get ownerAddressHint => 'الشارع / المنطقة';

  @override
  String get ownerSubmitListing => 'إرسال الإعلان';

  @override
  String get ownerPhotosAdded => 'تمت إضافة الصور';

  @override
  String get ownerPhotoRemoved => 'تمت إزالة الصورة';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get currency => 'العملة';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get profileActivity => 'النشاط';

  @override
  String get profileMyVisits => 'زياراتي';

  @override
  String get profileFindTechnician => 'العثور على فني';

  @override
  String get profileServiceBookings => 'حجوزات الخدمة';

  @override
  String get profileBecomeTechnician => 'كن فنيًا';

  @override
  String get profileMyTechnicianProfile => 'ملفي الفني';

  @override
  String get profileLists => 'القوائم';

  @override
  String get profileSavedProperties => 'العقارات المحفوظة';

  @override
  String get profileSavedSearches => 'عمليات البحث المحفوظة';

  @override
  String get profileOwner => 'المالك';

  @override
  String get profileRentManagement => 'إدارة الإيجار';

  @override
  String get profileBilling => 'الفوترة';

  @override
  String get profileWallet => 'المحفظة';

  @override
  String get profileAccount => 'الحساب';

  @override
  String get profileEditProfile => 'تعديل الملف الشخصي';

  @override
  String get profileChangePassword => 'تغيير كلمة المرور';

  @override
  String get profileExplore => 'استكشف';

  @override
  String get profileSupportLegal => 'الدعم والقانوني';

  @override
  String get profileHelpContact => 'المساعدة والتواصل';

  @override
  String get profilePrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get profileTermsConditions => 'الشروط والأحكام';

  @override
  String get profileDarkMode => 'الوضع الداكن';

  @override
  String get profileLogOut => 'تسجيل الخروج';

  @override
  String get profileLoginRegister => 'تسجيل الدخول / إنشاء حساب';

  @override
  String get profileAppVersion => 'Rentdo v1.0.0';

  @override
  String get profileGuestName => 'ضيف';

  @override
  String get profileGuestDesc => 'سجّل الدخول لإدارة حسابك';

  @override
  String get profileComingSoon => 'قريبًا';

  @override
  String get profilePhoneHint => '+1 415 555 0100';

  @override
  String profileCurrencyOption(String code, String name) {
    return '$code — $name';
  }

  @override
  String get profileWhoCanSeePhone => 'من يمكنه رؤية هاتفي';

  @override
  String get profileVisibilityEveryone => 'الجميع';

  @override
  String get profileVisibilityRegistered => 'المستخدمون المسجلون';

  @override
  String get profileVisibilityNobody => 'لا أحد';

  @override
  String get profileNothingToUpdate => 'لا يوجد شيء للتحديث';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي';

  @override
  String get profileUpdateFailed => 'فشل التحديث';

  @override
  String get profilePhotoUpdated => 'تم تحديث الصورة';

  @override
  String get profileUploadFailed => 'فشل الرفع';

  @override
  String get profileCurrentPassword => 'كلمة المرور الحالية';

  @override
  String get profileConfirmNewPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get profileUpdatePassword => 'تحديث كلمة المرور';

  @override
  String get profilePasswordChanged => 'تم تغيير كلمة المرور';

  @override
  String get profileCouldNotChangePassword => 'تعذر تغيير كلمة المرور';

  @override
  String get map => 'الخريطة';

  @override
  String get list => 'القائمة';

  @override
  String get close => 'إغلاق';

  @override
  String get reviews => 'المراجعات';

  @override
  String get write => 'كتابة';

  @override
  String get share => 'مشاركة';

  @override
  String get ofWord => 'من';

  @override
  String get logInToContinue => 'سجّل الدخول للمتابعة.';

  @override
  String get propertiesNoneFound => 'لم يتم العثور على عقارات';

  @override
  String get propertiesTryAdjusting => 'جرّب تعديل الفلاتر أو كلمات البحث.';

  @override
  String get clearFilters => 'مسح الفلاتر';

  @override
  String get propertiesLogInToSaveSearches => 'سجّل الدخول لحفظ عمليات البحث.';

  @override
  String get propertiesSearchSaved => 'تم حفظ البحث';

  @override
  String propertiesCount(int count) {
    return '$count عقارات';
  }

  @override
  String get propertiesSaveSearch => 'حفظ البحث';

  @override
  String get propertiesCouldntLoadArea => 'تعذر تحميل هذه المنطقة.';

  @override
  String get propertiesNoPropertiesInArea => 'لا توجد عقارات في هذه المنطقة';

  @override
  String get propertyDescription => 'الوصف';

  @override
  String get propertyDetails => 'تفاصيل العقار';

  @override
  String get propertyAvailability => 'التوفر';

  @override
  String get propertyAmenities => 'المرافق';

  @override
  String get propertyMortgageCalculator => 'حاسبة التمويل العقاري';

  @override
  String get propertyRentCalculator => 'حاسبة الإيجار';

  @override
  String get propertyEstimateRepayment => 'قدّر دفعتك الشهرية';

  @override
  String get propertyEstimateMoveInCost => 'قدّر تكلفة الانتقال';

  @override
  String get propertySqFt => 'قدم²';

  @override
  String get propertyArea => 'المساحة';

  @override
  String get propertyFloor => 'الطابق';

  @override
  String get propertyServiceCharge => 'رسوم الخدمة';

  @override
  String get propertyAdvance => 'مقدم';

  @override
  String propertyMonthsCount(int count) {
    return '$count شهر';
  }

  @override
  String propertyAway(String distance) {
    return 'يبعد $distance';
  }

  @override
  String get propertyAvailabilityUnavailable => 'التوفر غير متاح.';

  @override
  String get propertyNoAvailabilityYet => 'لم يتم نشر التوفر بعد.';

  @override
  String get propertyServicesNearby => 'خدمات قريبة';

  @override
  String get propertyTechnicianFallback => 'فني';

  @override
  String get propertySimilarProperties => 'عقارات مشابهة';

  @override
  String get propertyListedBy => 'مدرج بواسطة';

  @override
  String get propertyLogInToMessageOwner => 'سجّل الدخول لمراسلة المالك.';

  @override
  String get propertyContactNotAvailable =>
      'معلومات التواصل غير متاحة لهذا الإعلان.';

  @override
  String get propertyContactOwner => 'التواصل مع المالك';

  @override
  String get propertyVisitRequested => 'تم طلب الزيارة';

  @override
  String get propertyBookingRequested => 'تم طلب الحجز';

  @override
  String get propertyPriceLabel => 'السعر';

  @override
  String propertyPricePerPeriod(String period) {
    return 'السعر / $period';
  }

  @override
  String get propertyBookNow => 'احجز الآن';

  @override
  String get propertyScheduleVisit => 'جدولة زيارة';

  @override
  String get propertyCouldNotLoadReviews => 'تعذر تحميل المراجعات.';

  @override
  String get propertyNoReviewsYet => 'لا توجد مراجعات بعد. كن أول من يراجع.';

  @override
  String get propertyLogInToWriteReview => 'سجّل الدخول لكتابة مراجعة.';

  @override
  String get propertyReviewSubmitted => 'تم إرسال المراجعة';

  @override
  String get propertyReportThisReview => 'الإبلاغ عن هذه المراجعة';

  @override
  String get propertyReviewReported => 'تم الإبلاغ عن المراجعة';

  @override
  String get propertyGuestFallback => 'ضيف';

  @override
  String get propertyReportListing => 'الإبلاغ عن الإعلان';

  @override
  String get propertyBlockOwner => 'حظر المالك';

  @override
  String get propertyReportSubmitted => 'تم إرسال البلاغ';

  @override
  String get propertyOwnerBlocked => 'تم حظر المالك';

  @override
  String get name => 'الاسم';

  @override
  String get notes => 'ملاحظات';

  @override
  String get optional => 'اختياري';

  @override
  String get type => 'النوع';

  @override
  String get amount => 'المبلغ';

  @override
  String get date => 'التاريخ';

  @override
  String get generate => 'إنشاء';

  @override
  String get rentManagementTitle => 'إدارة الإيجار';

  @override
  String get rentUnits => 'الوحدات';

  @override
  String get rentTenancies => 'عقود الإيجار';

  @override
  String get rentPayments => 'مدفوعات الإيجار';

  @override
  String get rentLedger => 'دفتر الحسابات';

  @override
  String get rentAgreements => 'الاتفاقيات';

  @override
  String get rentCouldNotLoadSummary => 'تعذر تحميل الملخص';

  @override
  String get rentIncome => 'الدخل';

  @override
  String get rentExpenses => 'المصروفات';

  @override
  String get rentNet => 'الصافي';

  @override
  String get rentSignInToManage => 'سجّل الدخول لإدارة الإيجار';

  @override
  String get rentLogInToTrack =>
      'سجّل الدخول لتتبع الوحدات وعقود الإيجار والمدفوعات.';

  @override
  String get rentAddUnit => 'إضافة وحدة';

  @override
  String get rentDeleteUnit => 'حذف الوحدة';

  @override
  String get rentNoUnitsYet => 'لا توجد وحدات بعد';

  @override
  String get rentAddUnitDesc => 'أضف وحدة لبدء تتبع الإيجار.';

  @override
  String rentFloorValue(String floor) {
    return 'الطابق $floor';
  }

  @override
  String get rentPerMonth => '/شهر';

  @override
  String get rentUnitDeleted => 'تم حذف الوحدة';

  @override
  String get rentListingIdHint => 'رقم إعلان عقارك';

  @override
  String get rentUnitNameHint => 'مثال: شقة 2B';

  @override
  String get rentFloorHint => 'مثال: 2';

  @override
  String get rentRentAmount => 'قيمة الإيجار';

  @override
  String get rentMonthlyRentHint => 'الإيجار الشهري';

  @override
  String get rentOptionalNotesHint => 'ملاحظات اختيارية';

  @override
  String get rentUnitAdded => 'تمت إضافة الوحدة';

  @override
  String get rentEnterUnitName => 'أدخل اسم الوحدة';

  @override
  String get rentAddTenancy => 'إضافة عقد إيجار';

  @override
  String get rentNoTenanciesYet => 'لا توجد عقود إيجار بعد';

  @override
  String get rentAddTenancyDesc => 'أضف عقد إيجار لتتبع المستأجر وإيجاره.';

  @override
  String rentTenancyFallback(int id) {
    return 'عقد الإيجار رقم $id';
  }

  @override
  String get rentOngoing => 'مستمر';

  @override
  String get rentTenantName => 'اسم المستأجر';

  @override
  String get rentTenantPhone => 'هاتف المستأجر';

  @override
  String get rentDeposit => 'التأمين';

  @override
  String get rentDueDayOfMonth => 'يوم الاستحقاق من الشهر';

  @override
  String get rentDueDayHint => '1–31';

  @override
  String get rentStartDate => 'تاريخ البدء';

  @override
  String get rentSelectStartDate => 'اختر تاريخ البدء';

  @override
  String get rentTenancyAdded => 'تمت إضافة عقد الإيجار';

  @override
  String get rentEnterTenantName => 'أدخل اسم المستأجر';

  @override
  String get rentEnterRentAmount => 'أدخل مبلغ الإيجار';

  @override
  String get rentPickStartDate => 'اختر تاريخ البدء';

  @override
  String get rentNoPaymentsYet => 'لا توجد مدفوعات إيجار بعد';

  @override
  String get rentPaymentsEmptyDesc =>
      'ستظهر المدفوعات هنا بعد تفعيل عقود الإيجار.';

  @override
  String rentDueDate(String date) {
    return 'مستحق في $date';
  }

  @override
  String get rentMarkPaid => 'تمييز كمدفوع';

  @override
  String get rentMarkedAsPaid => 'تم التمييز كمدفوع';

  @override
  String get rentAddEntry => 'إضافة قيد';

  @override
  String get rentNoLedgerEntriesYet => 'لا توجد قيود حسابية بعد';

  @override
  String get rentLedgerEmptyDesc => 'أضف دخلًا أو مصروفات لتتبع الصافي.';

  @override
  String get rentIncomeLabel => 'دخل';

  @override
  String get rentExpenseLabel => 'مصروف';

  @override
  String get rentAddLedgerEntry => 'إضافة قيد حسابي';

  @override
  String get rentCategory => 'الفئة';

  @override
  String get rentCategoryHint => 'مثال: إيجار، صيانة';

  @override
  String get rentListingIdOptionalHint => 'اختياري — رقم إعلان عقارك';

  @override
  String get rentEnterCategory => 'أدخل فئة';

  @override
  String get rentEnterAmount => 'أدخل مبلغًا';

  @override
  String get rentEntryAdded => 'تمت إضافة القيد';

  @override
  String get rentTemplates => 'القوالب';

  @override
  String get rentGenerateAgreement => 'إنشاء اتفاقية';

  @override
  String get rentNoAgreementsYet => 'لا توجد اتفاقيات بعد';

  @override
  String get rentAgreementsEmptyDesc => 'أنشئ واحدة من عقد إيجار وقالب.';

  @override
  String rentAgreementFallback(int id) {
    return 'الاتفاقية رقم $id';
  }

  @override
  String get rentAgreementTemplates => 'قوالب الاتفاقيات';

  @override
  String get rentNoTemplatesYet => 'لا توجد قوالب بعد. أنشئ أول قالب أدناه.';

  @override
  String get rentDeleteTemplate => 'حذف القالب';

  @override
  String get rentNewTemplate => 'قالب جديد';

  @override
  String get rentTemplateNameHint => 'مثال: عقد إيجار قياسي لمدة 12 شهرًا';

  @override
  String get rentBody => 'النص';

  @override
  String get rentTemplateBodyHint => 'نص الاتفاقية';

  @override
  String get rentIsDefault => 'افتراضي';

  @override
  String get rentCreateTemplate => 'إنشاء قالب';

  @override
  String get rentDefault => 'افتراضي';

  @override
  String get rentEnterTemplateName => 'أدخل اسم القالب';

  @override
  String get rentEnterTemplateBody => 'أدخل نص القالب';

  @override
  String get rentTemplateCreated => 'تم إنشاء القالب';

  @override
  String get rentTemplateDeleted => 'تم حذف القالب';

  @override
  String get rentChooseTenancy => 'اختر عقد إيجار';

  @override
  String get rentChooseTemplate => 'اختر قالبًا';

  @override
  String get rentAgreementGenerated => 'تم إنشاء الاتفاقية';

  @override
  String get rentTenancyLabel => 'عقد الإيجار';

  @override
  String get rentTemplateLabel => 'القالب';

  @override
  String get savedSearchesTitle => 'عمليات البحث المحفوظة';

  @override
  String get savedSearchesNone => 'لا توجد عمليات بحث محفوظة';

  @override
  String get savedSearchesEmptyDesc =>
      'احفظ بحثًا لتلقي إشعارات عن المطابقات الجديدة.';

  @override
  String get savedSearchesMatchAlerts => 'تنبيهات المطابقة';

  @override
  String get savedSearchesSignInTitle => 'سجّل الدخول لعمليات البحث المحفوظة';

  @override
  String get savedSearchesLogInDesc =>
      'سجّل الدخول لحفظ عمليات البحث وتلقي تنبيهات المطابقة.';

  @override
  String get helpContactTitle => 'المساعدة والتواصل';

  @override
  String supportCouldNotOpen(String scheme) {
    return 'تعذر فتح $scheme';
  }

  @override
  String get supportGetInTouch => 'تواصل معنا';

  @override
  String get supportRespondDesc => 'عادةً نرد خلال يوم عمل واحد.';

  @override
  String get supportEmailUs => 'راسلنا عبر البريد';

  @override
  String get supportCallUs => 'اتصل بنا';

  @override
  String get supportVisitUs => 'زرنا';

  @override
  String get supportSendMessage => 'أرسل لنا رسالة';

  @override
  String get supportYourName => 'اسمك';

  @override
  String get supportSubject => 'الموضوع';

  @override
  String get supportMessage => 'الرسالة';

  @override
  String get supportSendMessageBtn => 'إرسال الرسالة';

  @override
  String get supportThanksMessage => 'شكرًا لتواصلك. سنرد عليك قريبًا.';

  @override
  String get supportCouldNotSend =>
      'تعذر إرسال رسالتك. يرجى المحاولة مرة أخرى.';

  @override
  String get supportFaqTitle => 'الأسئلة الشائعة';

  @override
  String supportLastUpdated(String date) {
    return 'آخر تحديث $date';
  }

  @override
  String get supportCouldntLoadPage => 'تعذر تحميل هذه الصفحة.';

  @override
  String get about => 'حول';

  @override
  String get skills => 'المهارات';

  @override
  String get bio => 'السيرة';

  @override
  String get category => 'الفئة';

  @override
  String get urgent => 'عاجل';

  @override
  String get reject => 'رفض';

  @override
  String get accept => 'قبول';

  @override
  String get technicianFindTitle => 'العثور على فني';

  @override
  String get technicianNoneFound => 'لم يتم العثور على فنيين';

  @override
  String technicianFallback(int id) {
    return 'فني رقم $id';
  }

  @override
  String get technicianPerHour => '/ساعة';

  @override
  String get technicianAvailable => 'متاح';

  @override
  String get technicianBusy => 'مشغول';

  @override
  String get technicianRating => 'التقييم';

  @override
  String get technicianJobs => 'الأعمال';

  @override
  String get technicianYrsExp => 'سنوات الخبرة';

  @override
  String get technicianLogInToRequest => 'سجّل الدخول لطلب خدمة.';

  @override
  String get technicianRequestSent => 'تم إرسال الطلب';

  @override
  String get technicianRequestService => 'طلب خدمة';

  @override
  String get technicianProfileTitle => 'ملفي الفني';

  @override
  String get technicianProfileDetails => 'تفاصيل الملف';

  @override
  String get technicianKeepCurrentDesc =>
      'حافظ على تحديث بياناتك ليعرف العملاء ما تقدمه.';

  @override
  String get technicianBioHint => 'نبذة قصيرة عن خبرتك';

  @override
  String get technicianSkillsHint => 'افصل بفواصل، مثال: سباكة، كهرباء';

  @override
  String get technicianExperienceYears => 'الخبرة (بالسنوات)';

  @override
  String get technicianExperienceHint => 'مثال: 5';

  @override
  String get technicianHourlyRate => 'السعر بالساعة';

  @override
  String get technicianRateHint => 'سعرك لكل ساعة';

  @override
  String get technicianAvailableForWork => 'متاح للعمل';

  @override
  String get technicianPauseDesc => 'أوقف هذا الخيار لإيقاف الطلبات الجديدة.';

  @override
  String get technicianSignInToManage => 'سجّل الدخول لإدارة ملفك';

  @override
  String get technicianLogInToUpdate =>
      'سجّل الدخول لتحديث بيانات الفني الخاصة بك.';

  @override
  String get technicianChooseCategory => 'اختر فئة';

  @override
  String get technicianApplicationSubmitted =>
      'تم إرسال الطلب — سنراجعه قريبًا';

  @override
  String get technicianBecomeTitle => 'كن فنيًا';

  @override
  String get technicianTellUsTitle => 'أخبرنا عن عملك';

  @override
  String get technicianReviewDesc => 'نراجع كل طلب قبل نشر ملفك.';

  @override
  String get technicianSubmitApplication => 'إرسال الطلب';

  @override
  String get technicianSignInToApply => 'سجّل الدخول للتقديم';

  @override
  String get technicianLogInToApply => 'سجّل الدخول لإرسال طلب الانضمام كفني.';

  @override
  String get technicianServiceBookingsTitle => 'حجوزات الخدمة';

  @override
  String get technicianNoServiceBookings => 'لا توجد حجوزات خدمة';

  @override
  String get technicianBookTechDesc => 'احجز فنيًا لتظهر الطلبات هنا.';

  @override
  String get technicianQuotes => 'عروض الأسعار';

  @override
  String get technicianSubmitQuote => 'إرسال عرض سعر';

  @override
  String get technicianSignInToSeeBookings => 'سجّل الدخول لعرض حجوزات الخدمة';

  @override
  String get technicianLogInToBookTrack =>
      'سجّل الدخول لحجز الفنيين وتتبع الطلبات.';

  @override
  String get visitsTitle => 'زياراتي';

  @override
  String get visitsNoneScheduled => 'لا توجد زيارات مجدولة';

  @override
  String get visitsBookViewingDesc => 'احجز معاينة من أي إعلان.';

  @override
  String visitsPropertyFallback(int id) {
    return 'العقار رقم $id';
  }

  @override
  String get visitsSignInToSeeVisits => 'سجّل الدخول لعرض زياراتك';

  @override
  String get visitsLogInToSchedule =>
      'سجّل الدخول لجدولة وتتبع معاينات العقارات.';

  @override
  String get walletBrandLabel => 'محفظة RENTDO';

  @override
  String get walletAvailableBalance => 'الرصيد المتاح';

  @override
  String get walletUnableToLoad => 'تعذر تحميل الرصيد';

  @override
  String get walletTopUpComingSoon => 'إعادة الشحن بالبطاقة قريبًا';

  @override
  String get walletTopUp => 'شحن الرصيد';

  @override
  String get walletTransactions => 'المعاملات';

  @override
  String get walletNoTransactionsYet => 'لا توجد معاملات بعد';

  @override
  String get walletSignInToView => 'سجّل الدخول لعرض محفظتك';

  @override
  String get walletLogInToSeeBalance => 'سجّل الدخول لعرض رصيدك ومعاملاتك.';

  @override
  String get reset => 'إعادة ضبط';

  @override
  String get any => 'أي';

  @override
  String get reason => 'السبب';

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String get selectTime => 'اختر الوقت';

  @override
  String get clearDate => 'مسح التاريخ';

  @override
  String get bookNowSelectDatesError => 'اختر تاريخ الوصول وتاريخ المغادرة';

  @override
  String get bookNowNightsUnavailable => 'بعض هذه الليالي غير متاحة';

  @override
  String get bookNowSelectDates => 'اختر التواريخ';

  @override
  String get bookNowTitle => 'احجز إقامتك';

  @override
  String get bookNowAllAvailable =>
      'كل التواريخ متاحة خلال الـ 60 يومًا القادمة';

  @override
  String bookNowSomeUnavailable(int count) {
    return '$count تواريخ غير متاحة — محجوبة';
  }

  @override
  String get bookNowSpecialRequests => 'طلبات خاصة (اختياري)';

  @override
  String get bookNowSpecialRequestsHint => 'وصول مبكر، سرير إضافي…';

  @override
  String get bookNowRequestBooking => 'طلب الحجز';

  @override
  String get chatDefaultMessage =>
      'مرحبًا، أنا مهتم بهذا العقار. هل ما زال متاحًا؟';

  @override
  String get chatWriteMessageFirst => 'اكتب رسالة أولًا';

  @override
  String get chatMessageOwnerTitle => 'مراسلة المالك';

  @override
  String get chatYourMessageHint => 'رسالتك';

  @override
  String get reportDetailsOptional => 'التفاصيل (اختياري)';

  @override
  String get reportDetailsHint => 'أضف أي سياق لفريقنا';

  @override
  String get reportSubmitReport => 'إرسال البلاغ';

  @override
  String get compareLogInToCompare => 'سجّل الدخول لمقارنة العقارات.';

  @override
  String get compareRemoveFromCompare => 'إزالة من المقارنة';

  @override
  String get compareAddToCompare => 'إضافة إلى المقارنة';

  @override
  String get compareAddedToCompare => 'تمت الإضافة إلى المقارنة';

  @override
  String get compareRemovedFromCompare => 'تمت الإزالة من المقارنة';

  @override
  String get homeWelcome => 'مرحبًا 👋';

  @override
  String homeHiName(String name) {
    return 'مرحبًا، $name 👋';
  }

  @override
  String get homeFindNextHome => 'اعثر على منزلك القادم';

  @override
  String notificationsUnreadLabel(int count) {
    return 'الإشعارات، $count غير مقروءة';
  }

  @override
  String get favoriteLogInToSave => 'سجّل الدخول لحفظ العقارات.';

  @override
  String get favoriteRemoveFromSaved => 'إزالة من المحفوظات';

  @override
  String get favoriteSaveProperty => 'حفظ العقار';

  @override
  String get reviewTapStarToRate => 'اضغط على نجمة للتقييم';

  @override
  String get reviewWriteTitle => 'اكتب مراجعة';

  @override
  String get reviewYourReviewOptional => 'مراجعتك (اختياري)';

  @override
  String get reviewShareDetailsHint => 'شارك تفاصيل تجربتك';

  @override
  String get reviewSubmitReview => 'إرسال المراجعة';

  @override
  String get technicianDescribeJobAddress => 'صف العمل وأدخل العنوان';

  @override
  String get technicianPickDateAndTime => 'اختر التاريخ والوقت';

  @override
  String get technicianChooseFutureTime => 'اختر وقتًا في المستقبل';

  @override
  String get technicianSelectDateTime => 'اختر التاريخ والوقت';

  @override
  String get technicianRequestTitle => 'طلب فني';

  @override
  String get technicianWhatNeedDone => 'ما الذي تحتاج إلى إنجازه؟';

  @override
  String get technicianDescribeJobHint => 'صف العمل';

  @override
  String get technicianServiceAddress => 'عنوان الخدمة';

  @override
  String get technicianWhereComeHint => 'أين يجب أن يحضروا؟';

  @override
  String get technicianMarkUrgent => 'تمييز كعاجل';

  @override
  String get technicianSendRequest => 'إرسال الطلب';

  @override
  String get quoteEnterValidAmount => 'أدخل مبلغًا صالحًا';

  @override
  String get quoteValidUntilOptional => 'صالح حتى (اختياري)';

  @override
  String quoteValidUntil(String date) {
    return 'صالح حتى $date';
  }

  @override
  String get quoteSubmitTitle => 'إرسال عرض سعر';

  @override
  String get quoteAmountHint => 'كم ستكلف هذه المهمة؟';

  @override
  String get quoteDescriptionHint => 'ما الذي يشمله عرض السعر؟';

  @override
  String get quoteSendQuote => 'إرسال عرض السعر';

  @override
  String get visitScheduleTitle => 'جدولة زيارة';

  @override
  String get visitNoteOptional => 'ملاحظة (اختياري)';

  @override
  String get visitNoteHint => 'أي شيء يجب أن يعرفه المالك';

  @override
  String get visitRequestVisit => 'طلب زيارة';

  @override
  String get affordEstimateRepayment => 'قدّر دفعتك الشهرية.';

  @override
  String get affordEstimateMoveIn => 'قدّر تكلفة الانتقال وإرشاد الدخل.';

  @override
  String get affordPropertyPrice => 'سعر العقار';

  @override
  String get affordMonthlyRent => 'الإيجار الشهري';

  @override
  String get affordDownPayment => 'الدفعة المقدمة';

  @override
  String get affordInterestRate => 'معدل الفائدة';

  @override
  String get affordLoanTenure => 'مدة القرض';

  @override
  String get affordYr => 'سنة';

  @override
  String get affordMonthlyPayment => 'الدفعة الشهرية';

  @override
  String get affordLoanAmount => 'مبلغ القرض';

  @override
  String get affordTotalInterest => 'إجمالي الفائدة';

  @override
  String get affordTotalPayable => 'إجمالي المستحق';

  @override
  String get affordAdvanceDeposit => 'مقدم / تأمين';

  @override
  String get affordMonthSingular => 'شهر واحد';

  @override
  String affordMonthsPlural(int count) {
    return '$count أشهر';
  }

  @override
  String get affordMoveInCost => 'تكلفة الانتقال';

  @override
  String affordDepositMo(int months) {
    return 'التأمين ($months شهر)';
  }

  @override
  String get affordFirstMonthRent => 'إيجار الشهر الأول';

  @override
  String get affordSuggestedIncome => 'الدخل المقترح / شهر';

  @override
  String get affordEstimatesDisclaimer =>
      'هذه تقديرات فقط. قد تختلف الأرقام الفعلية.';

  @override
  String get filtersTitle => 'الفلاتر';

  @override
  String get filterPropertyType => 'نوع العقار';

  @override
  String get filterAnyLocation => 'أي موقع';

  @override
  String get filterPriceRange => 'نطاق السعر';

  @override
  String get filterVerifiedOnly => 'الإعلانات الموثقة فقط';

  @override
  String get filterFeaturedOnly => 'المميزة فقط';

  @override
  String get filterSortBy => 'ترتيب حسب';

  @override
  String get filterShowResults => 'عرض النتائج';

  @override
  String get mapViewMap => 'عرض الخريطة';

  @override
  String get mapLocationFallback => 'الموقع';

  @override
  String get zoneSearchHint => 'ابحث عن الدول أو المدن';

  @override
  String get zoneNoLocationsFound => 'لم يتم العثور على مواقع';

  @override
  String get verified => 'موثق';

  @override
  String get featured => 'مميز';

  @override
  String get newLabel => 'جديد';

  @override
  String get searchLocationHint => 'ابحث عن موقع أو عقار...';

  @override
  String get searchCountryHint => 'ابحث عن دولة أو رمز';

  @override
  String get noCountriesFound => 'لم يتم العثور على دول';

  @override
  String get savedNoProperties => 'لا توجد عقارات محفوظة';

  @override
  String get savedTapHeartDesc => 'اضغط على القلب في أي إعلان لحفظه هنا.';

  @override
  String get savedSignInTitle => 'سجّل الدخول لعرض منازلك المحفوظة';

  @override
  String get savedSignInDesc => 'احفظ العقارات التي تحبها واعثر عليها هنا.';

  @override
  String get authContinueLoginDesc => 'سجّل الدخول لمتابعة استكشاف العقارات.';

  @override
  String get authJoinRentdoDesc =>
      'انضم إلى Rentdo لحفظ المفضلات والتواصل مع الوكلاء.';

  @override
  String get authFullNameHint => 'Jane Doe';

  @override
  String get authEnterCodeDesc => 'أدخل الرمز الذي أرسلناه إلى هاتفك.';

  @override
  String authVerifyingPhone(String phone) {
    return 'جارٍ التحقق من $phone';
  }

  @override
  String get notificationsSignInTitle => 'سجّل الدخول لعرض الإشعارات';

  @override
  String get notificationsLogInDesc =>
      'سجّل الدخول للحصول على تحديثات حول زياراتك وعمليات البحث المحفوظة.';

  @override
  String get notificationsMarkAllRead => 'تمييز الكل كمقروء';

  @override
  String get notificationsNoneYet => 'لا توجد إشعارات بعد';

  @override
  String get notificationsWillNotify => 'سنخبرك عندما يحدث شيء جديد.';

  @override
  String get categoryForSale => 'للبيع';

  @override
  String get categoryForRent => 'للإيجار';

  @override
  String get categoryShortStay => 'إقامة قصيرة';

  @override
  String get categoryLand => 'أرض';

  @override
  String get categoryOffice => 'مكتب';

  @override
  String get categoryRooms => 'غرف';
}
