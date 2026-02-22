// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_details_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BankDetailsState _$BankDetailsStateFromJson(Map<String, dynamic> json) {
  return _BankDetailsState.fromJson(json);
}

/// @nodoc
mixin _$BankDetailsState {
  @OptionalTextInputConverter()
  OptionalTextInput get bankName => throw _privateConstructorUsedError;
  @BankAccountInputConverter()
  BankAccountInput get accountNumber => throw _privateConstructorUsedError;
  @OptionalTextInputConverter()
  OptionalTextInput get accountName => throw _privateConstructorUsedError;

  /// Serializes this BankDetailsState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BankDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BankDetailsStateCopyWith<BankDetailsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankDetailsStateCopyWith<$Res> {
  factory $BankDetailsStateCopyWith(
          BankDetailsState value, $Res Function(BankDetailsState) then) =
      _$BankDetailsStateCopyWithImpl<$Res, BankDetailsState>;
  @useResult
  $Res call(
      {@OptionalTextInputConverter() OptionalTextInput bankName,
      @BankAccountInputConverter() BankAccountInput accountNumber,
      @OptionalTextInputConverter() OptionalTextInput accountName});
}

/// @nodoc
class _$BankDetailsStateCopyWithImpl<$Res, $Val extends BankDetailsState>
    implements $BankDetailsStateCopyWith<$Res> {
  _$BankDetailsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BankDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bankName = null,
    Object? accountNumber = null,
    Object? accountName = null,
  }) {
    return _then(_value.copyWith(
      bankName: null == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as OptionalTextInput,
      accountNumber: null == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as BankAccountInput,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as OptionalTextInput,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BankDetailsStateImplCopyWith<$Res>
    implements $BankDetailsStateCopyWith<$Res> {
  factory _$$BankDetailsStateImplCopyWith(_$BankDetailsStateImpl value,
          $Res Function(_$BankDetailsStateImpl) then) =
      __$$BankDetailsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@OptionalTextInputConverter() OptionalTextInput bankName,
      @BankAccountInputConverter() BankAccountInput accountNumber,
      @OptionalTextInputConverter() OptionalTextInput accountName});
}

/// @nodoc
class __$$BankDetailsStateImplCopyWithImpl<$Res>
    extends _$BankDetailsStateCopyWithImpl<$Res, _$BankDetailsStateImpl>
    implements _$$BankDetailsStateImplCopyWith<$Res> {
  __$$BankDetailsStateImplCopyWithImpl(_$BankDetailsStateImpl _value,
      $Res Function(_$BankDetailsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of BankDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bankName = null,
    Object? accountNumber = null,
    Object? accountName = null,
  }) {
    return _then(_$BankDetailsStateImpl(
      bankName: null == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as OptionalTextInput,
      accountNumber: null == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as BankAccountInput,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as OptionalTextInput,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$BankDetailsStateImpl extends _BankDetailsState {
  const _$BankDetailsStateImpl(
      {@OptionalTextInputConverter()
      this.bankName = const OptionalTextInput.pure(),
      @BankAccountInputConverter()
      this.accountNumber = const BankAccountInput.pure(),
      @OptionalTextInputConverter()
      this.accountName = const OptionalTextInput.pure()})
      : super._();

  factory _$BankDetailsStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$BankDetailsStateImplFromJson(json);

  @override
  @JsonKey()
  @OptionalTextInputConverter()
  final OptionalTextInput bankName;
  @override
  @JsonKey()
  @BankAccountInputConverter()
  final BankAccountInput accountNumber;
  @override
  @JsonKey()
  @OptionalTextInputConverter()
  final OptionalTextInput accountName;

  @override
  String toString() {
    return 'BankDetailsState(bankName: $bankName, accountNumber: $accountNumber, accountName: $accountName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BankDetailsStateImpl &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, bankName, accountNumber, accountName);

  /// Create a copy of BankDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BankDetailsStateImplCopyWith<_$BankDetailsStateImpl> get copyWith =>
      __$$BankDetailsStateImplCopyWithImpl<_$BankDetailsStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BankDetailsStateImplToJson(
      this,
    );
  }
}

abstract class _BankDetailsState extends BankDetailsState {
  const factory _BankDetailsState(
          {@OptionalTextInputConverter() final OptionalTextInput bankName,
          @BankAccountInputConverter() final BankAccountInput accountNumber,
          @OptionalTextInputConverter() final OptionalTextInput accountName}) =
      _$BankDetailsStateImpl;
  const _BankDetailsState._() : super._();

  factory _BankDetailsState.fromJson(Map<String, dynamic> json) =
      _$BankDetailsStateImpl.fromJson;

  @override
  @OptionalTextInputConverter()
  OptionalTextInput get bankName;
  @override
  @BankAccountInputConverter()
  BankAccountInput get accountNumber;
  @override
  @OptionalTextInputConverter()
  OptionalTextInput get accountName;

  /// Create a copy of BankDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BankDetailsStateImplCopyWith<_$BankDetailsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
