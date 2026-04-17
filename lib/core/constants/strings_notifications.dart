// Content Bible §14 — Notification strings
class StringsNotifications {
  StringsNotifications._();

  // Daily check-in reminders (rotated)
  static const List<String> dailyReminders = [
    "How's today?",
    'Quick check-in — how are you doing?',
    'A minute to check in with yourself.',
    'End of day. How did it go?',
    'Checking in. No wrong answers.',
    "How's the anxiety today?",
    'Time for your daily check-in.',
    'Take 15 seconds. How are you?',
    'Evening check-in. How was today?',
    'Just a moment for yourself.',
  ];

  // Re-engagement (after 7 days inactive — sent once, then 21-day silence)
  static const String reengagement =
      "It's been a few days. Anshin is here whenever you need it.";

  // Post-SOS follow-up (4 hours after SOS session, max once per day)
  static const String postSosFollowUp = 'You used SOS earlier. How are you doing now?';

  // Streak milestone
  static String streakMilestone(int days) => '$days days in a row. Consistency matters.';
}
