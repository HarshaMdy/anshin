// Content Bible §15 — Settings + profile strings
class StringsSettings {
  StringsSettings._();

  // ─── Section: Account ───────────────────────────────────────────────────────
  static const String sectionAccount = 'Account';
  static const String signIn = 'Sign in';
  static String signedInAs(String email) => 'Signed in as $email';
  static const String signOut = 'Sign out';
  static const String deleteAccount = 'Delete my account';
  static const String deleteAccountConfirm =
      'This will permanently delete all your data after 30 days. '
      'You can sign back in within 30 days to cancel. Are you sure?';
  static const String deleteAccountConfirmButton = 'Delete';
  static const String keepAccountButton = 'Keep my account';
  static const String exportData = 'Export my data';
  static const String exportDataSubtext =
      "We'll email you a copy of all your data within 48 hours.";

  // ─── Section: Appearance ────────────────────────────────────────────────────
  static const String sectionAppearance = 'Appearance';
  static const String themeLabel = 'Theme';
  static const String themeLight = 'Light';
  static const String themeDark = 'Dark';
  static const String themeSystem = 'System default';

  // ─── Section: Notifications ─────────────────────────────────────────────────
  static const String sectionNotifications = 'Notifications';
  static const String dailyReminderToggle = 'Daily reminder';
  static const String reminderTimeLabel = 'Reminder time';
  static const String postSosToggle = 'Post-SOS follow-up';

  // ─── Section: Audio & haptics ────────────────────────────────────────────────
  static const String sectionAudio = 'Audio & haptics';
  static const String voiceGuidanceToggle = 'Voice guidance';
  static const String vibrationToggle = 'Vibration';
  static const String defaultPatternLabel = 'Default breathing pattern';

  // ─── Section: About ─────────────────────────────────────────────────────────
  static const String sectionAbout = 'About Anshin';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsOfService = 'Terms of Service';
  static const String contactSupport = 'Contact support';
  static const String supportEmail = 'support@anshin.app';
  static const String rateAnshin = 'Rate Anshin';
  static const String shareAnshin = 'Share Anshin';
  static const String shareText =
      "I've been using Anshin for anxiety and panic relief. It actually helps. "
      'https://play.google.com/store/apps/details?id=com.anshin.app';

  // ─── Section: Subscription ──────────────────────────────────────────────────
  static const String sectionSubscription = 'Subscription';
  static const String premiumActive = 'Active';
  static const String premiumNotSubscribed = 'Not subscribed';
  static const String manageSubscription = 'Manage subscription';
  static const String restorePurchase = 'Restore purchase';
}
