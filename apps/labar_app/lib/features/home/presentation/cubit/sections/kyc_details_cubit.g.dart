// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_details_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KycDetailsStateImpl _$$KycDetailsStateImplFromJson(
        Map<String, dynamic> json) =>
    _$KycDetailsStateImpl(
      kycType: $enumDecodeNullable(_$KycTypeEnumMap, json['kyc_type']),
      kycNumber: json['kyc_number'] == null
          ? const RequiredTextInput.pure()
          : const RequiredTextInputConverter()
              .fromJson(json['kyc_number'] as String),
    );

Map<String, dynamic> _$$KycDetailsStateImplToJson(
        _$KycDetailsStateImpl instance) =>
    <String, dynamic>{
      'kyc_type': _$KycTypeEnumMap[instance.kycType],
      'kyc_number':
          const RequiredTextInputConverter().toJson(instance.kycNumber),
    };

const _$KycTypeEnumMap = {
  KycType.nin: 'nin',
  KycType.bvn: 'bvn',
  KycType.internationalPassport: 'international_passport',
  KycType.votersCard: 'voters_card',
};
