import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/gate_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/breathing/presentation/screens/breathing_picker_screen.dart';
import '../features/daily/presentation/screens/checkin_screen.dart';
import '../features/grounding/presentation/screens/grounding_picker_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/journal/presentation/screens/journal_entry_screen.dart';
import '../features/journal/presentation/screens/journal_home_screen.dart';
import '../features/learn/presentation/screens/learn_home_screen.dart';
import '../features/learn/presentation/screens/lesson_detail_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_a_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_b_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_c_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/progress/presentation/screens/progress_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/sleep/presentation/screens/sleep_home_screen.dart';
import '../features/sos/presentation/screens/post_session_screen.dart';
import '../features/sos/presentation/screens/sos_screen.dart';
import '../features/subscription/presentation/screens/paywall_screen.dart';
import '../features/tools/presentation/screens/tools_screen.dart';
import '../features/visualize/presentation/screens/visualize_home_screen.dart';
import 'app_routes.dart';
import 'router_notifier.dart';
import 'shell_scaffold.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      // ── Auth / launch ──────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.gate,
        builder: (_, _) => const GateScreen(),
      ),

      // ── Onboarding ────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.onboardingA,
        builder: (_, _) => const OnboardingAScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingB,
        builder: (_, _) => const OnboardingBScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingC,
        builder: (_, _) => const OnboardingCScreen(),
      ),

      // ── SOS (full-screen, no bottom nav) ───────────────────────────────────
      GoRoute(
        path: AppRoutes.sos,
        builder: (_, _) => const SosScreen(),
      ),
      GoRoute(
        path: AppRoutes.postSession,
        builder: (_, _) => const PostSessionScreen(),
      ),

      // ── Daily check-in ────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.checkin,
        builder: (_, _) => const CheckinScreen(),
      ),

      // ── Paywall (full-screen, no bottom nav) ──────────────────────────────
      GoRoute(
        path: AppRoutes.paywall,
        builder: (_, _) => const PaywallScreen(),
      ),

      // ── Breathing / Grounding ─────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.breathingPicker,
        builder: (_, _) => const BreathingPickerScreen(),
      ),
      GoRoute(
        path: AppRoutes.groundingPicker,
        builder: (_, _) => const GroundingPickerScreen(),
      ),

      // ── Journal ───────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.journalHome,
        builder: (_, _) => const JournalHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.journalEntry,
        builder: (_, _) => const JournalEntryScreen(),
      ),

      // ── Learn ─────────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.learnHome,
        builder: (_, _) => const LearnHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.lessonDetail,
        builder: (_, state) => LessonDetailScreen(
          lessonId: state.pathParameters['lessonId'] ?? '',
        ),
      ),

      // ── Coming soon ───────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.visualizeHome,
        builder: (_, _) => const VisualizeHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.sleepHome,
        builder: (_, _) => const SleepHomeScreen(),
      ),

      // ── Settings ──────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, _) => const SettingsScreen(),
      ),

      // ── Bottom-nav shell ──────────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => ShellScaffold(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (_, _) => const HomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.tools,
              builder: (_, _) => const ToolsScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.progress,
              builder: (_, _) => const ProgressScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (_, _) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
});
