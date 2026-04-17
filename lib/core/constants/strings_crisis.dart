// Content Bible §18 — Crisis + safety content
class StringsCrisis {
  StringsCrisis._();

  static const String heading = "You're not alone. Real help is available right now.";

  // Crisis hotlines (bundled offline)
  static const String usHotline = 'United States: 988 Suicide & Crisis Lifeline — call or text 988';
  static const String ukHotline = 'United Kingdom: Samaritans — call 116 123 (free, 24/7)';
  static const String caHotline = 'Canada: 988 Suicide Crisis Helpline — call or text 988';
  static const String auHotline = 'Australia: Lifeline — call 13 11 14 (24/7)';
  static const String inHotline =
      'India: iCall — 9152987821 / Vandrevala Foundation — 1860 2662 345';
  static const String intlHotline =
      'International: Crisis Text Line — text HOME to 741741 (US/CA) or 85258 (UK)';

  static const List<String> allHotlines = [
    usHotline,
    ukHotline,
    caHotline,
    auHotline,
    inHotline,
    intlHotline,
  ];

  static const String footer =
      "Anshin is not a therapist. If what you're feeling is dangerous or overwhelming, "
      "please reach out to a real person. There's no shame in asking for help — "
      "it's the strongest thing you can do.";

  // App disclaimer (shown in About section)
  static const String appDisclaimer =
      'Anshin is a self-help tool for managing anxiety and panic. It is not a medical device, '
      'a diagnostic tool, or a substitute for professional therapy or medication. '
      'If you are experiencing a mental health emergency, please contact your local '
      'crisis line or go to the nearest emergency room.';
}
