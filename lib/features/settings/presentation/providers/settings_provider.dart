// Riverpod notifier for persisted user settings (audio, haptics, etc.)
// Uses Firestore dot-notation so each field update is surgical — other
// nested settings fields are never overwritten.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final settingsNotifierProvider =
    NotifierProvider<SettingsNotifier, void>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<void> {
  @override
  void build() {}

  // ── Internal helper ───────────────────────────────────────────────────────

  Future<void> _update(Map<String, dynamic> fields) async {
    final auth = ref.read(authProvider).valueOrNull;
    if (auth is! AuthAuthenticated) return;

    await ref
        .read(userRepositoryProvider)
        .update(auth.user.userId, fields);

    // Re-fetch user doc so all authProvider-derived providers stay in sync
    await ref.read(authProvider.notifier).refresh();
  }

  // ── Public setters ────────────────────────────────────────────────────────

  Future<void> setVoiceCues(bool value) =>
      _update({'settings.voiceCues': value});

  Future<void> setHapticOn(bool value) =>
      _update({'settings.hapticOn': value});
}
