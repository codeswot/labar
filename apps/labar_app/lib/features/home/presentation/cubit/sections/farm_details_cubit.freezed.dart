// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'farm_details_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FarmDetailsState _$FarmDetailsStateFromJson(Map<String, dynamic> json) {
  return _FarmDetailsState.fromJson(json);
}

/// @nodoc
mixin _$FarmDetailsState {
  @NumberInputConverter()
  NumberInput get farmSize => throw _privateConstructorUsedError;
  @RequiredTextInputConverter()
  RequiredTextInput get farmLocation => throw _privateConstructorUsedError;
  @RequiredTextInputConverter()
  RequiredTextInput get cropType => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  List<dynamic> get farmPolygon => throw _privateConstructorUsedError;
  bool get isFetchingLocation => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;

  /// Serializes this FarmDetailsState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FarmDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FarmDetailsStateCopyWith<FarmDetailsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FarmDetailsStateCopyWith<$Res> {
  factory $FarmDetailsStateCopyWith(
          FarmDetailsState value, $Res Function(FarmDetailsState) then) =
      _$FarmDetailsStateCopyWithImpl<$Res, FarmDetailsState>;
  @useResult
  $Res call(
      {@NumberInputConverter() NumberInput farmSize,
      @RequiredTextInputConverter() RequiredTextInput farmLocation,
      @RequiredTextInputConverter() RequiredTextInput cropType,
      double? latitude,
      double? longitude,
      List<dynamic> farmPolygon,
      bool isFetchingLocation,
      String userId});
}

/// @nodoc
class _$FarmDetailsStateCopyWithImpl<$Res, $Val extends FarmDetailsState>
    implements $FarmDetailsStateCopyWith<$Res> {
  _$FarmDetailsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FarmDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? farmSize = null,
    Object? farmLocation = null,
    Object? cropType = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? farmPolygon = null,
    Object? isFetchingLocation = null,
    Object? userId = null,
  }) {
    return _then(_value.copyWith(
      farmSize: null == farmSize
          ? _value.farmSize
          : farmSize // ignore: cast_nullable_to_non_nullable
              as NumberInput,
      farmLocation: null == farmLocation
          ? _value.farmLocation
          : farmLocation // ignore: cast_nullable_to_non_nullable
              as RequiredTextInput,
      cropType: null == cropType
          ? _value.cropType
          : cropType // ignore: cast_nullable_to_non_nullable
              as RequiredTextInput,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      farmPolygon: null == farmPolygon
          ? _value.farmPolygon
          : farmPolygon // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      isFetchingLocation: null == isFetchingLocation
          ? _value.isFetchingLocation
          : isFetchingLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FarmDetailsStateImplCopyWith<$Res>
    implements $FarmDetailsStateCopyWith<$Res> {
  factory _$$FarmDetailsStateImplCopyWith(_$FarmDetailsStateImpl value,
          $Res Function(_$FarmDetailsStateImpl) then) =
      __$$FarmDetailsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@NumberInputConverter() NumberInput farmSize,
      @RequiredTextInputConverter() RequiredTextInput farmLocation,
      @RequiredTextInputConverter() RequiredTextInput cropType,
      double? latitude,
      double? longitude,
      List<dynamic> farmPolygon,
      bool isFetchingLocation,
      String userId});
}

/// @nodoc
class __$$FarmDetailsStateImplCopyWithImpl<$Res>
    extends _$FarmDetailsStateCopyWithImpl<$Res, _$FarmDetailsStateImpl>
    implements _$$FarmDetailsStateImplCopyWith<$Res> {
  __$$FarmDetailsStateImplCopyWithImpl(_$FarmDetailsStateImpl _value,
      $Res Function(_$FarmDetailsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FarmDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? farmSize = null,
    Object? farmLocation = null,
    Object? cropType = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? farmPolygon = null,
    Object? isFetchingLocation = null,
    Object? userId = null,
  }) {
    return _then(_$FarmDetailsStateImpl(
      farmSize: null == farmSize
          ? _value.farmSize
          : farmSize // ignore: cast_nullable_to_non_nullable
              as NumberInput,
      farmLocation: null == farmLocation
          ? _value.farmLocation
          : farmLocation // ignore: cast_nullable_to_non_nullable
              as RequiredTextInput,
      cropType: null == cropType
          ? _value.cropType
          : cropType // ignore: cast_nullable_to_non_nullable
              as RequiredTextInput,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      farmPolygon: null == farmPolygon
          ? _value._farmPolygon
          : farmPolygon // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      isFetchingLocation: null == isFetchingLocation
          ? _value.isFetchingLocation
          : isFetchingLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$FarmDetailsStateImpl extends _FarmDetailsState {
  const _$FarmDetailsStateImpl(
      {@NumberInputConverter() this.farmSize = const NumberInput.pure(),
      @RequiredTextInputConverter()
      this.farmLocation = const RequiredTextInput.pure(),
      @RequiredTextInputConverter()
      this.cropType = const RequiredTextInput.pure(),
      this.latitude,
      this.longitude,
      final List<dynamic> farmPolygon = const [],
      this.isFetchingLocation = false,
      this.userId = ''})
      : _farmPolygon = farmPolygon,
        super._();

  factory _$FarmDetailsStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$FarmDetailsStateImplFromJson(json);

  @override
  @JsonKey()
  @NumberInputConverter()
  final NumberInput farmSize;
  @override
  @JsonKey()
  @RequiredTextInputConverter()
  final RequiredTextInput farmLocation;
  @override
  @JsonKey()
  @RequiredTextInputConverter()
  final RequiredTextInput cropType;
  @override
  final double? latitude;
  @override
  final double? longitude;
  final List<dynamic> _farmPolygon;
  @override
  @JsonKey()
  List<dynamic> get farmPolygon {
    if (_farmPolygon is EqualUnmodifiableListView) return _farmPolygon;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_farmPolygon);
  }

  @override
  @JsonKey()
  final bool isFetchingLocation;
  @override
  @JsonKey()
  final String userId;

  @override
  String toString() {
    return 'FarmDetailsState(farmSize: $farmSize, farmLocation: $farmLocation, cropType: $cropType, latitude: $latitude, longitude: $longitude, farmPolygon: $farmPolygon, isFetchingLocation: $isFetchingLocation, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FarmDetailsStateImpl &&
            (identical(other.farmSize, farmSize) ||
                other.farmSize == farmSize) &&
            (identical(other.farmLocation, farmLocation) ||
                other.farmLocation == farmLocation) &&
            (identical(other.cropType, cropType) ||
                other.cropType == cropType) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality()
                .equals(other._farmPolygon, _farmPolygon) &&
            (identical(other.isFetchingLocation, isFetchingLocation) ||
                other.isFetchingLocation == isFetchingLocation) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      farmSize,
      farmLocation,
      cropType,
      latitude,
      longitude,
      const DeepCollectionEquality().hash(_farmPolygon),
      isFetchingLocation,
      userId);

  /// Create a copy of FarmDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FarmDetailsStateImplCopyWith<_$FarmDetailsStateImpl> get copyWith =>
      __$$FarmDetailsStateImplCopyWithImpl<_$FarmDetailsStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FarmDetailsStateImplToJson(
      this,
    );
  }
}

abstract class _FarmDetailsState extends FarmDetailsState {
  const factory _FarmDetailsState(
      {@NumberInputConverter() final NumberInput farmSize,
      @RequiredTextInputConverter() final RequiredTextInput farmLocation,
      @RequiredTextInputConverter() final RequiredTextInput cropType,
      final double? latitude,
      final double? longitude,
      final List<dynamic> farmPolygon,
      final bool isFetchingLocation,
      final String userId}) = _$FarmDetailsStateImpl;
  const _FarmDetailsState._() : super._();

  factory _FarmDetailsState.fromJson(Map<String, dynamic> json) =
      _$FarmDetailsStateImpl.fromJson;

  @override
  @NumberInputConverter()
  NumberInput get farmSize;
  @override
  @RequiredTextInputConverter()
  RequiredTextInput get farmLocation;
  @override
  @RequiredTextInputConverter()
  RequiredTextInput get cropType;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  List<dynamic> get farmPolygon;
  @override
  bool get isFetchingLocation;
  @override
  String get userId;

  /// Create a copy of FarmDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FarmDetailsStateImplCopyWith<_$FarmDetailsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
