// Content Bible §4 — Home screen strings
class StringsHome {
  StringsHome._();

  // Greetings (time-based, no user name appended)
  static const String greetingMorning = 'Good morning';
  static const String greetingAfternoon = 'Good afternoon';
  static const String greetingEvening = 'Good evening';
  static const String greetingLateNight = "Late night? You're not alone.";

  // SOS button
  static const String sosButtonLabel = 'SOS';

  // Six section cards: title + sublabel
  static const String cardBreatheTitle = 'Breathe';
  static const String cardBreatheSub = 'Find your rhythm';

  static const String cardGroundTitle = 'Ground';
  static const String cardGroundSub = 'Come back to here';

  static const String cardJournalTitle = 'Journal';
  static const String cardJournalSub = 'Get it out of your head';

  static const String cardLearnTitle = 'Learn';
  static const String cardLearnSub = 'Understand what\'s happening';

  static const String cardVisualizeTitle = 'Visualize';
  static const String cardVisualizeSub = 'See a calmer place';

  static const String cardSleepTitle = 'Sleep';
  static const String cardSleepSub = 'Rest your mind';

  // Today card (contextual recommendation)
  static const String todayNoCheckin = "How's today? Tap to check in.";
  static const String todayHighAnxiety = 'Tough day. Want to try a breathing exercise?';
  static const String todayModerateAnxiety = 'A short grounding session might help settle things.';
  static const String todayLowAnxiety = 'Good day. Want to journal about it?';
  static const String todayPostSos = 'Earlier was hard. How are you doing now?';

  // Streak indicator
  static const String streakBroken = 'Welcome back.';
  static const String streakDayOne = "Day 1. That's all it takes.";

  static String streakActive(int days) => '$days days';

  // Checked-in confirmation pill
  static const String checkedInPill = '✓ Checked in';

  // First-launch decision gate (Content Bible §2)
  static const String firstLaunchPrimary = 'I need help right now';
  static const String firstLaunchSecondary = 'I have a moment to set up';
  static const String firstLaunchMicrocopy = 'No account needed. No payment. Just help.';
}
