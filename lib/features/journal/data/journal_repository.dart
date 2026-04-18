// Journal repository — SQLite is source of truth; Firestore synced in background.
// Text fields (accomplishments, release, gratitude, notes) are encrypted before
// writing to SQLite; only metadata (mood, createdAt) is stored in plaintext so
// the calendar can render dots without decrypting.
import 'dart:async' show unawaited;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart' show Value;

import '../../../core/database/app_database.dart';
import '../../../core/services/journal_encryption_service.dart';

class JournalRepository {
  final AppDatabase _db;
  final FirebaseFirestore _firestore;

  JournalRepository({
    required AppDatabase db,
    FirebaseFirestore? firestore,
  })  : _db = db,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // ── Helpers ───────────────────────────────────────────────────────────────

  static String _newUuid() =>
      '${DateTime.now().microsecondsSinceEpoch.toRadixString(16)}'
      '${Random().nextInt(0xFFFF).toRadixString(16).padLeft(4, '0')}';

  JournalEncryptionService _enc(String userId) =>
      JournalEncryptionService(userId: userId);

  // ── Public API ────────────────────────────────────────────────────────────

  /// Saves a new journal entry.  Returns the new uuid.
  Future<String> saveEntry({
    required String userId,
    required String mood,
    required String accomplishments,
    required String release,
    required String gratitude,
    required String notes,
  }) async {
    final uuid = _newUuid();
    final enc = _enc(userId);
    await _db.insertJournalEntry(JournalEntriesCompanion.insert(
      uuid: uuid,
      userId: userId,
      createdAt: DateTime.now(),
      mood: mood,
      accomplishments: Value(enc.encrypt(accomplishments)),
      release: Value(enc.encrypt(release)),
      gratitude: Value(enc.encrypt(gratitude)),
      notes: Value(enc.encrypt(notes)),
    ));
    unawaited(_syncEntry(userId, uuid));
    return uuid;
  }

  /// Returns all entries for [userId] ordered newest-first.
  Future<List<JournalEntryRow>> entriesForUser(String userId) =>
      _db.journalEntriesForUser(userId);

  /// Returns all entries for [userId] in [year]/[month].
  Future<List<JournalEntryRow>> entriesForMonth(
    String userId,
    int year,
    int month,
  ) =>
      _db.journalEntriesForMonth(userId, year, month);

  /// Returns how many entries [userId] has saved.
  Future<int> entryCount(String userId) => _db.countJournalEntries(userId);

  /// Returns decrypted entry data, or null if uuid not found.
  Future<DecryptedJournalEntry?> getDecryptedEntry(
    String userId,
    String uuid,
  ) async {
    final row = await _db.getJournalEntryByUuid(uuid);
    if (row == null) return null;
    final enc = _enc(userId);
    return DecryptedJournalEntry(
      uuid: row.uuid,
      createdAt: row.createdAt,
      mood: row.mood,
      accomplishments: enc.decrypt(row.accomplishments),
      release: enc.decrypt(row.release),
      gratitude: enc.decrypt(row.gratitude),
      notes: enc.decrypt(row.notes),
    );
  }

  /// Permanently deletes an entry locally and from Firestore.
  Future<void> deleteEntry(String userId, String uuid) async {
    await _db.deleteJournalEntry(uuid);
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('journal_entries')
          .doc(uuid)
          .delete();
    } catch (_) {
      // Offline — Firestore doc stays orphaned; acceptable for a delete.
    }
  }

  /// Pushes all unsynced entries to Firestore.  Called on app launch.
  Future<void> syncPending(String userId) async {
    final rows = await _db.unsyncedJournalEntries(userId);
    for (final row in rows) {
      await _syncEntry(userId, row.uuid);
    }
  }

  // ── Private sync ──────────────────────────────────────────────────────────

  Future<void> _syncEntry(String userId, String uuid) async {
    try {
      final row = await _db.getJournalEntryByUuid(uuid);
      if (row == null) return;

      // Firestore stores encrypted blobs as-is; only mood + timestamp decoded.
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('journal_entries')
          .doc(uuid)
          .set({
        'uuid': row.uuid,
        'userId': row.userId,
        'createdAt': FieldValue.serverTimestamp(),
        'mood': row.mood,
        // encrypted blobs — Firestore keeps them opaque
        'accomplishments': row.accomplishments,
        'release': row.release,
        'gratitude': row.gratitude,
        'notes': row.notes,
      });

      await _db.updateJournalEntry(
        uuid,
        const JournalEntriesCompanion(synced: Value(true)),
      );
    } catch (_) {
      // Device offline — row stays synced=false; retried on syncPending()
    }
  }
}

// ── Decrypted model ───────────────────────────────────────────────────────────

class DecryptedJournalEntry {
  final String uuid;
  final DateTime createdAt;
  final String mood;
  final String accomplishments;
  final String release;
  final String gratitude;
  final String notes;

  const DecryptedJournalEntry({
    required this.uuid,
    required this.createdAt,
    required this.mood,
    required this.accomplishments,
    required this.release,
    required this.gratitude,
    required this.notes,
  });
}
