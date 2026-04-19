// Content Bible §13 — Paywall strings
// Prices updated per Task 17: $4.99/month, $34.99/year
class StringsPaywall {
  StringsPaywall._();

  static const String header = 'Unlock Anshin Premium';
  static const String subheader =
      'Everything you need to build calm into your day.';

  // Benefit lines (icon supplied by PaywallScreen)
  static const String benefit1 =
      'All breathing patterns and grounding techniques';
  static const String benefit2 = 'Unlimited journaling with guided prompts';
  static const String benefit3 =
      'Full progress insights and pattern tracking';

  // Future preview (teal chip at bottom of benefits)
  static const String futurePreview =
      'Coming soon: AI companion, sleep stories, and full CBT lesson library';

  // ── Pricing ──────────────────────────────────────────────────────────────────
  // Annual: $34.99 / 12 = $2.916 → "$2.92/month"
  // Savings: ($4.99×12 − $34.99) / ($4.99×12) = 41.6 % → "Save 42 %"
  static const String annualPrice    = '\$34.99/year';
  static const String annualBadge    = 'Save 42%';
  static const String annualSubtext  = "That's \$2.92/month";
  static const String monthlyPrice   = '\$4.99/month';
  static const String monthlySubtext = 'Billed monthly';

  // Plan labels
  static const String planAnnual   = 'Annual';
  static const String planMonthly  = 'Monthly';

  // CTA
  static const String ctaButton = 'Start 7-day free trial';
  static const String ctaSubtextAnnual =
      'Free for 7 days, then \$34.99/year. Cancel anytime in Play Store.';
  static const String ctaSubtextMonthly =
      'Free for 7 days, then \$4.99/month. Cancel anytime in Play Store.';

  // Bottom links
  static const String restorePurchase = 'Restore purchase';
  static const String termsLink       = 'Terms';
  static const String privacyLink     = 'Privacy';

  // ── Paywall trigger messages (shown as bottom-sheet subtitle) ────────────────
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

  // Sandbox message
  static const String sandboxUnavailable =
      'Store products not yet active. Connect Play Console in Task 21.';
}
