// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'personal_info_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PersonalInfoState _$PersonalInfoStateFromJson(Map<String, dynamic> json) {
  return _PersonalInfoState.fromJson(json);
}

/// @nodoc
mixin _$PersonalInfoState {
  @NameInputConverter()
  NameInput get firstName => throw _privateConstructorUsedError;
  @NameInputConverter()
  NameInput get lastName => throw _privateConstructorUsedError;
  @OptionalTextInputConverter()
  OptionalTextInput get otherNames => throw _privateConstructorUsedError;
  @RequiredTextInputConverter()
  RequiredTextInput get gender => throw _privateConstructorUsedError;
  @RequiredTextInputConverter()
  RequiredTextInput get stateOfOrigin => throw _privateConstructorUsedError;
  @RequiredTextInputConverter()
  RequiredTextInput get lga => throw _privateConstructorUsedError;
  @RequiredTextInputConverter()
  RequiredTextInput get town => throw _privateConstructorUsedError;
  DateTime? get dateOfBirth => throw _privateConstructorUsedError;
  List<String> get availableStates => throw _privateConstructorUsedError;
  List<String> get currentLgas => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;

  /// Serializes this PersonalInfoState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PersonalInfoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonalInfoStateCopyWith<PersonalInfoState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonalInfoStateCopyWith<$Res> {
  factory $PersonalInfoStateCopyWith(
          PersonalInfoState value, $Res Function(PersonalInfoState) then) =
      _$PersonalInfoStateCopyWithImpl<$Res, PersonalInfoState>;
  @useResult
  $Res call(
      {@NameInputConverter() NameInput firstName,
      @NameInputConverter() NameInput lastName,
      @OptionalTextInputConverter() OptionalTextInput otherNames,
      @RequiredTextInputConverter() RequiredTextInput gender,
      @RequiredTextInputConverter() RequiredTextInput stateOfOrigin,
      @RequiredTextInputConverter() RequiredTextInput lga,
      @RequiredTextInputConverter() RequiredTextInput town,
      DateTime? dateOfBirth,
      List<String> availableStates,
      List<String> currentLgas,
      String userId});
}

/// @nodoc
class _$PersonalInfoStateCopyWithImpl<$Res, $Val extends PersonalInfoState>
    implements $PersonalInfoStateCopyWith<$Res> {
  _$PersonalInfoStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersonalInfoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? otherNames = null,
    Object? gender = null,
    Object? stateOfOrigin = null,
    Object? lga = null,
    Object? town = null,
    Object? dateOfBirth = freezed,
    Object? availableStates = null,
    Object? currentLgas = null,
    Object? userId = null,
  }) {
    return _then(_value.copyWith(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as NameInput,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as NameInput,
      otherNames: null == otherNames
          ? _value.otherNames
          : otherNames // ignore: cast_nullable_to_non_nullable
              as OptionalTextInput,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as RequiredTextInput,
      stateOfOrigin: null == stateOfOrigin
          ? _value.stateOfOrigin
          : stateOfOrigin // ignore: cast_nullable_to_non_nullable
              as RequiredTextInput,
      lga: null == lga
          ? _value.lga
          : lga // ignore: cast_nullable_to_non_nullable
              as RequiredTextInput,
      town: null == town
          ? _value.town
          : town // ignore: cast_nullable_to_non_nullable
              as RequiredTextInput,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      availableStates: null == availableStates
          ? _value.availableStates
          : availableStates // ignore: cast_nullable_to_non_nullable
              as List<String>,
      currentLgas: null == currentLgas
          ? _value.currentLgas
          : currentLgas // ignore: cast_nullable_to_non_nullable
              as List<String>,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PersonalInfoStateImplCopyWith<$Res>
    implements $PersonalInfoStateCopyWith<$Res> {
  factory _$$PersonalInfoStateImplCopyWith(_$PersonalInfoStateImpl value,
          $Res Function(_$PersonalInfoStateImpl) then) =
      __$$PersonalInfoStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@NameInputConverter() NameInput firstName,
      @NameInputConverter() NameInput lastName,
      @OptionalTextInputConverter() OptionalTextInput otherNames,
      @RequiredTextInputConverter() RequiredTextInput gender,
      @RequiredTextInputConverter() RequiredTextInput stateOfOrigin,
      @RequiredTextInputConverter() RequiredTextInput lga,
      @RequiredTextInputConverter() RequiredTextInput town,
      DateTime? dateOfBirth,
      List<String> availableStates,
      List<String> currentLgas,
      String userId});
}

/// @nodoc
class __$$PersonalInfoStateImplCopyWithImpl<$Res>
    extends _$PersonalInfoStateCopyWithImpl<$Res, _$PersonalInfoStateImpl>
    implements _$$PersonalInfoStateImplCopyWith<$Res> {
  __$$PersonalInfoStateImplCopyWithImpl(_$PersonalInfoStateImpl _value,
      $Res Function(_$PersonalInfoStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PersonalInfoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? otherNames = null,
    Object? gender = null,
    Object? stateOfOrigin = null,
    Object? lga = null,
    Object? town = null,
    Object? dateOfBirth = freezed,
    Object? availableStates = null,
    Object? currentLgas = null,
    Object? userId = null,
  }) {
    return _then(_$PersonalInfoStateImpl(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as NameInput,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as NameInput,
      otherNames: null == otherNames
          ? _value.otherNames
          : otherNames // ignore: cast_nullable_to_non_nullable
              as OptionalTextInput,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as RequiredTextInput,
      stateOfOrigin: null == stateOfOrigin
          ? _value.stateOfOrigin
          : stateOfOrigin // ignore: cast_nullable_to_non_nullable
              as RequiredTextInput,
      lga: null == lga
          ? _value.lga
          : lga // ignore: cast_nullable_to_non_nullable
              as RequiredTextInput,
      town: null == town
          ? _value.town
          : town // ignore: cast_nullable_to_non_nullable
              as RequiredTextInput,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      availableStates: null == availableStates
          ? _value._availableStates
          : availableStates // ignore: cast_nullable_to_non_nullable
              as List<String>,
      currentLgas: null == currentLgas
          ? _value._currentLgas
          : currentLgas // ignore: cast_nullable_to_non_nullable
              as List<String>,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$PersonalInfoStateImpl extends _PersonalInfoState {
  const _$PersonalInfoStateImpl(
      {@NameInputConverter() this.firstName = const NameInput.pure(),
      @NameInputConverter() this.lastName = const NameInput.pure(),
      @OptionalTextInputConverter()
      this.otherNames = const OptionalTextInput.pure(),
      @RequiredTextInputConverter()
      this.gender = const RequiredTextInput.pure(),
      @RequiredTextInputConverter()
      this.stateOfOrigin = const RequiredTextInput.pure(),
      @RequiredTextInputConverter() this.lga = const RequiredTextInput.pure(),
      @RequiredTextInputConverter() this.town = const RequiredTextInput.pure(),
      this.dateOfBirth,
      final List<String> availableStates = const [],
      final List<String> currentLgas = const [],
      this.userId = ''})
      : _availableStates = availableStates,
        _currentLgas = currentLgas,
        super._();

  factory _$PersonalInfoStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonalInfoStateImplFromJson(json);

  @override
  @JsonKey()
  @NameInputConverter()
  final NameInput firstName;
  @override
  @JsonKey()
  @NameInputConverter()
  final NameInput lastName;
  @override
  @JsonKey()
  @OptionalTextInputConverter()
  final OptionalTextInput otherNames;
  @override
  @JsonKey()
  @RequiredTextInputConverter()
  final RequiredTextInput gender;
  @override
  @JsonKey()
  @RequiredTextInputConverter()
  final RequiredTextInput stateOfOrigin;
  @override
  @JsonKey()
  @RequiredTextInputConverter()
  final RequiredTextInput lga;
  @override
  @JsonKey()
  @RequiredTextInputConverter()
  final RequiredTextInput town;
  @override
  final DateTime? dateOfBirth;
  final List<String> _availableStates;
  @override
  @JsonKey()
  List<String> get availableStates {
    if (_availableStates is EqualUnmodifiableListView) return _availableStates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableStates);
  }

  final List<String> _currentLgas;
  @override
  @JsonKey()
  List<String> get currentLgas {
    if (_currentLgas is EqualUnmodifiableListView) return _currentLgas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currentLgas);
  }

  @override
  @JsonKey()
  final String userId;

  @override
  String toString() {
    return 'PersonalInfoState(firstName: $firstName, lastName: $lastName, otherNames: $otherNames, gender: $gender, stateOfOrigin: $stateOfOrigin, lga: $lga, town: $town, dateOfBirth: $dateOfBirth, availableStates: $availableStates, currentLgas: $currentLgas, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonalInfoStateImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.otherNames, otherNames) ||
                other.otherNames == otherNames) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.stateOfOrigin, stateOfOrigin) ||
                other.stateOfOrigin == stateOfOrigin) &&
            (identical(other.lga, lga) || other.lga == lga) &&
            (identical(other.town, town) || other.town == town) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            const DeepCollectionEquality()
                .equals(other._availableStates, _availableStates) &&
            const DeepCollectionEquality()
                .equals(other._currentLgas, _currentLgas) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      firstName,
      lastName,
      otherNames,
      gender,
      stateOfOrigin,
      lga,
      town,
      dateOfBirth,
      const DeepCollectionEquality().hash(_availableStates),
      const DeepCollectionEquality().hash(_currentLgas),
      userId);

  /// Create a copy of PersonalInfoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonalInfoStateImplCopyWith<_$PersonalInfoStateImpl> get copyWith =>
      __$$PersonalInfoStateImplCopyWithImpl<_$PersonalInfoStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonalInfoStateImplToJson(
      this,
    );
  }
}

abstract class _PersonalInfoState extends PersonalInfoState {
  const factory _PersonalInfoState(
      {@NameInputConverter() final NameInput firstName,
      @NameInputConverter() final NameInput lastName,
      @OptionalTextInputConverter() final OptionalTextInput otherNames,
      @RequiredTextInputConverter() final RequiredTextInput gender,
      @RequiredTextInputConverter() final RequiredTextInput stateOfOrigin,
      @RequiredTextInputConverter() final RequiredTextInput lga,
      @RequiredTextInputConverter() final RequiredTextInput town,
      final DateTime? dateOfBirth,
      final List<String> availableStates,
      final List<String> currentLgas,
      final String userId}) = _$PersonalInfoStateImpl;
  const _PersonalInfoState._() : super._();

  factory _PersonalInfoState.fromJson(Map<String, dynamic> json) =
      _$PersonalInfoStateImpl.fromJson;

  @override
  @NameInputConverter()
  NameInput get firstName;
  @override
  @NameInputConverter()
  NameInput get lastName;
  @override
  @OptionalTextInputConverter()
  OptionalTextInput get otherNames;
  @override
  @RequiredTextInputConverter()
  RequiredTextInput get gender;
  @override
  @RequiredTextInputConverter()
  RequiredTextInput get stateOfOrigin;
  @override
  @RequiredTextInputConverter()
  RequiredTextInput get lga;
  @override
  @RequiredTextInputConverter()
  RequiredTextInput get town;
  @override
  DateTime? get dateOfBirth;
  @override
  List<String> get availableStates;
  @override
  List<String> get currentLgas;
  @override
  String get userId;

  /// Create a copy of PersonalInfoState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonalInfoStateImplCopyWith<_$PersonalInfoStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
