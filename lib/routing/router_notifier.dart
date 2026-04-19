import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import 'app_routes.dart';

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  // True once we have seen an AuthAuthenticated state at least once.
  // Used to distinguish "initial auth loading" from "background refresh"
  // (e.g. after saving settings). During a background refresh we must NOT
  // redirect — the user should stay exactly where they are.
  bool _hasAuthenticatedOnce = false;

  RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<AuthState>>(authProvider, (_, next) {
      if (next.valueOrNull is AuthAuthenticated) {
        _hasAuthenticatedOnce = true;
      }
      notifyListeners();
    });
  }

  String? redirect(BuildContext context, dynamic state) {
    final location = state.matchedLocation as String;
    final authAsync = _ref.read(authProvider);

    // ── Loading ─────────────────────────────────────────────────────────────
    // If we have already been authenticated (e.g. user is on Settings and
    // toggles a switch which calls authProvider.notifier.refresh()), the
    // loading state is a background refresh — hold position, do NOT bounce to
    // splash/home. Only redirect to splash on the very first load.
    if (authAsync.isLoading) {
      if (_hasAuthenticatedOnce) return null;
      return location == AppRoutes.splash ? null : AppRoutes.splash;
    }

    final authState = authAsync.valueOrNull;

    if (authState == null || authState is AuthLoading) {
      return location == AppRoutes.splash ? null : AppRoutes.splash;
    }

    if (authState is AuthError) {
      return location == AppRoutes.splash ? null : AppRoutes.splash;
    }

    if (authState is AuthAuthenticated) {
      final onboardingDone = authState.user.onboarding.completed;

      // Leave the splash screen once auth is ready
      if (location == AppRoutes.splash) {
        return onboardingDone ? AppRoutes.home : AppRoutes.gate;
      }

      // Onboarding-complete users who somehow land on gate/onboarding → home
      final onOnboarding = location == AppRoutes.gate ||
          location.startsWith('/onboarding');
      if (onOnboarding && onboardingDone) return AppRoutes.home;

      // Incomplete-onboarding users must stay in gate/onboarding.
      // inShell reflects the current 4-tab layout: Home | Journal | Progress | Settings
      final inShell = location == AppRoutes.home ||
          location == AppRoutes.journalHome ||
          location == AppRoutes.progress ||
          location == AppRoutes.settings;
      if (inShell && !onboardingDone) return AppRoutes.gate;
    }

    return null;
  }
}
