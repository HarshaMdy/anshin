// Content Bible §8 — Post-session strings
class StringsPostSession {
  StringsPostSession._();

  // Default main message
  static const String defaultMessage = "You did it. You're here.";

  // Rotating alternative messages (chosen randomly)
  static const List<String> rotatingMessages = [
    "You did it. You're here.",
    "Still here. Still breathing.",
    "That was hard. You stayed.",
    "It passed. It always does.",
    "Your body did its job. Now it's calming down.",
    "Nothing else to do right now.",
    "Take a second. There's no rush.",
    "You showed up for yourself just now.",
    "This moment is yours.",
    "The worst part is behind you.",
    "Breathe normally. You already are.",
    "You didn't run. That matters.",
    "Rest here as long as you need.",
    "You've survived every panic attack you've ever had. This one too.",
    "One breath at a time. You already know how.",
  ];

  // Three optional action cards
  static const String cardLog = 'Log this';
  static const String cardWrite = 'Write about it';
  static const String cardRest = 'Just rest';
}
