import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import 'app_routes.dart';

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<AuthState>>(authProvider, (_, _) {
      notifyListeners();
    });
  }

  String? redirect(BuildContext context, dynamic state) {
    final location = state.matchedLocation as String;
    final authAsync = _ref.read(authProvider);

    // Auth still initialising — park on splash
    if (authAsync.isLoading) {
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

      // Incomplete-onboarding users must stay in gate/onboarding
      final inShell = location == AppRoutes.home ||
          location == AppRoutes.tools ||
          location == AppRoutes.progress ||
          location == AppRoutes.profile;
      if (inShell && !onboardingDone) return AppRoutes.gate;
    }

    return null;
  }
}
