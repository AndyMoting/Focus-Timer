// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FocusTimeTable extends FocusTime
    with TableInfo<$FocusTimeTable, FocusTimeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusTimeTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _dayNumMeta = const VerificationMeta('dayNum');
  @override
  late final GeneratedColumn<int> dayNum = GeneratedColumn<int>(
    'day_num',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<int> state = GeneratedColumn<int>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<int> startTime = GeneratedColumn<int>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<int> endTime = GeneratedColumn<int>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _scheduledTimeMeta = const VerificationMeta(
    'scheduledTime',
  );
  @override
  late final GeneratedColumn<int> scheduledTime = GeneratedColumn<int>(
    'scheduled_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<int> listId = GeneratedColumn<int>(
    'list_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
    'plan_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _evidenceUriMeta = const VerificationMeta(
    'evidenceUri',
  );
  @override
  late final GeneratedColumn<String> evidenceUri = GeneratedColumn<String>(
    'evidence_uri',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _evidenceDisplayNameMeta =
      const VerificationMeta('evidenceDisplayName');
  @override
  late final GeneratedColumn<String> evidenceDisplayName =
      GeneratedColumn<String>(
        'evidence_display_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _evidenceRelativePathMeta =
      const VerificationMeta('evidenceRelativePath');
  @override
  late final GeneratedColumn<String> evidenceRelativePath =
      GeneratedColumn<String>(
        'evidence_relative_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _evidenceMimeTypeMeta = const VerificationMeta(
    'evidenceMimeType',
  );
  @override
  late final GeneratedColumn<String> evidenceMimeType = GeneratedColumn<String>(
    'evidence_mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    dayNum,
    type,
    state,
    startTime,
    endTime,
    durationMs,
    scheduledTime,
    name,
    note,
    taskId,
    listId,
    planId,
    evidenceUri,
    evidenceDisplayName,
    evidenceRelativePath,
    evidenceMimeType,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_time';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusTimeData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('day_num')) {
      context.handle(
        _dayNumMeta,
        dayNum.isAcceptableOrUnknown(data['day_num']!, _dayNumMeta),
      );
    } else if (isInserting) {
      context.missing(_dayNumMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('scheduled_time')) {
      context.handle(
        _scheduledTimeMeta,
        scheduledTime.isAcceptableOrUnknown(
          data['scheduled_time']!,
          _scheduledTimeMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    }
    if (data.containsKey('evidence_uri')) {
      context.handle(
        _evidenceUriMeta,
        evidenceUri.isAcceptableOrUnknown(
          data['evidence_uri']!,
          _evidenceUriMeta,
        ),
      );
    }
    if (data.containsKey('evidence_display_name')) {
      context.handle(
        _evidenceDisplayNameMeta,
        evidenceDisplayName.isAcceptableOrUnknown(
          data['evidence_display_name']!,
          _evidenceDisplayNameMeta,
        ),
      );
    }
    if (data.containsKey('evidence_relative_path')) {
      context.handle(
        _evidenceRelativePathMeta,
        evidenceRelativePath.isAcceptableOrUnknown(
          data['evidence_relative_path']!,
          _evidenceRelativePathMeta,
        ),
      );
    }
    if (data.containsKey('evidence_mime_type')) {
      context.handle(
        _evidenceMimeTypeMeta,
        evidenceMimeType.isAcceptableOrUnknown(
          data['evidence_mime_type']!,
          _evidenceMimeTypeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusTimeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusTimeData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      dayNum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_num'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}state'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_time'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      scheduledTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scheduled_time'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      ),
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}list_id'],
      ),
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_id'],
      ),
      evidenceUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evidence_uri'],
      ),
      evidenceDisplayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evidence_display_name'],
      ),
      evidenceRelativePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evidence_relative_path'],
      ),
      evidenceMimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evidence_mime_type'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FocusTimeTable createAlias(String alias) {
    return $FocusTimeTable(attachedDatabase, alias);
  }
}

class FocusTimeData extends DataClass implements Insertable<FocusTimeData> {
  final int id;
  final int userId;
  final int dayNum;
  final int type;
  final int state;
  final int startTime;
  final int? endTime;
  final int durationMs;
  final int? scheduledTime;
  final String name;
  final String? note;
  final int? taskId;
  final int? listId;
  final int? planId;
  final String? evidenceUri;
  final String? evidenceDisplayName;
  final String? evidenceRelativePath;
  final String? evidenceMimeType;
  final int createdAt;
  final int updatedAt;
  const FocusTimeData({
    required this.id,
    required this.userId,
    required this.dayNum,
    required this.type,
    required this.state,
    required this.startTime,
    this.endTime,
    required this.durationMs,
    this.scheduledTime,
    required this.name,
    this.note,
    this.taskId,
    this.listId,
    this.planId,
    this.evidenceUri,
    this.evidenceDisplayName,
    this.evidenceRelativePath,
    this.evidenceMimeType,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['day_num'] = Variable<int>(dayNum);
    map['type'] = Variable<int>(type);
    map['state'] = Variable<int>(state);
    map['start_time'] = Variable<int>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<int>(endTime);
    }
    map['duration_ms'] = Variable<int>(durationMs);
    if (!nullToAbsent || scheduledTime != null) {
      map['scheduled_time'] = Variable<int>(scheduledTime);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<int>(taskId);
    }
    if (!nullToAbsent || listId != null) {
      map['list_id'] = Variable<int>(listId);
    }
    if (!nullToAbsent || planId != null) {
      map['plan_id'] = Variable<int>(planId);
    }
    if (!nullToAbsent || evidenceUri != null) {
      map['evidence_uri'] = Variable<String>(evidenceUri);
    }
    if (!nullToAbsent || evidenceDisplayName != null) {
      map['evidence_display_name'] = Variable<String>(evidenceDisplayName);
    }
    if (!nullToAbsent || evidenceRelativePath != null) {
      map['evidence_relative_path'] = Variable<String>(evidenceRelativePath);
    }
    if (!nullToAbsent || evidenceMimeType != null) {
      map['evidence_mime_type'] = Variable<String>(evidenceMimeType);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  FocusTimeCompanion toCompanion(bool nullToAbsent) {
    return FocusTimeCompanion(
      id: Value(id),
      userId: Value(userId),
      dayNum: Value(dayNum),
      type: Value(type),
      state: Value(state),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      durationMs: Value(durationMs),
      scheduledTime: scheduledTime == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledTime),
      name: Value(name),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      listId: listId == null && nullToAbsent
          ? const Value.absent()
          : Value(listId),
      planId: planId == null && nullToAbsent
          ? const Value.absent()
          : Value(planId),
      evidenceUri: evidenceUri == null && nullToAbsent
          ? const Value.absent()
          : Value(evidenceUri),
      evidenceDisplayName: evidenceDisplayName == null && nullToAbsent
          ? const Value.absent()
          : Value(evidenceDisplayName),
      evidenceRelativePath: evidenceRelativePath == null && nullToAbsent
          ? const Value.absent()
          : Value(evidenceRelativePath),
      evidenceMimeType: evidenceMimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(evidenceMimeType),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FocusTimeData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusTimeData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      dayNum: serializer.fromJson<int>(json['dayNum']),
      type: serializer.fromJson<int>(json['type']),
      state: serializer.fromJson<int>(json['state']),
      startTime: serializer.fromJson<int>(json['startTime']),
      endTime: serializer.fromJson<int?>(json['endTime']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      scheduledTime: serializer.fromJson<int?>(json['scheduledTime']),
      name: serializer.fromJson<String>(json['name']),
      note: serializer.fromJson<String?>(json['note']),
      taskId: serializer.fromJson<int?>(json['taskId']),
      listId: serializer.fromJson<int?>(json['listId']),
      planId: serializer.fromJson<int?>(json['planId']),
      evidenceUri: serializer.fromJson<String?>(json['evidenceUri']),
      evidenceDisplayName: serializer.fromJson<String?>(
        json['evidenceDisplayName'],
      ),
      evidenceRelativePath: serializer.fromJson<String?>(
        json['evidenceRelativePath'],
      ),
      evidenceMimeType: serializer.fromJson<String?>(json['evidenceMimeType']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'dayNum': serializer.toJson<int>(dayNum),
      'type': serializer.toJson<int>(type),
      'state': serializer.toJson<int>(state),
      'startTime': serializer.toJson<int>(startTime),
      'endTime': serializer.toJson<int?>(endTime),
      'durationMs': serializer.toJson<int>(durationMs),
      'scheduledTime': serializer.toJson<int?>(scheduledTime),
      'name': serializer.toJson<String>(name),
      'note': serializer.toJson<String?>(note),
      'taskId': serializer.toJson<int?>(taskId),
      'listId': serializer.toJson<int?>(listId),
      'planId': serializer.toJson<int?>(planId),
      'evidenceUri': serializer.toJson<String?>(evidenceUri),
      'evidenceDisplayName': serializer.toJson<String?>(evidenceDisplayName),
      'evidenceRelativePath': serializer.toJson<String?>(evidenceRelativePath),
      'evidenceMimeType': serializer.toJson<String?>(evidenceMimeType),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  FocusTimeData copyWith({
    int? id,
    int? userId,
    int? dayNum,
    int? type,
    int? state,
    int? startTime,
    Value<int?> endTime = const Value.absent(),
    int? durationMs,
    Value<int?> scheduledTime = const Value.absent(),
    String? name,
    Value<String?> note = const Value.absent(),
    Value<int?> taskId = const Value.absent(),
    Value<int?> listId = const Value.absent(),
    Value<int?> planId = const Value.absent(),
    Value<String?> evidenceUri = const Value.absent(),
    Value<String?> evidenceDisplayName = const Value.absent(),
    Value<String?> evidenceRelativePath = const Value.absent(),
    Value<String?> evidenceMimeType = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => FocusTimeData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    dayNum: dayNum ?? this.dayNum,
    type: type ?? this.type,
    state: state ?? this.state,
    startTime: startTime ?? this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    durationMs: durationMs ?? this.durationMs,
    scheduledTime: scheduledTime.present
        ? scheduledTime.value
        : this.scheduledTime,
    name: name ?? this.name,
    note: note.present ? note.value : this.note,
    taskId: taskId.present ? taskId.value : this.taskId,
    listId: listId.present ? listId.value : this.listId,
    planId: planId.present ? planId.value : this.planId,
    evidenceUri: evidenceUri.present ? evidenceUri.value : this.evidenceUri,
    evidenceDisplayName: evidenceDisplayName.present
        ? evidenceDisplayName.value
        : this.evidenceDisplayName,
    evidenceRelativePath: evidenceRelativePath.present
        ? evidenceRelativePath.value
        : this.evidenceRelativePath,
    evidenceMimeType: evidenceMimeType.present
        ? evidenceMimeType.value
        : this.evidenceMimeType,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FocusTimeData copyWithCompanion(FocusTimeCompanion data) {
    return FocusTimeData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      dayNum: data.dayNum.present ? data.dayNum.value : this.dayNum,
      type: data.type.present ? data.type.value : this.type,
      state: data.state.present ? data.state.value : this.state,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      scheduledTime: data.scheduledTime.present
          ? data.scheduledTime.value
          : this.scheduledTime,
      name: data.name.present ? data.name.value : this.name,
      note: data.note.present ? data.note.value : this.note,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      listId: data.listId.present ? data.listId.value : this.listId,
      planId: data.planId.present ? data.planId.value : this.planId,
      evidenceUri: data.evidenceUri.present
          ? data.evidenceUri.value
          : this.evidenceUri,
      evidenceDisplayName: data.evidenceDisplayName.present
          ? data.evidenceDisplayName.value
          : this.evidenceDisplayName,
      evidenceRelativePath: data.evidenceRelativePath.present
          ? data.evidenceRelativePath.value
          : this.evidenceRelativePath,
      evidenceMimeType: data.evidenceMimeType.present
          ? data.evidenceMimeType.value
          : this.evidenceMimeType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusTimeData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('dayNum: $dayNum, ')
          ..write('type: $type, ')
          ..write('state: $state, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('durationMs: $durationMs, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('name: $name, ')
          ..write('note: $note, ')
          ..write('taskId: $taskId, ')
          ..write('listId: $listId, ')
          ..write('planId: $planId, ')
          ..write('evidenceUri: $evidenceUri, ')
          ..write('evidenceDisplayName: $evidenceDisplayName, ')
          ..write('evidenceRelativePath: $evidenceRelativePath, ')
          ..write('evidenceMimeType: $evidenceMimeType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    dayNum,
    type,
    state,
    startTime,
    endTime,
    durationMs,
    scheduledTime,
    name,
    note,
    taskId,
    listId,
    planId,
    evidenceUri,
    evidenceDisplayName,
    evidenceRelativePath,
    evidenceMimeType,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusTimeData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.dayNum == this.dayNum &&
          other.type == this.type &&
          other.state == this.state &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.durationMs == this.durationMs &&
          other.scheduledTime == this.scheduledTime &&
          other.name == this.name &&
          other.note == this.note &&
          other.taskId == this.taskId &&
          other.listId == this.listId &&
          other.planId == this.planId &&
          other.evidenceUri == this.evidenceUri &&
          other.evidenceDisplayName == this.evidenceDisplayName &&
          other.evidenceRelativePath == this.evidenceRelativePath &&
          other.evidenceMimeType == this.evidenceMimeType &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FocusTimeCompanion extends UpdateCompanion<FocusTimeData> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> dayNum;
  final Value<int> type;
  final Value<int> state;
  final Value<int> startTime;
  final Value<int?> endTime;
  final Value<int> durationMs;
  final Value<int?> scheduledTime;
  final Value<String> name;
  final Value<String?> note;
  final Value<int?> taskId;
  final Value<int?> listId;
  final Value<int?> planId;
  final Value<String?> evidenceUri;
  final Value<String?> evidenceDisplayName;
  final Value<String?> evidenceRelativePath;
  final Value<String?> evidenceMimeType;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const FocusTimeCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.dayNum = const Value.absent(),
    this.type = const Value.absent(),
    this.state = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.scheduledTime = const Value.absent(),
    this.name = const Value.absent(),
    this.note = const Value.absent(),
    this.taskId = const Value.absent(),
    this.listId = const Value.absent(),
    this.planId = const Value.absent(),
    this.evidenceUri = const Value.absent(),
    this.evidenceDisplayName = const Value.absent(),
    this.evidenceRelativePath = const Value.absent(),
    this.evidenceMimeType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FocusTimeCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    required int dayNum,
    required int type,
    required int state,
    required int startTime,
    this.endTime = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.scheduledTime = const Value.absent(),
    required String name,
    this.note = const Value.absent(),
    this.taskId = const Value.absent(),
    this.listId = const Value.absent(),
    this.planId = const Value.absent(),
    this.evidenceUri = const Value.absent(),
    this.evidenceDisplayName = const Value.absent(),
    this.evidenceRelativePath = const Value.absent(),
    this.evidenceMimeType = const Value.absent(),
    required int createdAt,
    required int updatedAt,
  }) : dayNum = Value(dayNum),
       type = Value(type),
       state = Value(state),
       startTime = Value(startTime),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FocusTimeData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? dayNum,
    Expression<int>? type,
    Expression<int>? state,
    Expression<int>? startTime,
    Expression<int>? endTime,
    Expression<int>? durationMs,
    Expression<int>? scheduledTime,
    Expression<String>? name,
    Expression<String>? note,
    Expression<int>? taskId,
    Expression<int>? listId,
    Expression<int>? planId,
    Expression<String>? evidenceUri,
    Expression<String>? evidenceDisplayName,
    Expression<String>? evidenceRelativePath,
    Expression<String>? evidenceMimeType,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (dayNum != null) 'day_num': dayNum,
      if (type != null) 'type': type,
      if (state != null) 'state': state,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (durationMs != null) 'duration_ms': durationMs,
      if (scheduledTime != null) 'scheduled_time': scheduledTime,
      if (name != null) 'name': name,
      if (note != null) 'note': note,
      if (taskId != null) 'task_id': taskId,
      if (listId != null) 'list_id': listId,
      if (planId != null) 'plan_id': planId,
      if (evidenceUri != null) 'evidence_uri': evidenceUri,
      if (evidenceDisplayName != null)
        'evidence_display_name': evidenceDisplayName,
      if (evidenceRelativePath != null)
        'evidence_relative_path': evidenceRelativePath,
      if (evidenceMimeType != null) 'evidence_mime_type': evidenceMimeType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FocusTimeCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<int>? dayNum,
    Value<int>? type,
    Value<int>? state,
    Value<int>? startTime,
    Value<int?>? endTime,
    Value<int>? durationMs,
    Value<int?>? scheduledTime,
    Value<String>? name,
    Value<String?>? note,
    Value<int?>? taskId,
    Value<int?>? listId,
    Value<int?>? planId,
    Value<String?>? evidenceUri,
    Value<String?>? evidenceDisplayName,
    Value<String?>? evidenceRelativePath,
    Value<String?>? evidenceMimeType,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return FocusTimeCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dayNum: dayNum ?? this.dayNum,
      type: type ?? this.type,
      state: state ?? this.state,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMs: durationMs ?? this.durationMs,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      name: name ?? this.name,
      note: note ?? this.note,
      taskId: taskId ?? this.taskId,
      listId: listId ?? this.listId,
      planId: planId ?? this.planId,
      evidenceUri: evidenceUri ?? this.evidenceUri,
      evidenceDisplayName: evidenceDisplayName ?? this.evidenceDisplayName,
      evidenceRelativePath: evidenceRelativePath ?? this.evidenceRelativePath,
      evidenceMimeType: evidenceMimeType ?? this.evidenceMimeType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (dayNum.present) {
      map['day_num'] = Variable<int>(dayNum.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (state.present) {
      map['state'] = Variable<int>(state.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<int>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<int>(endTime.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (scheduledTime.present) {
      map['scheduled_time'] = Variable<int>(scheduledTime.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<int>(listId.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    if (evidenceUri.present) {
      map['evidence_uri'] = Variable<String>(evidenceUri.value);
    }
    if (evidenceDisplayName.present) {
      map['evidence_display_name'] = Variable<String>(
        evidenceDisplayName.value,
      );
    }
    if (evidenceRelativePath.present) {
      map['evidence_relative_path'] = Variable<String>(
        evidenceRelativePath.value,
      );
    }
    if (evidenceMimeType.present) {
      map['evidence_mime_type'] = Variable<String>(evidenceMimeType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusTimeCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('dayNum: $dayNum, ')
          ..write('type: $type, ')
          ..write('state: $state, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('durationMs: $durationMs, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('name: $name, ')
          ..write('note: $note, ')
          ..write('taskId: $taskId, ')
          ..write('listId: $listId, ')
          ..write('planId: $planId, ')
          ..write('evidenceUri: $evidenceUri, ')
          ..write('evidenceDisplayName: $evidenceDisplayName, ')
          ..write('evidenceRelativePath: $evidenceRelativePath, ')
          ..write('evidenceMimeType: $evidenceMimeType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ActiveTimerSessionTable extends ActiveTimerSession
    with TableInfo<$ActiveTimerSessionTable, ActiveTimerSessionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveTimerSessionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMsMeta = const VerificationMeta(
    'startTimeMs',
  );
  @override
  late final GeneratedColumn<int> startTimeMs = GeneratedColumn<int>(
    'start_time_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pauseStartMsMeta = const VerificationMeta(
    'pauseStartMs',
  );
  @override
  late final GeneratedColumn<int> pauseStartMs = GeneratedColumn<int>(
    'pause_start_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pauseTotalMsMeta = const VerificationMeta(
    'pauseTotalMs',
  );
  @override
  late final GeneratedColumn<int> pauseTotalMs = GeneratedColumn<int>(
    'pause_total_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _targetDurationMsMeta = const VerificationMeta(
    'targetDurationMs',
  );
  @override
  late final GeneratedColumn<int> targetDurationMs = GeneratedColumn<int>(
    'target_duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<int> state = GeneratedColumn<int>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<int> listId = GeneratedColumn<int>(
    'list_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
    'plan_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _evidenceUriMeta = const VerificationMeta(
    'evidenceUri',
  );
  @override
  late final GeneratedColumn<String> evidenceUri = GeneratedColumn<String>(
    'evidence_uri',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _evidenceDisplayNameMeta =
      const VerificationMeta('evidenceDisplayName');
  @override
  late final GeneratedColumn<String> evidenceDisplayName =
      GeneratedColumn<String>(
        'evidence_display_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _evidenceRelativePathMeta =
      const VerificationMeta('evidenceRelativePath');
  @override
  late final GeneratedColumn<String> evidenceRelativePath =
      GeneratedColumn<String>(
        'evidence_relative_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _evidenceMimeTypeMeta = const VerificationMeta(
    'evidenceMimeType',
  );
  @override
  late final GeneratedColumn<String> evidenceMimeType = GeneratedColumn<String>(
    'evidence_mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    name,
    startTimeMs,
    pauseStartMs,
    pauseTotalMs,
    targetDurationMs,
    state,
    note,
    taskId,
    listId,
    planId,
    evidenceUri,
    evidenceDisplayName,
    evidenceRelativePath,
    evidenceMimeType,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_timer_session';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActiveTimerSessionData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('start_time_ms')) {
      context.handle(
        _startTimeMsMeta,
        startTimeMs.isAcceptableOrUnknown(
          data['start_time_ms']!,
          _startTimeMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startTimeMsMeta);
    }
    if (data.containsKey('pause_start_ms')) {
      context.handle(
        _pauseStartMsMeta,
        pauseStartMs.isAcceptableOrUnknown(
          data['pause_start_ms']!,
          _pauseStartMsMeta,
        ),
      );
    }
    if (data.containsKey('pause_total_ms')) {
      context.handle(
        _pauseTotalMsMeta,
        pauseTotalMs.isAcceptableOrUnknown(
          data['pause_total_ms']!,
          _pauseTotalMsMeta,
        ),
      );
    }
    if (data.containsKey('target_duration_ms')) {
      context.handle(
        _targetDurationMsMeta,
        targetDurationMs.isAcceptableOrUnknown(
          data['target_duration_ms']!,
          _targetDurationMsMeta,
        ),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    }
    if (data.containsKey('evidence_uri')) {
      context.handle(
        _evidenceUriMeta,
        evidenceUri.isAcceptableOrUnknown(
          data['evidence_uri']!,
          _evidenceUriMeta,
        ),
      );
    }
    if (data.containsKey('evidence_display_name')) {
      context.handle(
        _evidenceDisplayNameMeta,
        evidenceDisplayName.isAcceptableOrUnknown(
          data['evidence_display_name']!,
          _evidenceDisplayNameMeta,
        ),
      );
    }
    if (data.containsKey('evidence_relative_path')) {
      context.handle(
        _evidenceRelativePathMeta,
        evidenceRelativePath.isAcceptableOrUnknown(
          data['evidence_relative_path']!,
          _evidenceRelativePathMeta,
        ),
      );
    }
    if (data.containsKey('evidence_mime_type')) {
      context.handle(
        _evidenceMimeTypeMeta,
        evidenceMimeType.isAcceptableOrUnknown(
          data['evidence_mime_type']!,
          _evidenceMimeTypeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActiveTimerSessionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveTimerSessionData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      startTimeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_time_ms'],
      )!,
      pauseStartMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pause_start_ms'],
      ),
      pauseTotalMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pause_total_ms'],
      )!,
      targetDurationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_duration_ms'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}state'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      ),
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}list_id'],
      ),
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_id'],
      ),
      evidenceUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evidence_uri'],
      ),
      evidenceDisplayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evidence_display_name'],
      ),
      evidenceRelativePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evidence_relative_path'],
      ),
      evidenceMimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evidence_mime_type'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ActiveTimerSessionTable createAlias(String alias) {
    return $ActiveTimerSessionTable(attachedDatabase, alias);
  }
}

class ActiveTimerSessionData extends DataClass
    implements Insertable<ActiveTimerSessionData> {
  final int id;
  final int type;
  final String name;
  final int startTimeMs;
  final int? pauseStartMs;
  final int pauseTotalMs;
  final int targetDurationMs;
  final int state;
  final String? note;
  final int? taskId;
  final int? listId;
  final int? planId;
  final String? evidenceUri;
  final String? evidenceDisplayName;
  final String? evidenceRelativePath;
  final String? evidenceMimeType;
  final int createdAt;
  final int updatedAt;
  const ActiveTimerSessionData({
    required this.id,
    required this.type,
    required this.name,
    required this.startTimeMs,
    this.pauseStartMs,
    required this.pauseTotalMs,
    required this.targetDurationMs,
    required this.state,
    this.note,
    this.taskId,
    this.listId,
    this.planId,
    this.evidenceUri,
    this.evidenceDisplayName,
    this.evidenceRelativePath,
    this.evidenceMimeType,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<int>(type);
    map['name'] = Variable<String>(name);
    map['start_time_ms'] = Variable<int>(startTimeMs);
    if (!nullToAbsent || pauseStartMs != null) {
      map['pause_start_ms'] = Variable<int>(pauseStartMs);
    }
    map['pause_total_ms'] = Variable<int>(pauseTotalMs);
    map['target_duration_ms'] = Variable<int>(targetDurationMs);
    map['state'] = Variable<int>(state);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<int>(taskId);
    }
    if (!nullToAbsent || listId != null) {
      map['list_id'] = Variable<int>(listId);
    }
    if (!nullToAbsent || planId != null) {
      map['plan_id'] = Variable<int>(planId);
    }
    if (!nullToAbsent || evidenceUri != null) {
      map['evidence_uri'] = Variable<String>(evidenceUri);
    }
    if (!nullToAbsent || evidenceDisplayName != null) {
      map['evidence_display_name'] = Variable<String>(evidenceDisplayName);
    }
    if (!nullToAbsent || evidenceRelativePath != null) {
      map['evidence_relative_path'] = Variable<String>(evidenceRelativePath);
    }
    if (!nullToAbsent || evidenceMimeType != null) {
      map['evidence_mime_type'] = Variable<String>(evidenceMimeType);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ActiveTimerSessionCompanion toCompanion(bool nullToAbsent) {
    return ActiveTimerSessionCompanion(
      id: Value(id),
      type: Value(type),
      name: Value(name),
      startTimeMs: Value(startTimeMs),
      pauseStartMs: pauseStartMs == null && nullToAbsent
          ? const Value.absent()
          : Value(pauseStartMs),
      pauseTotalMs: Value(pauseTotalMs),
      targetDurationMs: Value(targetDurationMs),
      state: Value(state),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      listId: listId == null && nullToAbsent
          ? const Value.absent()
          : Value(listId),
      planId: planId == null && nullToAbsent
          ? const Value.absent()
          : Value(planId),
      evidenceUri: evidenceUri == null && nullToAbsent
          ? const Value.absent()
          : Value(evidenceUri),
      evidenceDisplayName: evidenceDisplayName == null && nullToAbsent
          ? const Value.absent()
          : Value(evidenceDisplayName),
      evidenceRelativePath: evidenceRelativePath == null && nullToAbsent
          ? const Value.absent()
          : Value(evidenceRelativePath),
      evidenceMimeType: evidenceMimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(evidenceMimeType),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ActiveTimerSessionData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveTimerSessionData(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<int>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      startTimeMs: serializer.fromJson<int>(json['startTimeMs']),
      pauseStartMs: serializer.fromJson<int?>(json['pauseStartMs']),
      pauseTotalMs: serializer.fromJson<int>(json['pauseTotalMs']),
      targetDurationMs: serializer.fromJson<int>(json['targetDurationMs']),
      state: serializer.fromJson<int>(json['state']),
      note: serializer.fromJson<String?>(json['note']),
      taskId: serializer.fromJson<int?>(json['taskId']),
      listId: serializer.fromJson<int?>(json['listId']),
      planId: serializer.fromJson<int?>(json['planId']),
      evidenceUri: serializer.fromJson<String?>(json['evidenceUri']),
      evidenceDisplayName: serializer.fromJson<String?>(
        json['evidenceDisplayName'],
      ),
      evidenceRelativePath: serializer.fromJson<String?>(
        json['evidenceRelativePath'],
      ),
      evidenceMimeType: serializer.fromJson<String?>(json['evidenceMimeType']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<int>(type),
      'name': serializer.toJson<String>(name),
      'startTimeMs': serializer.toJson<int>(startTimeMs),
      'pauseStartMs': serializer.toJson<int?>(pauseStartMs),
      'pauseTotalMs': serializer.toJson<int>(pauseTotalMs),
      'targetDurationMs': serializer.toJson<int>(targetDurationMs),
      'state': serializer.toJson<int>(state),
      'note': serializer.toJson<String?>(note),
      'taskId': serializer.toJson<int?>(taskId),
      'listId': serializer.toJson<int?>(listId),
      'planId': serializer.toJson<int?>(planId),
      'evidenceUri': serializer.toJson<String?>(evidenceUri),
      'evidenceDisplayName': serializer.toJson<String?>(evidenceDisplayName),
      'evidenceRelativePath': serializer.toJson<String?>(evidenceRelativePath),
      'evidenceMimeType': serializer.toJson<String?>(evidenceMimeType),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ActiveTimerSessionData copyWith({
    int? id,
    int? type,
    String? name,
    int? startTimeMs,
    Value<int?> pauseStartMs = const Value.absent(),
    int? pauseTotalMs,
    int? targetDurationMs,
    int? state,
    Value<String?> note = const Value.absent(),
    Value<int?> taskId = const Value.absent(),
    Value<int?> listId = const Value.absent(),
    Value<int?> planId = const Value.absent(),
    Value<String?> evidenceUri = const Value.absent(),
    Value<String?> evidenceDisplayName = const Value.absent(),
    Value<String?> evidenceRelativePath = const Value.absent(),
    Value<String?> evidenceMimeType = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => ActiveTimerSessionData(
    id: id ?? this.id,
    type: type ?? this.type,
    name: name ?? this.name,
    startTimeMs: startTimeMs ?? this.startTimeMs,
    pauseStartMs: pauseStartMs.present ? pauseStartMs.value : this.pauseStartMs,
    pauseTotalMs: pauseTotalMs ?? this.pauseTotalMs,
    targetDurationMs: targetDurationMs ?? this.targetDurationMs,
    state: state ?? this.state,
    note: note.present ? note.value : this.note,
    taskId: taskId.present ? taskId.value : this.taskId,
    listId: listId.present ? listId.value : this.listId,
    planId: planId.present ? planId.value : this.planId,
    evidenceUri: evidenceUri.present ? evidenceUri.value : this.evidenceUri,
    evidenceDisplayName: evidenceDisplayName.present
        ? evidenceDisplayName.value
        : this.evidenceDisplayName,
    evidenceRelativePath: evidenceRelativePath.present
        ? evidenceRelativePath.value
        : this.evidenceRelativePath,
    evidenceMimeType: evidenceMimeType.present
        ? evidenceMimeType.value
        : this.evidenceMimeType,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ActiveTimerSessionData copyWithCompanion(ActiveTimerSessionCompanion data) {
    return ActiveTimerSessionData(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      startTimeMs: data.startTimeMs.present
          ? data.startTimeMs.value
          : this.startTimeMs,
      pauseStartMs: data.pauseStartMs.present
          ? data.pauseStartMs.value
          : this.pauseStartMs,
      pauseTotalMs: data.pauseTotalMs.present
          ? data.pauseTotalMs.value
          : this.pauseTotalMs,
      targetDurationMs: data.targetDurationMs.present
          ? data.targetDurationMs.value
          : this.targetDurationMs,
      state: data.state.present ? data.state.value : this.state,
      note: data.note.present ? data.note.value : this.note,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      listId: data.listId.present ? data.listId.value : this.listId,
      planId: data.planId.present ? data.planId.value : this.planId,
      evidenceUri: data.evidenceUri.present
          ? data.evidenceUri.value
          : this.evidenceUri,
      evidenceDisplayName: data.evidenceDisplayName.present
          ? data.evidenceDisplayName.value
          : this.evidenceDisplayName,
      evidenceRelativePath: data.evidenceRelativePath.present
          ? data.evidenceRelativePath.value
          : this.evidenceRelativePath,
      evidenceMimeType: data.evidenceMimeType.present
          ? data.evidenceMimeType.value
          : this.evidenceMimeType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveTimerSessionData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('startTimeMs: $startTimeMs, ')
          ..write('pauseStartMs: $pauseStartMs, ')
          ..write('pauseTotalMs: $pauseTotalMs, ')
          ..write('targetDurationMs: $targetDurationMs, ')
          ..write('state: $state, ')
          ..write('note: $note, ')
          ..write('taskId: $taskId, ')
          ..write('listId: $listId, ')
          ..write('planId: $planId, ')
          ..write('evidenceUri: $evidenceUri, ')
          ..write('evidenceDisplayName: $evidenceDisplayName, ')
          ..write('evidenceRelativePath: $evidenceRelativePath, ')
          ..write('evidenceMimeType: $evidenceMimeType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    name,
    startTimeMs,
    pauseStartMs,
    pauseTotalMs,
    targetDurationMs,
    state,
    note,
    taskId,
    listId,
    planId,
    evidenceUri,
    evidenceDisplayName,
    evidenceRelativePath,
    evidenceMimeType,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveTimerSessionData &&
          other.id == this.id &&
          other.type == this.type &&
          other.name == this.name &&
          other.startTimeMs == this.startTimeMs &&
          other.pauseStartMs == this.pauseStartMs &&
          other.pauseTotalMs == this.pauseTotalMs &&
          other.targetDurationMs == this.targetDurationMs &&
          other.state == this.state &&
          other.note == this.note &&
          other.taskId == this.taskId &&
          other.listId == this.listId &&
          other.planId == this.planId &&
          other.evidenceUri == this.evidenceUri &&
          other.evidenceDisplayName == this.evidenceDisplayName &&
          other.evidenceRelativePath == this.evidenceRelativePath &&
          other.evidenceMimeType == this.evidenceMimeType &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ActiveTimerSessionCompanion
    extends UpdateCompanion<ActiveTimerSessionData> {
  final Value<int> id;
  final Value<int> type;
  final Value<String> name;
  final Value<int> startTimeMs;
  final Value<int?> pauseStartMs;
  final Value<int> pauseTotalMs;
  final Value<int> targetDurationMs;
  final Value<int> state;
  final Value<String?> note;
  final Value<int?> taskId;
  final Value<int?> listId;
  final Value<int?> planId;
  final Value<String?> evidenceUri;
  final Value<String?> evidenceDisplayName;
  final Value<String?> evidenceRelativePath;
  final Value<String?> evidenceMimeType;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const ActiveTimerSessionCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.startTimeMs = const Value.absent(),
    this.pauseStartMs = const Value.absent(),
    this.pauseTotalMs = const Value.absent(),
    this.targetDurationMs = const Value.absent(),
    this.state = const Value.absent(),
    this.note = const Value.absent(),
    this.taskId = const Value.absent(),
    this.listId = const Value.absent(),
    this.planId = const Value.absent(),
    this.evidenceUri = const Value.absent(),
    this.evidenceDisplayName = const Value.absent(),
    this.evidenceRelativePath = const Value.absent(),
    this.evidenceMimeType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ActiveTimerSessionCompanion.insert({
    this.id = const Value.absent(),
    required int type,
    required String name,
    required int startTimeMs,
    this.pauseStartMs = const Value.absent(),
    this.pauseTotalMs = const Value.absent(),
    this.targetDurationMs = const Value.absent(),
    required int state,
    this.note = const Value.absent(),
    this.taskId = const Value.absent(),
    this.listId = const Value.absent(),
    this.planId = const Value.absent(),
    this.evidenceUri = const Value.absent(),
    this.evidenceDisplayName = const Value.absent(),
    this.evidenceRelativePath = const Value.absent(),
    this.evidenceMimeType = const Value.absent(),
    required int createdAt,
    required int updatedAt,
  }) : type = Value(type),
       name = Value(name),
       startTimeMs = Value(startTimeMs),
       state = Value(state),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ActiveTimerSessionData> custom({
    Expression<int>? id,
    Expression<int>? type,
    Expression<String>? name,
    Expression<int>? startTimeMs,
    Expression<int>? pauseStartMs,
    Expression<int>? pauseTotalMs,
    Expression<int>? targetDurationMs,
    Expression<int>? state,
    Expression<String>? note,
    Expression<int>? taskId,
    Expression<int>? listId,
    Expression<int>? planId,
    Expression<String>? evidenceUri,
    Expression<String>? evidenceDisplayName,
    Expression<String>? evidenceRelativePath,
    Expression<String>? evidenceMimeType,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (startTimeMs != null) 'start_time_ms': startTimeMs,
      if (pauseStartMs != null) 'pause_start_ms': pauseStartMs,
      if (pauseTotalMs != null) 'pause_total_ms': pauseTotalMs,
      if (targetDurationMs != null) 'target_duration_ms': targetDurationMs,
      if (state != null) 'state': state,
      if (note != null) 'note': note,
      if (taskId != null) 'task_id': taskId,
      if (listId != null) 'list_id': listId,
      if (planId != null) 'plan_id': planId,
      if (evidenceUri != null) 'evidence_uri': evidenceUri,
      if (evidenceDisplayName != null)
        'evidence_display_name': evidenceDisplayName,
      if (evidenceRelativePath != null)
        'evidence_relative_path': evidenceRelativePath,
      if (evidenceMimeType != null) 'evidence_mime_type': evidenceMimeType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ActiveTimerSessionCompanion copyWith({
    Value<int>? id,
    Value<int>? type,
    Value<String>? name,
    Value<int>? startTimeMs,
    Value<int?>? pauseStartMs,
    Value<int>? pauseTotalMs,
    Value<int>? targetDurationMs,
    Value<int>? state,
    Value<String?>? note,
    Value<int?>? taskId,
    Value<int?>? listId,
    Value<int?>? planId,
    Value<String?>? evidenceUri,
    Value<String?>? evidenceDisplayName,
    Value<String?>? evidenceRelativePath,
    Value<String?>? evidenceMimeType,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return ActiveTimerSessionCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      startTimeMs: startTimeMs ?? this.startTimeMs,
      pauseStartMs: pauseStartMs ?? this.pauseStartMs,
      pauseTotalMs: pauseTotalMs ?? this.pauseTotalMs,
      targetDurationMs: targetDurationMs ?? this.targetDurationMs,
      state: state ?? this.state,
      note: note ?? this.note,
      taskId: taskId ?? this.taskId,
      listId: listId ?? this.listId,
      planId: planId ?? this.planId,
      evidenceUri: evidenceUri ?? this.evidenceUri,
      evidenceDisplayName: evidenceDisplayName ?? this.evidenceDisplayName,
      evidenceRelativePath: evidenceRelativePath ?? this.evidenceRelativePath,
      evidenceMimeType: evidenceMimeType ?? this.evidenceMimeType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startTimeMs.present) {
      map['start_time_ms'] = Variable<int>(startTimeMs.value);
    }
    if (pauseStartMs.present) {
      map['pause_start_ms'] = Variable<int>(pauseStartMs.value);
    }
    if (pauseTotalMs.present) {
      map['pause_total_ms'] = Variable<int>(pauseTotalMs.value);
    }
    if (targetDurationMs.present) {
      map['target_duration_ms'] = Variable<int>(targetDurationMs.value);
    }
    if (state.present) {
      map['state'] = Variable<int>(state.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<int>(listId.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    if (evidenceUri.present) {
      map['evidence_uri'] = Variable<String>(evidenceUri.value);
    }
    if (evidenceDisplayName.present) {
      map['evidence_display_name'] = Variable<String>(
        evidenceDisplayName.value,
      );
    }
    if (evidenceRelativePath.present) {
      map['evidence_relative_path'] = Variable<String>(
        evidenceRelativePath.value,
      );
    }
    if (evidenceMimeType.present) {
      map['evidence_mime_type'] = Variable<String>(evidenceMimeType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveTimerSessionCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('startTimeMs: $startTimeMs, ')
          ..write('pauseStartMs: $pauseStartMs, ')
          ..write('pauseTotalMs: $pauseTotalMs, ')
          ..write('targetDurationMs: $targetDurationMs, ')
          ..write('state: $state, ')
          ..write('note: $note, ')
          ..write('taskId: $taskId, ')
          ..write('listId: $listId, ')
          ..write('planId: $planId, ')
          ..write('evidenceUri: $evidenceUri, ')
          ..write('evidenceDisplayName: $evidenceDisplayName, ')
          ..write('evidenceRelativePath: $evidenceRelativePath, ')
          ..write('evidenceMimeType: $evidenceMimeType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DailyLogsTable extends DailyLogs
    with TableInfo<$DailyLogsTable, DailyLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _dayNumMeta = const VerificationMeta('dayNum');
  @override
  late final GeneratedColumn<int> dayNum = GeneratedColumn<int>(
    'day_num',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<int> loggedAt = GeneratedColumn<int>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    dayNum,
    type,
    loggedAt,
    note,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('day_num')) {
      context.handle(
        _dayNumMeta,
        dayNum.isAcceptableOrUnknown(data['day_num']!, _dayNumMeta),
      );
    } else if (isInserting) {
      context.missing(_dayNumMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      dayNum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_num'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}logged_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DailyLogsTable createAlias(String alias) {
    return $DailyLogsTable(attachedDatabase, alias);
  }
}

class DailyLog extends DataClass implements Insertable<DailyLog> {
  final int id;
  final int userId;
  final int dayNum;
  final int type;
  final int loggedAt;
  final String? note;
  final int createdAt;
  final int updatedAt;
  const DailyLog({
    required this.id,
    required this.userId,
    required this.dayNum,
    required this.type,
    required this.loggedAt,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['day_num'] = Variable<int>(dayNum);
    map['type'] = Variable<int>(type);
    map['logged_at'] = Variable<int>(loggedAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  DailyLogsCompanion toCompanion(bool nullToAbsent) {
    return DailyLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      dayNum: Value(dayNum),
      type: Value(type),
      loggedAt: Value(loggedAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyLog(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      dayNum: serializer.fromJson<int>(json['dayNum']),
      type: serializer.fromJson<int>(json['type']),
      loggedAt: serializer.fromJson<int>(json['loggedAt']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'dayNum': serializer.toJson<int>(dayNum),
      'type': serializer.toJson<int>(type),
      'loggedAt': serializer.toJson<int>(loggedAt),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  DailyLog copyWith({
    int? id,
    int? userId,
    int? dayNum,
    int? type,
    int? loggedAt,
    Value<String?> note = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => DailyLog(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    dayNum: dayNum ?? this.dayNum,
    type: type ?? this.type,
    loggedAt: loggedAt ?? this.loggedAt,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DailyLog copyWithCompanion(DailyLogsCompanion data) {
    return DailyLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      dayNum: data.dayNum.present ? data.dayNum.value : this.dayNum,
      type: data.type.present ? data.type.value : this.type,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('dayNum: $dayNum, ')
          ..write('type: $type, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    dayNum,
    type,
    loggedAt,
    note,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.dayNum == this.dayNum &&
          other.type == this.type &&
          other.loggedAt == this.loggedAt &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DailyLogsCompanion extends UpdateCompanion<DailyLog> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> dayNum;
  final Value<int> type;
  final Value<int> loggedAt;
  final Value<String?> note;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const DailyLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.dayNum = const Value.absent(),
    this.type = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DailyLogsCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    required int dayNum,
    required int type,
    required int loggedAt,
    this.note = const Value.absent(),
    required int createdAt,
    required int updatedAt,
  }) : dayNum = Value(dayNum),
       type = Value(type),
       loggedAt = Value(loggedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DailyLog> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? dayNum,
    Expression<int>? type,
    Expression<int>? loggedAt,
    Expression<String>? note,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (dayNum != null) 'day_num': dayNum,
      if (type != null) 'type': type,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DailyLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<int>? dayNum,
    Value<int>? type,
    Value<int>? loggedAt,
    Value<String?>? note,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return DailyLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dayNum: dayNum ?? this.dayNum,
      type: type ?? this.type,
      loggedAt: loggedAt ?? this.loggedAt,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (dayNum.present) {
      map['day_num'] = Variable<int>(dayNum.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<int>(loggedAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('dayNum: $dayNum, ')
          ..write('type: $type, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TaskListsTable extends TaskLists
    with TableInfo<$TaskListsTable, TaskList> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskListsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF4CAF50),
  );
  static const VerificationMeta _iconCodePointMeta = const VerificationMeta(
    'iconCodePoint',
  );
  @override
  late final GeneratedColumn<int> iconCodePoint = GeneratedColumn<int>(
    'icon_code_point',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xf428),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isDailyResetMeta = const VerificationMeta(
    'isDailyReset',
  );
  @override
  late final GeneratedColumn<int> isDailyReset = GeneratedColumn<int>(
    'is_daily_reset',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    color,
    iconCodePoint,
    sortOrder,
    isDeleted,
    isDailyReset,
    deletedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_lists';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskList> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('icon_code_point')) {
      context.handle(
        _iconCodePointMeta,
        iconCodePoint.isAcceptableOrUnknown(
          data['icon_code_point']!,
          _iconCodePointMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('is_daily_reset')) {
      context.handle(
        _isDailyResetMeta,
        isDailyReset.isAcceptableOrUnknown(
          data['is_daily_reset']!,
          _isDailyResetMeta,
        ),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskList map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskList(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      iconCodePoint: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}icon_code_point'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_deleted'],
      )!,
      isDailyReset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_daily_reset'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TaskListsTable createAlias(String alias) {
    return $TaskListsTable(attachedDatabase, alias);
  }
}

class TaskList extends DataClass implements Insertable<TaskList> {
  final int id;
  final int userId;
  final String name;
  final int color;
  final int iconCodePoint;
  final int sortOrder;
  final int isDeleted;
  final int isDailyReset;
  final int? deletedAt;
  final int createdAt;
  final int updatedAt;
  const TaskList({
    required this.id,
    required this.userId,
    required this.name,
    required this.color,
    required this.iconCodePoint,
    required this.sortOrder,
    required this.isDeleted,
    required this.isDailyReset,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    map['icon_code_point'] = Variable<int>(iconCodePoint);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_deleted'] = Variable<int>(isDeleted);
    map['is_daily_reset'] = Variable<int>(isDailyReset);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  TaskListsCompanion toCompanion(bool nullToAbsent) {
    return TaskListsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      color: Value(color),
      iconCodePoint: Value(iconCodePoint),
      sortOrder: Value(sortOrder),
      isDeleted: Value(isDeleted),
      isDailyReset: Value(isDailyReset),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskList.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskList(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      iconCodePoint: serializer.fromJson<int>(json['iconCodePoint']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
      isDailyReset: serializer.fromJson<int>(json['isDailyReset']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'iconCodePoint': serializer.toJson<int>(iconCodePoint),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isDeleted': serializer.toJson<int>(isDeleted),
      'isDailyReset': serializer.toJson<int>(isDailyReset),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  TaskList copyWith({
    int? id,
    int? userId,
    String? name,
    int? color,
    int? iconCodePoint,
    int? sortOrder,
    int? isDeleted,
    int? isDailyReset,
    Value<int?> deletedAt = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => TaskList(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    color: color ?? this.color,
    iconCodePoint: iconCodePoint ?? this.iconCodePoint,
    sortOrder: sortOrder ?? this.sortOrder,
    isDeleted: isDeleted ?? this.isDeleted,
    isDailyReset: isDailyReset ?? this.isDailyReset,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskList copyWithCompanion(TaskListsCompanion data) {
    return TaskList(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      iconCodePoint: data.iconCodePoint.present
          ? data.iconCodePoint.value
          : this.iconCodePoint,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      isDailyReset: data.isDailyReset.present
          ? data.isDailyReset.value
          : this.isDailyReset,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskList(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('isDailyReset: $isDailyReset, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    color,
    iconCodePoint,
    sortOrder,
    isDeleted,
    isDailyReset,
    deletedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskList &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.color == this.color &&
          other.iconCodePoint == this.iconCodePoint &&
          other.sortOrder == this.sortOrder &&
          other.isDeleted == this.isDeleted &&
          other.isDailyReset == this.isDailyReset &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaskListsCompanion extends UpdateCompanion<TaskList> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> name;
  final Value<int> color;
  final Value<int> iconCodePoint;
  final Value<int> sortOrder;
  final Value<int> isDeleted;
  final Value<int> isDailyReset;
  final Value<int?> deletedAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const TaskListsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.iconCodePoint = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.isDailyReset = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TaskListsCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
    this.iconCodePoint = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.isDailyReset = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required int createdAt,
    required int updatedAt,
  }) : name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TaskList> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? name,
    Expression<int>? color,
    Expression<int>? iconCodePoint,
    Expression<int>? sortOrder,
    Expression<int>? isDeleted,
    Expression<int>? isDailyReset,
    Expression<int>? deletedAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (iconCodePoint != null) 'icon_code_point': iconCodePoint,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (isDailyReset != null) 'is_daily_reset': isDailyReset,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TaskListsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? name,
    Value<int>? color,
    Value<int>? iconCodePoint,
    Value<int>? sortOrder,
    Value<int>? isDeleted,
    Value<int>? isDailyReset,
    Value<int?>? deletedAt,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return TaskListsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      color: color ?? this.color,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      sortOrder: sortOrder ?? this.sortOrder,
      isDeleted: isDeleted ?? this.isDeleted,
      isDailyReset: isDailyReset ?? this.isDailyReset,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (iconCodePoint.present) {
      map['icon_code_point'] = Variable<int>(iconCodePoint.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    if (isDailyReset.present) {
      map['is_daily_reset'] = Variable<int>(isDailyReset.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskListsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('isDailyReset: $isDailyReset, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<int> listId = GeneratedColumn<int>(
    'list_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayNumMeta = const VerificationMeta('dayNum');
  @override
  late final GeneratedColumn<int> dayNum = GeneratedColumn<int>(
    'day_num',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<int> state = GeneratedColumn<int>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dueDayNumMeta = const VerificationMeta(
    'dueDayNum',
  );
  @override
  late final GeneratedColumn<int> dueDayNum = GeneratedColumn<int>(
    'due_day_num',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estimatedMinutesMeta = const VerificationMeta(
    'estimatedMinutes',
  );
  @override
  late final GeneratedColumn<int> estimatedMinutes = GeneratedColumn<int>(
    'estimated_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isFocusMeta = const VerificationMeta(
    'isFocus',
  );
  @override
  late final GeneratedColumn<int> isFocus = GeneratedColumn<int>(
    'is_focus',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<int> isPinned = GeneratedColumn<int>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pinnedAtMeta = const VerificationMeta(
    'pinnedAt',
  );
  @override
  late final GeneratedColumn<int> pinnedAt = GeneratedColumn<int>(
    'pinned_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderAtMeta = const VerificationMeta(
    'reminderAt',
  );
  @override
  late final GeneratedColumn<int> reminderAt = GeneratedColumn<int>(
    'reminder_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatRuleMeta = const VerificationMeta(
    'repeatRule',
  );
  @override
  late final GeneratedColumn<String> repeatRule = GeneratedColumn<String>(
    'repeat_rule',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<int> completedAt = GeneratedColumn<int>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    listId,
    dayNum,
    title,
    description,
    color,
    state,
    priority,
    dueDayNum,
    estimatedMinutes,
    isFocus,
    isPinned,
    pinnedAt,
    reminderAt,
    repeatRule,
    sortOrder,
    createdAt,
    updatedAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('day_num')) {
      context.handle(
        _dayNumMeta,
        dayNum.isAcceptableOrUnknown(data['day_num']!, _dayNumMeta),
      );
    } else if (isInserting) {
      context.missing(_dayNumMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('due_day_num')) {
      context.handle(
        _dueDayNumMeta,
        dueDayNum.isAcceptableOrUnknown(data['due_day_num']!, _dueDayNumMeta),
      );
    }
    if (data.containsKey('estimated_minutes')) {
      context.handle(
        _estimatedMinutesMeta,
        estimatedMinutes.isAcceptableOrUnknown(
          data['estimated_minutes']!,
          _estimatedMinutesMeta,
        ),
      );
    }
    if (data.containsKey('is_focus')) {
      context.handle(
        _isFocusMeta,
        isFocus.isAcceptableOrUnknown(data['is_focus']!, _isFocusMeta),
      );
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
      );
    }
    if (data.containsKey('pinned_at')) {
      context.handle(
        _pinnedAtMeta,
        pinnedAt.isAcceptableOrUnknown(data['pinned_at']!, _pinnedAtMeta),
      );
    }
    if (data.containsKey('reminder_at')) {
      context.handle(
        _reminderAtMeta,
        reminderAt.isAcceptableOrUnknown(data['reminder_at']!, _reminderAtMeta),
      );
    }
    if (data.containsKey('repeat_rule')) {
      context.handle(
        _repeatRuleMeta,
        repeatRule.isAcceptableOrUnknown(data['repeat_rule']!, _repeatRuleMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}list_id'],
      )!,
      dayNum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_num'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}state'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      dueDayNum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_day_num'],
      ),
      estimatedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_minutes'],
      )!,
      isFocus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_focus'],
      )!,
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_pinned'],
      )!,
      pinnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pinned_at'],
      ),
      reminderAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_at'],
      ),
      repeatRule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_rule'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final int id;
  final int userId;
  final int listId;
  final int dayNum;
  final String title;
  final String? description;
  final int? color;
  final int state;
  final int priority;
  final int? dueDayNum;
  final int estimatedMinutes;
  final int isFocus;
  final int isPinned;
  final int? pinnedAt;
  final int? reminderAt;
  final String repeatRule;
  final int sortOrder;
  final int createdAt;
  final int updatedAt;
  final int? completedAt;
  const Task({
    required this.id,
    required this.userId,
    required this.listId,
    required this.dayNum,
    required this.title,
    this.description,
    this.color,
    required this.state,
    required this.priority,
    this.dueDayNum,
    required this.estimatedMinutes,
    required this.isFocus,
    required this.isPinned,
    this.pinnedAt,
    this.reminderAt,
    required this.repeatRule,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['list_id'] = Variable<int>(listId);
    map['day_num'] = Variable<int>(dayNum);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    map['state'] = Variable<int>(state);
    map['priority'] = Variable<int>(priority);
    if (!nullToAbsent || dueDayNum != null) {
      map['due_day_num'] = Variable<int>(dueDayNum);
    }
    map['estimated_minutes'] = Variable<int>(estimatedMinutes);
    map['is_focus'] = Variable<int>(isFocus);
    map['is_pinned'] = Variable<int>(isPinned);
    if (!nullToAbsent || pinnedAt != null) {
      map['pinned_at'] = Variable<int>(pinnedAt);
    }
    if (!nullToAbsent || reminderAt != null) {
      map['reminder_at'] = Variable<int>(reminderAt);
    }
    map['repeat_rule'] = Variable<String>(repeatRule);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<int>(completedAt);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      userId: Value(userId),
      listId: Value(listId),
      dayNum: Value(dayNum),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      state: Value(state),
      priority: Value(priority),
      dueDayNum: dueDayNum == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDayNum),
      estimatedMinutes: Value(estimatedMinutes),
      isFocus: Value(isFocus),
      isPinned: Value(isPinned),
      pinnedAt: pinnedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(pinnedAt),
      reminderAt: reminderAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderAt),
      repeatRule: Value(repeatRule),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      listId: serializer.fromJson<int>(json['listId']),
      dayNum: serializer.fromJson<int>(json['dayNum']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      color: serializer.fromJson<int?>(json['color']),
      state: serializer.fromJson<int>(json['state']),
      priority: serializer.fromJson<int>(json['priority']),
      dueDayNum: serializer.fromJson<int?>(json['dueDayNum']),
      estimatedMinutes: serializer.fromJson<int>(json['estimatedMinutes']),
      isFocus: serializer.fromJson<int>(json['isFocus']),
      isPinned: serializer.fromJson<int>(json['isPinned']),
      pinnedAt: serializer.fromJson<int?>(json['pinnedAt']),
      reminderAt: serializer.fromJson<int?>(json['reminderAt']),
      repeatRule: serializer.fromJson<String>(json['repeatRule']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      completedAt: serializer.fromJson<int?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'listId': serializer.toJson<int>(listId),
      'dayNum': serializer.toJson<int>(dayNum),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'color': serializer.toJson<int?>(color),
      'state': serializer.toJson<int>(state),
      'priority': serializer.toJson<int>(priority),
      'dueDayNum': serializer.toJson<int?>(dueDayNum),
      'estimatedMinutes': serializer.toJson<int>(estimatedMinutes),
      'isFocus': serializer.toJson<int>(isFocus),
      'isPinned': serializer.toJson<int>(isPinned),
      'pinnedAt': serializer.toJson<int?>(pinnedAt),
      'reminderAt': serializer.toJson<int?>(reminderAt),
      'repeatRule': serializer.toJson<String>(repeatRule),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'completedAt': serializer.toJson<int?>(completedAt),
    };
  }

  Task copyWith({
    int? id,
    int? userId,
    int? listId,
    int? dayNum,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<int?> color = const Value.absent(),
    int? state,
    int? priority,
    Value<int?> dueDayNum = const Value.absent(),
    int? estimatedMinutes,
    int? isFocus,
    int? isPinned,
    Value<int?> pinnedAt = const Value.absent(),
    Value<int?> reminderAt = const Value.absent(),
    String? repeatRule,
    int? sortOrder,
    int? createdAt,
    int? updatedAt,
    Value<int?> completedAt = const Value.absent(),
  }) => Task(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    listId: listId ?? this.listId,
    dayNum: dayNum ?? this.dayNum,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    color: color.present ? color.value : this.color,
    state: state ?? this.state,
    priority: priority ?? this.priority,
    dueDayNum: dueDayNum.present ? dueDayNum.value : this.dueDayNum,
    estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    isFocus: isFocus ?? this.isFocus,
    isPinned: isPinned ?? this.isPinned,
    pinnedAt: pinnedAt.present ? pinnedAt.value : this.pinnedAt,
    reminderAt: reminderAt.present ? reminderAt.value : this.reminderAt,
    repeatRule: repeatRule ?? this.repeatRule,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      listId: data.listId.present ? data.listId.value : this.listId,
      dayNum: data.dayNum.present ? data.dayNum.value : this.dayNum,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      color: data.color.present ? data.color.value : this.color,
      state: data.state.present ? data.state.value : this.state,
      priority: data.priority.present ? data.priority.value : this.priority,
      dueDayNum: data.dueDayNum.present ? data.dueDayNum.value : this.dueDayNum,
      estimatedMinutes: data.estimatedMinutes.present
          ? data.estimatedMinutes.value
          : this.estimatedMinutes,
      isFocus: data.isFocus.present ? data.isFocus.value : this.isFocus,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      pinnedAt: data.pinnedAt.present ? data.pinnedAt.value : this.pinnedAt,
      reminderAt: data.reminderAt.present
          ? data.reminderAt.value
          : this.reminderAt,
      repeatRule: data.repeatRule.present
          ? data.repeatRule.value
          : this.repeatRule,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('listId: $listId, ')
          ..write('dayNum: $dayNum, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('color: $color, ')
          ..write('state: $state, ')
          ..write('priority: $priority, ')
          ..write('dueDayNum: $dueDayNum, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('isFocus: $isFocus, ')
          ..write('isPinned: $isPinned, ')
          ..write('pinnedAt: $pinnedAt, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('repeatRule: $repeatRule, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    listId,
    dayNum,
    title,
    description,
    color,
    state,
    priority,
    dueDayNum,
    estimatedMinutes,
    isFocus,
    isPinned,
    pinnedAt,
    reminderAt,
    repeatRule,
    sortOrder,
    createdAt,
    updatedAt,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.listId == this.listId &&
          other.dayNum == this.dayNum &&
          other.title == this.title &&
          other.description == this.description &&
          other.color == this.color &&
          other.state == this.state &&
          other.priority == this.priority &&
          other.dueDayNum == this.dueDayNum &&
          other.estimatedMinutes == this.estimatedMinutes &&
          other.isFocus == this.isFocus &&
          other.isPinned == this.isPinned &&
          other.pinnedAt == this.pinnedAt &&
          other.reminderAt == this.reminderAt &&
          other.repeatRule == this.repeatRule &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.completedAt == this.completedAt);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> listId;
  final Value<int> dayNum;
  final Value<String> title;
  final Value<String?> description;
  final Value<int?> color;
  final Value<int> state;
  final Value<int> priority;
  final Value<int?> dueDayNum;
  final Value<int> estimatedMinutes;
  final Value<int> isFocus;
  final Value<int> isPinned;
  final Value<int?> pinnedAt;
  final Value<int?> reminderAt;
  final Value<String> repeatRule;
  final Value<int> sortOrder;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> completedAt;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.listId = const Value.absent(),
    this.dayNum = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.color = const Value.absent(),
    this.state = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueDayNum = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.isFocus = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.pinnedAt = const Value.absent(),
    this.reminderAt = const Value.absent(),
    this.repeatRule = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    required int listId,
    required int dayNum,
    required String title,
    this.description = const Value.absent(),
    this.color = const Value.absent(),
    this.state = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueDayNum = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.isFocus = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.pinnedAt = const Value.absent(),
    this.reminderAt = const Value.absent(),
    this.repeatRule = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.completedAt = const Value.absent(),
  }) : listId = Value(listId),
       dayNum = Value(dayNum),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Task> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? listId,
    Expression<int>? dayNum,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? color,
    Expression<int>? state,
    Expression<int>? priority,
    Expression<int>? dueDayNum,
    Expression<int>? estimatedMinutes,
    Expression<int>? isFocus,
    Expression<int>? isPinned,
    Expression<int>? pinnedAt,
    Expression<int>? reminderAt,
    Expression<String>? repeatRule,
    Expression<int>? sortOrder,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (listId != null) 'list_id': listId,
      if (dayNum != null) 'day_num': dayNum,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (color != null) 'color': color,
      if (state != null) 'state': state,
      if (priority != null) 'priority': priority,
      if (dueDayNum != null) 'due_day_num': dueDayNum,
      if (estimatedMinutes != null) 'estimated_minutes': estimatedMinutes,
      if (isFocus != null) 'is_focus': isFocus,
      if (isPinned != null) 'is_pinned': isPinned,
      if (pinnedAt != null) 'pinned_at': pinnedAt,
      if (reminderAt != null) 'reminder_at': reminderAt,
      if (repeatRule != null) 'repeat_rule': repeatRule,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  TasksCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<int>? listId,
    Value<int>? dayNum,
    Value<String>? title,
    Value<String?>? description,
    Value<int?>? color,
    Value<int>? state,
    Value<int>? priority,
    Value<int?>? dueDayNum,
    Value<int>? estimatedMinutes,
    Value<int>? isFocus,
    Value<int>? isPinned,
    Value<int?>? pinnedAt,
    Value<int?>? reminderAt,
    Value<String>? repeatRule,
    Value<int>? sortOrder,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? completedAt,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      listId: listId ?? this.listId,
      dayNum: dayNum ?? this.dayNum,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
      state: state ?? this.state,
      priority: priority ?? this.priority,
      dueDayNum: dueDayNum ?? this.dueDayNum,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      isFocus: isFocus ?? this.isFocus,
      isPinned: isPinned ?? this.isPinned,
      pinnedAt: pinnedAt ?? this.pinnedAt,
      reminderAt: reminderAt ?? this.reminderAt,
      repeatRule: repeatRule ?? this.repeatRule,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<int>(listId.value);
    }
    if (dayNum.present) {
      map['day_num'] = Variable<int>(dayNum.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (state.present) {
      map['state'] = Variable<int>(state.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (dueDayNum.present) {
      map['due_day_num'] = Variable<int>(dueDayNum.value);
    }
    if (estimatedMinutes.present) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes.value);
    }
    if (isFocus.present) {
      map['is_focus'] = Variable<int>(isFocus.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<int>(isPinned.value);
    }
    if (pinnedAt.present) {
      map['pinned_at'] = Variable<int>(pinnedAt.value);
    }
    if (reminderAt.present) {
      map['reminder_at'] = Variable<int>(reminderAt.value);
    }
    if (repeatRule.present) {
      map['repeat_rule'] = Variable<String>(repeatRule.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<int>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('listId: $listId, ')
          ..write('dayNum: $dayNum, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('color: $color, ')
          ..write('state: $state, ')
          ..write('priority: $priority, ')
          ..write('dueDayNum: $dueDayNum, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('isFocus: $isFocus, ')
          ..write('isPinned: $isPinned, ')
          ..write('pinnedAt: $pinnedAt, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('repeatRule: $repeatRule, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $TaskPlansTable extends TaskPlans
    with TableInfo<$TaskPlansTable, TaskPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskPlansTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<int> listId = GeneratedColumn<int>(
    'list_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayNumMeta = const VerificationMeta('dayNum');
  @override
  late final GeneratedColumn<int> dayNum = GeneratedColumn<int>(
    'day_num',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startHourMeta = const VerificationMeta(
    'startHour',
  );
  @override
  late final GeneratedColumn<int> startHour = GeneratedColumn<int>(
    'start_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMinuteMeta = const VerificationMeta(
    'startMinute',
  );
  @override
  late final GeneratedColumn<int> startMinute = GeneratedColumn<int>(
    'start_minute',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(60),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    listId,
    taskId,
    dayNum,
    startHour,
    startMinute,
    durationMinutes,
    sortOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('day_num')) {
      context.handle(
        _dayNumMeta,
        dayNum.isAcceptableOrUnknown(data['day_num']!, _dayNumMeta),
      );
    } else if (isInserting) {
      context.missing(_dayNumMeta);
    }
    if (data.containsKey('start_hour')) {
      context.handle(
        _startHourMeta,
        startHour.isAcceptableOrUnknown(data['start_hour']!, _startHourMeta),
      );
    } else if (isInserting) {
      context.missing(_startHourMeta);
    }
    if (data.containsKey('start_minute')) {
      context.handle(
        _startMinuteMeta,
        startMinute.isAcceptableOrUnknown(
          data['start_minute']!,
          _startMinuteMeta,
        ),
      );
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}list_id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      )!,
      dayNum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_num'],
      )!,
      startHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_hour'],
      )!,
      startMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minute'],
      ),
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TaskPlansTable createAlias(String alias) {
    return $TaskPlansTable(attachedDatabase, alias);
  }
}

class TaskPlan extends DataClass implements Insertable<TaskPlan> {
  final int id;
  final int userId;
  final int listId;
  final int taskId;
  final int dayNum;
  final int startHour;
  final int? startMinute;
  final int durationMinutes;
  final int sortOrder;
  final int createdAt;
  final int updatedAt;
  const TaskPlan({
    required this.id,
    required this.userId,
    required this.listId,
    required this.taskId,
    required this.dayNum,
    required this.startHour,
    this.startMinute,
    required this.durationMinutes,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['list_id'] = Variable<int>(listId);
    map['task_id'] = Variable<int>(taskId);
    map['day_num'] = Variable<int>(dayNum);
    map['start_hour'] = Variable<int>(startHour);
    if (!nullToAbsent || startMinute != null) {
      map['start_minute'] = Variable<int>(startMinute);
    }
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  TaskPlansCompanion toCompanion(bool nullToAbsent) {
    return TaskPlansCompanion(
      id: Value(id),
      userId: Value(userId),
      listId: Value(listId),
      taskId: Value(taskId),
      dayNum: Value(dayNum),
      startHour: Value(startHour),
      startMinute: startMinute == null && nullToAbsent
          ? const Value.absent()
          : Value(startMinute),
      durationMinutes: Value(durationMinutes),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskPlan(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      listId: serializer.fromJson<int>(json['listId']),
      taskId: serializer.fromJson<int>(json['taskId']),
      dayNum: serializer.fromJson<int>(json['dayNum']),
      startHour: serializer.fromJson<int>(json['startHour']),
      startMinute: serializer.fromJson<int?>(json['startMinute']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'listId': serializer.toJson<int>(listId),
      'taskId': serializer.toJson<int>(taskId),
      'dayNum': serializer.toJson<int>(dayNum),
      'startHour': serializer.toJson<int>(startHour),
      'startMinute': serializer.toJson<int?>(startMinute),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  TaskPlan copyWith({
    int? id,
    int? userId,
    int? listId,
    int? taskId,
    int? dayNum,
    int? startHour,
    Value<int?> startMinute = const Value.absent(),
    int? durationMinutes,
    int? sortOrder,
    int? createdAt,
    int? updatedAt,
  }) => TaskPlan(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    listId: listId ?? this.listId,
    taskId: taskId ?? this.taskId,
    dayNum: dayNum ?? this.dayNum,
    startHour: startHour ?? this.startHour,
    startMinute: startMinute.present ? startMinute.value : this.startMinute,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskPlan copyWithCompanion(TaskPlansCompanion data) {
    return TaskPlan(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      listId: data.listId.present ? data.listId.value : this.listId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      dayNum: data.dayNum.present ? data.dayNum.value : this.dayNum,
      startHour: data.startHour.present ? data.startHour.value : this.startHour,
      startMinute: data.startMinute.present
          ? data.startMinute.value
          : this.startMinute,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskPlan(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('listId: $listId, ')
          ..write('taskId: $taskId, ')
          ..write('dayNum: $dayNum, ')
          ..write('startHour: $startHour, ')
          ..write('startMinute: $startMinute, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    listId,
    taskId,
    dayNum,
    startHour,
    startMinute,
    durationMinutes,
    sortOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskPlan &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.listId == this.listId &&
          other.taskId == this.taskId &&
          other.dayNum == this.dayNum &&
          other.startHour == this.startHour &&
          other.startMinute == this.startMinute &&
          other.durationMinutes == this.durationMinutes &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaskPlansCompanion extends UpdateCompanion<TaskPlan> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> listId;
  final Value<int> taskId;
  final Value<int> dayNum;
  final Value<int> startHour;
  final Value<int?> startMinute;
  final Value<int> durationMinutes;
  final Value<int> sortOrder;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const TaskPlansCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.listId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.dayNum = const Value.absent(),
    this.startHour = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TaskPlansCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    required int listId,
    required int taskId,
    required int dayNum,
    required int startHour,
    this.startMinute = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required int createdAt,
    required int updatedAt,
  }) : listId = Value(listId),
       taskId = Value(taskId),
       dayNum = Value(dayNum),
       startHour = Value(startHour),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TaskPlan> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? listId,
    Expression<int>? taskId,
    Expression<int>? dayNum,
    Expression<int>? startHour,
    Expression<int>? startMinute,
    Expression<int>? durationMinutes,
    Expression<int>? sortOrder,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (listId != null) 'list_id': listId,
      if (taskId != null) 'task_id': taskId,
      if (dayNum != null) 'day_num': dayNum,
      if (startHour != null) 'start_hour': startHour,
      if (startMinute != null) 'start_minute': startMinute,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TaskPlansCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<int>? listId,
    Value<int>? taskId,
    Value<int>? dayNum,
    Value<int>? startHour,
    Value<int?>? startMinute,
    Value<int>? durationMinutes,
    Value<int>? sortOrder,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return TaskPlansCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      listId: listId ?? this.listId,
      taskId: taskId ?? this.taskId,
      dayNum: dayNum ?? this.dayNum,
      startHour: startHour ?? this.startHour,
      startMinute: startMinute ?? this.startMinute,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<int>(listId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (dayNum.present) {
      map['day_num'] = Variable<int>(dayNum.value);
    }
    if (startHour.present) {
      map['start_hour'] = Variable<int>(startHour.value);
    }
    if (startMinute.present) {
      map['start_minute'] = Variable<int>(startMinute.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskPlansCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('listId: $listId, ')
          ..write('taskId: $taskId, ')
          ..write('dayNum: $dayNum, ')
          ..write('startHour: $startHour, ')
          ..write('startMinute: $startMinute, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TaskPlanSettingsTable extends TaskPlanSettings
    with TableInfo<$TaskPlanSettingsTable, TaskPlanSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskPlanSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _startMinuteMeta = const VerificationMeta(
    'startMinute',
  );
  @override
  late final GeneratedColumn<int> startMinute = GeneratedColumn<int>(
    'start_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _endMinuteMeta = const VerificationMeta(
    'endMinute',
  );
  @override
  late final GeneratedColumn<int> endMinute = GeneratedColumn<int>(
    'end_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1440),
  );
  static const VerificationMeta _slotMinutesMeta = const VerificationMeta(
    'slotMinutes',
  );
  @override
  late final GeneratedColumn<int> slotMinutes = GeneratedColumn<int>(
    'slot_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(60),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startMinute,
    endMinute,
    slotMinutes,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_plan_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskPlanSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_minute')) {
      context.handle(
        _startMinuteMeta,
        startMinute.isAcceptableOrUnknown(
          data['start_minute']!,
          _startMinuteMeta,
        ),
      );
    }
    if (data.containsKey('end_minute')) {
      context.handle(
        _endMinuteMeta,
        endMinute.isAcceptableOrUnknown(data['end_minute']!, _endMinuteMeta),
      );
    }
    if (data.containsKey('slot_minutes')) {
      context.handle(
        _slotMinutesMeta,
        slotMinutes.isAcceptableOrUnknown(
          data['slot_minutes']!,
          _slotMinutesMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskPlanSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskPlanSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minute'],
      )!,
      endMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minute'],
      )!,
      slotMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slot_minutes'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TaskPlanSettingsTable createAlias(String alias) {
    return $TaskPlanSettingsTable(attachedDatabase, alias);
  }
}

class TaskPlanSetting extends DataClass implements Insertable<TaskPlanSetting> {
  final int id;
  final int startMinute;
  final int endMinute;
  final int slotMinutes;
  final int updatedAt;
  const TaskPlanSetting({
    required this.id,
    required this.startMinute,
    required this.endMinute,
    required this.slotMinutes,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_minute'] = Variable<int>(startMinute);
    map['end_minute'] = Variable<int>(endMinute);
    map['slot_minutes'] = Variable<int>(slotMinutes);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  TaskPlanSettingsCompanion toCompanion(bool nullToAbsent) {
    return TaskPlanSettingsCompanion(
      id: Value(id),
      startMinute: Value(startMinute),
      endMinute: Value(endMinute),
      slotMinutes: Value(slotMinutes),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskPlanSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskPlanSetting(
      id: serializer.fromJson<int>(json['id']),
      startMinute: serializer.fromJson<int>(json['startMinute']),
      endMinute: serializer.fromJson<int>(json['endMinute']),
      slotMinutes: serializer.fromJson<int>(json['slotMinutes']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startMinute': serializer.toJson<int>(startMinute),
      'endMinute': serializer.toJson<int>(endMinute),
      'slotMinutes': serializer.toJson<int>(slotMinutes),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  TaskPlanSetting copyWith({
    int? id,
    int? startMinute,
    int? endMinute,
    int? slotMinutes,
    int? updatedAt,
  }) => TaskPlanSetting(
    id: id ?? this.id,
    startMinute: startMinute ?? this.startMinute,
    endMinute: endMinute ?? this.endMinute,
    slotMinutes: slotMinutes ?? this.slotMinutes,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskPlanSetting copyWithCompanion(TaskPlanSettingsCompanion data) {
    return TaskPlanSetting(
      id: data.id.present ? data.id.value : this.id,
      startMinute: data.startMinute.present
          ? data.startMinute.value
          : this.startMinute,
      endMinute: data.endMinute.present ? data.endMinute.value : this.endMinute,
      slotMinutes: data.slotMinutes.present
          ? data.slotMinutes.value
          : this.slotMinutes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskPlanSetting(')
          ..write('id: $id, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute, ')
          ..write('slotMinutes: $slotMinutes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, startMinute, endMinute, slotMinutes, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskPlanSetting &&
          other.id == this.id &&
          other.startMinute == this.startMinute &&
          other.endMinute == this.endMinute &&
          other.slotMinutes == this.slotMinutes &&
          other.updatedAt == this.updatedAt);
}

class TaskPlanSettingsCompanion extends UpdateCompanion<TaskPlanSetting> {
  final Value<int> id;
  final Value<int> startMinute;
  final Value<int> endMinute;
  final Value<int> slotMinutes;
  final Value<int> updatedAt;
  const TaskPlanSettingsCompanion({
    this.id = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endMinute = const Value.absent(),
    this.slotMinutes = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TaskPlanSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endMinute = const Value.absent(),
    this.slotMinutes = const Value.absent(),
    required int updatedAt,
  }) : updatedAt = Value(updatedAt);
  static Insertable<TaskPlanSetting> custom({
    Expression<int>? id,
    Expression<int>? startMinute,
    Expression<int>? endMinute,
    Expression<int>? slotMinutes,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startMinute != null) 'start_minute': startMinute,
      if (endMinute != null) 'end_minute': endMinute,
      if (slotMinutes != null) 'slot_minutes': slotMinutes,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TaskPlanSettingsCompanion copyWith({
    Value<int>? id,
    Value<int>? startMinute,
    Value<int>? endMinute,
    Value<int>? slotMinutes,
    Value<int>? updatedAt,
  }) {
    return TaskPlanSettingsCompanion(
      id: id ?? this.id,
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
      slotMinutes: slotMinutes ?? this.slotMinutes,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startMinute.present) {
      map['start_minute'] = Variable<int>(startMinute.value);
    }
    if (endMinute.present) {
      map['end_minute'] = Variable<int>(endMinute.value);
    }
    if (slotMinutes.present) {
      map['slot_minutes'] = Variable<int>(slotMinutes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskPlanSettingsCompanion(')
          ..write('id: $id, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute, ')
          ..write('slotMinutes: $slotMinutes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $StatsSettingsTable extends StatsSettings
    with TableInfo<$StatsSettingsTable, StatsSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StatsSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _visibleChartsMeta = const VerificationMeta(
    'visibleCharts',
  );
  @override
  late final GeneratedColumn<String> visibleCharts = GeneratedColumn<String>(
    'visible_charts',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('heatmap,pie,dailyLog,timeline'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, visibleCharts, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stats_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<StatsSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('visible_charts')) {
      context.handle(
        _visibleChartsMeta,
        visibleCharts.isAcceptableOrUnknown(
          data['visible_charts']!,
          _visibleChartsMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StatsSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StatsSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      visibleCharts: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visible_charts'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StatsSettingsTable createAlias(String alias) {
    return $StatsSettingsTable(attachedDatabase, alias);
  }
}

class StatsSetting extends DataClass implements Insertable<StatsSetting> {
  final int id;
  final String visibleCharts;
  final int updatedAt;
  const StatsSetting({
    required this.id,
    required this.visibleCharts,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['visible_charts'] = Variable<String>(visibleCharts);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  StatsSettingsCompanion toCompanion(bool nullToAbsent) {
    return StatsSettingsCompanion(
      id: Value(id),
      visibleCharts: Value(visibleCharts),
      updatedAt: Value(updatedAt),
    );
  }

  factory StatsSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StatsSetting(
      id: serializer.fromJson<int>(json['id']),
      visibleCharts: serializer.fromJson<String>(json['visibleCharts']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'visibleCharts': serializer.toJson<String>(visibleCharts),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  StatsSetting copyWith({int? id, String? visibleCharts, int? updatedAt}) =>
      StatsSetting(
        id: id ?? this.id,
        visibleCharts: visibleCharts ?? this.visibleCharts,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  StatsSetting copyWithCompanion(StatsSettingsCompanion data) {
    return StatsSetting(
      id: data.id.present ? data.id.value : this.id,
      visibleCharts: data.visibleCharts.present
          ? data.visibleCharts.value
          : this.visibleCharts,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StatsSetting(')
          ..write('id: $id, ')
          ..write('visibleCharts: $visibleCharts, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, visibleCharts, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StatsSetting &&
          other.id == this.id &&
          other.visibleCharts == this.visibleCharts &&
          other.updatedAt == this.updatedAt);
}

class StatsSettingsCompanion extends UpdateCompanion<StatsSetting> {
  final Value<int> id;
  final Value<String> visibleCharts;
  final Value<int> updatedAt;
  const StatsSettingsCompanion({
    this.id = const Value.absent(),
    this.visibleCharts = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  StatsSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.visibleCharts = const Value.absent(),
    required int updatedAt,
  }) : updatedAt = Value(updatedAt);
  static Insertable<StatsSetting> custom({
    Expression<int>? id,
    Expression<String>? visibleCharts,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (visibleCharts != null) 'visible_charts': visibleCharts,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  StatsSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? visibleCharts,
    Value<int>? updatedAt,
  }) {
    return StatsSettingsCompanion(
      id: id ?? this.id,
      visibleCharts: visibleCharts ?? this.visibleCharts,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (visibleCharts.present) {
      map['visible_charts'] = Variable<String>(visibleCharts.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StatsSettingsCompanion(')
          ..write('id: $id, ')
          ..write('visibleCharts: $visibleCharts, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FocusTimeTable focusTime = $FocusTimeTable(this);
  late final $ActiveTimerSessionTable activeTimerSession =
      $ActiveTimerSessionTable(this);
  late final $DailyLogsTable dailyLogs = $DailyLogsTable(this);
  late final $TaskListsTable taskLists = $TaskListsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $TaskPlansTable taskPlans = $TaskPlansTable(this);
  late final $TaskPlanSettingsTable taskPlanSettings = $TaskPlanSettingsTable(
    this,
  );
  late final $StatsSettingsTable statsSettings = $StatsSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    focusTime,
    activeTimerSession,
    dailyLogs,
    taskLists,
    tasks,
    taskPlans,
    taskPlanSettings,
    statsSettings,
  ];
}

typedef $$FocusTimeTableCreateCompanionBuilder =
    FocusTimeCompanion Function({
      Value<int> id,
      Value<int> userId,
      required int dayNum,
      required int type,
      required int state,
      required int startTime,
      Value<int?> endTime,
      Value<int> durationMs,
      Value<int?> scheduledTime,
      required String name,
      Value<String?> note,
      Value<int?> taskId,
      Value<int?> listId,
      Value<int?> planId,
      Value<String?> evidenceUri,
      Value<String?> evidenceDisplayName,
      Value<String?> evidenceRelativePath,
      Value<String?> evidenceMimeType,
      required int createdAt,
      required int updatedAt,
    });
typedef $$FocusTimeTableUpdateCompanionBuilder =
    FocusTimeCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<int> dayNum,
      Value<int> type,
      Value<int> state,
      Value<int> startTime,
      Value<int?> endTime,
      Value<int> durationMs,
      Value<int?> scheduledTime,
      Value<String> name,
      Value<String?> note,
      Value<int?> taskId,
      Value<int?> listId,
      Value<int?> planId,
      Value<String?> evidenceUri,
      Value<String?> evidenceDisplayName,
      Value<String?> evidenceRelativePath,
      Value<String?> evidenceMimeType,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

class $$FocusTimeTableFilterComposer
    extends Composer<_$AppDatabase, $FocusTimeTable> {
  $$FocusTimeTableFilterComposer({
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

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayNum => $composableBuilder(
    column: $table.dayNum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evidenceUri => $composableBuilder(
    column: $table.evidenceUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evidenceDisplayName => $composableBuilder(
    column: $table.evidenceDisplayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evidenceRelativePath => $composableBuilder(
    column: $table.evidenceRelativePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evidenceMimeType => $composableBuilder(
    column: $table.evidenceMimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FocusTimeTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusTimeTable> {
  $$FocusTimeTableOrderingComposer({
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

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayNum => $composableBuilder(
    column: $table.dayNum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evidenceUri => $composableBuilder(
    column: $table.evidenceUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evidenceDisplayName => $composableBuilder(
    column: $table.evidenceDisplayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evidenceRelativePath => $composableBuilder(
    column: $table.evidenceRelativePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evidenceMimeType => $composableBuilder(
    column: $table.evidenceMimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FocusTimeTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusTimeTable> {
  $$FocusTimeTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get dayNum =>
      $composableBuilder(column: $table.dayNum, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<int> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<int> get listId =>
      $composableBuilder(column: $table.listId, builder: (column) => column);

  GeneratedColumn<int> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<String> get evidenceUri => $composableBuilder(
    column: $table.evidenceUri,
    builder: (column) => column,
  );

  GeneratedColumn<String> get evidenceDisplayName => $composableBuilder(
    column: $table.evidenceDisplayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get evidenceRelativePath => $composableBuilder(
    column: $table.evidenceRelativePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get evidenceMimeType => $composableBuilder(
    column: $table.evidenceMimeType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FocusTimeTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusTimeTable,
          FocusTimeData,
          $$FocusTimeTableFilterComposer,
          $$FocusTimeTableOrderingComposer,
          $$FocusTimeTableAnnotationComposer,
          $$FocusTimeTableCreateCompanionBuilder,
          $$FocusTimeTableUpdateCompanionBuilder,
          (
            FocusTimeData,
            BaseReferences<_$AppDatabase, $FocusTimeTable, FocusTimeData>,
          ),
          FocusTimeData,
          PrefetchHooks Function()
        > {
  $$FocusTimeTableTableManager(_$AppDatabase db, $FocusTimeTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusTimeTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusTimeTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusTimeTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int> dayNum = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<int> state = const Value.absent(),
                Value<int> startTime = const Value.absent(),
                Value<int?> endTime = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<int?> scheduledTime = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> taskId = const Value.absent(),
                Value<int?> listId = const Value.absent(),
                Value<int?> planId = const Value.absent(),
                Value<String?> evidenceUri = const Value.absent(),
                Value<String?> evidenceDisplayName = const Value.absent(),
                Value<String?> evidenceRelativePath = const Value.absent(),
                Value<String?> evidenceMimeType = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => FocusTimeCompanion(
                id: id,
                userId: userId,
                dayNum: dayNum,
                type: type,
                state: state,
                startTime: startTime,
                endTime: endTime,
                durationMs: durationMs,
                scheduledTime: scheduledTime,
                name: name,
                note: note,
                taskId: taskId,
                listId: listId,
                planId: planId,
                evidenceUri: evidenceUri,
                evidenceDisplayName: evidenceDisplayName,
                evidenceRelativePath: evidenceRelativePath,
                evidenceMimeType: evidenceMimeType,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                required int dayNum,
                required int type,
                required int state,
                required int startTime,
                Value<int?> endTime = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<int?> scheduledTime = const Value.absent(),
                required String name,
                Value<String?> note = const Value.absent(),
                Value<int?> taskId = const Value.absent(),
                Value<int?> listId = const Value.absent(),
                Value<int?> planId = const Value.absent(),
                Value<String?> evidenceUri = const Value.absent(),
                Value<String?> evidenceDisplayName = const Value.absent(),
                Value<String?> evidenceRelativePath = const Value.absent(),
                Value<String?> evidenceMimeType = const Value.absent(),
                required int createdAt,
                required int updatedAt,
              }) => FocusTimeCompanion.insert(
                id: id,
                userId: userId,
                dayNum: dayNum,
                type: type,
                state: state,
                startTime: startTime,
                endTime: endTime,
                durationMs: durationMs,
                scheduledTime: scheduledTime,
                name: name,
                note: note,
                taskId: taskId,
                listId: listId,
                planId: planId,
                evidenceUri: evidenceUri,
                evidenceDisplayName: evidenceDisplayName,
                evidenceRelativePath: evidenceRelativePath,
                evidenceMimeType: evidenceMimeType,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FocusTimeTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusTimeTable,
      FocusTimeData,
      $$FocusTimeTableFilterComposer,
      $$FocusTimeTableOrderingComposer,
      $$FocusTimeTableAnnotationComposer,
      $$FocusTimeTableCreateCompanionBuilder,
      $$FocusTimeTableUpdateCompanionBuilder,
      (
        FocusTimeData,
        BaseReferences<_$AppDatabase, $FocusTimeTable, FocusTimeData>,
      ),
      FocusTimeData,
      PrefetchHooks Function()
    >;
typedef $$ActiveTimerSessionTableCreateCompanionBuilder =
    ActiveTimerSessionCompanion Function({
      Value<int> id,
      required int type,
      required String name,
      required int startTimeMs,
      Value<int?> pauseStartMs,
      Value<int> pauseTotalMs,
      Value<int> targetDurationMs,
      required int state,
      Value<String?> note,
      Value<int?> taskId,
      Value<int?> listId,
      Value<int?> planId,
      Value<String?> evidenceUri,
      Value<String?> evidenceDisplayName,
      Value<String?> evidenceRelativePath,
      Value<String?> evidenceMimeType,
      required int createdAt,
      required int updatedAt,
    });
typedef $$ActiveTimerSessionTableUpdateCompanionBuilder =
    ActiveTimerSessionCompanion Function({
      Value<int> id,
      Value<int> type,
      Value<String> name,
      Value<int> startTimeMs,
      Value<int?> pauseStartMs,
      Value<int> pauseTotalMs,
      Value<int> targetDurationMs,
      Value<int> state,
      Value<String?> note,
      Value<int?> taskId,
      Value<int?> listId,
      Value<int?> planId,
      Value<String?> evidenceUri,
      Value<String?> evidenceDisplayName,
      Value<String?> evidenceRelativePath,
      Value<String?> evidenceMimeType,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

class $$ActiveTimerSessionTableFilterComposer
    extends Composer<_$AppDatabase, $ActiveTimerSessionTable> {
  $$ActiveTimerSessionTableFilterComposer({
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

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startTimeMs => $composableBuilder(
    column: $table.startTimeMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pauseStartMs => $composableBuilder(
    column: $table.pauseStartMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pauseTotalMs => $composableBuilder(
    column: $table.pauseTotalMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetDurationMs => $composableBuilder(
    column: $table.targetDurationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evidenceUri => $composableBuilder(
    column: $table.evidenceUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evidenceDisplayName => $composableBuilder(
    column: $table.evidenceDisplayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evidenceRelativePath => $composableBuilder(
    column: $table.evidenceRelativePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evidenceMimeType => $composableBuilder(
    column: $table.evidenceMimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActiveTimerSessionTableOrderingComposer
    extends Composer<_$AppDatabase, $ActiveTimerSessionTable> {
  $$ActiveTimerSessionTableOrderingComposer({
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

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startTimeMs => $composableBuilder(
    column: $table.startTimeMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pauseStartMs => $composableBuilder(
    column: $table.pauseStartMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pauseTotalMs => $composableBuilder(
    column: $table.pauseTotalMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetDurationMs => $composableBuilder(
    column: $table.targetDurationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evidenceUri => $composableBuilder(
    column: $table.evidenceUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evidenceDisplayName => $composableBuilder(
    column: $table.evidenceDisplayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evidenceRelativePath => $composableBuilder(
    column: $table.evidenceRelativePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evidenceMimeType => $composableBuilder(
    column: $table.evidenceMimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActiveTimerSessionTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActiveTimerSessionTable> {
  $$ActiveTimerSessionTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get startTimeMs => $composableBuilder(
    column: $table.startTimeMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pauseStartMs => $composableBuilder(
    column: $table.pauseStartMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pauseTotalMs => $composableBuilder(
    column: $table.pauseTotalMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetDurationMs => $composableBuilder(
    column: $table.targetDurationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<int> get listId =>
      $composableBuilder(column: $table.listId, builder: (column) => column);

  GeneratedColumn<int> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<String> get evidenceUri => $composableBuilder(
    column: $table.evidenceUri,
    builder: (column) => column,
  );

  GeneratedColumn<String> get evidenceDisplayName => $composableBuilder(
    column: $table.evidenceDisplayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get evidenceRelativePath => $composableBuilder(
    column: $table.evidenceRelativePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get evidenceMimeType => $composableBuilder(
    column: $table.evidenceMimeType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ActiveTimerSessionTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActiveTimerSessionTable,
          ActiveTimerSessionData,
          $$ActiveTimerSessionTableFilterComposer,
          $$ActiveTimerSessionTableOrderingComposer,
          $$ActiveTimerSessionTableAnnotationComposer,
          $$ActiveTimerSessionTableCreateCompanionBuilder,
          $$ActiveTimerSessionTableUpdateCompanionBuilder,
          (
            ActiveTimerSessionData,
            BaseReferences<
              _$AppDatabase,
              $ActiveTimerSessionTable,
              ActiveTimerSessionData
            >,
          ),
          ActiveTimerSessionData,
          PrefetchHooks Function()
        > {
  $$ActiveTimerSessionTableTableManager(
    _$AppDatabase db,
    $ActiveTimerSessionTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveTimerSessionTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActiveTimerSessionTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActiveTimerSessionTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> startTimeMs = const Value.absent(),
                Value<int?> pauseStartMs = const Value.absent(),
                Value<int> pauseTotalMs = const Value.absent(),
                Value<int> targetDurationMs = const Value.absent(),
                Value<int> state = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> taskId = const Value.absent(),
                Value<int?> listId = const Value.absent(),
                Value<int?> planId = const Value.absent(),
                Value<String?> evidenceUri = const Value.absent(),
                Value<String?> evidenceDisplayName = const Value.absent(),
                Value<String?> evidenceRelativePath = const Value.absent(),
                Value<String?> evidenceMimeType = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => ActiveTimerSessionCompanion(
                id: id,
                type: type,
                name: name,
                startTimeMs: startTimeMs,
                pauseStartMs: pauseStartMs,
                pauseTotalMs: pauseTotalMs,
                targetDurationMs: targetDurationMs,
                state: state,
                note: note,
                taskId: taskId,
                listId: listId,
                planId: planId,
                evidenceUri: evidenceUri,
                evidenceDisplayName: evidenceDisplayName,
                evidenceRelativePath: evidenceRelativePath,
                evidenceMimeType: evidenceMimeType,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int type,
                required String name,
                required int startTimeMs,
                Value<int?> pauseStartMs = const Value.absent(),
                Value<int> pauseTotalMs = const Value.absent(),
                Value<int> targetDurationMs = const Value.absent(),
                required int state,
                Value<String?> note = const Value.absent(),
                Value<int?> taskId = const Value.absent(),
                Value<int?> listId = const Value.absent(),
                Value<int?> planId = const Value.absent(),
                Value<String?> evidenceUri = const Value.absent(),
                Value<String?> evidenceDisplayName = const Value.absent(),
                Value<String?> evidenceRelativePath = const Value.absent(),
                Value<String?> evidenceMimeType = const Value.absent(),
                required int createdAt,
                required int updatedAt,
              }) => ActiveTimerSessionCompanion.insert(
                id: id,
                type: type,
                name: name,
                startTimeMs: startTimeMs,
                pauseStartMs: pauseStartMs,
                pauseTotalMs: pauseTotalMs,
                targetDurationMs: targetDurationMs,
                state: state,
                note: note,
                taskId: taskId,
                listId: listId,
                planId: planId,
                evidenceUri: evidenceUri,
                evidenceDisplayName: evidenceDisplayName,
                evidenceRelativePath: evidenceRelativePath,
                evidenceMimeType: evidenceMimeType,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActiveTimerSessionTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActiveTimerSessionTable,
      ActiveTimerSessionData,
      $$ActiveTimerSessionTableFilterComposer,
      $$ActiveTimerSessionTableOrderingComposer,
      $$ActiveTimerSessionTableAnnotationComposer,
      $$ActiveTimerSessionTableCreateCompanionBuilder,
      $$ActiveTimerSessionTableUpdateCompanionBuilder,
      (
        ActiveTimerSessionData,
        BaseReferences<
          _$AppDatabase,
          $ActiveTimerSessionTable,
          ActiveTimerSessionData
        >,
      ),
      ActiveTimerSessionData,
      PrefetchHooks Function()
    >;
typedef $$DailyLogsTableCreateCompanionBuilder =
    DailyLogsCompanion Function({
      Value<int> id,
      Value<int> userId,
      required int dayNum,
      required int type,
      required int loggedAt,
      Value<String?> note,
      required int createdAt,
      required int updatedAt,
    });
typedef $$DailyLogsTableUpdateCompanionBuilder =
    DailyLogsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<int> dayNum,
      Value<int> type,
      Value<int> loggedAt,
      Value<String?> note,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

class $$DailyLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableFilterComposer({
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

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayNum => $composableBuilder(
    column: $table.dayNum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableOrderingComposer({
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

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayNum => $composableBuilder(
    column: $table.dayNum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get dayNum =>
      $composableBuilder(column: $table.dayNum, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailyLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyLogsTable,
          DailyLog,
          $$DailyLogsTableFilterComposer,
          $$DailyLogsTableOrderingComposer,
          $$DailyLogsTableAnnotationComposer,
          $$DailyLogsTableCreateCompanionBuilder,
          $$DailyLogsTableUpdateCompanionBuilder,
          (DailyLog, BaseReferences<_$AppDatabase, $DailyLogsTable, DailyLog>),
          DailyLog,
          PrefetchHooks Function()
        > {
  $$DailyLogsTableTableManager(_$AppDatabase db, $DailyLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int> dayNum = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<int> loggedAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => DailyLogsCompanion(
                id: id,
                userId: userId,
                dayNum: dayNum,
                type: type,
                loggedAt: loggedAt,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                required int dayNum,
                required int type,
                required int loggedAt,
                Value<String?> note = const Value.absent(),
                required int createdAt,
                required int updatedAt,
              }) => DailyLogsCompanion.insert(
                id: id,
                userId: userId,
                dayNum: dayNum,
                type: type,
                loggedAt: loggedAt,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyLogsTable,
      DailyLog,
      $$DailyLogsTableFilterComposer,
      $$DailyLogsTableOrderingComposer,
      $$DailyLogsTableAnnotationComposer,
      $$DailyLogsTableCreateCompanionBuilder,
      $$DailyLogsTableUpdateCompanionBuilder,
      (DailyLog, BaseReferences<_$AppDatabase, $DailyLogsTable, DailyLog>),
      DailyLog,
      PrefetchHooks Function()
    >;
typedef $$TaskListsTableCreateCompanionBuilder =
    TaskListsCompanion Function({
      Value<int> id,
      Value<int> userId,
      required String name,
      Value<int> color,
      Value<int> iconCodePoint,
      Value<int> sortOrder,
      Value<int> isDeleted,
      Value<int> isDailyReset,
      Value<int?> deletedAt,
      required int createdAt,
      required int updatedAt,
    });
typedef $$TaskListsTableUpdateCompanionBuilder =
    TaskListsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> name,
      Value<int> color,
      Value<int> iconCodePoint,
      Value<int> sortOrder,
      Value<int> isDeleted,
      Value<int> isDailyReset,
      Value<int?> deletedAt,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

class $$TaskListsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskListsTable> {
  $$TaskListsTableFilterComposer({
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

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get iconCodePoint => $composableBuilder(
    column: $table.iconCodePoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDailyReset => $composableBuilder(
    column: $table.isDailyReset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskListsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskListsTable> {
  $$TaskListsTableOrderingComposer({
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

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get iconCodePoint => $composableBuilder(
    column: $table.iconCodePoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDailyReset => $composableBuilder(
    column: $table.isDailyReset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskListsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskListsTable> {
  $$TaskListsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get iconCodePoint => $composableBuilder(
    column: $table.iconCodePoint,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get isDailyReset => $composableBuilder(
    column: $table.isDailyReset,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TaskListsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskListsTable,
          TaskList,
          $$TaskListsTableFilterComposer,
          $$TaskListsTableOrderingComposer,
          $$TaskListsTableAnnotationComposer,
          $$TaskListsTableCreateCompanionBuilder,
          $$TaskListsTableUpdateCompanionBuilder,
          (TaskList, BaseReferences<_$AppDatabase, $TaskListsTable, TaskList>),
          TaskList,
          PrefetchHooks Function()
        > {
  $$TaskListsTableTableManager(_$AppDatabase db, $TaskListsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskListsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskListsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskListsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<int> iconCodePoint = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> isDailyReset = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => TaskListsCompanion(
                id: id,
                userId: userId,
                name: name,
                color: color,
                iconCodePoint: iconCodePoint,
                sortOrder: sortOrder,
                isDeleted: isDeleted,
                isDailyReset: isDailyReset,
                deletedAt: deletedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                required String name,
                Value<int> color = const Value.absent(),
                Value<int> iconCodePoint = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> isDailyReset = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                required int createdAt,
                required int updatedAt,
              }) => TaskListsCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                color: color,
                iconCodePoint: iconCodePoint,
                sortOrder: sortOrder,
                isDeleted: isDeleted,
                isDailyReset: isDailyReset,
                deletedAt: deletedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskListsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskListsTable,
      TaskList,
      $$TaskListsTableFilterComposer,
      $$TaskListsTableOrderingComposer,
      $$TaskListsTableAnnotationComposer,
      $$TaskListsTableCreateCompanionBuilder,
      $$TaskListsTableUpdateCompanionBuilder,
      (TaskList, BaseReferences<_$AppDatabase, $TaskListsTable, TaskList>),
      TaskList,
      PrefetchHooks Function()
    >;
typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      Value<int> id,
      Value<int> userId,
      required int listId,
      required int dayNum,
      required String title,
      Value<String?> description,
      Value<int?> color,
      Value<int> state,
      Value<int> priority,
      Value<int?> dueDayNum,
      Value<int> estimatedMinutes,
      Value<int> isFocus,
      Value<int> isPinned,
      Value<int?> pinnedAt,
      Value<int?> reminderAt,
      Value<String> repeatRule,
      Value<int> sortOrder,
      required int createdAt,
      required int updatedAt,
      Value<int?> completedAt,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<int> listId,
      Value<int> dayNum,
      Value<String> title,
      Value<String?> description,
      Value<int?> color,
      Value<int> state,
      Value<int> priority,
      Value<int?> dueDayNum,
      Value<int> estimatedMinutes,
      Value<int> isFocus,
      Value<int> isPinned,
      Value<int?> pinnedAt,
      Value<int?> reminderAt,
      Value<String> repeatRule,
      Value<int> sortOrder,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> completedAt,
    });

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
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

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayNum => $composableBuilder(
    column: $table.dayNum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDayNum => $composableBuilder(
    column: $table.dueDayNum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isFocus => $composableBuilder(
    column: $table.isFocus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pinnedAt => $composableBuilder(
    column: $table.pinnedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
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

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayNum => $composableBuilder(
    column: $table.dayNum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDayNum => $composableBuilder(
    column: $table.dueDayNum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isFocus => $composableBuilder(
    column: $table.isFocus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pinnedAt => $composableBuilder(
    column: $table.pinnedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get listId =>
      $composableBuilder(column: $table.listId, builder: (column) => column);

  GeneratedColumn<int> get dayNum =>
      $composableBuilder(column: $table.dayNum, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get dueDayNum =>
      $composableBuilder(column: $table.dueDayNum, builder: (column) => column);

  GeneratedColumn<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isFocus =>
      $composableBuilder(column: $table.isFocus, builder: (column) => column);

  GeneratedColumn<int> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<int> get pinnedAt =>
      $composableBuilder(column: $table.pinnedAt, builder: (column) => column);

  GeneratedColumn<int> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
          Task,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int> listId = const Value.absent(),
                Value<int> dayNum = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int?> color = const Value.absent(),
                Value<int> state = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<int?> dueDayNum = const Value.absent(),
                Value<int> estimatedMinutes = const Value.absent(),
                Value<int> isFocus = const Value.absent(),
                Value<int> isPinned = const Value.absent(),
                Value<int?> pinnedAt = const Value.absent(),
                Value<int?> reminderAt = const Value.absent(),
                Value<String> repeatRule = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> completedAt = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                userId: userId,
                listId: listId,
                dayNum: dayNum,
                title: title,
                description: description,
                color: color,
                state: state,
                priority: priority,
                dueDayNum: dueDayNum,
                estimatedMinutes: estimatedMinutes,
                isFocus: isFocus,
                isPinned: isPinned,
                pinnedAt: pinnedAt,
                reminderAt: reminderAt,
                repeatRule: repeatRule,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                required int listId,
                required int dayNum,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<int?> color = const Value.absent(),
                Value<int> state = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<int?> dueDayNum = const Value.absent(),
                Value<int> estimatedMinutes = const Value.absent(),
                Value<int> isFocus = const Value.absent(),
                Value<int> isPinned = const Value.absent(),
                Value<int?> pinnedAt = const Value.absent(),
                Value<int?> reminderAt = const Value.absent(),
                Value<String> repeatRule = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int?> completedAt = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                userId: userId,
                listId: listId,
                dayNum: dayNum,
                title: title,
                description: description,
                color: color,
                state: state,
                priority: priority,
                dueDayNum: dueDayNum,
                estimatedMinutes: estimatedMinutes,
                isFocus: isFocus,
                isPinned: isPinned,
                pinnedAt: pinnedAt,
                reminderAt: reminderAt,
                repeatRule: repeatRule,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
      Task,
      PrefetchHooks Function()
    >;
typedef $$TaskPlansTableCreateCompanionBuilder =
    TaskPlansCompanion Function({
      Value<int> id,
      Value<int> userId,
      required int listId,
      required int taskId,
      required int dayNum,
      required int startHour,
      Value<int?> startMinute,
      Value<int> durationMinutes,
      Value<int> sortOrder,
      required int createdAt,
      required int updatedAt,
    });
typedef $$TaskPlansTableUpdateCompanionBuilder =
    TaskPlansCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<int> listId,
      Value<int> taskId,
      Value<int> dayNum,
      Value<int> startHour,
      Value<int?> startMinute,
      Value<int> durationMinutes,
      Value<int> sortOrder,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

class $$TaskPlansTableFilterComposer
    extends Composer<_$AppDatabase, $TaskPlansTable> {
  $$TaskPlansTableFilterComposer({
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

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayNum => $composableBuilder(
    column: $table.dayNum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startHour => $composableBuilder(
    column: $table.startHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskPlansTable> {
  $$TaskPlansTableOrderingComposer({
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

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayNum => $composableBuilder(
    column: $table.dayNum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startHour => $composableBuilder(
    column: $table.startHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskPlansTable> {
  $$TaskPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get listId =>
      $composableBuilder(column: $table.listId, builder: (column) => column);

  GeneratedColumn<int> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<int> get dayNum =>
      $composableBuilder(column: $table.dayNum, builder: (column) => column);

  GeneratedColumn<int> get startHour =>
      $composableBuilder(column: $table.startHour, builder: (column) => column);

  GeneratedColumn<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TaskPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskPlansTable,
          TaskPlan,
          $$TaskPlansTableFilterComposer,
          $$TaskPlansTableOrderingComposer,
          $$TaskPlansTableAnnotationComposer,
          $$TaskPlansTableCreateCompanionBuilder,
          $$TaskPlansTableUpdateCompanionBuilder,
          (TaskPlan, BaseReferences<_$AppDatabase, $TaskPlansTable, TaskPlan>),
          TaskPlan,
          PrefetchHooks Function()
        > {
  $$TaskPlansTableTableManager(_$AppDatabase db, $TaskPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int> listId = const Value.absent(),
                Value<int> taskId = const Value.absent(),
                Value<int> dayNum = const Value.absent(),
                Value<int> startHour = const Value.absent(),
                Value<int?> startMinute = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => TaskPlansCompanion(
                id: id,
                userId: userId,
                listId: listId,
                taskId: taskId,
                dayNum: dayNum,
                startHour: startHour,
                startMinute: startMinute,
                durationMinutes: durationMinutes,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                required int listId,
                required int taskId,
                required int dayNum,
                required int startHour,
                Value<int?> startMinute = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required int createdAt,
                required int updatedAt,
              }) => TaskPlansCompanion.insert(
                id: id,
                userId: userId,
                listId: listId,
                taskId: taskId,
                dayNum: dayNum,
                startHour: startHour,
                startMinute: startMinute,
                durationMinutes: durationMinutes,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskPlansTable,
      TaskPlan,
      $$TaskPlansTableFilterComposer,
      $$TaskPlansTableOrderingComposer,
      $$TaskPlansTableAnnotationComposer,
      $$TaskPlansTableCreateCompanionBuilder,
      $$TaskPlansTableUpdateCompanionBuilder,
      (TaskPlan, BaseReferences<_$AppDatabase, $TaskPlansTable, TaskPlan>),
      TaskPlan,
      PrefetchHooks Function()
    >;
typedef $$TaskPlanSettingsTableCreateCompanionBuilder =
    TaskPlanSettingsCompanion Function({
      Value<int> id,
      Value<int> startMinute,
      Value<int> endMinute,
      Value<int> slotMinutes,
      required int updatedAt,
    });
typedef $$TaskPlanSettingsTableUpdateCompanionBuilder =
    TaskPlanSettingsCompanion Function({
      Value<int> id,
      Value<int> startMinute,
      Value<int> endMinute,
      Value<int> slotMinutes,
      Value<int> updatedAt,
    });

class $$TaskPlanSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskPlanSettingsTable> {
  $$TaskPlanSettingsTableFilterComposer({
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

  ColumnFilters<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get slotMinutes => $composableBuilder(
    column: $table.slotMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskPlanSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskPlanSettingsTable> {
  $$TaskPlanSettingsTableOrderingComposer({
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

  ColumnOrderings<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get slotMinutes => $composableBuilder(
    column: $table.slotMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskPlanSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskPlanSettingsTable> {
  $$TaskPlanSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinute =>
      $composableBuilder(column: $table.endMinute, builder: (column) => column);

  GeneratedColumn<int> get slotMinutes => $composableBuilder(
    column: $table.slotMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TaskPlanSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskPlanSettingsTable,
          TaskPlanSetting,
          $$TaskPlanSettingsTableFilterComposer,
          $$TaskPlanSettingsTableOrderingComposer,
          $$TaskPlanSettingsTableAnnotationComposer,
          $$TaskPlanSettingsTableCreateCompanionBuilder,
          $$TaskPlanSettingsTableUpdateCompanionBuilder,
          (
            TaskPlanSetting,
            BaseReferences<
              _$AppDatabase,
              $TaskPlanSettingsTable,
              TaskPlanSetting
            >,
          ),
          TaskPlanSetting,
          PrefetchHooks Function()
        > {
  $$TaskPlanSettingsTableTableManager(
    _$AppDatabase db,
    $TaskPlanSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskPlanSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskPlanSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskPlanSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> startMinute = const Value.absent(),
                Value<int> endMinute = const Value.absent(),
                Value<int> slotMinutes = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => TaskPlanSettingsCompanion(
                id: id,
                startMinute: startMinute,
                endMinute: endMinute,
                slotMinutes: slotMinutes,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> startMinute = const Value.absent(),
                Value<int> endMinute = const Value.absent(),
                Value<int> slotMinutes = const Value.absent(),
                required int updatedAt,
              }) => TaskPlanSettingsCompanion.insert(
                id: id,
                startMinute: startMinute,
                endMinute: endMinute,
                slotMinutes: slotMinutes,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskPlanSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskPlanSettingsTable,
      TaskPlanSetting,
      $$TaskPlanSettingsTableFilterComposer,
      $$TaskPlanSettingsTableOrderingComposer,
      $$TaskPlanSettingsTableAnnotationComposer,
      $$TaskPlanSettingsTableCreateCompanionBuilder,
      $$TaskPlanSettingsTableUpdateCompanionBuilder,
      (
        TaskPlanSetting,
        BaseReferences<_$AppDatabase, $TaskPlanSettingsTable, TaskPlanSetting>,
      ),
      TaskPlanSetting,
      PrefetchHooks Function()
    >;
typedef $$StatsSettingsTableCreateCompanionBuilder =
    StatsSettingsCompanion Function({
      Value<int> id,
      Value<String> visibleCharts,
      required int updatedAt,
    });
typedef $$StatsSettingsTableUpdateCompanionBuilder =
    StatsSettingsCompanion Function({
      Value<int> id,
      Value<String> visibleCharts,
      Value<int> updatedAt,
    });

class $$StatsSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $StatsSettingsTable> {
  $$StatsSettingsTableFilterComposer({
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

  ColumnFilters<String> get visibleCharts => $composableBuilder(
    column: $table.visibleCharts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StatsSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $StatsSettingsTable> {
  $$StatsSettingsTableOrderingComposer({
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

  ColumnOrderings<String> get visibleCharts => $composableBuilder(
    column: $table.visibleCharts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StatsSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StatsSettingsTable> {
  $$StatsSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get visibleCharts => $composableBuilder(
    column: $table.visibleCharts,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$StatsSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StatsSettingsTable,
          StatsSetting,
          $$StatsSettingsTableFilterComposer,
          $$StatsSettingsTableOrderingComposer,
          $$StatsSettingsTableAnnotationComposer,
          $$StatsSettingsTableCreateCompanionBuilder,
          $$StatsSettingsTableUpdateCompanionBuilder,
          (
            StatsSetting,
            BaseReferences<_$AppDatabase, $StatsSettingsTable, StatsSetting>,
          ),
          StatsSetting,
          PrefetchHooks Function()
        > {
  $$StatsSettingsTableTableManager(_$AppDatabase db, $StatsSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StatsSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StatsSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StatsSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> visibleCharts = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => StatsSettingsCompanion(
                id: id,
                visibleCharts: visibleCharts,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> visibleCharts = const Value.absent(),
                required int updatedAt,
              }) => StatsSettingsCompanion.insert(
                id: id,
                visibleCharts: visibleCharts,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StatsSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StatsSettingsTable,
      StatsSetting,
      $$StatsSettingsTableFilterComposer,
      $$StatsSettingsTableOrderingComposer,
      $$StatsSettingsTableAnnotationComposer,
      $$StatsSettingsTableCreateCompanionBuilder,
      $$StatsSettingsTableUpdateCompanionBuilder,
      (
        StatsSetting,
        BaseReferences<_$AppDatabase, $StatsSettingsTable, StatsSetting>,
      ),
      StatsSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FocusTimeTableTableManager get focusTime =>
      $$FocusTimeTableTableManager(_db, _db.focusTime);
  $$ActiveTimerSessionTableTableManager get activeTimerSession =>
      $$ActiveTimerSessionTableTableManager(_db, _db.activeTimerSession);
  $$DailyLogsTableTableManager get dailyLogs =>
      $$DailyLogsTableTableManager(_db, _db.dailyLogs);
  $$TaskListsTableTableManager get taskLists =>
      $$TaskListsTableTableManager(_db, _db.taskLists);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$TaskPlansTableTableManager get taskPlans =>
      $$TaskPlansTableTableManager(_db, _db.taskPlans);
  $$TaskPlanSettingsTableTableManager get taskPlanSettings =>
      $$TaskPlanSettingsTableTableManager(_db, _db.taskPlanSettings);
  $$StatsSettingsTableTableManager get statsSettings =>
      $$StatsSettingsTableTableManager(_db, _db.statsSettings);
}
