// Riverpod notifier for persisted user settings (audio, haptics, notifications).
// Uses Firestore dot-notation so each field update is surgical — other
// nested settings fields are never overwritten.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/notification_provider.dart';
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

  // ── Notification setters ─────────────────────────────────────────────────

  Future<void> setReminderEnabled(bool value) async {
    await _update({'notificationPreferences.enabled': value});
    final svc = ref.read(notificationServiceProvider);
    if (value) {
      final auth2 = ref.read(authProvider).valueOrNull;
      if (auth2 is AuthAuthenticated) {
        final parts = auth2.user.notificationPreferences.dailyTime.split(':');
        await svc.scheduleDailyReminder(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } else {
      await svc.cancelDailyReminder();
    }
  }

  Future<void> setReminderTime(String timeStr) async {
    await _update({'notificationPreferences.dailyTime': timeStr});
    final auth2 = ref.read(authProvider).valueOrNull;
    if (auth2 is! AuthAuthenticated) return;
    if (auth2.user.notificationPreferences.enabled) {
      final parts = timeStr.split(':');
      await ref.read(notificationServiceProvider).scheduleDailyReminder(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
    }
  }

  Future<void> setPostSosEnabled(bool value) =>
      _update({'notificationPreferences.postSosEnabled': value});
}
