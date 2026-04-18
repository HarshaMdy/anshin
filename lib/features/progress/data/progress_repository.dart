// Progress repository — aggregates check-in, SOS, grounding, and journal
// data for the Progress tab.  All reads are from local SQLite; no network calls.
import 'dart:math';

import '../../../core/constants/strings_progress.dart';
import '../../../core/database/app_database.dart';

// ── Data model ────────────────────────────────────────────────────────────────

class ProgressData {
  /// Check-in rows ordered **ascending** by date (oldest → today).
  final List<DailyCheckinRow> checkins;
  final int sosCount;
  final int sessionCount;
  final int journalCount;
  final int streakDays;
  final int windowDays;

  /// Rule-based insight strings (premium users only; empty for free).
  final List<String> insights;

  const ProgressData({
    required this.checkins,
    required this.sosCount,
    required this.sessionCount,
    required this.journalCount,
    required this.streakDays,
    required this.windowDays,
    required this.insights,
  });

  /// True when there are at least 2 check-ins to draw meaningful charts.
  bool get hasEnoughData => checkins.length >= 2;
}

// ── Repository ────────────────────────────────────────────────────────────────

class ProgressRepository {
  final AppDatabase _db;
  ProgressRepository({required AppDatabase db}) : _db = db;

  /// Loads [ProgressData] for the given [days] window.
  /// Pass [generateInsights] = true only for premium users.
  Future<ProgressData> load(
    String userId, {
    required int days,
    bool generateInsights = false,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final cutoff = today.subtract(Duration(days: days));

    // ── Check-ins ─────────────────────────────────────────────────────────────
    // Fetch 90 for accurate streak calculation even in 30-day mode.
    final allCheckins = await _db.recentDailyCheckins(userId, 90);

    final windowCheckins = allCheckins
        .where((c) => !_parseDate(c.date).isBefore(cutoff))
        .toList()
        .reversed // ascending
        .toList();

    // ── SOS ───────────────────────────────────────────────────────────────────
    final fetchLimit = max(days * 3, 90);
    final allSos = await _db.recentSosEpisodes(userId, fetchLimit);
    final windowSos = allSos.where((s) {
      final d = DateTime(s.startedAt.year, s.startedAt.month, s.startedAt.day);
      return !d.isBefore(cutoff);
    }).toList();

    // ── Grounding sessions ────────────────────────────────────────────────────
    final allSessions = await _db.recentGroundingSessions(userId, fetchLimit);
    final sessionCount = allSessions.where((s) {
      final d = DateTime(s.startedAt.year, s.startedAt.month, s.startedAt.day);
      return !d.isBefore(cutoff);
    }).length;

    // ── Journal entries ───────────────────────────────────────────────────────
    final allJournal = await _db.journalEntriesForUser(userId);
    final windowJournal = allJournal.where((e) {
      final d = DateTime(
          e.createdAt.year, e.createdAt.month, e.createdAt.day);
      return !d.isBefore(cutoff);
    }).toList();

    // ── Streak ────────────────────────────────────────────────────────────────
    final streak = _calculateStreak(allCheckins);

    // ── Insights (premium only) ───────────────────────────────────────────────
    final insights = generateInsights
        ? _buildInsights(
            checkins: windowCheckins,
            sosEpisodes: windowSos,
            journalEntries: windowJournal,
            streak: streak,
            windowDays: days,
          )
        : <String>[];

    return ProgressData(
      checkins: windowCheckins,
      sosCount: windowSos.length,
      sessionCount: sessionCount,
      journalCount: windowJournal.length,
      streakDays: streak,
      windowDays: days,
      insights: insights,
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static DateTime _parseDate(String s) {
    final p = s.split('-');
    return DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
  }

  static String _dateKey(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-'
      '${dt.month.toString().padLeft(2, '0')}-'
      '${dt.day.toString().padLeft(2, '0')}';

  static int _calculateStreak(List<DailyCheckinRow> rows) {
    // rows is ordered descending from DB
    final dateSet = rows.map((r) => r.date).toSet();
    int streak = 0;
    var cursor = DateTime.now();
    while (dateSet.contains(_dateKey(cursor))) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  // ── Insight rule engine ───────────────────────────────────────────────────

  static List<String> _buildInsights({
    required List<DailyCheckinRow> checkins,
    required List<SosEpisodeRow> sosEpisodes,
    required List<JournalEntryRow> journalEntries,
    required int streak,
    required int windowDays,
  }) {
    if (checkins.length < 3) return [];
    final results = <String>[];

    // 1. Consistency streak
    if (streak >= 3) {
      results.add(
        StringsProgress.insightConsistency
            .replaceAll('{days}', '$streak'),
      );
    }

    // 2. No SOS recently
    if (sosEpisodes.isEmpty && windowDays >= 7) {
      results.add(
        StringsProgress.insightNoSos.replaceAll('{days}', '$windowDays'),
      );
    } else if (sosEpisodes.isNotEmpty) {
      final latest = sosEpisodes
          .map((s) => s.startedAt)
          .reduce((a, b) => a.isAfter(b) ? a : b);
      final daysSince = DateTime.now().difference(latest).inDays;
      if (daysSince >= 3) {
        results.add(
          StringsProgress.insightNoSos.replaceAll('{days}', '$daysSince'),
        );
      }
    }

    // 3. SOS day-of-week pattern
    if (sosEpisodes.length >= 2) {
      final dayCounts = <int, int>{};
      for (final ep in sosEpisodes) {
        final wd = ep.startedAt.weekday;
        dayCounts[wd] = (dayCounts[wd] ?? 0) + 1;
      }
      final peak = dayCounts.entries
          .reduce((a, b) => a.value > b.value ? a : b);
      results.add(
        StringsProgress.insightSosPattern
            .replaceAll('{count}', '${sosEpisodes.length}')
            .replaceAll(
                '{frequency}', peak.value >= 2 ? 'most often' : 'sometimes')
            .replaceAll('{day}', _weekdayName(peak.key)),
      );
    }

    // 4. Week-over-week anxiety comparison
    if (checkins.length >= 6) {
      final half = checkins.length ~/ 2;
      final older = checkins.sublist(0, half);
      final recent = checkins.sublist(checkins.length - half);
      final olderAvg = older
              .map((c) => c.anxiety.toDouble())
              .reduce((a, b) => a + b) /
          older.length;
      final recentAvg = recent
              .map((c) => c.anxiety.toDouble())
              .reduce((a, b) => a + b) /
          recent.length;

      if (recentAvg > olderAvg + 1.5) {
        results.add(StringsProgress.insightHarderWeek);
      } else if (olderAvg - recentAvg >= 1.5) {
        results.add(
          StringsProgress.insightAvgDropped
              .replaceAll('{from}', olderAvg.toStringAsFixed(1))
              .replaceAll('{to}', recentAvg.toStringAsFixed(1))
              .replaceAll('{weeks}', '${windowDays ~/ 7}'),
        );
      }
    }

    // 5. Journal days correlate with lower anxiety
    if (journalEntries.isNotEmpty) {
      final journalKeys =
          journalEntries.map((e) => _dateKey(e.createdAt)).toSet();
      final jDays =
          checkins.where((c) => journalKeys.contains(c.date)).toList();
      final nDays =
          checkins.where((c) => !journalKeys.contains(c.date)).toList();
      if (jDays.isNotEmpty && nDays.isNotEmpty) {
        final jAvg = jDays
                .map((c) => c.anxiety.toDouble())
                .reduce((a, b) => a + b) /
            jDays.length;
        final nAvg = nDays
                .map((c) => c.anxiety.toDouble())
                .reduce((a, b) => a + b) /
            nDays.length;
        if (nAvg - jAvg >= 1.5) {
          results.add(StringsProgress.insightJournalAnxiety);
        }
      }
    }

    // 6. Sleep tag → higher anxiety
    final sleepDays =
        checkins.where((c) => c.tags.contains('Sleep')).toList();
    if (sleepDays.length >= 2 && checkins.length >= 4) {
      final sleepAvg = sleepDays
              .map((c) => c.anxiety.toDouble())
              .reduce((a, b) => a + b) /
          sleepDays.length;
      final allAvg = checkins
              .map((c) => c.anxiety.toDouble())
              .reduce((a, b) => a + b) /
          checkins.length;
      if (sleepAvg > allAvg + 1.0) {
        results.add(StringsProgress.insightSleep);
      }
    }

    return results.take(3).toList();
  }

  static String _weekdayName(int weekday) {
    const names = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];
    return names[(weekday - 1) % 7];
  }
}
