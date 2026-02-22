// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_overview_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DashboardOverviewState {
  int get totalApplications => throw _privateConstructorUsedError;
  int get activeAgents => throw _privateConstructorUsedError;
  int get pendingReviews => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get recentActivity =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of DashboardOverviewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardOverviewStateCopyWith<DashboardOverviewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardOverviewStateCopyWith<$Res> {
  factory $DashboardOverviewStateCopyWith(DashboardOverviewState value,
          $Res Function(DashboardOverviewState) then) =
      _$DashboardOverviewStateCopyWithImpl<$Res, DashboardOverviewState>;
  @useResult
  $Res call(
      {int totalApplications,
      int activeAgents,
      int pendingReviews,
      List<Map<String, dynamic>> recentActivity,
      bool isLoading,
      String? error});
}

/// @nodoc
class _$DashboardOverviewStateCopyWithImpl<$Res,
        $Val extends DashboardOverviewState>
    implements $DashboardOverviewStateCopyWith<$Res> {
  _$DashboardOverviewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardOverviewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalApplications = null,
    Object? activeAgents = null,
    Object? pendingReviews = null,
    Object? recentActivity = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      totalApplications: null == totalApplications
          ? _value.totalApplications
          : totalApplications // ignore: cast_nullable_to_non_nullable
              as int,
      activeAgents: null == activeAgents
          ? _value.activeAgents
          : activeAgents // ignore: cast_nullable_to_non_nullable
              as int,
      pendingReviews: null == pendingReviews
          ? _value.pendingReviews
          : pendingReviews // ignore: cast_nullable_to_non_nullable
              as int,
      recentActivity: null == recentActivity
          ? _value.recentActivity
          : recentActivity // ignore: cast_nullable_to_non_nullable
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
abstract class _$$DashboardOverviewStateImplCopyWith<$Res>
    implements $DashboardOverviewStateCopyWith<$Res> {
  factory _$$DashboardOverviewStateImplCopyWith(
          _$DashboardOverviewStateImpl value,
          $Res Function(_$DashboardOverviewStateImpl) then) =
      __$$DashboardOverviewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalApplications,
      int activeAgents,
      int pendingReviews,
      List<Map<String, dynamic>> recentActivity,
      bool isLoading,
      String? error});
}

/// @nodoc
class __$$DashboardOverviewStateImplCopyWithImpl<$Res>
    extends _$DashboardOverviewStateCopyWithImpl<$Res,
        _$DashboardOverviewStateImpl>
    implements _$$DashboardOverviewStateImplCopyWith<$Res> {
  __$$DashboardOverviewStateImplCopyWithImpl(
      _$DashboardOverviewStateImpl _value,
      $Res Function(_$DashboardOverviewStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardOverviewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalApplications = null,
    Object? activeAgents = null,
    Object? pendingReviews = null,
    Object? recentActivity = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$DashboardOverviewStateImpl(
      totalApplications: null == totalApplications
          ? _value.totalApplications
          : totalApplications // ignore: cast_nullable_to_non_nullable
              as int,
      activeAgents: null == activeAgents
          ? _value.activeAgents
          : activeAgents // ignore: cast_nullable_to_non_nullable
              as int,
      pendingReviews: null == pendingReviews
          ? _value.pendingReviews
          : pendingReviews // ignore: cast_nullable_to_non_nullable
              as int,
      recentActivity: null == recentActivity
          ? _value._recentActivity
          : recentActivity // ignore: cast_nullable_to_non_nullable
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

class _$DashboardOverviewStateImpl implements _DashboardOverviewState {
  const _$DashboardOverviewStateImpl(
      {this.totalApplications = 0,
      this.activeAgents = 0,
      this.pendingReviews = 0,
      final List<Map<String, dynamic>> recentActivity = const [],
      this.isLoading = false,
      this.error})
      : _recentActivity = recentActivity;

  @override
  @JsonKey()
  final int totalApplications;
  @override
  @JsonKey()
  final int activeAgents;
  @override
  @JsonKey()
  final int pendingReviews;
  final List<Map<String, dynamic>> _recentActivity;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get recentActivity {
    if (_recentActivity is EqualUnmodifiableListView) return _recentActivity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentActivity);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'DashboardOverviewState(totalApplications: $totalApplications, activeAgents: $activeAgents, pendingReviews: $pendingReviews, recentActivity: $recentActivity, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardOverviewStateImpl &&
            (identical(other.totalApplications, totalApplications) ||
                other.totalApplications == totalApplications) &&
            (identical(other.activeAgents, activeAgents) ||
                other.activeAgents == activeAgents) &&
            (identical(other.pendingReviews, pendingReviews) ||
                other.pendingReviews == pendingReviews) &&
            const DeepCollectionEquality()
                .equals(other._recentActivity, _recentActivity) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalApplications,
      activeAgents,
      pendingReviews,
      const DeepCollectionEquality().hash(_recentActivity),
      isLoading,
      error);

  /// Create a copy of DashboardOverviewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardOverviewStateImplCopyWith<_$DashboardOverviewStateImpl>
      get copyWith => __$$DashboardOverviewStateImplCopyWithImpl<
          _$DashboardOverviewStateImpl>(this, _$identity);
}

abstract class _DashboardOverviewState implements DashboardOverviewState {
  const factory _DashboardOverviewState(
      {final int totalApplications,
      final int activeAgents,
      final int pendingReviews,
      final List<Map<String, dynamic>> recentActivity,
      final bool isLoading,
      final String? error}) = _$DashboardOverviewStateImpl;

  @override
  int get totalApplications;
  @override
  int get activeAgents;
  @override
  int get pendingReviews;
  @override
  List<Map<String, dynamic>> get recentActivity;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of DashboardOverviewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardOverviewStateImplCopyWith<_$DashboardOverviewStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
