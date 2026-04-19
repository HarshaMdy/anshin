// Notification service — Content Bible §14
// Wraps flutter_local_notifications v17.
//
// Three notification types:
//   dailyId (0)       — daily check-in reminder at user's chosen time, repeating
//   postSosId (1)     — one-shot follow-up 4 hours after an SOS session
//   reengagementId(2) — one-shot re-engagement 7 days after last app open
//
// init() must be awaited in main() before runApp().
// All scheduling is fire-and-forget safe after init().
import 'dart:math' as math;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../constants/strings_notifications.dart';

class NotificationService {
  // Singleton
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialised = false;

  // ── Notification IDs ────────────────────────────────────────────────────────
  static const int _dailyId = 0;
  static const int _postSosId = 1;
  static const int _reengagementId = 2;

  // ── Channel IDs ─────────────────────────────────────────────────────────────
  static const String _channelDailyId = 'anshin_daily';
  static const String _channelDailyName = 'Daily check-in';
  static const String _channelDailyDesc =
      'Daily reminder to check in with yourself';

  static const String _channelReminderId = 'anshin_reminders';
  static const String _channelReminderName = 'Reminders';
  static const String _channelReminderDesc = 'Post-session and re-engagement reminders';

  // ── Initialise ───────────────────────────────────────────────────────────────

  Future<void> init() async {
    if (_initialised) return;

    // Timezone setup (required for zonedSchedule)
    tz_data.initializeTimeZones();
    try {
      final tzName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzName));
    } catch (_) {
      // Fallback: UTC — rare on Android devices
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      const InitializationSettings(android: androidSettings),
    );

    // Request POST_NOTIFICATIONS permission (Android 13+)
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialised = true;
  }

  // ── Daily reminder ───────────────────────────────────────────────────────────

  /// Schedule (or reschedule) the daily check-in reminder at [hour]:[minute].
  /// Repeats every 24 h at the same wall-clock time.
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    await _plugin.cancel(_dailyId);
    await _plugin.zonedSchedule(
      _dailyId,
      'Anshin',
      _pickDailyBody(),
      _nextInstanceOf(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelDailyId,
          _channelDailyName,
          channelDescription: _channelDailyDesc,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelDailyReminder() => _plugin.cancel(_dailyId);

  // ── Post-SOS follow-up ───────────────────────────────────────────────────────

  /// Schedule a one-shot follow-up notification 4 hours from now.
  /// Call this when the user exits an SOS session.
  Future<void> schedulePostSosFollowUp() async {
    await _plugin.cancel(_postSosId);
    await _plugin.zonedSchedule(
      _postSosId,
      'Anshin',
      StringsNotifications.postSosFollowUp,
      tz.TZDateTime.now(tz.local).add(const Duration(hours: 4)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelReminderId,
          _channelReminderName,
          channelDescription: _channelReminderDesc,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelPostSosFollowUp() => _plugin.cancel(_postSosId);

  // ── Re-engagement ────────────────────────────────────────────────────────────

  /// Reset the 7-day re-engagement clock.
  /// Call on every app open — schedules a notification 7 days from now,
  /// overwriting any previously scheduled one.
  Future<void> resetReengagement() async {
    await _plugin.cancel(_reengagementId);
    await _plugin.zonedSchedule(
      _reengagementId,
      'Anshin',
      StringsNotifications.reengagement,
      tz.TZDateTime.now(tz.local).add(const Duration(days: 7)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelReminderId,
          _channelReminderName,
          channelDescription: _channelReminderDesc,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now.add(const Duration(seconds: 30)))) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  String _pickDailyBody() {
    final i =
        math.Random().nextInt(StringsNotifications.dailyReminders.length);
    return StringsNotifications.dailyReminders[i];
  }
}
