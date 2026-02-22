// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApplicationFormState _$ApplicationFormStateFromJson(Map<String, dynamic> json) {
  return _ApplicationFormState.fromJson(json);
}

/// @nodoc
mixin _$ApplicationFormState {
  int get currentStep => throw _privateConstructorUsedError;
  ApplicationFormStatus get status => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  String? get loadingMessage => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  ApplicationEntity? get initialApplication =>
      throw _privateConstructorUsedError;

  /// Serializes this ApplicationFormState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApplicationFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApplicationFormStateCopyWith<ApplicationFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationFormStateCopyWith<$Res> {
  factory $ApplicationFormStateCopyWith(ApplicationFormState value,
          $Res Function(ApplicationFormState) then) =
      _$ApplicationFormStateCopyWithImpl<$Res, ApplicationFormState>;
  @useResult
  $Res call(
      {int currentStep,
      ApplicationFormStatus status,
      String? errorMessage,
      String? loadingMessage,
      String userId,
      ApplicationEntity? initialApplication});
}

/// @nodoc
class _$ApplicationFormStateCopyWithImpl<$Res,
        $Val extends ApplicationFormState>
    implements $ApplicationFormStateCopyWith<$Res> {
  _$ApplicationFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApplicationFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? status = null,
    Object? errorMessage = freezed,
    Object? loadingMessage = freezed,
    Object? userId = null,
    Object? initialApplication = freezed,
  }) {
    return _then(_value.copyWith(
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ApplicationFormStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingMessage: freezed == loadingMessage
          ? _value.loadingMessage
          : loadingMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      initialApplication: freezed == initialApplication
          ? _value.initialApplication
          : initialApplication // ignore: cast_nullable_to_non_nullable
              as ApplicationEntity?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApplicationFormStateImplCopyWith<$Res>
    implements $ApplicationFormStateCopyWith<$Res> {
  factory _$$ApplicationFormStateImplCopyWith(_$ApplicationFormStateImpl value,
          $Res Function(_$ApplicationFormStateImpl) then) =
      __$$ApplicationFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int currentStep,
      ApplicationFormStatus status,
      String? errorMessage,
      String? loadingMessage,
      String userId,
      ApplicationEntity? initialApplication});
}

/// @nodoc
class __$$ApplicationFormStateImplCopyWithImpl<$Res>
    extends _$ApplicationFormStateCopyWithImpl<$Res, _$ApplicationFormStateImpl>
    implements _$$ApplicationFormStateImplCopyWith<$Res> {
  __$$ApplicationFormStateImplCopyWithImpl(_$ApplicationFormStateImpl _value,
      $Res Function(_$ApplicationFormStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApplicationFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? status = null,
    Object? errorMessage = freezed,
    Object? loadingMessage = freezed,
    Object? userId = null,
    Object? initialApplication = freezed,
  }) {
    return _then(_$ApplicationFormStateImpl(
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ApplicationFormStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingMessage: freezed == loadingMessage
          ? _value.loadingMessage
          : loadingMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      initialApplication: freezed == initialApplication
          ? _value.initialApplication
          : initialApplication // ignore: cast_nullable_to_non_nullable
              as ApplicationEntity?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$ApplicationFormStateImpl extends _ApplicationFormState {
  const _$ApplicationFormStateImpl(
      {this.currentStep = 0,
      this.status = ApplicationFormStatus.initial,
      this.errorMessage,
      this.loadingMessage,
      this.userId = '',
      this.initialApplication})
      : super._();

  factory _$ApplicationFormStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplicationFormStateImplFromJson(json);

  @override
  @JsonKey()
  final int currentStep;
  @override
  @JsonKey()
  final ApplicationFormStatus status;
  @override
  final String? errorMessage;
  @override
  final String? loadingMessage;
  @override
  @JsonKey()
  final String userId;
  @override
  final ApplicationEntity? initialApplication;

  @override
  String toString() {
    return 'ApplicationFormState(currentStep: $currentStep, status: $status, errorMessage: $errorMessage, loadingMessage: $loadingMessage, userId: $userId, initialApplication: $initialApplication)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationFormStateImpl &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.loadingMessage, loadingMessage) ||
                other.loadingMessage == loadingMessage) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.initialApplication, initialApplication) ||
                other.initialApplication == initialApplication));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currentStep, status,
      errorMessage, loadingMessage, userId, initialApplication);

  /// Create a copy of ApplicationFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationFormStateImplCopyWith<_$ApplicationFormStateImpl>
      get copyWith =>
          __$$ApplicationFormStateImplCopyWithImpl<_$ApplicationFormStateImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplicationFormStateImplToJson(
      this,
    );
  }
}

abstract class _ApplicationFormState extends ApplicationFormState {
  const factory _ApplicationFormState(
          {final int currentStep,
          final ApplicationFormStatus status,
          final String? errorMessage,
          final String? loadingMessage,
          final String userId,
          final ApplicationEntity? initialApplication}) =
      _$ApplicationFormStateImpl;
  const _ApplicationFormState._() : super._();

  factory _ApplicationFormState.fromJson(Map<String, dynamic> json) =
      _$ApplicationFormStateImpl.fromJson;

  @override
  int get currentStep;
  @override
  ApplicationFormStatus get status;
  @override
  String? get errorMessage;
  @override
  String? get loadingMessage;
  @override
  String get userId;
  @override
  ApplicationEntity? get initialApplication;

  /// Create a copy of ApplicationFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplicationFormStateImplCopyWith<_$ApplicationFormStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
