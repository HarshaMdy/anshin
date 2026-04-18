// All route paths in one place — avoids magic strings throughout the codebase
abstract final class AppRoutes {
  // ─── Auth / launch ────────────────────────────────────────────────────────
  static const splash = '/splash';
  static const gate = '/gate';          // first-launch decision gate

  // ─── Onboarding ───────────────────────────────────────────────────────────
  static const onboardingA = '/onboarding/a';
  static const onboardingB = '/onboarding/b';
  static const onboardingC = '/onboarding/c';

  // ─── SOS (full-screen, no bottom nav) ────────────────────────────────────
  static const sos = '/sos';
  static const postSession = '/post-session';

  // ─── Daily check-in (pushed over home) ───────────────────────────────────
  static const checkin = '/checkin';

  // ─── Bottom-nav shell tabs ────────────────────────────────────────────────
  static const home = '/home';
  static const tools = '/tools';
  static const progress = '/progress';
  static const profile = '/profile';

  // ─── Breathing (accessible from tools tab + SOS) ─────────────────────────
  static const breathingPicker = '/breathing';

  // ─── Grounding (accessible from tools tab + SOS) ─────────────────────────
  static const groundingPicker = '/grounding';
  static const groundingSession = '/grounding/:techniqueId'; // param: techniqueId
  static String groundingSessionPath(String id) => '/grounding/$id';

  // ─── Journal ─────────────────────────────────────────────────────────────
  static const journalHome = '/journal';
  static const journalEntry = '/journal/entry';

  // ─── Learn ───────────────────────────────────────────────────────────────
  static const learnHome = '/learn';
  static const lessonDetail = '/learn/:lessonId'; // param: lessonId
  static String lessonDetailPath(String id) => '/learn/$id';

  // ─── Coming soon (V1.2) ───────────────────────────────────────────────────
  static const visualizeHome = '/visualize';
  static const sleepHome = '/sleep';

  // ─── Paywall (full-screen, no bottom nav) ─────────────────────────────────
  static const paywall = '/paywall';

  // ─── Settings (from profile tab) ─────────────────────────────────────────
  static const settings = '/settings';
}
