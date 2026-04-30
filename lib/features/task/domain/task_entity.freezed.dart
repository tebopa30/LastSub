// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskEntity {
  String get id;
  String get title;
  String? get iconName;
  String? get colorCode;
  bool get isActive;
  bool get isPremiumLocked;
  int get order;
  DateTime? get lastRecordedAt;

  /// 推奨間隔（秒単位）。null = 未設定。
  /// DB列名は後方互換のため recommendedIntervalDays のままだが、実際には秒を格納する。
  int? get recommendedIntervalDays;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of TaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TaskEntityCopyWith<TaskEntity> get copyWith =>
      _$TaskEntityCopyWithImpl<TaskEntity>(this as TaskEntity, _$identity);

  /// Serializes this TaskEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TaskEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.colorCode, colorCode) ||
                other.colorCode == colorCode) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isPremiumLocked, isPremiumLocked) ||
                other.isPremiumLocked == isPremiumLocked) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.lastRecordedAt, lastRecordedAt) ||
                other.lastRecordedAt == lastRecordedAt) &&
            (identical(
                    other.recommendedIntervalDays, recommendedIntervalDays) ||
                other.recommendedIntervalDays == recommendedIntervalDays) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      iconName,
      colorCode,
      isActive,
      isPremiumLocked,
      order,
      lastRecordedAt,
      recommendedIntervalDays,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'TaskEntity(id: $id, title: $title, iconName: $iconName, colorCode: $colorCode, isActive: $isActive, isPremiumLocked: $isPremiumLocked, order: $order, lastRecordedAt: $lastRecordedAt, recommendedIntervalDays: $recommendedIntervalDays, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $TaskEntityCopyWith<$Res> {
  factory $TaskEntityCopyWith(
          TaskEntity value, $Res Function(TaskEntity) _then) =
      _$TaskEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String title,
      String? iconName,
      String? colorCode,
      bool isActive,
      bool isPremiumLocked,
      int order,
      DateTime? lastRecordedAt,
      int? recommendedIntervalDays,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$TaskEntityCopyWithImpl<$Res> implements $TaskEntityCopyWith<$Res> {
  _$TaskEntityCopyWithImpl(this._self, this._then);

  final TaskEntity _self;
  final $Res Function(TaskEntity) _then;

  /// Create a copy of TaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? iconName = freezed,
    Object? colorCode = freezed,
    Object? isActive = null,
    Object? isPremiumLocked = null,
    Object? order = null,
    Object? lastRecordedAt = freezed,
    Object? recommendedIntervalDays = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      iconName: freezed == iconName
          ? _self.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      colorCode: freezed == colorCode
          ? _self.colorCode
          : colorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isPremiumLocked: null == isPremiumLocked
          ? _self.isPremiumLocked
          : isPremiumLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      lastRecordedAt: freezed == lastRecordedAt
          ? _self.lastRecordedAt
          : lastRecordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      recommendedIntervalDays: freezed == recommendedIntervalDays
          ? _self.recommendedIntervalDays
          : recommendedIntervalDays // ignore: cast_nullable_to_non_nullable
              as int?,
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

/// Adds pattern-matching-related methods to [TaskEntity].
extension TaskEntityPatterns on TaskEntity {
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
    TResult Function(_TaskEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TaskEntity() when $default != null:
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
    TResult Function(_TaskEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskEntity():
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
    TResult? Function(_TaskEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskEntity() when $default != null:
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
            String title,
            String? iconName,
            String? colorCode,
            bool isActive,
            bool isPremiumLocked,
            int order,
            DateTime? lastRecordedAt,
            int? recommendedIntervalDays,
            DateTime createdAt,
            DateTime updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TaskEntity() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.iconName,
            _that.colorCode,
            _that.isActive,
            _that.isPremiumLocked,
            _that.order,
            _that.lastRecordedAt,
            _that.recommendedIntervalDays,
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
            String title,
            String? iconName,
            String? colorCode,
            bool isActive,
            bool isPremiumLocked,
            int order,
            DateTime? lastRecordedAt,
            int? recommendedIntervalDays,
            DateTime createdAt,
            DateTime updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskEntity():
        return $default(
            _that.id,
            _that.title,
            _that.iconName,
            _that.colorCode,
            _that.isActive,
            _that.isPremiumLocked,
            _that.order,
            _that.lastRecordedAt,
            _that.recommendedIntervalDays,
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
            String title,
            String? iconName,
            String? colorCode,
            bool isActive,
            bool isPremiumLocked,
            int order,
            DateTime? lastRecordedAt,
            int? recommendedIntervalDays,
            DateTime createdAt,
            DateTime updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskEntity() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.iconName,
            _that.colorCode,
            _that.isActive,
            _that.isPremiumLocked,
            _that.order,
            _that.lastRecordedAt,
            _that.recommendedIntervalDays,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TaskEntity implements TaskEntity {
  const _TaskEntity(
      {required this.id,
      required this.title,
      this.iconName,
      this.colorCode,
      this.isActive = true,
      this.isPremiumLocked = false,
      this.order = 0,
      this.lastRecordedAt,
      this.recommendedIntervalDays,
      required this.createdAt,
      required this.updatedAt});
  factory _TaskEntity.fromJson(Map<String, dynamic> json) =>
      _$TaskEntityFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? iconName;
  @override
  final String? colorCode;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isPremiumLocked;
  @override
  @JsonKey()
  final int order;
  @override
  final DateTime? lastRecordedAt;

  /// 推奨間隔（秒単位）。null = 未設定。
  /// DB列名は後方互換のため recommendedIntervalDays のままだが、実際には秒を格納する。
  @override
  final int? recommendedIntervalDays;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Create a copy of TaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TaskEntityCopyWith<_TaskEntity> get copyWith =>
      __$TaskEntityCopyWithImpl<_TaskEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TaskEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TaskEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.colorCode, colorCode) ||
                other.colorCode == colorCode) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isPremiumLocked, isPremiumLocked) ||
                other.isPremiumLocked == isPremiumLocked) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.lastRecordedAt, lastRecordedAt) ||
                other.lastRecordedAt == lastRecordedAt) &&
            (identical(
                    other.recommendedIntervalDays, recommendedIntervalDays) ||
                other.recommendedIntervalDays == recommendedIntervalDays) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      iconName,
      colorCode,
      isActive,
      isPremiumLocked,
      order,
      lastRecordedAt,
      recommendedIntervalDays,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'TaskEntity(id: $id, title: $title, iconName: $iconName, colorCode: $colorCode, isActive: $isActive, isPremiumLocked: $isPremiumLocked, order: $order, lastRecordedAt: $lastRecordedAt, recommendedIntervalDays: $recommendedIntervalDays, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$TaskEntityCopyWith<$Res>
    implements $TaskEntityCopyWith<$Res> {
  factory _$TaskEntityCopyWith(
          _TaskEntity value, $Res Function(_TaskEntity) _then) =
      __$TaskEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? iconName,
      String? colorCode,
      bool isActive,
      bool isPremiumLocked,
      int order,
      DateTime? lastRecordedAt,
      int? recommendedIntervalDays,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$TaskEntityCopyWithImpl<$Res> implements _$TaskEntityCopyWith<$Res> {
  __$TaskEntityCopyWithImpl(this._self, this._then);

  final _TaskEntity _self;
  final $Res Function(_TaskEntity) _then;

  /// Create a copy of TaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? iconName = freezed,
    Object? colorCode = freezed,
    Object? isActive = null,
    Object? isPremiumLocked = null,
    Object? order = null,
    Object? lastRecordedAt = freezed,
    Object? recommendedIntervalDays = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_TaskEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      iconName: freezed == iconName
          ? _self.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      colorCode: freezed == colorCode
          ? _self.colorCode
          : colorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isPremiumLocked: null == isPremiumLocked
          ? _self.isPremiumLocked
          : isPremiumLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      lastRecordedAt: freezed == lastRecordedAt
          ? _self.lastRecordedAt
          : lastRecordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      recommendedIntervalDays: freezed == recommendedIntervalDays
          ? _self.recommendedIntervalDays
          : recommendedIntervalDays // ignore: cast_nullable_to_non_nullable
              as int?,
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
