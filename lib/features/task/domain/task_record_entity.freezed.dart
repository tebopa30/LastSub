// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_record_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskRecordEntity {
  String get id; // UUID
  String get taskId; // 紐づく TaskEntity の ID
  DateTime get recordedAt; // 実行日時（AI統計の要）
  DateTime? get startedAt; // 開始時刻（睡眠タスク専用: startTask で記録した lastRecordedAt）
  double? get value; // 量や時間（ミルク100mlなら100, 睡眠120分なら120など）
  String? get unit; // "ml", "mins", "times" など
  String? get memo; // ユーザーが入力したフリーテキストメモ
  bool get isActive; // 論理削除フラグ
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of TaskRecordEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TaskRecordEntityCopyWith<TaskRecordEntity> get copyWith =>
      _$TaskRecordEntityCopyWithImpl<TaskRecordEntity>(
          this as TaskRecordEntity, _$identity);

  /// Serializes this TaskRecordEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TaskRecordEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, taskId, recordedAt,
      startedAt, value, unit, memo, isActive, createdAt, updatedAt);

  @override
  String toString() {
    return 'TaskRecordEntity(id: $id, taskId: $taskId, recordedAt: $recordedAt, startedAt: $startedAt, value: $value, unit: $unit, memo: $memo, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $TaskRecordEntityCopyWith<$Res> {
  factory $TaskRecordEntityCopyWith(
          TaskRecordEntity value, $Res Function(TaskRecordEntity) _then) =
      _$TaskRecordEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String taskId,
      DateTime recordedAt,
      DateTime? startedAt,
      double? value,
      String? unit,
      String? memo,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$TaskRecordEntityCopyWithImpl<$Res>
    implements $TaskRecordEntityCopyWith<$Res> {
  _$TaskRecordEntityCopyWithImpl(this._self, this._then);

  final TaskRecordEntity _self;
  final $Res Function(TaskRecordEntity) _then;

  /// Create a copy of TaskRecordEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? recordedAt = null,
    Object? startedAt = freezed,
    Object? value = freezed,
    Object? unit = freezed,
    Object? memo = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _self.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      recordedAt: null == recordedAt
          ? _self.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startedAt: freezed == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      value: freezed == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _self.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [TaskRecordEntity].
extension TaskRecordEntityPatterns on TaskRecordEntity {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TaskRecordEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TaskRecordEntity() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TaskRecordEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskRecordEntity():
        return $default(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TaskRecordEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskRecordEntity() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String taskId,
            DateTime recordedAt,
            DateTime? startedAt,
            double? value,
            String? unit,
            String? memo,
            bool isActive,
            DateTime createdAt,
            DateTime updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TaskRecordEntity() when $default != null:
        return $default(
            _that.id,
            _that.taskId,
            _that.recordedAt,
            _that.startedAt,
            _that.value,
            _that.unit,
            _that.memo,
            _that.isActive,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String taskId,
            DateTime recordedAt,
            DateTime? startedAt,
            double? value,
            String? unit,
            String? memo,
            bool isActive,
            DateTime createdAt,
            DateTime updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskRecordEntity():
        return $default(
            _that.id,
            _that.taskId,
            _that.recordedAt,
            _that.startedAt,
            _that.value,
            _that.unit,
            _that.memo,
            _that.isActive,
            _that.createdAt,
            _that.updatedAt);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String taskId,
            DateTime recordedAt,
            DateTime? startedAt,
            double? value,
            String? unit,
            String? memo,
            bool isActive,
            DateTime createdAt,
            DateTime updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskRecordEntity() when $default != null:
        return $default(
            _that.id,
            _that.taskId,
            _that.recordedAt,
            _that.startedAt,
            _that.value,
            _that.unit,
            _that.memo,
            _that.isActive,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TaskRecordEntity implements TaskRecordEntity {
  const _TaskRecordEntity(
      {required this.id,
      required this.taskId,
      required this.recordedAt,
      this.startedAt,
      this.value,
      this.unit,
      this.memo,
      this.isActive = true,
      required this.createdAt,
      required this.updatedAt});
  factory _TaskRecordEntity.fromJson(Map<String, dynamic> json) =>
      _$TaskRecordEntityFromJson(json);

  @override
  final String id;
// UUID
  @override
  final String taskId;
// 紐づく TaskEntity の ID
  @override
  final DateTime recordedAt;
// 実行日時（AI統計の要）
  @override
  final DateTime? startedAt;
// 開始時刻（睡眠タスク専用: startTask で記録した lastRecordedAt）
  @override
  final double? value;
// 量や時間（ミルク100mlなら100, 睡眠120分なら120など）
  @override
  final String? unit;
// "ml", "mins", "times" など
  @override
  final String? memo;
// ユーザーが入力したフリーテキストメモ
  @override
  @JsonKey()
  final bool isActive;
// 論理削除フラグ
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Create a copy of TaskRecordEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TaskRecordEntityCopyWith<_TaskRecordEntity> get copyWith =>
      __$TaskRecordEntityCopyWithImpl<_TaskRecordEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TaskRecordEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TaskRecordEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, taskId, recordedAt,
      startedAt, value, unit, memo, isActive, createdAt, updatedAt);

  @override
  String toString() {
    return 'TaskRecordEntity(id: $id, taskId: $taskId, recordedAt: $recordedAt, startedAt: $startedAt, value: $value, unit: $unit, memo: $memo, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$TaskRecordEntityCopyWith<$Res>
    implements $TaskRecordEntityCopyWith<$Res> {
  factory _$TaskRecordEntityCopyWith(
          _TaskRecordEntity value, $Res Function(_TaskRecordEntity) _then) =
      __$TaskRecordEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String taskId,
      DateTime recordedAt,
      DateTime? startedAt,
      double? value,
      String? unit,
      String? memo,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$TaskRecordEntityCopyWithImpl<$Res>
    implements _$TaskRecordEntityCopyWith<$Res> {
  __$TaskRecordEntityCopyWithImpl(this._self, this._then);

  final _TaskRecordEntity _self;
  final $Res Function(_TaskRecordEntity) _then;

  /// Create a copy of TaskRecordEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? recordedAt = null,
    Object? startedAt = freezed,
    Object? value = freezed,
    Object? unit = freezed,
    Object? memo = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_TaskRecordEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _self.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      recordedAt: null == recordedAt
          ? _self.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startedAt: freezed == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      value: freezed == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _self.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
