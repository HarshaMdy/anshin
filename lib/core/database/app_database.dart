// Drift/SQLite local database — source of truth for all session data.
// Schema v1: sos_episodes + grounding_sessions.
// Schema v2: + daily_checkins.
// Schema v3: + journal_entries.
// NativeDatabase uses the bundled SQLite (sqlite3_flutter_libs) for reliability.
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ── Tables ────────────────────────────────────────────────────────────────────

/// One row per daily check-in (one per user per calendar date).
@DataClassName('DailyCheckinRow')
class DailyCheckins extends Table {
  @override
  String get tableName => 'daily_checkins';

  IntColumn get id => integer().autoIncrement()();

  // Hex UUID — Firestore document ID inside users/{uid}/checkins/
  TextColumn get uuid => text()();

  TextColumn get userId => text()();

  // 'YYYY-MM-DD' in local time — also the Firestore doc ID so one doc per day
  TextColumn get date => text()();

  // 1 = Struggling … 5 = Great (Content Bible §10 mood scale)
  IntColumn get mood => integer()();

  // 1 (low) … 10 (high) (Content Bible §10 anxiety slider)
  IntColumn get anxiety => integer()();

  // Comma-separated tag list (empty string = no tags)
  TextColumn get tags => text().withDefault(const Constant(''))();

  BoolColumn get synced =>
      boolean().withDefault(const Constant(false))();
}

/// One row per journal entry.  Text fields except [mood] are AES-256 encrypted
/// (stored as '{iv_base64}:{cipher_base64}'); [mood] is plaintext so the
/// calendar can show dots without decrypting.
@DataClassName('JournalEntryRow')
class JournalEntries extends Table {
  @override
  String get tableName => 'journal_entries';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text()();
  TextColumn get userId => text()();
  DateTimeColumn get createdAt => dateTime()();

  // One of the 12 emotion labels from StringsMascot — plaintext
  TextColumn get mood => text()();

  // AES-256-CBC encrypted — '{iv_base64}:{cipher_base64}'; empty = skipped
  TextColumn get accomplishments =>
      text().withDefault(const Constant(''))();
  TextColumn get release => text().withDefault(const Constant(''))();
  TextColumn get gratitude => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();

  BoolColumn get synced =>
      boolean().withDefault(const Constant(false))();
}

/// One row per SOS activation.
@DataClassName('SosEpisodeRow')
class SosEpisodes extends Table {
  @override
  String get tableName => 'sos_episodes';

  // Local auto-increment PK — never exposed outside the DB layer.
  IntColumn get id => integer().autoIncrement()();

  // Hex UUID used as the Firestore document ID.
  TextColumn get uuid => text()();

  TextColumn get userId => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get durationSeconds => integer().nullable()();

  // How the episode ended:
  // 'x_button' | 'better_90s' | 'same_90s' | 'worse_to_grounding' | 'grounding_60s'
  TextColumn get outcome => text().nullable()();

  BoolColumn get synced =>
      boolean().withDefault(const Constant(false))();
}

/// One row per grounding technique session.
@DataClassName('GroundingSessionRow')
class GroundingSessions extends Table {
  @override
  String get tableName => 'grounding_sessions';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text()();
  TextColumn get userId => text()();

  // 'fiveSenses' | 'bodyScan' | 'coldWater' | 'movement'
  TextColumn get techniqueId => text()();

  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  BoolColumn get completed =>
      boolean().withDefault(const Constant(false))();

  // 'better' | 'same' | 'worse' — null when abandoned mid-session
  TextColumn get feelingOutcome => text().nullable()();

  // UUID of the SOS episode that triggered this session, if any
  TextColumn get sosTriggerUuid => text().nullable()();

  BoolColumn get synced =>
      boolean().withDefault(const Constant(false))();
}

// ── Database ──────────────────────────────────────────────────────────────────

@DriftDatabase(tables: [JournalEntries, DailyCheckins, SosEpisodes, GroundingSessions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor for unit tests — pass an in-memory executor directly.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(dailyCheckins);
      }
      if (from < 3) {
        await m.createTable(journalEntries);
      }
    },
  );

  // ── Journal entry queries ─────────────────────────────────────────────────

  Future<void> insertJournalEntry(JournalEntriesCompanion entry) =>
      into(journalEntries).insert(entry);

  Future<void> updateJournalEntry(
    String uuid,
    JournalEntriesCompanion entry,
  ) =>
      (update(journalEntries)..where((t) => t.uuid.equals(uuid))).write(entry);

  Future<JournalEntryRow?> getJournalEntryByUuid(String uuid) =>
      (select(journalEntries)..where((t) => t.uuid.equals(uuid)))
          .getSingleOrNull();

  Future<List<JournalEntryRow>> journalEntriesForUser(String userId) =>
      (select(journalEntries)
            ..where((t) => t.userId.equals(userId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  /// Returns all entries for [userId] in [year]/[month] (1-indexed month).
  Future<List<JournalEntryRow>> journalEntriesForMonth(
    String userId,
    int year,
    int month,
  ) async {
    final start = DateTime(year, month);
    final end = DateTime(year, month + 1);
    return (select(journalEntries)
          ..where(
            (t) =>
                t.userId.equals(userId) &
                t.createdAt.isBiggerOrEqualValue(start) &
                t.createdAt.isSmallerThanValue(end),
          ))
        .get();
  }

  Future<int> countJournalEntries(String userId) async {
    final count = journalEntries.uuid.count();
    final query = selectOnly(journalEntries)
      ..addColumns([count])
      ..where(journalEntries.userId.equals(userId));
    return (await query.getSingle()).read(count) ?? 0;
  }

  Future<void> deleteJournalEntry(String uuid) =>
      (delete(journalEntries)..where((t) => t.uuid.equals(uuid))).go();

  Future<List<JournalEntryRow>> unsyncedJournalEntries(String userId) =>
      (select(journalEntries)
            ..where((t) => t.userId.equals(userId) & t.synced.equals(false)))
          .get();

  // ── Daily check-in queries ─────────────────────────────────────────────────

  Future<void> insertDailyCheckin(DailyCheckinsCompanion entry) =>
      into(dailyCheckins).insert(entry);

  Future<void> updateDailyCheckin(
    String uuid,
    DailyCheckinsCompanion entry,
  ) =>
      (update(dailyCheckins)..where((t) => t.uuid.equals(uuid))).write(entry);

  Future<DailyCheckinRow?> getDailyCheckinByUuid(String uuid) =>
      (select(dailyCheckins)..where((t) => t.uuid.equals(uuid)))
          .getSingleOrNull();

  /// Returns the check-in for [userId] on [date] ('YYYY-MM-DD'), or null.
  Future<DailyCheckinRow?> getDailyCheckinByDate(
    String userId,
    String date,
  ) =>
      (select(dailyCheckins)
            ..where((t) => t.userId.equals(userId) & t.date.equals(date)))
          .getSingleOrNull();

  Future<List<DailyCheckinRow>> unsyncedDailyCheckins(String userId) =>
      (select(dailyCheckins)
            ..where((t) => t.userId.equals(userId) & t.synced.equals(false)))
          .get();

  Future<List<DailyCheckinRow>> recentDailyCheckins(
    String userId,
    int limit,
  ) =>
      (select(dailyCheckins)
            ..where((t) => t.userId.equals(userId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)])
            ..limit(limit))
          .get();

  // ── SOS episode queries ────────────────────────────────────────────────────

  Future<void> insertSosEpisode(SosEpisodesCompanion entry) =>
      into(sosEpisodes).insert(entry);

  Future<void> updateSosEpisode(String uuid, SosEpisodesCompanion entry) =>
      (update(sosEpisodes)..where((t) => t.uuid.equals(uuid))).write(entry);

  Future<SosEpisodeRow?> getSosEpisodeByUuid(String uuid) =>
      (select(sosEpisodes)..where((t) => t.uuid.equals(uuid)))
          .getSingleOrNull();

  Future<List<SosEpisodeRow>> unsyncedSosEpisodes(String userId) =>
      (select(sosEpisodes)
            ..where((t) => t.userId.equals(userId) & t.synced.equals(false)))
          .get();

  Future<List<SosEpisodeRow>> recentSosEpisodes(String userId, int limit) =>
      (select(sosEpisodes)
            ..where((t) => t.userId.equals(userId))
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
            ..limit(limit))
          .get();

  // ── Grounding session queries ──────────────────────────────────────────────

  Future<void> insertGroundingSession(GroundingSessionsCompanion entry) =>
      into(groundingSessions).insert(entry);

  Future<void> updateGroundingSession(
    String uuid,
    GroundingSessionsCompanion entry,
  ) =>
      (update(groundingSessions)..where((t) => t.uuid.equals(uuid)))
          .write(entry);

  Future<GroundingSessionRow?> getGroundingSessionByUuid(String uuid) =>
      (select(groundingSessions)..where((t) => t.uuid.equals(uuid)))
          .getSingleOrNull();

  Future<List<GroundingSessionRow>> unsyncedGroundingSessions(
    String userId,
  ) =>
      (select(groundingSessions)
            ..where(
                (t) => t.userId.equals(userId) & t.synced.equals(false)))
          .get();

  Future<List<GroundingSessionRow>> recentGroundingSessions(
    String userId,
    int limit,
  ) =>
      (select(groundingSessions)
            ..where((t) => t.userId.equals(userId))
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
            ..limit(limit))
          .get();
}

// ── Connection factory ────────────────────────────────────────────────────────

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'anshin.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
