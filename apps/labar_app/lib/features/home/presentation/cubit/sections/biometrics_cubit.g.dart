// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometrics_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BiometricsStateImpl _$$BiometricsStateImplFromJson(
        Map<String, dynamic> json) =>
    _$BiometricsStateImpl(
      signatureBytes: (json['signatureBytes'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      passportPath: json['passportPath'] as String?,
    );

Map<String, dynamic> _$$BiometricsStateImplToJson(
        _$BiometricsStateImpl instance) =>
    <String, dynamic>{
      'signatureBytes': instance.signatureBytes,
      'passportPath': instance.passportPath,
    };
