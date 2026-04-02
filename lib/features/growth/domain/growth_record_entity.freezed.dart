// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'growth_record_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GrowthRecordEntity {
  String get id;
  String get userId; // 匿名認証のUIDなど
  DateTime get recordedAt; // 測定日または接種日
  double? get height;
  double? get weight;
  double? get headCircumference;
  String? get vaccinationName;
  String? get memo;
  DateTime get updatedAt; // 双方向同期用
  bool get isActive;

  /// Create a copy of GrowthRecordEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GrowthRecordEntityCopyWith<GrowthRecordEntity> get copyWith =>
      _$GrowthRecordEntityCopyWithImpl<GrowthRecordEntity>(
          this as GrowthRecordEntity, _$identity);

  /// Serializes this GrowthRecordEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GrowthRecordEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.headCircumference, headCircumference) ||
                other.headCircumference == headCircumference) &&
            (identical(other.vaccinationName, vaccinationName) ||
                other.vaccinationName == vaccinationName) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, recordedAt, height,
      weight, headCircumference, vaccinationName, memo, updatedAt, isActive);

  @override
  String toString() {
    return 'GrowthRecordEntity(id: $id, userId: $userId, recordedAt: $recordedAt, height: $height, weight: $weight, headCircumference: $headCircumference, vaccinationName: $vaccinationName, memo: $memo, updatedAt: $updatedAt, isActive: $isActive)';
  }
}

/// @nodoc
abstract mixin class $GrowthRecordEntityCopyWith<$Res> {
  factory $GrowthRecordEntityCopyWith(
          GrowthRecordEntity value, $Res Function(GrowthRecordEntity) _then) =
      _$GrowthRecordEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userId,
      DateTime recordedAt,
      double? height,
      double? weight,
      double? headCircumference,
      String? vaccinationName,
      String? memo,
      DateTime updatedAt,
      bool isActive});
}

/// @nodoc
class _$GrowthRecordEntityCopyWithImpl<$Res>
    implements $GrowthRecordEntityCopyWith<$Res> {
  _$GrowthRecordEntityCopyWithImpl(this._self, this._then);

  final GrowthRecordEntity _self;
  final $Res Function(GrowthRecordEntity) _then;

  /// Create a copy of GrowthRecordEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? recordedAt = null,
    Object? height = freezed,
    Object? weight = freezed,
    Object? headCircumference = freezed,
    Object? vaccinationName = freezed,
    Object? memo = freezed,
    Object? updatedAt = null,
    Object? isActive = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      recordedAt: null == recordedAt
          ? _self.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      height: freezed == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      weight: freezed == weight
          ? _self.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      headCircumference: freezed == headCircumference
          ? _self.headCircumference
          : headCircumference // ignore: cast_nullable_to_non_nullable
              as double?,
      vaccinationName: freezed == vaccinationName
          ? _self.vaccinationName
          : vaccinationName // ignore: cast_nullable_to_non_nullable
              as String?,
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [GrowthRecordEntity].
extension GrowthRecordEntityPatterns on GrowthRecordEntity {
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
    TResult Function(_GrowthRecordEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GrowthRecordEntity() when $default != null:
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
    TResult Function(_GrowthRecordEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GrowthRecordEntity():
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
    TResult? Function(_GrowthRecordEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GrowthRecordEntity() when $default != null:
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
            String userId,
            DateTime recordedAt,
            double? height,
            double? weight,
            double? headCircumference,
            String? vaccinationName,
            String? memo,
            DateTime updatedAt,
            bool isActive)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GrowthRecordEntity() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.recordedAt,
            _that.height,
            _that.weight,
            _that.headCircumference,
            _that.vaccinationName,
            _that.memo,
            _that.updatedAt,
            _that.isActive);
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
            String userId,
            DateTime recordedAt,
            double? height,
            double? weight,
            double? headCircumference,
            String? vaccinationName,
            String? memo,
            DateTime updatedAt,
            bool isActive)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GrowthRecordEntity():
        return $default(
            _that.id,
            _that.userId,
            _that.recordedAt,
            _that.height,
            _that.weight,
            _that.headCircumference,
            _that.vaccinationName,
            _that.memo,
            _that.updatedAt,
            _that.isActive);
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
            String userId,
            DateTime recordedAt,
            double? height,
            double? weight,
            double? headCircumference,
            String? vaccinationName,
            String? memo,
            DateTime updatedAt,
            bool isActive)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GrowthRecordEntity() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.recordedAt,
            _that.height,
            _that.weight,
            _that.headCircumference,
            _that.vaccinationName,
            _that.memo,
            _that.updatedAt,
            _that.isActive);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GrowthRecordEntity implements GrowthRecordEntity {
  const _GrowthRecordEntity(
      {required this.id,
      required this.userId,
      required this.recordedAt,
      this.height,
      this.weight,
      this.headCircumference,
      this.vaccinationName,
      this.memo,
      required this.updatedAt,
      this.isActive = true});
  factory _GrowthRecordEntity.fromJson(Map<String, dynamic> json) =>
      _$GrowthRecordEntityFromJson(json);

  @override
  final String id;
  @override
  final String userId;
// 匿名認証のUIDなど
  @override
  final DateTime recordedAt;
// 測定日または接種日
  @override
  final double? height;
  @override
  final double? weight;
  @override
  final double? headCircumference;
  @override
  final String? vaccinationName;
  @override
  final String? memo;
  @override
  final DateTime updatedAt;
// 双方向同期用
  @override
  @JsonKey()
  final bool isActive;

  /// Create a copy of GrowthRecordEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GrowthRecordEntityCopyWith<_GrowthRecordEntity> get copyWith =>
      __$GrowthRecordEntityCopyWithImpl<_GrowthRecordEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GrowthRecordEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GrowthRecordEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.headCircumference, headCircumference) ||
                other.headCircumference == headCircumference) &&
            (identical(other.vaccinationName, vaccinationName) ||
                other.vaccinationName == vaccinationName) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, recordedAt, height,
      weight, headCircumference, vaccinationName, memo, updatedAt, isActive);

  @override
  String toString() {
    return 'GrowthRecordEntity(id: $id, userId: $userId, recordedAt: $recordedAt, height: $height, weight: $weight, headCircumference: $headCircumference, vaccinationName: $vaccinationName, memo: $memo, updatedAt: $updatedAt, isActive: $isActive)';
  }
}

/// @nodoc
abstract mixin class _$GrowthRecordEntityCopyWith<$Res>
    implements $GrowthRecordEntityCopyWith<$Res> {
  factory _$GrowthRecordEntityCopyWith(
          _GrowthRecordEntity value, $Res Function(_GrowthRecordEntity) _then) =
      __$GrowthRecordEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      DateTime recordedAt,
      double? height,
      double? weight,
      double? headCircumference,
      String? vaccinationName,
      String? memo,
      DateTime updatedAt,
      bool isActive});
}

/// @nodoc
class __$GrowthRecordEntityCopyWithImpl<$Res>
    implements _$GrowthRecordEntityCopyWith<$Res> {
  __$GrowthRecordEntityCopyWithImpl(this._self, this._then);

  final _GrowthRecordEntity _self;
  final $Res Function(_GrowthRecordEntity) _then;

  /// Create a copy of GrowthRecordEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? recordedAt = null,
    Object? height = freezed,
    Object? weight = freezed,
    Object? headCircumference = freezed,
    Object? vaccinationName = freezed,
    Object? memo = freezed,
    Object? updatedAt = null,
    Object? isActive = null,
  }) {
    return _then(_GrowthRecordEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      recordedAt: null == recordedAt
          ? _self.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      height: freezed == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      weight: freezed == weight
          ? _self.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      headCircumference: freezed == headCircumference
          ? _self.headCircumference
          : headCircumference // ignore: cast_nullable_to_non_nullable
              as double?,
      vaccinationName: freezed == vaccinationName
          ? _self.vaccinationName
          : vaccinationName // ignore: cast_nullable_to_non_nullable
              as String?,
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
