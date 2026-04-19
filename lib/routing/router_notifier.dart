import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import 'app_routes.dart';

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  // Set to true the first time authProvider emits AuthAuthenticated.
  // After that, any loading state (AsyncLoading *or* AsyncData(AuthLoading()))
  // is a background refresh — we must NOT bounce the user to splash/home.
  //
  // Why two loading flavours?
  //   • AsyncLoading<AuthState>   → Riverpod's own loading wrapper (initial build)
  //   • AsyncData(AuthLoading())  → what AuthNotifier.refresh() sets explicitly:
  //       state = const AsyncData(AuthLoading());
  //       state = AsyncData(await _initialise());
  //     In this case authAsync.isLoading is false, but authState IS AuthLoading.
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

    // ── Riverpod-level loading (initial build) ───────────────────────────────
    if (authAsync.isLoading) {
      if (_hasAuthenticatedOnce) return null; // background refresh — hold
      return location == AppRoutes.splash ? null : AppRoutes.splash;
    }

    final authState = authAsync.valueOrNull;

    // ── Inner AuthLoading (from AuthNotifier.refresh()) or null ─────────────
    // refresh() sets state = AsyncData(AuthLoading()), so authAsync.isLoading
    // is false here but authState IS AuthLoading.  Must guard the same way.
    if (authState == null || authState is AuthLoading) {
      if (_hasAuthenticatedOnce) return null; // background refresh — hold
      return location == AppRoutes.splash ? null : AppRoutes.splash;
    }

    // ── Permanent error ───────────────────────────────────────────────────────
    if (authState is AuthError) {
      return location == AppRoutes.splash ? null : AppRoutes.splash;
    }

    // ── Authenticated ─────────────────────────────────────────────────────────
    if (authState is AuthAuthenticated) {
      final onboardingDone = authState.user.onboarding.completed;

      // Leave splash once auth resolves
      if (location == AppRoutes.splash) {
        return onboardingDone ? AppRoutes.home : AppRoutes.gate;
      }

      // Onboarding-complete users on gate/onboarding → home
      final onOnboarding = location == AppRoutes.gate ||
          location.startsWith('/onboarding');
      if (onOnboarding && onboardingDone) return AppRoutes.home;

      // Incomplete-onboarding users must stay in gate/onboarding.
      // inShell reflects the current 4-tab layout:
      //   Home | Journal | Progress | Settings
      final inShell = location == AppRoutes.home ||
          location == AppRoutes.journalHome ||
          location == AppRoutes.progress ||
          location == AppRoutes.settings;
      if (inShell && !onboardingDone) return AppRoutes.gate;
    }

    return null;
  }
}
