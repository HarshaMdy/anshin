// Content Bible §13 — Paywall strings
class StringsPaywall {
  StringsPaywall._();

  static const String header = 'Unlock Anshin Premium';

  // Benefit lines (3 max, each with small icon)
  static const String benefit1 = 'All breathing patterns and grounding techniques';
  static const String benefit2 = 'Unlimited journaling with guided prompts';
  static const String benefit3 = 'Full progress insights and pattern tracking';

  // Future preview (smaller text)
  static const String futurePreview =
      'Coming soon: AI companion, sleep stories, and full CBT lesson library';

  // Pricing
  static const String annualPrice = '\$49.99/year';
  static const String annualBadge = 'Save 48%';
  static const String annualSubtext = "That's \$4.17/month";
  static const String monthlyPrice = '\$7.99/month';

  // CTA
  static const String ctaButton = 'Start 7-day free trial';
  static const String ctaSubtext =
      'Free for 7 days, then \$49.99/year. Cancel anytime in Play Store.';

  // Bottom links
  static const String restorePurchase = 'Restore purchase';
  static const String termsLink = 'Terms';
  static const String privacyLink = 'Privacy';

  // ─── Paywall trigger messages ────────────────────────────────────────────────
  static const String lockedBreathing =
      'This breathing pattern is part of Anshin Premium. Try it free for 7 days.';
  static const String lockedGrounding =
      'This technique is in Anshin Premium. Try it free for 7 days.';
  static const String journalLimitReached =
      "You've filled your free journal. Unlock unlimited entries with Premium.";
  static const String lockedProgressInsights =
      'Full insights and patterns are part of Premium.';
  static const String lockedLesson =
      'This lesson is coming soon as part of Anshin Premium.';
}
