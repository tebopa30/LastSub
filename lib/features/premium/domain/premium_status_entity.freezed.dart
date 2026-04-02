// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'premium_status_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PremiumStatusEntity {
  bool get isPremium;
  bool get isLoading;
  String? get errorMessage;

  /// Create a copy of PremiumStatusEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PremiumStatusEntityCopyWith<PremiumStatusEntity> get copyWith =>
      _$PremiumStatusEntityCopyWithImpl<PremiumStatusEntity>(
          this as PremiumStatusEntity, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PremiumStatusEntity &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isPremium, isLoading, errorMessage);

  @override
  String toString() {
    return 'PremiumStatusEntity(isPremium: $isPremium, isLoading: $isLoading, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $PremiumStatusEntityCopyWith<$Res> {
  factory $PremiumStatusEntityCopyWith(
          PremiumStatusEntity value, $Res Function(PremiumStatusEntity) _then) =
      _$PremiumStatusEntityCopyWithImpl;
  @useResult
  $Res call({bool isPremium, bool isLoading, String? errorMessage});
}

/// @nodoc
class _$PremiumStatusEntityCopyWithImpl<$Res>
    implements $PremiumStatusEntityCopyWith<$Res> {
  _$PremiumStatusEntityCopyWithImpl(this._self, this._then);

  final PremiumStatusEntity _self;
  final $Res Function(PremiumStatusEntity) _then;

  /// Create a copy of PremiumStatusEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPremium = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      isPremium: null == isPremium
          ? _self.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PremiumStatusEntity].
extension PremiumStatusEntityPatterns on PremiumStatusEntity {
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
    TResult Function(_PremiumStatusEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PremiumStatusEntity() when $default != null:
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
    TResult Function(_PremiumStatusEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PremiumStatusEntity():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
    TResult? Function(_PremiumStatusEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PremiumStatusEntity() when $default != null:
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
    TResult Function(bool isPremium, bool isLoading, String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PremiumStatusEntity() when $default != null:
        return $default(_that.isPremium, _that.isLoading, _that.errorMessage);
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
    TResult Function(bool isPremium, bool isLoading, String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PremiumStatusEntity():
        return $default(_that.isPremium, _that.isLoading, _that.errorMessage);
      case _:
        throw StateError('Unexpected subclass');
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
    TResult? Function(bool isPremium, bool isLoading, String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PremiumStatusEntity() when $default != null:
        return $default(_that.isPremium, _that.isLoading, _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PremiumStatusEntity implements PremiumStatusEntity {
  const _PremiumStatusEntity(
      {this.isPremium = false, this.isLoading = false, this.errorMessage});

  @override
  @JsonKey()
  final bool isPremium;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  /// Create a copy of PremiumStatusEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PremiumStatusEntityCopyWith<_PremiumStatusEntity> get copyWith =>
      __$PremiumStatusEntityCopyWithImpl<_PremiumStatusEntity>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PremiumStatusEntity &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isPremium, isLoading, errorMessage);

  @override
  String toString() {
    return 'PremiumStatusEntity(isPremium: $isPremium, isLoading: $isLoading, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$PremiumStatusEntityCopyWith<$Res>
    implements $PremiumStatusEntityCopyWith<$Res> {
  factory _$PremiumStatusEntityCopyWith(_PremiumStatusEntity value,
          $Res Function(_PremiumStatusEntity) _then) =
      __$PremiumStatusEntityCopyWithImpl;
  @override
  @useResult
  $Res call({bool isPremium, bool isLoading, String? errorMessage});
}

/// @nodoc
class __$PremiumStatusEntityCopyWithImpl<$Res>
    implements _$PremiumStatusEntityCopyWith<$Res> {
  __$PremiumStatusEntityCopyWithImpl(this._self, this._then);

  final _PremiumStatusEntity _self;
  final $Res Function(_PremiumStatusEntity) _then;

  /// Create a copy of PremiumStatusEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isPremium = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_PremiumStatusEntity(
      isPremium: null == isPremium
          ? _self.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
