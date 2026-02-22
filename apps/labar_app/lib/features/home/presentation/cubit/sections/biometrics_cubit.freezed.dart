// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'biometrics_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BiometricsState _$BiometricsStateFromJson(Map<String, dynamic> json) {
  return _BiometricsState.fromJson(json);
}

/// @nodoc
mixin _$BiometricsState {
  List<int>? get signatureBytes => throw _privateConstructorUsedError;
  String? get passportPath => throw _privateConstructorUsedError;

  /// Serializes this BiometricsState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BiometricsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BiometricsStateCopyWith<BiometricsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BiometricsStateCopyWith<$Res> {
  factory $BiometricsStateCopyWith(
          BiometricsState value, $Res Function(BiometricsState) then) =
      _$BiometricsStateCopyWithImpl<$Res, BiometricsState>;
  @useResult
  $Res call({List<int>? signatureBytes, String? passportPath});
}

/// @nodoc
class _$BiometricsStateCopyWithImpl<$Res, $Val extends BiometricsState>
    implements $BiometricsStateCopyWith<$Res> {
  _$BiometricsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BiometricsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? signatureBytes = freezed,
    Object? passportPath = freezed,
  }) {
    return _then(_value.copyWith(
      signatureBytes: freezed == signatureBytes
          ? _value.signatureBytes
          : signatureBytes // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      passportPath: freezed == passportPath
          ? _value.passportPath
          : passportPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BiometricsStateImplCopyWith<$Res>
    implements $BiometricsStateCopyWith<$Res> {
  factory _$$BiometricsStateImplCopyWith(_$BiometricsStateImpl value,
          $Res Function(_$BiometricsStateImpl) then) =
      __$$BiometricsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<int>? signatureBytes, String? passportPath});
}

/// @nodoc
class __$$BiometricsStateImplCopyWithImpl<$Res>
    extends _$BiometricsStateCopyWithImpl<$Res, _$BiometricsStateImpl>
    implements _$$BiometricsStateImplCopyWith<$Res> {
  __$$BiometricsStateImplCopyWithImpl(
      _$BiometricsStateImpl _value, $Res Function(_$BiometricsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of BiometricsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? signatureBytes = freezed,
    Object? passportPath = freezed,
  }) {
    return _then(_$BiometricsStateImpl(
      signatureBytes: freezed == signatureBytes
          ? _value._signatureBytes
          : signatureBytes // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      passportPath: freezed == passportPath
          ? _value.passportPath
          : passportPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BiometricsStateImpl extends _BiometricsState {
  const _$BiometricsStateImpl(
      {final List<int>? signatureBytes, this.passportPath})
      : _signatureBytes = signatureBytes,
        super._();

  factory _$BiometricsStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$BiometricsStateImplFromJson(json);

  final List<int>? _signatureBytes;
  @override
  List<int>? get signatureBytes {
    final value = _signatureBytes;
    if (value == null) return null;
    if (_signatureBytes is EqualUnmodifiableListView) return _signatureBytes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? passportPath;

  @override
  String toString() {
    return 'BiometricsState(signatureBytes: $signatureBytes, passportPath: $passportPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BiometricsStateImpl &&
            const DeepCollectionEquality()
                .equals(other._signatureBytes, _signatureBytes) &&
            (identical(other.passportPath, passportPath) ||
                other.passportPath == passportPath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_signatureBytes), passportPath);

  /// Create a copy of BiometricsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BiometricsStateImplCopyWith<_$BiometricsStateImpl> get copyWith =>
      __$$BiometricsStateImplCopyWithImpl<_$BiometricsStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BiometricsStateImplToJson(
      this,
    );
  }
}

abstract class _BiometricsState extends BiometricsState {
  const factory _BiometricsState(
      {final List<int>? signatureBytes,
      final String? passportPath}) = _$BiometricsStateImpl;
  const _BiometricsState._() : super._();

  factory _BiometricsState.fromJson(Map<String, dynamic> json) =
      _$BiometricsStateImpl.fromJson;

  @override
  List<int>? get signatureBytes;
  @override
  String? get passportPath;

  /// Create a copy of BiometricsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BiometricsStateImplCopyWith<_$BiometricsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
