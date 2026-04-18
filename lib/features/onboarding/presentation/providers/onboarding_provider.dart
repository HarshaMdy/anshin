// Riverpod provider for the onboarding flow.
//
// onboardingNotifierProvider  — holds in-progress answers + complete()
// kOnboardingCompleteKey      — SharedPreferences key written on finish
//
// Flow:
//   GateScreen → OnboardingA (setAnxietyType) → OnboardingB (setFrequency)
//     → OnboardingC (complete) → auth.refresh() → router sends to /home
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/presentation/providers/auth_provider.dart';

// ── Shared-Preferences key ────────────────────────────────────────────────────

const String kOnboardingCompleteKey = 'anshin_onboarding_complete';

// ── Draft model ───────────────────────────────────────────────────────────────

class OnboardingDraft {
  final String? anxietyType; // from screen 3a
  final String? frequency;   // from screen 3b

  const OnboardingDraft({this.anxietyType, this.frequency});

  OnboardingDraft copyWith({String? anxietyType, String? frequency}) =>
      OnboardingDraft(
        anxietyType: anxietyType ?? this.anxietyType,
        frequency: frequency ?? this.frequency,
      );
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class OnboardingNotifier extends Notifier<OnboardingDraft> {
  @override
  OnboardingDraft build() => const OnboardingDraft();

  void setAnxietyType(String value) =>
      state = state.copyWith(anxietyType: value);

  void setFrequency(String value) =>
      state = state.copyWith(frequency: value);

  /// Persists answers to Firestore, marks SP, then refreshes auth so the
  /// router redirect fires and sends the user to /home.
  Future<void> complete({
    required String userId,
    required bool reminderEnabled,
    String reminderTime = '20:00', // 'HH:mm'
  }) async {
    final fields = <String, dynamic>{
      'onboarding.completed': true,
      'onboarding.anxietyType': state.anxietyType ?? '',
      'onboarding.frequency': state.frequency ?? '',
    };

    if (reminderEnabled) {
      fields['notificationPreferences.enabled'] = true;
      fields['notificationPreferences.dailyTime'] = reminderTime;
    } else {
      fields['notificationPreferences.enabled'] = false;
    }

    // Firestore has offline persistence — write queues if offline and
    // applies when reconnected; call succeeds locally either way.
    await ref.read(userRepositoryProvider).update(userId, fields);

    // Local cache — used as a fast-path on next boot to skip Firestore fetch
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kOnboardingCompleteKey, true);

    // Refresh AuthNotifier so onboarding.completed == true propagates
    // to RouterNotifier → redirect to /home fires automatically.
    await ref.read(authProvider.notifier).refresh();
  }
}

final onboardingNotifierProvider =
    NotifierProvider<OnboardingNotifier, OnboardingDraft>(
  OnboardingNotifier.new,
);
