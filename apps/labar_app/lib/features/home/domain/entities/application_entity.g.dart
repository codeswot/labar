// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationEntity _$ApplicationEntityFromJson(Map<String, dynamic> json) =>
    ApplicationEntity(
      id: json['id'] as String,
      userId: json['userId'] as String,
      status: $enumDecodeNullable(_$ApplicationStatusEnumMap, json['status']) ??
          ApplicationStatus.initial,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      otherNames: json['otherNames'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String? ?? '',
      state: json['state'] as String? ?? '',
      lga: json['lga'] as String? ?? '',
      bankName: json['bankName'] as String?,
      accountNumber: json['accountNumber'] as String?,
      accountName: json['accountName'] as String?,
      phoneNumber: json['phoneNumber'] as String? ?? '',
      nextOfKinName: json['nextOfKinName'] as String? ?? '',
      nextOfKinPhone: json['nextOfKinPhone'] as String? ?? '',
      nextOfKinRelationship: json['nextOfKinRelationship'] as String? ?? '',
      farmSize: json['farmSize'] as String?,
      farmLocation: json['farmLocation'] as String?,
      cropType: json['cropType'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      farmPolygon: (json['farm_polygon'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      passportPath: json['passportPath'] as String?,
      kycType: $enumDecodeNullable(_$KycTypeEnumMap, json['kycType']),
      kycNumber: json['kycNumber'] as String?,
      signaturePath: json['signaturePath'] as String?,
      proofOfPaymentPath: json['proof_of_payment_path'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ApplicationEntityToJson(ApplicationEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'status': _$ApplicationStatusEnumMap[instance.status]!,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'otherNames': instance.otherNames,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'gender': instance.gender,
      'state': instance.state,
      'lga': instance.lga,
      'bankName': instance.bankName,
      'accountNumber': instance.accountNumber,
      'accountName': instance.accountName,
      'phoneNumber': instance.phoneNumber,
      'nextOfKinName': instance.nextOfKinName,
      'nextOfKinPhone': instance.nextOfKinPhone,
      'nextOfKinRelationship': instance.nextOfKinRelationship,
      'farmSize': instance.farmSize,
      'farmLocation': instance.farmLocation,
      'cropType': instance.cropType,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'farm_polygon': instance.farmPolygon,
      'passportPath': instance.passportPath,
      'kycType': _$KycTypeEnumMap[instance.kycType],
      'kycNumber': instance.kycNumber,
      'signaturePath': instance.signaturePath,
      'proof_of_payment_path': instance.proofOfPaymentPath,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
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
