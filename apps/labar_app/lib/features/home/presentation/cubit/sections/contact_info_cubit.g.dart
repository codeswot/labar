// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_info_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactInfoStateImpl _$$ContactInfoStateImplFromJson(
        Map<String, dynamic> json) =>
    _$ContactInfoStateImpl(
      phoneNumber: json['phone_number'] == null
          ? const PhoneNumberInput.pure()
          : const PhoneNumberInputConverter()
              .fromJson(json['phone_number'] as String),
      nextOfKinName: json['next_of_kin_name'] == null
          ? const NameInput.pure()
          : const NameInputConverter()
              .fromJson(json['next_of_kin_name'] as String),
      nextOfKinPhone: json['next_of_kin_phone'] == null
          ? const PhoneNumberInput.pure()
          : const PhoneNumberInputConverter()
              .fromJson(json['next_of_kin_phone'] as String),
      nextOfKinRelationship: json['next_of_kin_relationship'] == null
          ? const RequiredTextInput.pure()
          : const RequiredTextInputConverter()
              .fromJson(json['next_of_kin_relationship'] as String),
      userId: json['user_id'] as String? ?? '',
    );

Map<String, dynamic> _$$ContactInfoStateImplToJson(
        _$ContactInfoStateImpl instance) =>
    <String, dynamic>{
      'phone_number':
          const PhoneNumberInputConverter().toJson(instance.phoneNumber),
      'next_of_kin_name':
          const NameInputConverter().toJson(instance.nextOfKinName),
      'next_of_kin_phone':
          const PhoneNumberInputConverter().toJson(instance.nextOfKinPhone),
      'next_of_kin_relationship': const RequiredTextInputConverter()
          .toJson(instance.nextOfKinRelationship),
      'user_id': instance.userId,
    };
