// Content Bible §1 — Mascot emotion labels and descriptions
class StringsMascot {
  StringsMascot._();

  // Labels shown below mascot in journal picker
  static const String emotionCalm = 'Calm';
  static const String emotionAnxious = 'Anxious';
  static const String emotionPanicked = 'Panicked';
  static const String emotionSad = 'Sad';
  static const String emotionTired = 'Tired';
  static const String emotionOverwhelmed = 'Overwhelmed';
  static const String emotionHopeful = 'Hopeful';
  static const String emotionRelieved = 'Relieved';
  static const String emotionGrateful = 'Grateful';
  static const String emotionFrustrated = 'Frustrated';
  static const String emotionNumb = 'Numb';
  static const String emotionProud = 'Proud';

  // Descriptions (shown on tap/long-press in journal picker)
  static const String descCalm = "I'm okay right now";
  static const String descAnxious = 'Something feels off';
  static const String descPanicked = "I'm really scared";
  static const String descSad = "I'm hurting today";
  static const String descTired = "I'm running on empty";
  static const String descOverwhelmed = "There's too much right now";
  static const String descHopeful = 'Maybe things are shifting';
  static const String descRelieved = "It passed. I'm okay.";
  static const String descGrateful = 'I notice something good';
  static const String descFrustrated = 'Nothing seems to work';
  static const String descNumb = "I don't feel much";
  static const String descProud = 'I showed up today';

  // Ordered list for grid rendering (4×3)
  static const List<String> allLabels = [
    emotionCalm,
    emotionAnxious,
    emotionPanicked,
    emotionSad,
    emotionTired,
    emotionOverwhelmed,
    emotionHopeful,
    emotionRelieved,
    emotionGrateful,
    emotionFrustrated,
    emotionNumb,
    emotionProud,
  ];

  static const List<String> allDescriptions = [
    descCalm,
    descAnxious,
    descPanicked,
    descSad,
    descTired,
    descOverwhelmed,
    descHopeful,
    descRelieved,
    descGrateful,
    descFrustrated,
    descNumb,
    descProud,
  ];
}
