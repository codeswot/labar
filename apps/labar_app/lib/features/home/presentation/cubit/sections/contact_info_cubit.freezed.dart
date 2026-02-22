// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_info_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContactInfoState _$ContactInfoStateFromJson(Map<String, dynamic> json) {
  return _ContactInfoState.fromJson(json);
}

/// @nodoc
mixin _$ContactInfoState {
  @PhoneNumberInputConverter()
  PhoneNumberInput get phoneNumber => throw _privateConstructorUsedError;
  @NameInputConverter()
  NameInput get nextOfKinName => throw _privateConstructorUsedError;
  @PhoneNumberInputConverter()
  PhoneNumberInput get nextOfKinPhone => throw _privateConstructorUsedError;
  @RequiredTextInputConverter()
  RequiredTextInput get nextOfKinRelationship =>
      throw _privateConstructorUsedError;

  /// Serializes this ContactInfoState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactInfoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactInfoStateCopyWith<ContactInfoState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactInfoStateCopyWith<$Res> {
  factory $ContactInfoStateCopyWith(
          ContactInfoState value, $Res Function(ContactInfoState) then) =
      _$ContactInfoStateCopyWithImpl<$Res, ContactInfoState>;
  @useResult
  $Res call(
      {@PhoneNumberInputConverter() PhoneNumberInput phoneNumber,
      @NameInputConverter() NameInput nextOfKinName,
      @PhoneNumberInputConverter() PhoneNumberInput nextOfKinPhone,
      @RequiredTextInputConverter() RequiredTextInput nextOfKinRelationship});
}

/// @nodoc
class _$ContactInfoStateCopyWithImpl<$Res, $Val extends ContactInfoState>
    implements $ContactInfoStateCopyWith<$Res> {
  _$ContactInfoStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactInfoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? nextOfKinName = null,
    Object? nextOfKinPhone = null,
    Object? nextOfKinRelationship = null,
  }) {
    return _then(_value.copyWith(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as PhoneNumberInput,
      nextOfKinName: null == nextOfKinName
          ? _value.nextOfKinName
          : nextOfKinName // ignore: cast_nullable_to_non_nullable
              as NameInput,
      nextOfKinPhone: null == nextOfKinPhone
          ? _value.nextOfKinPhone
          : nextOfKinPhone // ignore: cast_nullable_to_non_nullable
              as PhoneNumberInput,
      nextOfKinRelationship: null == nextOfKinRelationship
          ? _value.nextOfKinRelationship
          : nextOfKinRelationship // ignore: cast_nullable_to_non_nullable
              as RequiredTextInput,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactInfoStateImplCopyWith<$Res>
    implements $ContactInfoStateCopyWith<$Res> {
  factory _$$ContactInfoStateImplCopyWith(_$ContactInfoStateImpl value,
          $Res Function(_$ContactInfoStateImpl) then) =
      __$$ContactInfoStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@PhoneNumberInputConverter() PhoneNumberInput phoneNumber,
      @NameInputConverter() NameInput nextOfKinName,
      @PhoneNumberInputConverter() PhoneNumberInput nextOfKinPhone,
      @RequiredTextInputConverter() RequiredTextInput nextOfKinRelationship});
}

/// @nodoc
class __$$ContactInfoStateImplCopyWithImpl<$Res>
    extends _$ContactInfoStateCopyWithImpl<$Res, _$ContactInfoStateImpl>
    implements _$$ContactInfoStateImplCopyWith<$Res> {
  __$$ContactInfoStateImplCopyWithImpl(_$ContactInfoStateImpl _value,
      $Res Function(_$ContactInfoStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactInfoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? nextOfKinName = null,
    Object? nextOfKinPhone = null,
    Object? nextOfKinRelationship = null,
  }) {
    return _then(_$ContactInfoStateImpl(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as PhoneNumberInput,
      nextOfKinName: null == nextOfKinName
          ? _value.nextOfKinName
          : nextOfKinName // ignore: cast_nullable_to_non_nullable
              as NameInput,
      nextOfKinPhone: null == nextOfKinPhone
          ? _value.nextOfKinPhone
          : nextOfKinPhone // ignore: cast_nullable_to_non_nullable
              as PhoneNumberInput,
      nextOfKinRelationship: null == nextOfKinRelationship
          ? _value.nextOfKinRelationship
          : nextOfKinRelationship // ignore: cast_nullable_to_non_nullable
              as RequiredTextInput,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$ContactInfoStateImpl extends _ContactInfoState {
  const _$ContactInfoStateImpl(
      {@PhoneNumberInputConverter()
      this.phoneNumber = const PhoneNumberInput.pure(),
      @NameInputConverter() this.nextOfKinName = const NameInput.pure(),
      @PhoneNumberInputConverter()
      this.nextOfKinPhone = const PhoneNumberInput.pure(),
      @RequiredTextInputConverter()
      this.nextOfKinRelationship = const RequiredTextInput.pure()})
      : super._();

  factory _$ContactInfoStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactInfoStateImplFromJson(json);

  @override
  @JsonKey()
  @PhoneNumberInputConverter()
  final PhoneNumberInput phoneNumber;
  @override
  @JsonKey()
  @NameInputConverter()
  final NameInput nextOfKinName;
  @override
  @JsonKey()
  @PhoneNumberInputConverter()
  final PhoneNumberInput nextOfKinPhone;
  @override
  @JsonKey()
  @RequiredTextInputConverter()
  final RequiredTextInput nextOfKinRelationship;

  @override
  String toString() {
    return 'ContactInfoState(phoneNumber: $phoneNumber, nextOfKinName: $nextOfKinName, nextOfKinPhone: $nextOfKinPhone, nextOfKinRelationship: $nextOfKinRelationship)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactInfoStateImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.nextOfKinName, nextOfKinName) ||
                other.nextOfKinName == nextOfKinName) &&
            (identical(other.nextOfKinPhone, nextOfKinPhone) ||
                other.nextOfKinPhone == nextOfKinPhone) &&
            (identical(other.nextOfKinRelationship, nextOfKinRelationship) ||
                other.nextOfKinRelationship == nextOfKinRelationship));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, phoneNumber, nextOfKinName,
      nextOfKinPhone, nextOfKinRelationship);

  /// Create a copy of ContactInfoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactInfoStateImplCopyWith<_$ContactInfoStateImpl> get copyWith =>
      __$$ContactInfoStateImplCopyWithImpl<_$ContactInfoStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactInfoStateImplToJson(
      this,
    );
  }
}

abstract class _ContactInfoState extends ContactInfoState {
  const factory _ContactInfoState(
      {@PhoneNumberInputConverter() final PhoneNumberInput phoneNumber,
      @NameInputConverter() final NameInput nextOfKinName,
      @PhoneNumberInputConverter() final PhoneNumberInput nextOfKinPhone,
      @RequiredTextInputConverter()
      final RequiredTextInput nextOfKinRelationship}) = _$ContactInfoStateImpl;
  const _ContactInfoState._() : super._();

  factory _ContactInfoState.fromJson(Map<String, dynamic> json) =
      _$ContactInfoStateImpl.fromJson;

  @override
  @PhoneNumberInputConverter()
  PhoneNumberInput get phoneNumber;
  @override
  @NameInputConverter()
  NameInput get nextOfKinName;
  @override
  @PhoneNumberInputConverter()
  PhoneNumberInput get nextOfKinPhone;
  @override
  @RequiredTextInputConverter()
  RequiredTextInput get nextOfKinRelationship;

  /// Create a copy of ContactInfoState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactInfoStateImplCopyWith<_$ContactInfoStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
