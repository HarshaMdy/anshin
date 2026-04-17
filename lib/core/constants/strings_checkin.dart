// Content Bible §10 — Daily check-in strings
class StringsCheckin {
  StringsCheckin._();

  static const String heading = "How's today?";

  // Mood scale labels (1–5, shown below mascot expressions)
  static const String mood1Label = 'Struggling';
  static const String mood2Label = 'Rough';
  static const String mood3Label = 'Okay';
  static const String mood4Label = 'Good';
  static const String mood5Label = 'Great';

  // Anxiety slider
  static const String anxietySliderLabel = 'Anxiety level';
  static const String anxietyLow = 'Low';
  static const String anxietyHigh = 'High';

  // Optional tag chips
  static const String tagsLabel = "What's on your mind?";
  static const String tagWork = 'Work';
  static const String tagSleep = 'Sleep';
  static const String tagRelationship = 'Relationship';
  static const String tagHealth = 'Health';
  static const String tagMoney = 'Money';
  static const String tagNothing = 'Nothing specific';

  static const List<String> allTags = [
    tagWork,
    tagSleep,
    tagRelationship,
    tagHealth,
    tagMoney,
    tagNothing,
  ];

  // Save / confirmation
  static const String saveButton = 'Save';
  static const String savedConfirmation = 'Logged.';
}
