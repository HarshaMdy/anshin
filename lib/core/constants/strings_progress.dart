// Content Bible §11 — Progress screen strings
class StringsProgress {
  StringsProgress._();

  static const String tabLabel = 'Progress';

  // Chart labels
  static const String moodChartLabel = "How you've been feeling";
  static const String anxietyChartLabel = 'Anxiety levels';

  // Stats row
  static const String statsSosLabel = 'SOS uses';
  static const String statsSessionsLabel = 'Sessions';
  static const String statsJournalLabel = 'Journal entries';

  // Streak section
  static String streakDays(int n) => '$n days in a row';
  static const String streakZero = 'Start fresh today.';
  static const String streakOne = "Day 1. That's all it takes.";
  static const String streakSeven = 'One full week.';
  static const String streakThirty = 'A whole month. Look at that.';

  // Insufficient data state (< 7 days)
  static const String insufficientDataBody =
      'Keep going. Your patterns will appear after a week of check-ins.';

  // Premium insights (rule-based templates — filled dynamically)
  static const String insightSosPattern =
      'You used SOS {count} times this week — {frequency} on {day}. Notice a pattern?';
  static const String insightJournalAnxiety =
      'Your anxiety has been lower on days you journaled.';
  static const String insightConsistency =
      "You've been checking in every day for {days} days. Consistency builds resilience.";
  static const String insightHarderWeek =
      "This week was harder than last week. That happens. It doesn't mean you're going backward.";
  static const String insightAvgDropped =
      'Your average anxiety dropped from {from} to {to} over the past {weeks} weeks.';
  static const String insightNoSos =
      "You haven't used SOS in {days} days. That's progress, even if it doesn't feel like it.";
  static const String insightMornings =
      'Mornings seem harder for you. Want to set a morning breathing reminder?';
  static const String insightSleep =
      'Sleep-tagged days tend to have higher anxiety. Worth exploring in your journal.';
}
