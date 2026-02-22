// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kyc_details_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

KycDetailsState _$KycDetailsStateFromJson(Map<String, dynamic> json) {
  return _KycDetailsState.fromJson(json);
}

/// @nodoc
mixin _$KycDetailsState {
  KycType? get kycType => throw _privateConstructorUsedError;
  @RequiredTextInputConverter()
  RequiredTextInput get kycNumber => throw _privateConstructorUsedError;

  /// Serializes this KycDetailsState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KycDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KycDetailsStateCopyWith<KycDetailsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KycDetailsStateCopyWith<$Res> {
  factory $KycDetailsStateCopyWith(
          KycDetailsState value, $Res Function(KycDetailsState) then) =
      _$KycDetailsStateCopyWithImpl<$Res, KycDetailsState>;
  @useResult
  $Res call(
      {KycType? kycType,
      @RequiredTextInputConverter() RequiredTextInput kycNumber});
}

/// @nodoc
class _$KycDetailsStateCopyWithImpl<$Res, $Val extends KycDetailsState>
    implements $KycDetailsStateCopyWith<$Res> {
  _$KycDetailsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KycDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kycType = freezed,
    Object? kycNumber = null,
  }) {
    return _then(_value.copyWith(
      kycType: freezed == kycType
          ? _value.kycType
          : kycType // ignore: cast_nullable_to_non_nullable
              as KycType?,
      kycNumber: null == kycNumber
          ? _value.kycNumber
          : kycNumber // ignore: cast_nullable_to_non_nullable
              as RequiredTextInput,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KycDetailsStateImplCopyWith<$Res>
    implements $KycDetailsStateCopyWith<$Res> {
  factory _$$KycDetailsStateImplCopyWith(_$KycDetailsStateImpl value,
          $Res Function(_$KycDetailsStateImpl) then) =
      __$$KycDetailsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {KycType? kycType,
      @RequiredTextInputConverter() RequiredTextInput kycNumber});
}

/// @nodoc
class __$$KycDetailsStateImplCopyWithImpl<$Res>
    extends _$KycDetailsStateCopyWithImpl<$Res, _$KycDetailsStateImpl>
    implements _$$KycDetailsStateImplCopyWith<$Res> {
  __$$KycDetailsStateImplCopyWithImpl(
      _$KycDetailsStateImpl _value, $Res Function(_$KycDetailsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of KycDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kycType = freezed,
    Object? kycNumber = null,
  }) {
    return _then(_$KycDetailsStateImpl(
      kycType: freezed == kycType
          ? _value.kycType
          : kycType // ignore: cast_nullable_to_non_nullable
              as KycType?,
      kycNumber: null == kycNumber
          ? _value.kycNumber
          : kycNumber // ignore: cast_nullable_to_non_nullable
              as RequiredTextInput,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$KycDetailsStateImpl extends _KycDetailsState {
  const _$KycDetailsStateImpl(
      {this.kycType,
      @RequiredTextInputConverter()
      this.kycNumber = const RequiredTextInput.pure()})
      : super._();

  factory _$KycDetailsStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$KycDetailsStateImplFromJson(json);

  @override
  final KycType? kycType;
  @override
  @JsonKey()
  @RequiredTextInputConverter()
  final RequiredTextInput kycNumber;

  @override
  String toString() {
    return 'KycDetailsState(kycType: $kycType, kycNumber: $kycNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KycDetailsStateImpl &&
            (identical(other.kycType, kycType) || other.kycType == kycType) &&
            (identical(other.kycNumber, kycNumber) ||
                other.kycNumber == kycNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kycType, kycNumber);

  /// Create a copy of KycDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KycDetailsStateImplCopyWith<_$KycDetailsStateImpl> get copyWith =>
      __$$KycDetailsStateImplCopyWithImpl<_$KycDetailsStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KycDetailsStateImplToJson(
      this,
    );
  }
}

abstract class _KycDetailsState extends KycDetailsState {
  const factory _KycDetailsState(
          {final KycType? kycType,
          @RequiredTextInputConverter() final RequiredTextInput kycNumber}) =
      _$KycDetailsStateImpl;
  const _KycDetailsState._() : super._();

  factory _KycDetailsState.fromJson(Map<String, dynamic> json) =
      _$KycDetailsStateImpl.fromJson;

  @override
  KycType? get kycType;
  @override
  @RequiredTextInputConverter()
  RequiredTextInput get kycNumber;

  /// Create a copy of KycDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KycDetailsStateImplCopyWith<_$KycDetailsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
