// Riverpod providers for the local DB + activity log.
// appDatabaseProvider    — singleton Drift database (closed on dispose)
// activityLogRepositoryProvider — repository wired to DB + Firestore
// activityLogSyncProvider — FutureProvider that syncs pending rows whenever
//                           the auth state resolves to an authenticated user
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/activity_log_repository.dart';

// ── Drift database singleton ──────────────────────────────────────────────────

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

// ── Repository ────────────────────────────────────────────────────────────────

final activityLogRepositoryProvider = Provider<ActivityLogRepository>((ref) {
  return ActivityLogRepository(db: ref.watch(appDatabaseProvider));
});

// ── Startup / reconnect sync ──────────────────────────────────────────────────
// Watches authProvider so it re-fires whenever the user signs in.
// Pushes any rows that are synced=false to Firestore.
// Watch this in the app shell (HomeScreen) to trigger it on launch.

final activityLogSyncProvider = FutureProvider<void>((ref) async {
  final auth = await ref.watch(authProvider.future);
  if (auth is AuthAuthenticated) {
    await ref
        .read(activityLogRepositoryProvider)
        .syncPending(auth.user.userId);
  }
});
