// Content Bible §6 — four breathing patterns
// isFree: true → available on free plan
// isFree: false → requires hasPremiumAccess (Runbook §5)
import '../../../core/constants/strings_breathing.dart';

// ─── Phase type ───────────────────────────────────────────────────────────────

enum BreathingPhaseType {
  inhale,     // lungs filling
  holdIn,     // hold at full capacity
  exhale,     // lungs emptying
  holdOut,    // hold at empty
}

// ─── Single phase (e.g. "inhale for 4 s") ────────────────────────────────────

class BreathingPhase {
  final BreathingPhaseType type;
  final int durationSeconds;

  const BreathingPhase({
    required this.type,
    required this.durationSeconds,
  });
}

// ─── Pattern model ────────────────────────────────────────────────────────────

class BreathingPattern {
  /// Firestore / SharedPreferences key: 'box' | '478' | 'sigh' | 'coherent'
  final String id;
  final String name;
  final String description;
  final List<BreathingPhase> phases;

  /// true = free tier; false = requires hasPremiumAccess
  final bool isFree;

  const BreathingPattern({
    required this.id,
    required this.name,
    required this.description,
    required this.phases,
    required this.isFree,
  });

  /// Total cycle length in seconds (e.g. box = 16 s, 4-7-8 = 19 s)
  int get cycleDuration =>
      phases.fold(0, (sum, phase) => sum + phase.durationSeconds);

  /// Human-readable phase summary — e.g. "4 · 4 · 4 · 4"
  String get phaseSummary =>
      phases.map((p) => '${p.durationSeconds}').join(' · ');

  // ─── Canonical catalogue (Content Bible §6) ────────────────────────────────

  static const List<BreathingPattern> all = [
    // Box breathing — FREE
    BreathingPattern(
      id: 'box',
      name: StringsBreathing.patternBoxName,
      description: StringsBreathing.patternBoxDesc,
      isFree: true,
      phases: [
        BreathingPhase(type: BreathingPhaseType.inhale,  durationSeconds: 4),
        BreathingPhase(type: BreathingPhaseType.holdIn,  durationSeconds: 4),
        BreathingPhase(type: BreathingPhaseType.exhale,  durationSeconds: 4),
        BreathingPhase(type: BreathingPhaseType.holdOut, durationSeconds: 4),
      ],
    ),

    // 4-7-8 — PREMIUM
    BreathingPattern(
      id: '478',
      name: StringsBreathing.pattern478Name,
      description: StringsBreathing.pattern478Desc,
      isFree: false,
      phases: [
        BreathingPhase(type: BreathingPhaseType.inhale,  durationSeconds: 4),
        BreathingPhase(type: BreathingPhaseType.holdIn,  durationSeconds: 7),
        BreathingPhase(type: BreathingPhaseType.exhale,  durationSeconds: 8),
      ],
    ),

    // Physiological sigh — PREMIUM
    // Two inhales (fill + top-up) then one long exhale — Stanford research
    BreathingPattern(
      id: 'sigh',
      name: StringsBreathing.patternSighName,
      description: StringsBreathing.patternSighDesc,
      isFree: false,
      phases: [
        BreathingPhase(type: BreathingPhaseType.inhale, durationSeconds: 2),
        BreathingPhase(type: BreathingPhaseType.inhale, durationSeconds: 1),
        BreathingPhase(type: BreathingPhaseType.exhale, durationSeconds: 6),
      ],
    ),

    // Coherent breathing — PREMIUM
    // 5 in + 5 out ≈ 6 breaths/min — aligns heart-rate variability
    BreathingPattern(
      id: 'coherent',
      name: StringsBreathing.patternCoherentName,
      description: StringsBreathing.patternCoherentDesc,
      isFree: false,
      phases: [
        BreathingPhase(type: BreathingPhaseType.inhale, durationSeconds: 5),
        BreathingPhase(type: BreathingPhaseType.exhale, durationSeconds: 5),
      ],
    ),
  ];

  /// Look up a pattern by id; returns box as safe fallback.
  static BreathingPattern byId(String id) =>
      all.firstWhere((p) => p.id == id, orElse: () => all.first);
}
