// Check-in repository — SQLite is the source of truth; Firestore is synced
// in the background.  Works fully offline; unsynced rows are retried by
// syncPending() on app launch / auth change.
import 'dart:async' show unawaited;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart' show Value;

import '../../../core/database/app_database.dart';

class CheckinRepository {
  final AppDatabase _db;
  final FirebaseFirestore _firestore;

  CheckinRepository({
    required AppDatabase db,
    FirebaseFirestore? firestore,
  })  : _db = db,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // ── Helpers ───────────────────────────────────────────────────────────────

  static String _newUuid() =>
      '${DateTime.now().microsecondsSinceEpoch.toRadixString(16)}'
      '${Random().nextInt(0xFFFF).toRadixString(16).padLeft(4, '0')}';

  static String _dateKey(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-'
      '${dt.month.toString().padLeft(2, '0')}-'
      '${dt.day.toString().padLeft(2, '0')}';

  // ── Public API ────────────────────────────────────────────────────────────

  /// Saves (or replaces) today's check-in.  Returns without error even when
  /// the device is offline — Firestore sync is retried via [syncPending].
  Future<void> saveCheckin(
    String userId,
    int mood,
    int anxiety,
    List<String> tags,
  ) async {
    final date = _dateKey(DateTime.now());
    final existing = await _db.getDailyCheckinByDate(userId, date);
    final tagsStr = tags.where((t) => t.isNotEmpty).join(',');

    if (existing != null) {
      // Already checked in today — overwrite with latest values
      await _db.updateDailyCheckin(
        existing.uuid,
        DailyCheckinsCompanion(
          mood: Value(mood),
          anxiety: Value(anxiety),
          tags: Value(tagsStr),
          synced: const Value(false),
        ),
      );
      unawaited(_syncCheckin(userId, existing.uuid));
    } else {
      final uuid = _newUuid();
      await _db.insertDailyCheckin(DailyCheckinsCompanion.insert(
        uuid: uuid,
        userId: userId,
        date: date,
        mood: mood,
        anxiety: anxiety,
        tags: Value(tagsStr),
      ));
      unawaited(_syncCheckin(userId, uuid));
    }
  }

  /// Returns today's check-in for [userId], or null if not yet logged.
  Future<DailyCheckinRow?> getTodayCheckin(String userId) =>
      _db.getDailyCheckinByDate(userId, _dateKey(DateTime.now()));

  /// Pushes all unsynced check-ins to Firestore.  Called on app launch.
  Future<void> syncPending(String userId) async {
    final rows = await _db.unsyncedDailyCheckins(userId);
    for (final row in rows) {
      await _syncCheckin(userId, row.uuid);
    }
  }

  // ── Private sync ──────────────────────────────────────────────────────────

  Future<void> _syncCheckin(String userId, String uuid) async {
    try {
      final row = await _db.getDailyCheckinByUuid(uuid);
      if (row == null) return;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('checkins')
          .doc(row.date) // date string as doc ID — one doc per day
          .set({
        'uuid': row.uuid,
        'userId': row.userId,
        'date': row.date,
        'mood': row.mood,
        'anxiety': row.anxiety,
        'tags': row.tags.isEmpty
            ? <String>[]
            : row.tags.split(',').where((t) => t.isNotEmpty).toList(),
        'recordedAt': FieldValue.serverTimestamp(),
      });

      await _db.updateDailyCheckin(
        uuid,
        const DailyCheckinsCompanion(synced: Value(true)),
      );
    } catch (_) {
      // Device offline — row stays synced=false; retried on syncPending()
    }
  }
}
