// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_management_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ItemManagementState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get items => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of ItemManagementState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemManagementStateCopyWith<ItemManagementState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemManagementStateCopyWith<$Res> {
  factory $ItemManagementStateCopyWith(
          ItemManagementState value, $Res Function(ItemManagementState) then) =
      _$ItemManagementStateCopyWithImpl<$Res, ItemManagementState>;
  @useResult
  $Res call({bool isLoading, List<Map<String, dynamic>> items, String? error});
}

/// @nodoc
class _$ItemManagementStateCopyWithImpl<$Res, $Val extends ItemManagementState>
    implements $ItemManagementStateCopyWith<$Res> {
  _$ItemManagementStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemManagementState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? items = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ItemManagementStateImplCopyWith<$Res>
    implements $ItemManagementStateCopyWith<$Res> {
  factory _$$ItemManagementStateImplCopyWith(_$ItemManagementStateImpl value,
          $Res Function(_$ItemManagementStateImpl) then) =
      __$$ItemManagementStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, List<Map<String, dynamic>> items, String? error});
}

/// @nodoc
class __$$ItemManagementStateImplCopyWithImpl<$Res>
    extends _$ItemManagementStateCopyWithImpl<$Res, _$ItemManagementStateImpl>
    implements _$$ItemManagementStateImplCopyWith<$Res> {
  __$$ItemManagementStateImplCopyWithImpl(_$ItemManagementStateImpl _value,
      $Res Function(_$ItemManagementStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ItemManagementState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? items = null,
    Object? error = freezed,
  }) {
    return _then(_$ItemManagementStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ItemManagementStateImpl implements _ItemManagementState {
  const _$ItemManagementStateImpl(
      {this.isLoading = false,
      final List<Map<String, dynamic>> items = const [],
      this.error})
      : _items = items;

  @override
  @JsonKey()
  final bool isLoading;
  final List<Map<String, dynamic>> _items;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? error;

  @override
  String toString() {
    return 'ItemManagementState(isLoading: $isLoading, items: $items, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemManagementStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading,
      const DeepCollectionEquality().hash(_items), error);

  /// Create a copy of ItemManagementState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemManagementStateImplCopyWith<_$ItemManagementStateImpl> get copyWith =>
      __$$ItemManagementStateImplCopyWithImpl<_$ItemManagementStateImpl>(
          this, _$identity);
}

abstract class _ItemManagementState implements ItemManagementState {
  const factory _ItemManagementState(
      {final bool isLoading,
      final List<Map<String, dynamic>> items,
      final String? error}) = _$ItemManagementStateImpl;

  @override
  bool get isLoading;
  @override
  List<Map<String, dynamic>> get items;
  @override
  String? get error;

  /// Create a copy of ItemManagementState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemManagementStateImplCopyWith<_$ItemManagementStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
