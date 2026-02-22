// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_details_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FarmDetailsStateImpl _$$FarmDetailsStateImplFromJson(
        Map<String, dynamic> json) =>
    _$FarmDetailsStateImpl(
      farmSize: json['farm_size'] == null
          ? const NumberInput.pure()
          : const NumberInputConverter().fromJson(json['farm_size'] as String),
      farmLocation: json['farm_location'] == null
          ? const RequiredTextInput.pure()
          : const RequiredTextInputConverter()
              .fromJson(json['farm_location'] as String),
      cropType: json['crop_type'] == null
          ? const RequiredTextInput.pure()
          : const RequiredTextInputConverter()
              .fromJson(json['crop_type'] as String),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      farmPolygon: json['farm_polygon'] as List<dynamic>? ?? const [],
      isFetchingLocation: json['is_fetching_location'] as bool? ?? false,
    );

Map<String, dynamic> _$$FarmDetailsStateImplToJson(
        _$FarmDetailsStateImpl instance) =>
    <String, dynamic>{
      'farm_size': const NumberInputConverter().toJson(instance.farmSize),
      'farm_location':
          const RequiredTextInputConverter().toJson(instance.farmLocation),
      'crop_type': const RequiredTextInputConverter().toJson(instance.cropType),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'farm_polygon': instance.farmPolygon,
      'is_fetching_location': instance.isFetchingLocation,
    };
