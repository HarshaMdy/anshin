// Content Bible §3 — Onboarding strings (3 screens)
class StringsOnboarding {
  StringsOnboarding._();

  // ─── Screen 3a — What brings you here? ──────────────────────────────────────
  static const String screen1Heading = 'What brings you to Anshin?';
  static const String option1PanicAttacks = 'Panic attacks';
  static const String option1Anxiety = "Anxiety that won't quiet down";
  static const String option1Sleep = 'Trouble sleeping';
  static const String option1Stress = "Stress I can't shake";
  static const String option1Exploring = 'Just exploring';

  static const List<String> screen1Options = [
    option1PanicAttacks,
    option1Anxiety,
    option1Sleep,
    option1Stress,
    option1Exploring,
  ];

  // ─── Screen 3b — How often? ──────────────────────────────────────────────────
  static const String screen2Heading = 'How often does this happen?';
  static const String option2EveryDay = 'Every day or almost';
  static const String option2FewTimes = 'A few times a week';
  static const String option2OnceAWeek = 'Once a week or so';
  static const String option2Rarely = "Rarely — but it's intense";
  static const String option2BrandNew = 'This is brand new for me';

  static const List<String> screen2Options = [
    option2EveryDay,
    option2FewTimes,
    option2OnceAWeek,
    option2Rarely,
    option2BrandNew,
  ];

  // ─── Screen 3c — Daily reminder ─────────────────────────────────────────────
  static const String screen3Heading = 'Want a daily check-in reminder?';
  static const String screen3Sub =
      'One gentle nudge per day. You pick the time. Nothing more.';
  static const String screen3SetButton = 'Set reminder';
  static const String screen3SkipButton = 'Not right now';

  // Shared
  static const String continueButton = 'Continue';
  static const String skipLink = 'Skip for now';
}
