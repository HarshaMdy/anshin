// Activity log repository — single write path for SOS + grounding events.
// Every write goes to SQLite first (offline-safe), then a fire-and-forget
// Firestore sync marks the row as synced=true.  Rows that fail to sync
// (device offline) stay synced=false and are retried via syncPending().
import 'dart:async' show unawaited;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart' show Value;

import '../../../core/database/app_database.dart';

class ActivityLogRepository {
  final AppDatabase _db;
  final FirebaseFirestore _firestore;

  ActivityLogRepository({
    required AppDatabase db,
    FirebaseFirestore? firestore,
  })  : _db = db,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // ── UUID ─────────────────────────────────────────────────────────────────

  static String _newUuid() =>
      '${DateTime.now().microsecondsSinceEpoch.toRadixString(16)}'
      '${Random().nextInt(0xFFFF).toRadixString(16).padLeft(4, '0')}';

  // ═══════════════════════════════════════════════════════════════════════════
  // SOS Episodes
  // ═══════════════════════════════════════════════════════════════════════════

  /// Writes a new in-progress episode to SQLite. Returns its UUID.
  Future<String> startSosEpisode(String userId) async {
    final uuid = _newUuid();
    await _db.insertSosEpisode(SosEpisodesCompanion.insert(
      uuid: uuid,
      userId: userId,
      startedAt: DateTime.now(),
    ));
    return uuid;
  }

  /// Closes the episode and fires a background sync to Firestore.
  ///
  /// [outcome] values: 'x_button' | 'better_90s' | 'same_90s' |
  ///                   'worse_to_grounding' | 'grounding_60s'
  Future<void> endSosEpisode(String uuid, String outcome) async {
    final row = await _db.getSosEpisodeByUuid(uuid);
    if (row == null) return;

    final now = DateTime.now();
    await _db.updateSosEpisode(
      uuid,
      SosEpisodesCompanion(
        endedAt: Value(now),
        durationSeconds: Value(now.difference(row.startedAt).inSeconds),
        outcome: Value(outcome),
        synced: const Value(false),
      ),
    );
    unawaited(_syncSosEpisode(row.userId, uuid));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Grounding Sessions
  // ═══════════════════════════════════════════════════════════════════════════

  /// Writes a new in-progress grounding session to SQLite. Returns its UUID.
  Future<String> startGroundingSession(
    String userId,
    String techniqueId, {
    String? sosTriggerUuid,
  }) async {
    final uuid = _newUuid();
    await _db.insertGroundingSession(GroundingSessionsCompanion.insert(
      uuid: uuid,
      userId: userId,
      techniqueId: techniqueId,
      startedAt: DateTime.now(),
      sosTriggerUuid: Value(sosTriggerUuid),
    ));
    return uuid;
  }

  /// Closes the grounding session and fires a background sync.
  ///
  /// [feelingOutcome] values: 'better' | 'same' | 'worse' | null (abandoned)
  Future<void> endGroundingSession(
    String uuid, {
    required bool completed,
    String? feelingOutcome,
  }) async {
    final row = await _db.getGroundingSessionByUuid(uuid);
    if (row == null) return;

    await _db.updateGroundingSession(
      uuid,
      GroundingSessionsCompanion(
        completedAt: Value(DateTime.now()),
        completed: Value(completed),
        feelingOutcome: Value(feelingOutcome),
        synced: const Value(false),
      ),
    );
    unawaited(_syncGroundingSession(row.userId, uuid));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Bulk pending sync — call on app launch / auth change
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> syncPending(String userId) async {
    await Future.wait([
      _syncPendingSosEpisodes(userId),
      _syncPendingGroundingSessions(userId),
    ]);
  }

  // ── Private sync helpers ──────────────────────────────────────────────────

  Future<void> _syncSosEpisode(String userId, String uuid) async {
    try {
      final row = await _db.getSosEpisodeByUuid(uuid);
      if (row == null) return;
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('sos_episodes')
          .doc(uuid)
          .set(_sosEpisodeToMap(row));
      await _db.updateSosEpisode(
        uuid,
        const SosEpisodesCompanion(synced: Value(true)),
      );
    } catch (_) {
      // Device offline — row stays synced=false; retried on syncPending()
    }
  }

  Future<void> _syncGroundingSession(String userId, String uuid) async {
    try {
      final row = await _db.getGroundingSessionByUuid(uuid);
      if (row == null) return;
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('grounding_sessions')
          .doc(uuid)
          .set(_groundingSessionToMap(row));
      await _db.updateGroundingSession(
        uuid,
        const GroundingSessionsCompanion(synced: Value(true)),
      );
    } catch (_) {
      // Device offline — retried on syncPending()
    }
  }

  Future<void> _syncPendingSosEpisodes(String userId) async {
    final rows = await _db.unsyncedSosEpisodes(userId);
    for (final row in rows) {
      await _syncSosEpisode(userId, row.uuid);
    }
  }

  Future<void> _syncPendingGroundingSessions(String userId) async {
    final rows = await _db.unsyncedGroundingSessions(userId);
    for (final row in rows) {
      await _syncGroundingSession(userId, row.uuid);
    }
  }

  // ── Serialization ─────────────────────────────────────────────────────────

  static Map<String, dynamic> _sosEpisodeToMap(SosEpisodeRow row) => {
        'uuid': row.uuid,
        'userId': row.userId,
        'startedAt': Timestamp.fromDate(row.startedAt),
        'endedAt':
            row.endedAt != null ? Timestamp.fromDate(row.endedAt!) : null,
        'durationSeconds': row.durationSeconds,
        'outcome': row.outcome,
      };

  static Map<String, dynamic> _groundingSessionToMap(
    GroundingSessionRow row,
  ) =>
      {
        'uuid': row.uuid,
        'userId': row.userId,
        'techniqueId': row.techniqueId,
        'startedAt': Timestamp.fromDate(row.startedAt),
        'completedAt': row.completedAt != null
            ? Timestamp.fromDate(row.completedAt!)
            : null,
        'completed': row.completed,
        'feelingOutcome': row.feelingOutcome,
        'sosTriggerUuid': row.sosTriggerUuid,
      };
}
