// Content Bible §5 — SOS / Panic mode strings
class StringsSos {
  StringsSos._();

  // Active screen — breathing phase text (also spoken via TTS)
  static const String phaseInhale = 'Breathe in';
  static const String phaseHoldAfterInhale = 'Hold';
  static const String phaseExhale = 'Breathe out';
  static const String phaseHoldAfterExhale = 'Hold';

  // 60-second soft prompt
  static const String prompt60s = 'Want to try a grounding exercise?';
  static const String prompt60sYes = 'Yes';
  static const String prompt60sKeepBreathing = 'Keep breathing';

  // 90-second feeling check
  static const String prompt90s = 'How are you feeling?';
  static const String prompt90sBetter = 'Better';
  static const String prompt90sSame = 'About the same';
  static const String prompt90sWorse = 'Worse';

  // Transition to grounding when "Worse"
  static const String transitionToGrounding = "Let's try something different.";
}
