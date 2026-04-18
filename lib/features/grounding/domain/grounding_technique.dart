// Content Bible §7 — four grounding techniques, all text from local constants.
// steps[0] is always the intro; steps[1..N] are the numbered prompts.
// isFree: true = available on free plan (Five Senses only).
import '../../../core/constants/strings_grounding.dart';

class GroundingTechnique {
  /// Stable id used in GoRouter path params and analytics.
  final String id;
  final String title;

  /// Ordered list of full-screen prompts.
  /// Index 0 = intro paragraph, 1..N = numbered steps.
  final List<String> steps;

  /// Shown on the completion + feeling-check screen.
  final String completion;

  final bool isFree;

  const GroundingTechnique({
    required this.id,
    required this.title,
    required this.steps,
    required this.completion,
    required this.isFree,
  });

  // ── Catalogue (Content Bible §7) ─────────────────────────────────────────

  static const List<GroundingTechnique> all = [
    // ── Five Senses (5-4-3-2-1) — FREE ──────────────────────────────────────
    GroundingTechnique(
      id: 'fiveSenses',
      title: StringsGrounding.fiveSensesTitle,
      isFree: true,
      completion: StringsGrounding.fiveSensesCompletion,
      steps: [
        StringsGrounding.fiveSensesIntro,
        StringsGrounding.fiveSensesScreen1,
        StringsGrounding.fiveSensesScreen2,
        StringsGrounding.fiveSensesScreen3,
        StringsGrounding.fiveSensesScreen4,
        StringsGrounding.fiveSensesScreen5,
      ],
    ),

    // ── Body Scan — PREMIUM ──────────────────────────────────────────────────
    GroundingTechnique(
      id: 'bodyScan',
      title: StringsGrounding.bodyScanTitle,
      isFree: false,
      completion: StringsGrounding.bodyScanCompletion,
      steps: [
        StringsGrounding.bodyScanIntro,
        StringsGrounding.bodyScanScreen1,
        StringsGrounding.bodyScanScreen2,
        StringsGrounding.bodyScanScreen3,
        StringsGrounding.bodyScanScreen4,
        StringsGrounding.bodyScanScreen5,
        StringsGrounding.bodyScanScreen6,
      ],
    ),

    // ── Cold Water Reset — PREMIUM ───────────────────────────────────────────
    GroundingTechnique(
      id: 'coldWater',
      title: StringsGrounding.coldWaterTitle,
      isFree: false,
      completion: StringsGrounding.coldWaterCompletion,
      steps: [
        StringsGrounding.coldWaterIntro,
        StringsGrounding.coldWaterScreen1,
        StringsGrounding.coldWaterScreen2,
        StringsGrounding.coldWaterScreen3,
      ],
    ),

    // ── Movement Reset — PREMIUM ─────────────────────────────────────────────
    GroundingTechnique(
      id: 'movement',
      title: StringsGrounding.movementTitle,
      isFree: false,
      completion: StringsGrounding.movementCompletion,
      steps: [
        StringsGrounding.movementIntro,
        StringsGrounding.movementScreen1,
        StringsGrounding.movementScreen2,
        StringsGrounding.movementScreen3,
        StringsGrounding.movementScreen4,
        StringsGrounding.movementScreen5,
      ],
    ),
  ];

  /// Safe lookup — returns Five Senses as fallback.
  static GroundingTechnique byId(String id) =>
      all.firstWhere((t) => t.id == id, orElse: () => all.first);
}
