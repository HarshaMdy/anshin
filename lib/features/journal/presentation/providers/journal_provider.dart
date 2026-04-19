// Riverpod providers for the journal feature.
//
// journalRepositoryProvider   — wired to Drift DB + Firestore
// journalEntriesProvider      — FutureProvider<List<JournalEntryRow>>
// journalEntriesForMonthProvider — month-scoped list for calendar
// canCreateJournalEntryProvider  — false when free user has hit 30-entry cap
// journalEntryCountProvider   — current entry count (for cap display)
// journalNotifierProvider     — save / delete handler
// journalSyncProvider         — startup sync for unsynced rows
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../activity_log/presentation/providers/activity_log_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../subscription/presentation/providers/subscription_provider.dart';
import '../../data/journal_repository.dart';

// ── Repository ────────────────────────────────────────────────────────────────

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepository(db: ref.watch(appDatabaseProvider));
});

// ── Entry list ────────────────────────────────────────────────────────────────

final journalEntriesProvider =
    FutureProvider<List<JournalEntryRow>>((ref) async {
  final auth = ref.watch(authProvider).valueOrNull;
  if (auth is! AuthAuthenticated) return [];
  return ref
      .read(journalRepositoryProvider)
      .entriesForUser(auth.user.userId);
});

// ── Month-scoped entries (for calendar) ──────────────────────────────────────

final journalMonthProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);

final journalEntriesForMonthProvider =
    FutureProvider<List<JournalEntryRow>>((ref) async {
  final auth = ref.watch(authProvider).valueOrNull;
  if (auth is! AuthAuthenticated) return [];
  final month = ref.watch(journalMonthProvider);
  return ref
      .read(journalRepositoryProvider)
      .entriesForMonth(auth.user.userId, month.year, month.month);
});

// ── Selected calendar date (null = no date selected → show whole month) ──────

final journalSelectedDateProvider = StateProvider<DateTime?>((ref) => null);

// ── Entry date for new entries (null = use DateTime.now()) ───────────────────
// Set to the calendar-selected date before pushing to JournalEntryScreen so
// that entries written from a past date are correctly timestamped.
// Cleared by JournalEntryScreen after every save.

final journalEntryDateProvider = StateProvider<DateTime?>((ref) => null);

// ── Date-filtered entries (used by the entry list below the calendar) ─────────
// When a date is selected, returns only entries for that day.
// When null, returns all entries for the current month.

final journalEntriesForDateProvider =
    FutureProvider<List<JournalEntryRow>>((ref) async {
  final allEntries = await ref.watch(journalEntriesForMonthProvider.future);
  final selected   = ref.watch(journalSelectedDateProvider);
  if (selected == null) return allEntries;
  return allEntries
      .where((e) =>
          e.createdAt.year  == selected.year  &&
          e.createdAt.month == selected.month &&
          e.createdAt.day   == selected.day)
      .toList();
});

// ── Entry count + free cap ────────────────────────────────────────────────────

const int kFreeJournalEntryLimit = 30;

final journalEntryCountProvider = FutureProvider<int>((ref) async {
  final auth = ref.watch(authProvider).valueOrNull;
  if (auth is! AuthAuthenticated) return 0;
  // Invalidated after every save/delete by the notifier.
  ref.watch(journalEntriesProvider);
  return ref
      .read(journalRepositoryProvider)
      .entryCount(auth.user.userId);
});

/// True when the user may write a new entry.
/// Premium users have no cap; free users capped at 30 entries.
final canCreateJournalEntryProvider = FutureProvider<bool>((ref) async {
  final isPremium = ref.watch(isPremiumProvider);
  if (isPremium) return true; // unlimited for premium
  final count = await ref.watch(journalEntryCountProvider.future);
  return count < kFreeJournalEntryLimit;
});

// ── Notifier (save + delete) ──────────────────────────────────────────────────

class JournalNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> save({
    required String mood,
    required String accomplishments,
    required String release,
    required String gratitude,
    required String notes,
    DateTime? entryDate,
  }) async {
    final auth = ref.read(authProvider).valueOrNull;
    if (auth is! AuthAuthenticated) return null;

    state = const AsyncLoading();
    String? uuid;
    state = await AsyncValue.guard(() async {
      uuid = await ref.read(journalRepositoryProvider).saveEntry(
            userId: auth.user.userId,
            mood: mood,
            accomplishments: accomplishments,
            release: release,
            gratitude: gratitude,
            notes: notes,
            entryDate: entryDate,
          );
      ref.invalidate(journalEntriesProvider);
      ref.invalidate(journalEntryCountProvider);
      ref.invalidate(journalEntriesForMonthProvider);
    });
    return uuid;
  }

  Future<void> delete(String userId, String uuid) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(journalRepositoryProvider).deleteEntry(userId, uuid);
      ref.invalidate(journalEntriesProvider);
      ref.invalidate(journalEntryCountProvider);
      ref.invalidate(journalEntriesForMonthProvider);
    });
  }
}

final journalNotifierProvider =
    AsyncNotifierProvider<JournalNotifier, void>(JournalNotifier.new);

// ── Startup sync ──────────────────────────────────────────────────────────────

final journalSyncProvider = FutureProvider<void>((ref) async {
  final auth = await ref.watch(authProvider.future);
  if (auth is AuthAuthenticated) {
    await ref
        .read(journalRepositoryProvider)
        .syncPending(auth.user.userId);
  }
});
