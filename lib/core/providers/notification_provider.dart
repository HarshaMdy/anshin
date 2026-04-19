// Notification provider — bridges NotificationService with Riverpod auth state.
//
// notificationServiceProvider  — singleton NotificationService instance
// notificationSetupProvider    — FutureProvider watched on home screen:
//     • re-applies daily reminder schedule from stored NotificationPreferences
//     • resets the 7-day re-engagement clock on every app open
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// Runs on every home-screen build (re-watches authProvider changes).
/// Re-schedules daily reminder and resets 7-day re-engagement timer.
final notificationSetupProvider = FutureProvider<void>((ref) async {
  final auth = await ref.watch(authProvider.future);
  if (auth is! AuthAuthenticated) return;

  final svc = ref.read(notificationServiceProvider);
  final prefs = auth.user.notificationPreferences;

  // Daily reminder
  if (prefs.enabled) {
    final parts = prefs.dailyTime.split(':');
    await svc.scheduleDailyReminder(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  } else {
    await svc.cancelDailyReminder();
  }

  // Reset re-engagement clock — user just opened the app
  await svc.resetReengagement();
});
