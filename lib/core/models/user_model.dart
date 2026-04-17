// PRD §7 — Firestore users/{userId} document model
// Runbook: all "steady" references replaced with "anshin"
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final DateTime createdAt;
  final String? displayName;
  final String? email;
  final bool isAnonymous;

  // Runbook §5 + Override 10: founder override for lifetime premium
  final bool isLifetimePremium;

  // 'free' | 'trialing' | 'premium' | 'expired'
  final String subscriptionStatus;

  final NotificationPreferences notificationPreferences;
  final OnboardingData onboarding;
  final UserSettings settings;

  const UserModel({
    required this.userId,
    required this.createdAt,
    this.displayName,
    this.email,
    required this.isAnonymous,
    required this.isLifetimePremium,
    required this.subscriptionStatus,
    required this.notificationPreferences,
    required this.onboarding,
    required this.settings,
  });

  // Runbook §5 — hasPremiumAccess: the single gate used everywhere
  bool get hasPremiumAccess =>
      subscriptionStatus == 'premium' ||
      subscriptionStatus == 'trialing' ||
      isLifetimePremium == true;

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      userId: doc.id,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      displayName: data['displayName'] as String?,
      email: data['email'] as String?,
      isAnonymous: data['isAnonymous'] as bool? ?? true,
      isLifetimePremium: data['isLifetimePremium'] as bool? ?? false,
      subscriptionStatus: data['subscriptionStatus'] as String? ?? 'free',
      notificationPreferences: NotificationPreferences.fromMap(
        data['notificationPreferences'] as Map<String, dynamic>? ?? {},
      ),
      onboarding: OnboardingData.fromMap(
        data['onboarding'] as Map<String, dynamic>? ?? {},
      ),
      settings: UserSettings.fromMap(
        data['settings'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'createdAt': Timestamp.fromDate(createdAt),
        'displayName': displayName,
        'email': email,
        'isAnonymous': isAnonymous,
        'isLifetimePremium': isLifetimePremium,
        'subscriptionStatus': subscriptionStatus,
        'notificationPreferences': notificationPreferences.toMap(),
        'onboarding': onboarding.toMap(),
        'settings': settings.toMap(),
      };

  // Default document written on first anonymous sign-in
  factory UserModel.newAnonymous(String userId) => UserModel(
        userId: userId,
        createdAt: DateTime.now(),
        displayName: null,
        email: null,
        isAnonymous: true,
        isLifetimePremium: false,
        subscriptionStatus: 'free',
        notificationPreferences: const NotificationPreferences(),
        onboarding: const OnboardingData(),
        settings: const UserSettings(),
      );

  UserModel copyWith({
    String? displayName,
    String? email,
    bool? isAnonymous,
    bool? isLifetimePremium,
    String? subscriptionStatus,
    NotificationPreferences? notificationPreferences,
    OnboardingData? onboarding,
    UserSettings? settings,
  }) =>
      UserModel(
        userId: userId,
        createdAt: createdAt,
        displayName: displayName ?? this.displayName,
        email: email ?? this.email,
        isAnonymous: isAnonymous ?? this.isAnonymous,
        isLifetimePremium: isLifetimePremium ?? this.isLifetimePremium,
        subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
        notificationPreferences:
            notificationPreferences ?? this.notificationPreferences,
        onboarding: onboarding ?? this.onboarding,
        settings: settings ?? this.settings,
      );
}

// ─── Nested models ───────────────────────────────────────────────────────────

class NotificationPreferences {
  final String dailyTime; // 'HH:mm', default '20:00'
  final bool enabled;
  final bool postSosEnabled;

  const NotificationPreferences({
    this.dailyTime = '20:00',
    this.enabled = true,
    this.postSosEnabled = true,
  });

  factory NotificationPreferences.fromMap(Map<String, dynamic> map) =>
      NotificationPreferences(
        dailyTime: map['dailyTime'] as String? ?? '20:00',
        enabled: map['enabled'] as bool? ?? true,
        postSosEnabled: map['postSosEnabled'] as bool? ?? true,
      );

  Map<String, dynamic> toMap() => {
        'dailyTime': dailyTime,
        'enabled': enabled,
        'postSosEnabled': postSosEnabled,
      };
}

class OnboardingData {
  final bool completed;
  final String anxietyType; // from onboarding screen 3a
  final String frequency;   // from onboarding screen 3b

  const OnboardingData({
    this.completed = false,
    this.anxietyType = '',
    this.frequency = '',
  });

  factory OnboardingData.fromMap(Map<String, dynamic> map) => OnboardingData(
        completed: map['completed'] as bool? ?? false,
        anxietyType: map['anxietyType'] as String? ?? '',
        frequency: map['frequency'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'completed': completed,
        'anxietyType': anxietyType,
        'frequency': frequency,
      };
}

class UserSettings {
  // 'box' | '478' | 'sigh' | 'coherent'
  final String breathingPreference;
  final bool voiceCues;
  final bool hapticOn;
  // 'light' | 'dark' | 'system' — mirrors theme_provider
  final String theme;

  const UserSettings({
    this.breathingPreference = 'box',
    this.voiceCues = true,
    this.hapticOn = true,
    this.theme = 'light',
  });

  factory UserSettings.fromMap(Map<String, dynamic> map) => UserSettings(
        breathingPreference:
            map['breathingPreference'] as String? ?? 'box',
        voiceCues: map['voiceCues'] as bool? ?? true,
        hapticOn: map['hapticOn'] as bool? ?? true,
        theme: map['theme'] as String? ?? 'light',
      );

  Map<String, dynamic> toMap() => {
        'breathingPreference': breathingPreference,
        'voiceCues': voiceCues,
        'hapticOn': hapticOn,
        'theme': theme,
      };
}
