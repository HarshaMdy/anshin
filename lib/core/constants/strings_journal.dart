// Content Bible §9 — Journal full flow strings
class StringsJournal {
  StringsJournal._();

  // ─── Main journal screen ────────────────────────────────────────────────────
  static const String header = 'My journal';
  static const String emptyStateBody = "Nothing written yet. That's okay. Whenever you're ready.";
  static const String emptyStateCta = 'Write my first entry';

  // ─── Screen 9a — Mood picker ────────────────────────────────────────────────
  static const String moodPickerHeading = 'How are you feeling right now?';

  // ─── Screen 9b — Accomplishments ────────────────────────────────────────────
  static const String accomplishmentsHeading = 'Three things you accomplished today.';
  static const String accomplishmentsSub = 'Big or small. Getting out of bed counts.';

  // ─── Screen 9c — Release ────────────────────────────────────────────────────
  static const String releaseHeading = 'Is something weighing on you?';
  static const String releaseSub = 'Write it down and let it go. Nobody sees this but you.';

  // ─── Screen 9d — Gratitude ──────────────────────────────────────────────────
  static const String gratitudeHeading = 'What are you grateful for today?';
  static const String gratitudeSub = 'Even one small thing.';

  // ─── Screen 9e — Additional notes ───────────────────────────────────────────
  static const String notesHeading = 'Anything else on your mind?';
  static const String notesSub = 'Optional. Sometimes there\'s more to say.';

  // Shared button labels
  static const String buttonContinue = 'Continue';
  static const String buttonFinish = 'Finish';

  // ─── Screen 9f — Completion ─────────────────────────────────────────────────
  static const String completionPoints = '+5 mindfulness points';
  static const String completionSaved = 'Entry saved.';
  static const String completionDone = 'Done';
  static const String completionShare = 'Share';

  static const List<String> completionInsights = [
    'Journaling helps you process what happened and notice what\'s changing.',
    'Writing things down takes them out of the loop in your head.',
    'Tracking how you feel over time reveals patterns you can\'t see day-to-day.',
    'Even a few words count. Consistency matters more than length.',
    'You just did something most people avoid. That\'s worth recognizing.',
  ];

  // ─── Detail view ─────────────────────────────────────────────────────────────
  static const String deleteEntry = 'Delete this entry';
  static const String deleteConfirm = "Delete permanently? This can't be undone.";
  static const String deleteYes = 'Delete';
  static const String deleteCancel = 'Keep my entry';
}
