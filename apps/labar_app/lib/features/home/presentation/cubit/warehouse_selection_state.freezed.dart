// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warehouse_selection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WarehouseSelectionState {
  List<WarehouseEntity> get warehouses => throw _privateConstructorUsedError;
  List<WarehouseEntity> get filteredWarehouses =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;

  /// Create a copy of WarehouseSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WarehouseSelectionStateCopyWith<WarehouseSelectionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WarehouseSelectionStateCopyWith<$Res> {
  factory $WarehouseSelectionStateCopyWith(WarehouseSelectionState value,
          $Res Function(WarehouseSelectionState) then) =
      _$WarehouseSelectionStateCopyWithImpl<$Res, WarehouseSelectionState>;
  @useResult
  $Res call(
      {List<WarehouseEntity> warehouses,
      List<WarehouseEntity> filteredWarehouses,
      bool isLoading,
      String? error,
      String searchQuery});
}

/// @nodoc
class _$WarehouseSelectionStateCopyWithImpl<$Res,
        $Val extends WarehouseSelectionState>
    implements $WarehouseSelectionStateCopyWith<$Res> {
  _$WarehouseSelectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WarehouseSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? warehouses = null,
    Object? filteredWarehouses = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? searchQuery = null,
  }) {
    return _then(_value.copyWith(
      warehouses: null == warehouses
          ? _value.warehouses
          : warehouses // ignore: cast_nullable_to_non_nullable
              as List<WarehouseEntity>,
      filteredWarehouses: null == filteredWarehouses
          ? _value.filteredWarehouses
          : filteredWarehouses // ignore: cast_nullable_to_non_nullable
              as List<WarehouseEntity>,
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
abstract class _$$WarehouseSelectionStateImplCopyWith<$Res>
    implements $WarehouseSelectionStateCopyWith<$Res> {
  factory _$$WarehouseSelectionStateImplCopyWith(
          _$WarehouseSelectionStateImpl value,
          $Res Function(_$WarehouseSelectionStateImpl) then) =
      __$$WarehouseSelectionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<WarehouseEntity> warehouses,
      List<WarehouseEntity> filteredWarehouses,
      bool isLoading,
      String? error,
      String searchQuery});
}

/// @nodoc
class __$$WarehouseSelectionStateImplCopyWithImpl<$Res>
    extends _$WarehouseSelectionStateCopyWithImpl<$Res,
        _$WarehouseSelectionStateImpl>
    implements _$$WarehouseSelectionStateImplCopyWith<$Res> {
  __$$WarehouseSelectionStateImplCopyWithImpl(
      _$WarehouseSelectionStateImpl _value,
      $Res Function(_$WarehouseSelectionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of WarehouseSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? warehouses = null,
    Object? filteredWarehouses = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? searchQuery = null,
  }) {
    return _then(_$WarehouseSelectionStateImpl(
      warehouses: null == warehouses
          ? _value._warehouses
          : warehouses // ignore: cast_nullable_to_non_nullable
              as List<WarehouseEntity>,
      filteredWarehouses: null == filteredWarehouses
          ? _value._filteredWarehouses
          : filteredWarehouses // ignore: cast_nullable_to_non_nullable
              as List<WarehouseEntity>,
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

class _$WarehouseSelectionStateImpl implements _WarehouseSelectionState {
  const _$WarehouseSelectionStateImpl(
      {final List<WarehouseEntity> warehouses = const [],
      final List<WarehouseEntity> filteredWarehouses = const [],
      this.isLoading = false,
      this.error,
      this.searchQuery = ''})
      : _warehouses = warehouses,
        _filteredWarehouses = filteredWarehouses;

  final List<WarehouseEntity> _warehouses;
  @override
  @JsonKey()
  List<WarehouseEntity> get warehouses {
    if (_warehouses is EqualUnmodifiableListView) return _warehouses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warehouses);
  }

  final List<WarehouseEntity> _filteredWarehouses;
  @override
  @JsonKey()
  List<WarehouseEntity> get filteredWarehouses {
    if (_filteredWarehouses is EqualUnmodifiableListView)
      return _filteredWarehouses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredWarehouses);
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
    return 'WarehouseSelectionState(warehouses: $warehouses, filteredWarehouses: $filteredWarehouses, isLoading: $isLoading, error: $error, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WarehouseSelectionStateImpl &&
            const DeepCollectionEquality()
                .equals(other._warehouses, _warehouses) &&
            const DeepCollectionEquality()
                .equals(other._filteredWarehouses, _filteredWarehouses) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_warehouses),
      const DeepCollectionEquality().hash(_filteredWarehouses),
      isLoading,
      error,
      searchQuery);

  /// Create a copy of WarehouseSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WarehouseSelectionStateImplCopyWith<_$WarehouseSelectionStateImpl>
      get copyWith => __$$WarehouseSelectionStateImplCopyWithImpl<
          _$WarehouseSelectionStateImpl>(this, _$identity);
}

abstract class _WarehouseSelectionState implements WarehouseSelectionState {
  const factory _WarehouseSelectionState(
      {final List<WarehouseEntity> warehouses,
      final List<WarehouseEntity> filteredWarehouses,
      final bool isLoading,
      final String? error,
      final String searchQuery}) = _$WarehouseSelectionStateImpl;

  @override
  List<WarehouseEntity> get warehouses;
  @override
  List<WarehouseEntity> get filteredWarehouses;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  String get searchQuery;

  /// Create a copy of WarehouseSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WarehouseSelectionStateImplCopyWith<_$WarehouseSelectionStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
