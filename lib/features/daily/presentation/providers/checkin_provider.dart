// Riverpod providers for the daily check-in feature.
//
// checkinRepositoryProvider — wired to the Drift DB + Firestore
// todayCheckinProvider      — FutureProvider<DailyCheckinRow?>; null = not yet logged today
// checkinNotifierProvider   — submit handler; invalidates todayCheckinProvider on success
// checkinSyncProvider       — startup sync for unsynced rows (watches authProvider)
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../activity_log/presentation/providers/activity_log_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/checkin_repository.dart';

// ── Repository ────────────────────────────────────────────────────────────────

final checkinRepositoryProvider = Provider<CheckinRepository>((ref) {
  return CheckinRepository(db: ref.watch(appDatabaseProvider));
});

// ── Today's check-in ──────────────────────────────────────────────────────────
// null  → user has not checked in today
// row   → check-in exists; use .mood / .anxiety / .tags

final todayCheckinProvider = FutureProvider<DailyCheckinRow?>((ref) async {
  final auth = ref.watch(authProvider).valueOrNull;
  if (auth is! AuthAuthenticated) return null;
  return ref
      .read(checkinRepositoryProvider)
      .getTodayCheckin(auth.user.userId);
});

// ── Submit notifier ───────────────────────────────────────────────────────────

class CheckinNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> save(
    String userId,
    int mood,
    int anxiety,
    List<String> tags,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(checkinRepositoryProvider)
          .saveCheckin(userId, mood, anxiety, tags);
      // Refresh the home screen today card
      ref.invalidate(todayCheckinProvider);
    });
  }
}

final checkinNotifierProvider =
    AsyncNotifierProvider<CheckinNotifier, void>(CheckinNotifier.new);

// ── Startup sync ──────────────────────────────────────────────────────────────
// Watch this alongside activityLogSyncProvider so unsynced checkins from
// offline sessions are pushed to Firestore on the next app launch.

final checkinSyncProvider = FutureProvider<void>((ref) async {
  final auth = await ref.watch(authProvider.future);
  if (auth is AuthAuthenticated) {
    await ref
        .read(checkinRepositoryProvider)
        .syncPending(auth.user.userId);
  }
});
