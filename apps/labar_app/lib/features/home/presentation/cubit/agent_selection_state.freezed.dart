// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agent_selection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AgentSelectionState {
  List<AgentEntity> get agents => throw _privateConstructorUsedError;
  List<AgentEntity> get filteredAgents => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;

  /// Create a copy of AgentSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AgentSelectionStateCopyWith<AgentSelectionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgentSelectionStateCopyWith<$Res> {
  factory $AgentSelectionStateCopyWith(
          AgentSelectionState value, $Res Function(AgentSelectionState) then) =
      _$AgentSelectionStateCopyWithImpl<$Res, AgentSelectionState>;
  @useResult
  $Res call(
      {List<AgentEntity> agents,
      List<AgentEntity> filteredAgents,
      bool isLoading,
      String? error,
      String searchQuery});
}

/// @nodoc
class _$AgentSelectionStateCopyWithImpl<$Res, $Val extends AgentSelectionState>
    implements $AgentSelectionStateCopyWith<$Res> {
  _$AgentSelectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AgentSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? agents = null,
    Object? filteredAgents = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? searchQuery = null,
  }) {
    return _then(_value.copyWith(
      agents: null == agents
          ? _value.agents
          : agents // ignore: cast_nullable_to_non_nullable
              as List<AgentEntity>,
      filteredAgents: null == filteredAgents
          ? _value.filteredAgents
          : filteredAgents // ignore: cast_nullable_to_non_nullable
              as List<AgentEntity>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AgentSelectionStateImplCopyWith<$Res>
    implements $AgentSelectionStateCopyWith<$Res> {
  factory _$$AgentSelectionStateImplCopyWith(_$AgentSelectionStateImpl value,
          $Res Function(_$AgentSelectionStateImpl) then) =
      __$$AgentSelectionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<AgentEntity> agents,
      List<AgentEntity> filteredAgents,
      bool isLoading,
      String? error,
      String searchQuery});
}

/// @nodoc
class __$$AgentSelectionStateImplCopyWithImpl<$Res>
    extends _$AgentSelectionStateCopyWithImpl<$Res, _$AgentSelectionStateImpl>
    implements _$$AgentSelectionStateImplCopyWith<$Res> {
  __$$AgentSelectionStateImplCopyWithImpl(_$AgentSelectionStateImpl _value,
      $Res Function(_$AgentSelectionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AgentSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? agents = null,
    Object? filteredAgents = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? searchQuery = null,
  }) {
    return _then(_$AgentSelectionStateImpl(
      agents: null == agents
          ? _value._agents
          : agents // ignore: cast_nullable_to_non_nullable
              as List<AgentEntity>,
      filteredAgents: null == filteredAgents
          ? _value._filteredAgents
          : filteredAgents // ignore: cast_nullable_to_non_nullable
              as List<AgentEntity>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AgentSelectionStateImpl implements _AgentSelectionState {
  const _$AgentSelectionStateImpl(
      {final List<AgentEntity> agents = const [],
      final List<AgentEntity> filteredAgents = const [],
      this.isLoading = false,
      this.error,
      this.searchQuery = ''})
      : _agents = agents,
        _filteredAgents = filteredAgents;

  final List<AgentEntity> _agents;
  @override
  @JsonKey()
  List<AgentEntity> get agents {
    if (_agents is EqualUnmodifiableListView) return _agents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_agents);
  }

  final List<AgentEntity> _filteredAgents;
  @override
  @JsonKey()
  List<AgentEntity> get filteredAgents {
    if (_filteredAgents is EqualUnmodifiableListView) return _filteredAgents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredAgents);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  @JsonKey()
  final String searchQuery;

  @override
  String toString() {
    return 'AgentSelectionState(agents: $agents, filteredAgents: $filteredAgents, isLoading: $isLoading, error: $error, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgentSelectionStateImpl &&
            const DeepCollectionEquality().equals(other._agents, _agents) &&
            const DeepCollectionEquality()
                .equals(other._filteredAgents, _filteredAgents) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_agents),
      const DeepCollectionEquality().hash(_filteredAgents),
      isLoading,
      error,
      searchQuery);

  /// Create a copy of AgentSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AgentSelectionStateImplCopyWith<_$AgentSelectionStateImpl> get copyWith =>
      __$$AgentSelectionStateImplCopyWithImpl<_$AgentSelectionStateImpl>(
          this, _$identity);
}

abstract class _AgentSelectionState implements AgentSelectionState {
  const factory _AgentSelectionState(
      {final List<AgentEntity> agents,
      final List<AgentEntity> filteredAgents,
      final bool isLoading,
      final String? error,
      final String searchQuery}) = _$AgentSelectionStateImpl;

  @override
  List<AgentEntity> get agents;
  @override
  List<AgentEntity> get filteredAgents;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  String get searchQuery;

  /// Create a copy of AgentSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AgentSelectionStateImplCopyWith<_$AgentSelectionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
