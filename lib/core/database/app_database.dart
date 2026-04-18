// Drift/SQLite local database — source of truth for all session data.
// Schema v1: sos_episodes + grounding_sessions.
// NativeDatabase uses the bundled SQLite (sqlite3_flutter_libs) for reliability.
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ── Tables ────────────────────────────────────────────────────────────────────

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

@DriftDatabase(tables: [SosEpisodes, GroundingSessions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor for unit tests — pass an in-memory executor directly.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

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
