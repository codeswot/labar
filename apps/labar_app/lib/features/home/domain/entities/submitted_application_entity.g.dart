// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submitted_application_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmittedApplicationEntity _$SubmittedApplicationEntityFromJson(
        Map<String, dynamic> json) =>
    SubmittedApplicationEntity(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      warehouseId: json['warehouse_id'] as String?,
      agentId: json['agent_id'] as String?,
      status: $enumDecodeNullable(_$ApplicationStatusEnumMap, json['status']) ??
          ApplicationStatus.initial,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      otherNames: json['other_names'] as String?,
      dateOfBirth: json['date_of_birth'] == null
          ? null
          : DateTime.parse(json['date_of_birth'] as String),
      gender: json['gender'] as String?,
      state: json['state'] as String?,
      lga: json['lga'] as String?,
      town: json['town'] as String?,
      bankName: json['bank_name'] as String?,
      accountNumber: json['account_number'] as String?,
      accountName: json['account_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      nextOfKinName: json['next_of_kin_name'] as String?,
      nextOfKinPhone: json['next_of_kin_phone'] as String?,
      nextOfKinRelationship: json['next_of_kin_relationship'] as String?,
      farmSize: json['farm_size'] as String?,
      farmLocation: json['farm_location'] as String?,
      cropType: json['crop_type'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      passportPath: json['passport_path'] as String?,
      kycType: $enumDecodeNullable(_$KycTypeEnumMap, json['kyc_type']),
      kycNumber: json['kyc_number'] as String?,
      signaturePath: json['signature_path'] as String?,
      idCardPath: json['id_card_path'] as String?,
      proofOfPaymentPath: json['proof_of_payment_path'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$SubmittedApplicationEntityToJson(
        SubmittedApplicationEntity instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      'user_id': instance.userId,
      'warehouse_id': instance.warehouseId,
      'agent_id': instance.agentId,
      'status': _$ApplicationStatusEnumMap[instance.status]!,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'other_names': instance.otherNames,
      'date_of_birth': instance.dateOfBirth?.toIso8601String(),
      'gender': instance.gender,
      'state': instance.state,
      'lga': instance.lga,
      'town': instance.town,
      'bank_name': instance.bankName,
      'account_number': instance.accountNumber,
      'account_name': instance.accountName,
      'phone_number': instance.phoneNumber,
      'next_of_kin_name': instance.nextOfKinName,
      'next_of_kin_phone': instance.nextOfKinPhone,
      'next_of_kin_relationship': instance.nextOfKinRelationship,
      'farm_size': instance.farmSize,
      'farm_location': instance.farmLocation,
      'crop_type': instance.cropType,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'passport_path': instance.passportPath,
      'kyc_type': _$KycTypeEnumMap[instance.kycType],
      'kyc_number': instance.kycNumber,
      'signature_path': instance.signaturePath,
      'id_card_path': instance.idCardPath,
      'proof_of_payment_path': instance.proofOfPaymentPath,
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
    };

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.initial: 'initial',
  ApplicationStatus.inReview: 'in_review',
  ApplicationStatus.approved: 'approved',
  ApplicationStatus.rejected: 'rejected',
};

const _$KycTypeEnumMap = {
  KycType.nin: 'nin',
  KycType.bvn: 'bvn',
  KycType.internationalPassport: 'international_passport',
  KycType.votersCard: 'voters_card',
};
