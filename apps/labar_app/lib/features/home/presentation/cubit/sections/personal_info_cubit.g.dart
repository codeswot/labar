// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_info_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PersonalInfoStateImpl _$$PersonalInfoStateImplFromJson(
        Map<String, dynamic> json) =>
    _$PersonalInfoStateImpl(
      firstName: json['first_name'] == null
          ? const NameInput.pure()
          : const NameInputConverter().fromJson(json['first_name'] as String),
      lastName: json['last_name'] == null
          ? const NameInput.pure()
          : const NameInputConverter().fromJson(json['last_name'] as String),
      otherNames: json['other_names'] == null
          ? const OptionalTextInput.pure()
          : const OptionalTextInputConverter()
              .fromJson(json['other_names'] as String),
      gender: json['gender'] == null
          ? const RequiredTextInput.pure()
          : const RequiredTextInputConverter()
              .fromJson(json['gender'] as String),
      stateOfOrigin: json['state_of_origin'] == null
          ? const RequiredTextInput.pure()
          : const RequiredTextInputConverter()
              .fromJson(json['state_of_origin'] as String),
      lga: json['lga'] == null
          ? const RequiredTextInput.pure()
          : const RequiredTextInputConverter().fromJson(json['lga'] as String),
      town: json['town'] == null
          ? const RequiredTextInput.pure()
          : const RequiredTextInputConverter().fromJson(json['town'] as String),
      dateOfBirth: json['date_of_birth'] == null
          ? null
          : DateTime.parse(json['date_of_birth'] as String),
      availableStates: (json['available_states'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      currentLgas: (json['current_lgas'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PersonalInfoStateImplToJson(
        _$PersonalInfoStateImpl instance) =>
    <String, dynamic>{
      'first_name': const NameInputConverter().toJson(instance.firstName),
      'last_name': const NameInputConverter().toJson(instance.lastName),
      'other_names':
          const OptionalTextInputConverter().toJson(instance.otherNames),
      'gender': const RequiredTextInputConverter().toJson(instance.gender),
      'state_of_origin':
          const RequiredTextInputConverter().toJson(instance.stateOfOrigin),
      'lga': const RequiredTextInputConverter().toJson(instance.lga),
      'town': const RequiredTextInputConverter().toJson(instance.town),
      'date_of_birth': instance.dateOfBirth?.toIso8601String(),
      'available_states': instance.availableStates,
      'current_lgas': instance.currentLgas,
    };
