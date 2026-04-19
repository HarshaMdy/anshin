// Riverpod providers for the Progress tab.
//
// windowDaysProvider    — StateProvider<int>: 7 (free) or 30 (premium)
// isPremiumProvider     — re-exported from subscription_provider
// progressRepositoryProvider
// progressDataProvider  — FutureProvider<ProgressData?>
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../activity_log/presentation/providers/activity_log_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../subscription/presentation/providers/subscription_provider.dart';
import '../../data/progress_repository.dart';

// isPremiumProvider is defined in subscription_provider — re-export for
// backward-compatibility with progress_screen.dart which already imports it
// from this file.
export '../../../subscription/presentation/providers/subscription_provider.dart'
    show isPremiumProvider;

// ── Period selection ──────────────────────────────────────────────────────────

/// 7 = free default; 30 = premium.  Resets to 7 when user is not premium.
final windowDaysProvider = StateProvider<int>((ref) {
  final premium = ref.watch(isPremiumProvider);
  return premium ? 7 : 7; // always start at 7; premium may raise to 30
});

// ── Repository ────────────────────────────────────────────────────────────────

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(db: ref.watch(appDatabaseProvider));
});

// ── Data provider ─────────────────────────────────────────────────────────────

final progressDataProvider = FutureProvider<ProgressData?>((ref) async {
  final auth = ref.watch(authProvider).valueOrNull;
  if (auth is! AuthAuthenticated) return null;

  final days = ref.watch(windowDaysProvider);
  final isPremium = ref.watch(isPremiumProvider);

  return ref.read(progressRepositoryProvider).load(
        auth.user.userId,
        days: days,
        generateInsights: isPremium,
      );
});
