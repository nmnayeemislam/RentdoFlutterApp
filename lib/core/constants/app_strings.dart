/// Centralized user-facing copy. In a fully localized app these would move to
/// ARB files; keeping them here avoids scattered string literals for now.
abstract final class AppStrings {
  AppStrings._();

  static const String appName = 'Rentdo';
  static const String tagline =
      'Find the right property. Right place. Right price.';
  static const String heroSubtitle =
      'Discover verified properties for rent, sale or investment. Trusted by thousands.';

  // Generic
  static const String retry = 'Retry';
  static const String somethingWentWrong = 'Something went wrong';
  static const String noInternet =
      'No internet connection. Check your network and try again.';
  static const String noResults = 'No results found';
  static const String seeAll = 'See all';
  static const String explore = 'Explore Properties';

  // Auth
  static const String login = 'Login';
  static const String register = 'Register';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String fullName = 'Full name';
  static const String phone = 'Phone';
  static const String forgotPassword = 'Forgot password?';
  static const String dontHaveAccount = "Don't have an account?";
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String welcomeBack = 'Welcome back';
  static const String createAccount = 'Create your account';
  static const String usePhoneInstead = 'Use phone instead';
  static const String useEmailInstead = 'Use email instead';
  static const String sendOtp = 'Send OTP';
  static const String resendOtp = 'Resend OTP';
  static const String verifyAndContinue = 'Verify & continue';
  static const String continueAsGuest = 'Continue as guest';
  static const String otpCode = 'Verification code';
  static const String otpHint = '6-digit code';
  static const String resetPassword = 'Reset password';
  static const String forgotPasswordTitle = 'Forgot password';
  static const String forgotPasswordSubtitle =
      'Reset your password by email or phone.';
  static const String newPassword = 'New password';
  static const String createAccountCta = 'Create account';
  static const String changeDetails = 'Change details';
  static const String checkEmailForReset = 'Check your email for a reset link';
  static const String passwordUpdated =
      'Password updated. Please log in with your new password.';

  // Nav
  static const String home = 'Home';
  static const String search = 'Search';
  static const String saved = 'Saved';
  static const String profile = 'Profile';
}
