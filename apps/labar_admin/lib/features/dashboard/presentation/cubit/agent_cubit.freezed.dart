// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agent_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AgentState {
  List<Map<String, dynamic>> get applications =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of AgentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AgentStateCopyWith<AgentState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgentStateCopyWith<$Res> {
  factory $AgentStateCopyWith(
          AgentState value, $Res Function(AgentState) then) =
      _$AgentStateCopyWithImpl<$Res, AgentState>;
  @useResult
  $Res call(
      {List<Map<String, dynamic>> applications, bool isLoading, String? error});
}

/// @nodoc
class _$AgentStateCopyWithImpl<$Res, $Val extends AgentState>
    implements $AgentStateCopyWith<$Res> {
  _$AgentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AgentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applications = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      applications: null == applications
          ? _value.applications
          : applications // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AgentStateImplCopyWith<$Res>
    implements $AgentStateCopyWith<$Res> {
  factory _$$AgentStateImplCopyWith(
          _$AgentStateImpl value, $Res Function(_$AgentStateImpl) then) =
      __$$AgentStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Map<String, dynamic>> applications, bool isLoading, String? error});
}

/// @nodoc
class __$$AgentStateImplCopyWithImpl<$Res>
    extends _$AgentStateCopyWithImpl<$Res, _$AgentStateImpl>
    implements _$$AgentStateImplCopyWith<$Res> {
  __$$AgentStateImplCopyWithImpl(
      _$AgentStateImpl _value, $Res Function(_$AgentStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AgentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applications = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$AgentStateImpl(
      applications: null == applications
          ? _value._applications
          : applications // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AgentStateImpl implements _AgentState {
  const _$AgentStateImpl(
      {final List<Map<String, dynamic>> applications = const [],
      this.isLoading = false,
      this.error})
      : _applications = applications;

  final List<Map<String, dynamic>> _applications;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get applications {
    if (_applications is EqualUnmodifiableListView) return _applications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_applications);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'AgentState(applications: $applications, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgentStateImpl &&
            const DeepCollectionEquality()
                .equals(other._applications, _applications) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_applications), isLoading, error);

  /// Create a copy of AgentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AgentStateImplCopyWith<_$AgentStateImpl> get copyWith =>
      __$$AgentStateImplCopyWithImpl<_$AgentStateImpl>(this, _$identity);
}

abstract class _AgentState implements AgentState {
  const factory _AgentState(
      {final List<Map<String, dynamic>> applications,
      final bool isLoading,
      final String? error}) = _$AgentStateImpl;

  @override
  List<Map<String, dynamic>> get applications;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of AgentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AgentStateImplCopyWith<_$AgentStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
