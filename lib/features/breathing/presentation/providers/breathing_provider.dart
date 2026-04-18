// Riverpod providers for breathing preferences
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/breathing_pattern.dart';

// ─── Read-only derived providers ─────────────────────────────────────────────

/// All 4 patterns — static catalogue, never changes at runtime
final breathingPatternsProvider = Provider<List<BreathingPattern>>(
  (_) => BreathingPattern.all,
);

/// Currently-selected pattern id, driven by UserModel.settings.breathingPreference
final selectedPatternIdProvider = Provider<String>((ref) {
  final auth = ref.watch(authProvider).valueOrNull;
  if (auth is AuthAuthenticated) {
    return auth.user.settings.breathingPreference;
  }
  return 'box'; // safe fallback before auth resolves
});

/// Convenience: the full BreathingPattern for the selected id
final selectedPatternProvider = Provider<BreathingPattern>((ref) {
  final id = ref.watch(selectedPatternIdProvider);
  return BreathingPattern.byId(id);
});

// ─── Write: save preference to Firestore ─────────────────────────────────────

/// Call `.save(patternId)` from any screen to persist the user's choice.
/// Uses Firestore dot-notation to update the nested settings field without
/// overwriting other user settings.
final breathingPreferenceNotifierProvider =
    NotifierProvider<BreathingPreferenceNotifier, void>(
  BreathingPreferenceNotifier.new,
);

class BreathingPreferenceNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<void> save(String patternId) async {
    final auth = ref.read(authProvider).valueOrNull;
    if (auth is! AuthAuthenticated) return;

    // Firestore dot-notation: updates only settings.breathingPreference,
    // leaving all other settings fields untouched
    await ref.read(userRepositoryProvider).update(
      auth.user.userId,
      {'settings.breathingPreference': patternId},
    );

    // Re-fetch the user doc so all providers derived from authProvider
    // immediately reflect the new preference
    await ref.read(authProvider.notifier).refresh();
  }
}
