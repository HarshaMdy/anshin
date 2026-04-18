// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DailyCheckinsTable extends DailyCheckins
    with TableInfo<$DailyCheckinsTable, DailyCheckinRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyCheckinsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
    'mood',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anxietyMeta = const VerificationMeta(
    'anxiety',
  );
  @override
  late final GeneratedColumn<int> anxiety = GeneratedColumn<int>(
    'anxiety',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    userId,
    date,
    mood,
    anxiety,
    tags,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_checkins';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyCheckinRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    } else if (isInserting) {
      context.missing(_moodMeta);
    }
    if (data.containsKey('anxiety')) {
      context.handle(
        _anxietyMeta,
        anxiety.isAcceptableOrUnknown(data['anxiety']!, _anxietyMeta),
      );
    } else if (isInserting) {
      context.missing(_anxietyMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyCheckinRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyCheckinRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood'],
      )!,
      anxiety: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anxiety'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $DailyCheckinsTable createAlias(String alias) {
    return $DailyCheckinsTable(attachedDatabase, alias);
  }
}

class DailyCheckinRow extends DataClass implements Insertable<DailyCheckinRow> {
  final int id;
  final String uuid;
  final String userId;
  final String date;
  final int mood;
  final int anxiety;
  final String tags;
  final bool synced;
  const DailyCheckinRow({
    required this.id,
    required this.uuid,
    required this.userId,
    required this.date,
    required this.mood,
    required this.anxiety,
    required this.tags,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['user_id'] = Variable<String>(userId);
    map['date'] = Variable<String>(date);
    map['mood'] = Variable<int>(mood);
    map['anxiety'] = Variable<int>(anxiety);
    map['tags'] = Variable<String>(tags);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  DailyCheckinsCompanion toCompanion(bool nullToAbsent) {
    return DailyCheckinsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      userId: Value(userId),
      date: Value(date),
      mood: Value(mood),
      anxiety: Value(anxiety),
      tags: Value(tags),
      synced: Value(synced),
    );
  }

  factory DailyCheckinRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyCheckinRow(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      userId: serializer.fromJson<String>(json['userId']),
      date: serializer.fromJson<String>(json['date']),
      mood: serializer.fromJson<int>(json['mood']),
      anxiety: serializer.fromJson<int>(json['anxiety']),
      tags: serializer.fromJson<String>(json['tags']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'userId': serializer.toJson<String>(userId),
      'date': serializer.toJson<String>(date),
      'mood': serializer.toJson<int>(mood),
      'anxiety': serializer.toJson<int>(anxiety),
      'tags': serializer.toJson<String>(tags),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  DailyCheckinRow copyWith({
    int? id,
    String? uuid,
    String? userId,
    String? date,
    int? mood,
    int? anxiety,
    String? tags,
    bool? synced,
  }) => DailyCheckinRow(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    userId: userId ?? this.userId,
    date: date ?? this.date,
    mood: mood ?? this.mood,
    anxiety: anxiety ?? this.anxiety,
    tags: tags ?? this.tags,
    synced: synced ?? this.synced,
  );
  DailyCheckinRow copyWithCompanion(DailyCheckinsCompanion data) {
    return DailyCheckinRow(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      userId: data.userId.present ? data.userId.value : this.userId,
      date: data.date.present ? data.date.value : this.date,
      mood: data.mood.present ? data.mood.value : this.mood,
      anxiety: data.anxiety.present ? data.anxiety.value : this.anxiety,
      tags: data.tags.present ? data.tags.value : this.tags,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyCheckinRow(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('mood: $mood, ')
          ..write('anxiety: $anxiety, ')
          ..write('tags: $tags, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, uuid, userId, date, mood, anxiety, tags, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyCheckinRow &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.userId == this.userId &&
          other.date == this.date &&
          other.mood == this.mood &&
          other.anxiety == this.anxiety &&
          other.tags == this.tags &&
          other.synced == this.synced);
}

class DailyCheckinsCompanion extends UpdateCompanion<DailyCheckinRow> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> userId;
  final Value<String> date;
  final Value<int> mood;
  final Value<int> anxiety;
  final Value<String> tags;
  final Value<bool> synced;
  const DailyCheckinsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.userId = const Value.absent(),
    this.date = const Value.absent(),
    this.mood = const Value.absent(),
    this.anxiety = const Value.absent(),
    this.tags = const Value.absent(),
    this.synced = const Value.absent(),
  });
  DailyCheckinsCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String userId,
    required String date,
    required int mood,
    required int anxiety,
    this.tags = const Value.absent(),
    this.synced = const Value.absent(),
  }) : uuid = Value(uuid),
       userId = Value(userId),
       date = Value(date),
       mood = Value(mood),
       anxiety = Value(anxiety);
  static Insertable<DailyCheckinRow> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? userId,
    Expression<String>? date,
    Expression<int>? mood,
    Expression<int>? anxiety,
    Expression<String>? tags,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (userId != null) 'user_id': userId,
      if (date != null) 'date': date,
      if (mood != null) 'mood': mood,
      if (anxiety != null) 'anxiety': anxiety,
      if (tags != null) 'tags': tags,
      if (synced != null) 'synced': synced,
    });
  }

  DailyCheckinsCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<String>? userId,
    Value<String>? date,
    Value<int>? mood,
    Value<int>? anxiety,
    Value<String>? tags,
    Value<bool>? synced,
  }) {
    return DailyCheckinsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      anxiety: anxiety ?? this.anxiety,
      tags: tags ?? this.tags,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (anxiety.present) {
      map['anxiety'] = Variable<int>(anxiety.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyCheckinsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('mood: $mood, ')
          ..write('anxiety: $anxiety, ')
          ..write('tags: $tags, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $SosEpisodesTable extends SosEpisodes
    with TableInfo<$SosEpisodesTable, SosEpisodeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SosEpisodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    userId,
    startedAt,
    endedAt,
    durationSeconds,
    outcome,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sos_episodes';
  @override
  VerificationContext validateIntegrity(
    Insertable<SosEpisodeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SosEpisodeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SosEpisodeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $SosEpisodesTable createAlias(String alias) {
    return $SosEpisodesTable(attachedDatabase, alias);
  }
}

class SosEpisodeRow extends DataClass implements Insertable<SosEpisodeRow> {
  final int id;
  final String uuid;
  final String userId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int? durationSeconds;
  final String? outcome;
  final bool synced;
  const SosEpisodeRow({
    required this.id,
    required this.uuid,
    required this.userId,
    required this.startedAt,
    this.endedAt,
    this.durationSeconds,
    this.outcome,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['user_id'] = Variable<String>(userId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    if (!nullToAbsent || outcome != null) {
      map['outcome'] = Variable<String>(outcome);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  SosEpisodesCompanion toCompanion(bool nullToAbsent) {
    return SosEpisodesCompanion(
      id: Value(id),
      uuid: Value(uuid),
      userId: Value(userId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      outcome: outcome == null && nullToAbsent
          ? const Value.absent()
          : Value(outcome),
      synced: Value(synced),
    );
  }

  factory SosEpisodeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SosEpisodeRow(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      userId: serializer.fromJson<String>(json['userId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      outcome: serializer.fromJson<String?>(json['outcome']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'userId': serializer.toJson<String>(userId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'outcome': serializer.toJson<String?>(outcome),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  SosEpisodeRow copyWith({
    int? id,
    String? uuid,
    String? userId,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
    Value<String?> outcome = const Value.absent(),
    bool? synced,
  }) => SosEpisodeRow(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    userId: userId ?? this.userId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    outcome: outcome.present ? outcome.value : this.outcome,
    synced: synced ?? this.synced,
  );
  SosEpisodeRow copyWithCompanion(SosEpisodesCompanion data) {
    return SosEpisodeRow(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      userId: data.userId.present ? data.userId.value : this.userId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SosEpisodeRow(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('userId: $userId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('outcome: $outcome, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    userId,
    startedAt,
    endedAt,
    durationSeconds,
    outcome,
    synced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SosEpisodeRow &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.userId == this.userId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.durationSeconds == this.durationSeconds &&
          other.outcome == this.outcome &&
          other.synced == this.synced);
}

class SosEpisodesCompanion extends UpdateCompanion<SosEpisodeRow> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> userId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int?> durationSeconds;
  final Value<String?> outcome;
  final Value<bool> synced;
  const SosEpisodesCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.userId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.outcome = const Value.absent(),
    this.synced = const Value.absent(),
  });
  SosEpisodesCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String userId,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.outcome = const Value.absent(),
    this.synced = const Value.absent(),
  }) : uuid = Value(uuid),
       userId = Value(userId),
       startedAt = Value(startedAt);
  static Insertable<SosEpisodeRow> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? userId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? durationSeconds,
    Expression<String>? outcome,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (userId != null) 'user_id': userId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (outcome != null) 'outcome': outcome,
      if (synced != null) 'synced': synced,
    });
  }

  SosEpisodesCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<String>? userId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int?>? durationSeconds,
    Value<String?>? outcome,
    Value<bool>? synced,
  }) {
    return SosEpisodesCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      userId: userId ?? this.userId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      outcome: outcome ?? this.outcome,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SosEpisodesCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('userId: $userId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('outcome: $outcome, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $GroundingSessionsTable extends GroundingSessions
    with TableInfo<$GroundingSessionsTable, GroundingSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroundingSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _techniqueIdMeta = const VerificationMeta(
    'techniqueId',
  );
  @override
  late final GeneratedColumn<String> techniqueId = GeneratedColumn<String>(
    'technique_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _feelingOutcomeMeta = const VerificationMeta(
    'feelingOutcome',
  );
  @override
  late final GeneratedColumn<String> feelingOutcome = GeneratedColumn<String>(
    'feeling_outcome',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sosTriggerUuidMeta = const VerificationMeta(
    'sosTriggerUuid',
  );
  @override
  late final GeneratedColumn<String> sosTriggerUuid = GeneratedColumn<String>(
    'sos_trigger_uuid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    userId,
    techniqueId,
    startedAt,
    completedAt,
    completed,
    feelingOutcome,
    sosTriggerUuid,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grounding_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroundingSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('technique_id')) {
      context.handle(
        _techniqueIdMeta,
        techniqueId.isAcceptableOrUnknown(
          data['technique_id']!,
          _techniqueIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_techniqueIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('feeling_outcome')) {
      context.handle(
        _feelingOutcomeMeta,
        feelingOutcome.isAcceptableOrUnknown(
          data['feeling_outcome']!,
          _feelingOutcomeMeta,
        ),
      );
    }
    if (data.containsKey('sos_trigger_uuid')) {
      context.handle(
        _sosTriggerUuidMeta,
        sosTriggerUuid.isAcceptableOrUnknown(
          data['sos_trigger_uuid']!,
          _sosTriggerUuidMeta,
        ),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroundingSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroundingSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      techniqueId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}technique_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      feelingOutcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feeling_outcome'],
      ),
      sosTriggerUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sos_trigger_uuid'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $GroundingSessionsTable createAlias(String alias) {
    return $GroundingSessionsTable(attachedDatabase, alias);
  }
}

class GroundingSessionRow extends DataClass
    implements Insertable<GroundingSessionRow> {
  final int id;
  final String uuid;
  final String userId;
  final String techniqueId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final bool completed;
  final String? feelingOutcome;
  final String? sosTriggerUuid;
  final bool synced;
  const GroundingSessionRow({
    required this.id,
    required this.uuid,
    required this.userId,
    required this.techniqueId,
    required this.startedAt,
    this.completedAt,
    required this.completed,
    this.feelingOutcome,
    this.sosTriggerUuid,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['user_id'] = Variable<String>(userId);
    map['technique_id'] = Variable<String>(techniqueId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || feelingOutcome != null) {
      map['feeling_outcome'] = Variable<String>(feelingOutcome);
    }
    if (!nullToAbsent || sosTriggerUuid != null) {
      map['sos_trigger_uuid'] = Variable<String>(sosTriggerUuid);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  GroundingSessionsCompanion toCompanion(bool nullToAbsent) {
    return GroundingSessionsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      userId: Value(userId),
      techniqueId: Value(techniqueId),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      completed: Value(completed),
      feelingOutcome: feelingOutcome == null && nullToAbsent
          ? const Value.absent()
          : Value(feelingOutcome),
      sosTriggerUuid: sosTriggerUuid == null && nullToAbsent
          ? const Value.absent()
          : Value(sosTriggerUuid),
      synced: Value(synced),
    );
  }

  factory GroundingSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroundingSessionRow(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      userId: serializer.fromJson<String>(json['userId']),
      techniqueId: serializer.fromJson<String>(json['techniqueId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      completed: serializer.fromJson<bool>(json['completed']),
      feelingOutcome: serializer.fromJson<String?>(json['feelingOutcome']),
      sosTriggerUuid: serializer.fromJson<String?>(json['sosTriggerUuid']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'userId': serializer.toJson<String>(userId),
      'techniqueId': serializer.toJson<String>(techniqueId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'completed': serializer.toJson<bool>(completed),
      'feelingOutcome': serializer.toJson<String?>(feelingOutcome),
      'sosTriggerUuid': serializer.toJson<String?>(sosTriggerUuid),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  GroundingSessionRow copyWith({
    int? id,
    String? uuid,
    String? userId,
    String? techniqueId,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    bool? completed,
    Value<String?> feelingOutcome = const Value.absent(),
    Value<String?> sosTriggerUuid = const Value.absent(),
    bool? synced,
  }) => GroundingSessionRow(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    userId: userId ?? this.userId,
    techniqueId: techniqueId ?? this.techniqueId,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    completed: completed ?? this.completed,
    feelingOutcome: feelingOutcome.present
        ? feelingOutcome.value
        : this.feelingOutcome,
    sosTriggerUuid: sosTriggerUuid.present
        ? sosTriggerUuid.value
        : this.sosTriggerUuid,
    synced: synced ?? this.synced,
  );
  GroundingSessionRow copyWithCompanion(GroundingSessionsCompanion data) {
    return GroundingSessionRow(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      userId: data.userId.present ? data.userId.value : this.userId,
      techniqueId: data.techniqueId.present
          ? data.techniqueId.value
          : this.techniqueId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      completed: data.completed.present ? data.completed.value : this.completed,
      feelingOutcome: data.feelingOutcome.present
          ? data.feelingOutcome.value
          : this.feelingOutcome,
      sosTriggerUuid: data.sosTriggerUuid.present
          ? data.sosTriggerUuid.value
          : this.sosTriggerUuid,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroundingSessionRow(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('userId: $userId, ')
          ..write('techniqueId: $techniqueId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('completed: $completed, ')
          ..write('feelingOutcome: $feelingOutcome, ')
          ..write('sosTriggerUuid: $sosTriggerUuid, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    userId,
    techniqueId,
    startedAt,
    completedAt,
    completed,
    feelingOutcome,
    sosTriggerUuid,
    synced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroundingSessionRow &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.userId == this.userId &&
          other.techniqueId == this.techniqueId &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.completed == this.completed &&
          other.feelingOutcome == this.feelingOutcome &&
          other.sosTriggerUuid == this.sosTriggerUuid &&
          other.synced == this.synced);
}

class GroundingSessionsCompanion extends UpdateCompanion<GroundingSessionRow> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> userId;
  final Value<String> techniqueId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<bool> completed;
  final Value<String?> feelingOutcome;
  final Value<String?> sosTriggerUuid;
  final Value<bool> synced;
  const GroundingSessionsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.userId = const Value.absent(),
    this.techniqueId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.completed = const Value.absent(),
    this.feelingOutcome = const Value.absent(),
    this.sosTriggerUuid = const Value.absent(),
    this.synced = const Value.absent(),
  });
  GroundingSessionsCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String userId,
    required String techniqueId,
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.completed = const Value.absent(),
    this.feelingOutcome = const Value.absent(),
    this.sosTriggerUuid = const Value.absent(),
    this.synced = const Value.absent(),
  }) : uuid = Value(uuid),
       userId = Value(userId),
       techniqueId = Value(techniqueId),
       startedAt = Value(startedAt);
  static Insertable<GroundingSessionRow> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? userId,
    Expression<String>? techniqueId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<bool>? completed,
    Expression<String>? feelingOutcome,
    Expression<String>? sosTriggerUuid,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (userId != null) 'user_id': userId,
      if (techniqueId != null) 'technique_id': techniqueId,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (completed != null) 'completed': completed,
      if (feelingOutcome != null) 'feeling_outcome': feelingOutcome,
      if (sosTriggerUuid != null) 'sos_trigger_uuid': sosTriggerUuid,
      if (synced != null) 'synced': synced,
    });
  }

  GroundingSessionsCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<String>? userId,
    Value<String>? techniqueId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<bool>? completed,
    Value<String?>? feelingOutcome,
    Value<String?>? sosTriggerUuid,
    Value<bool>? synced,
  }) {
    return GroundingSessionsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      userId: userId ?? this.userId,
      techniqueId: techniqueId ?? this.techniqueId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      completed: completed ?? this.completed,
      feelingOutcome: feelingOutcome ?? this.feelingOutcome,
      sosTriggerUuid: sosTriggerUuid ?? this.sosTriggerUuid,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (techniqueId.present) {
      map['technique_id'] = Variable<String>(techniqueId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (feelingOutcome.present) {
      map['feeling_outcome'] = Variable<String>(feelingOutcome.value);
    }
    if (sosTriggerUuid.present) {
      map['sos_trigger_uuid'] = Variable<String>(sosTriggerUuid.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroundingSessionsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('userId: $userId, ')
          ..write('techniqueId: $techniqueId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('completed: $completed, ')
          ..write('feelingOutcome: $feelingOutcome, ')
          ..write('sosTriggerUuid: $sosTriggerUuid, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DailyCheckinsTable dailyCheckins = $DailyCheckinsTable(this);
  late final $SosEpisodesTable sosEpisodes = $SosEpisodesTable(this);
  late final $GroundingSessionsTable groundingSessions =
      $GroundingSessionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dailyCheckins,
    sosEpisodes,
    groundingSessions,
  ];
}

typedef $$DailyCheckinsTableCreateCompanionBuilder =
    DailyCheckinsCompanion Function({
      Value<int> id,
      required String uuid,
      required String userId,
      required String date,
      required int mood,
      required int anxiety,
      Value<String> tags,
      Value<bool> synced,
    });
typedef $$DailyCheckinsTableUpdateCompanionBuilder =
    DailyCheckinsCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<String> userId,
      Value<String> date,
      Value<int> mood,
      Value<int> anxiety,
      Value<String> tags,
      Value<bool> synced,
    });

class $$DailyCheckinsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyCheckinsTable> {
  $$DailyCheckinsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anxiety => $composableBuilder(
    column: $table.anxiety,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyCheckinsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyCheckinsTable> {
  $$DailyCheckinsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anxiety => $composableBuilder(
    column: $table.anxiety,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyCheckinsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyCheckinsTable> {
  $$DailyCheckinsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<int> get anxiety =>
      $composableBuilder(column: $table.anxiety, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$DailyCheckinsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyCheckinsTable,
          DailyCheckinRow,
          $$DailyCheckinsTableFilterComposer,
          $$DailyCheckinsTableOrderingComposer,
          $$DailyCheckinsTableAnnotationComposer,
          $$DailyCheckinsTableCreateCompanionBuilder,
          $$DailyCheckinsTableUpdateCompanionBuilder,
          (
            DailyCheckinRow,
            BaseReferences<_$AppDatabase, $DailyCheckinsTable, DailyCheckinRow>,
          ),
          DailyCheckinRow,
          PrefetchHooks Function()
        > {
  $$DailyCheckinsTableTableManager(_$AppDatabase db, $DailyCheckinsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyCheckinsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyCheckinsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyCheckinsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> mood = const Value.absent(),
                Value<int> anxiety = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => DailyCheckinsCompanion(
                id: id,
                uuid: uuid,
                userId: userId,
                date: date,
                mood: mood,
                anxiety: anxiety,
                tags: tags,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required String userId,
                required String date,
                required int mood,
                required int anxiety,
                Value<String> tags = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => DailyCheckinsCompanion.insert(
                id: id,
                uuid: uuid,
                userId: userId,
                date: date,
                mood: mood,
                anxiety: anxiety,
                tags: tags,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyCheckinsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyCheckinsTable,
      DailyCheckinRow,
      $$DailyCheckinsTableFilterComposer,
      $$DailyCheckinsTableOrderingComposer,
      $$DailyCheckinsTableAnnotationComposer,
      $$DailyCheckinsTableCreateCompanionBuilder,
      $$DailyCheckinsTableUpdateCompanionBuilder,
      (
        DailyCheckinRow,
        BaseReferences<_$AppDatabase, $DailyCheckinsTable, DailyCheckinRow>,
      ),
      DailyCheckinRow,
      PrefetchHooks Function()
    >;
typedef $$SosEpisodesTableCreateCompanionBuilder =
    SosEpisodesCompanion Function({
      Value<int> id,
      required String uuid,
      required String userId,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<int?> durationSeconds,
      Value<String?> outcome,
      Value<bool> synced,
    });
typedef $$SosEpisodesTableUpdateCompanionBuilder =
    SosEpisodesCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<String> userId,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int?> durationSeconds,
      Value<String?> outcome,
      Value<bool> synced,
    });

class $$SosEpisodesTableFilterComposer
    extends Composer<_$AppDatabase, $SosEpisodesTable> {
  $$SosEpisodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SosEpisodesTableOrderingComposer
    extends Composer<_$AppDatabase, $SosEpisodesTable> {
  $$SosEpisodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SosEpisodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SosEpisodesTable> {
  $$SosEpisodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$SosEpisodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SosEpisodesTable,
          SosEpisodeRow,
          $$SosEpisodesTableFilterComposer,
          $$SosEpisodesTableOrderingComposer,
          $$SosEpisodesTableAnnotationComposer,
          $$SosEpisodesTableCreateCompanionBuilder,
          $$SosEpisodesTableUpdateCompanionBuilder,
          (
            SosEpisodeRow,
            BaseReferences<_$AppDatabase, $SosEpisodesTable, SosEpisodeRow>,
          ),
          SosEpisodeRow,
          PrefetchHooks Function()
        > {
  $$SosEpisodesTableTableManager(_$AppDatabase db, $SosEpisodesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SosEpisodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SosEpisodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SosEpisodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<String?> outcome = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => SosEpisodesCompanion(
                id: id,
                uuid: uuid,
                userId: userId,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                outcome: outcome,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required String userId,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<String?> outcome = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => SosEpisodesCompanion.insert(
                id: id,
                uuid: uuid,
                userId: userId,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                outcome: outcome,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SosEpisodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SosEpisodesTable,
      SosEpisodeRow,
      $$SosEpisodesTableFilterComposer,
      $$SosEpisodesTableOrderingComposer,
      $$SosEpisodesTableAnnotationComposer,
      $$SosEpisodesTableCreateCompanionBuilder,
      $$SosEpisodesTableUpdateCompanionBuilder,
      (
        SosEpisodeRow,
        BaseReferences<_$AppDatabase, $SosEpisodesTable, SosEpisodeRow>,
      ),
      SosEpisodeRow,
      PrefetchHooks Function()
    >;
typedef $$GroundingSessionsTableCreateCompanionBuilder =
    GroundingSessionsCompanion Function({
      Value<int> id,
      required String uuid,
      required String userId,
      required String techniqueId,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
      Value<bool> completed,
      Value<String?> feelingOutcome,
      Value<String?> sosTriggerUuid,
      Value<bool> synced,
    });
typedef $$GroundingSessionsTableUpdateCompanionBuilder =
    GroundingSessionsCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<String> userId,
      Value<String> techniqueId,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<bool> completed,
      Value<String?> feelingOutcome,
      Value<String?> sosTriggerUuid,
      Value<bool> synced,
    });

class $$GroundingSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $GroundingSessionsTable> {
  $$GroundingSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get techniqueId => $composableBuilder(
    column: $table.techniqueId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feelingOutcome => $composableBuilder(
    column: $table.feelingOutcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sosTriggerUuid => $composableBuilder(
    column: $table.sosTriggerUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GroundingSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroundingSessionsTable> {
  $$GroundingSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get techniqueId => $composableBuilder(
    column: $table.techniqueId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feelingOutcome => $composableBuilder(
    column: $table.feelingOutcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sosTriggerUuid => $composableBuilder(
    column: $table.sosTriggerUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GroundingSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroundingSessionsTable> {
  $$GroundingSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get techniqueId => $composableBuilder(
    column: $table.techniqueId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<String> get feelingOutcome => $composableBuilder(
    column: $table.feelingOutcome,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sosTriggerUuid => $composableBuilder(
    column: $table.sosTriggerUuid,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$GroundingSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroundingSessionsTable,
          GroundingSessionRow,
          $$GroundingSessionsTableFilterComposer,
          $$GroundingSessionsTableOrderingComposer,
          $$GroundingSessionsTableAnnotationComposer,
          $$GroundingSessionsTableCreateCompanionBuilder,
          $$GroundingSessionsTableUpdateCompanionBuilder,
          (
            GroundingSessionRow,
            BaseReferences<
              _$AppDatabase,
              $GroundingSessionsTable,
              GroundingSessionRow
            >,
          ),
          GroundingSessionRow,
          PrefetchHooks Function()
        > {
  $$GroundingSessionsTableTableManager(
    _$AppDatabase db,
    $GroundingSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroundingSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroundingSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroundingSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> techniqueId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<String?> feelingOutcome = const Value.absent(),
                Value<String?> sosTriggerUuid = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => GroundingSessionsCompanion(
                id: id,
                uuid: uuid,
                userId: userId,
                techniqueId: techniqueId,
                startedAt: startedAt,
                completedAt: completedAt,
                completed: completed,
                feelingOutcome: feelingOutcome,
                sosTriggerUuid: sosTriggerUuid,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required String userId,
                required String techniqueId,
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<String?> feelingOutcome = const Value.absent(),
                Value<String?> sosTriggerUuid = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => GroundingSessionsCompanion.insert(
                id: id,
                uuid: uuid,
                userId: userId,
                techniqueId: techniqueId,
                startedAt: startedAt,
                completedAt: completedAt,
                completed: completed,
                feelingOutcome: feelingOutcome,
                sosTriggerUuid: sosTriggerUuid,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GroundingSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroundingSessionsTable,
      GroundingSessionRow,
      $$GroundingSessionsTableFilterComposer,
      $$GroundingSessionsTableOrderingComposer,
      $$GroundingSessionsTableAnnotationComposer,
      $$GroundingSessionsTableCreateCompanionBuilder,
      $$GroundingSessionsTableUpdateCompanionBuilder,
      (
        GroundingSessionRow,
        BaseReferences<
          _$AppDatabase,
          $GroundingSessionsTable,
          GroundingSessionRow
        >,
      ),
      GroundingSessionRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DailyCheckinsTableTableManager get dailyCheckins =>
      $$DailyCheckinsTableTableManager(_db, _db.dailyCheckins);
  $$SosEpisodesTableTableManager get sosEpisodes =>
      $$SosEpisodesTableTableManager(_db, _db.sosEpisodes);
  $$GroundingSessionsTableTableManager get groundingSessions =>
      $$GroundingSessionsTableTableManager(_db, _db.groundingSessions);
}
