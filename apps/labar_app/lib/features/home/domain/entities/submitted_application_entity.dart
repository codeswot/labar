import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:labar_app/features/home/domain/entities/application_entity.dart';
import 'package:labar_app/features/home/domain/entities/enums.dart';

part 'submitted_application_entity.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class SubmittedApplicationEntity extends Equatable {
  @JsonKey(includeIfNull: false)
  final String? id;
  final String userId;
  final ApplicationStatus status;

  // Personal Info
  final String firstName;
  final String lastName;
  final String? otherNames;
  final DateTime? dateOfBirth;
  final String gender;
  final String state;
  final String lga;
  final String town;

  // Bank Details
  final String? bankName;
  final String? accountNumber;
  final String? accountName;

  // Contact Info
  final String phoneNumber;
  final String nextOfKinName;
  final String nextOfKinPhone;
  final String nextOfKinRelationship;

  // Farm Info
  final String? farmSize;
  final String? farmLocation;
  final String cropType;
  final double? latitude;
  final double? longitude;

  // KYC
  final String? passportPath;
  final KycType? kycType;
  final String? kycNumber;

  @JsonKey(name: 'signature_path')
  final String? signaturePath;
  @JsonKey(name: 'proof_of_payment_path')
  final String? proofOfPaymentPath;

  @JsonKey(includeIfNull: false)
  final DateTime? createdAt;
  @JsonKey(includeIfNull: false)
  final DateTime? updatedAt;

  const SubmittedApplicationEntity({
    this.id,
    required this.userId,
    this.status = ApplicationStatus.initial,
    required this.firstName,
    required this.lastName,
    this.otherNames,
    this.dateOfBirth,
    required this.gender,
    required this.state,
    required this.lga,
    required this.town,
    this.bankName,
    this.accountNumber,
    this.accountName,
    required this.phoneNumber,
    required this.nextOfKinName,
    required this.nextOfKinPhone,
    required this.nextOfKinRelationship,
    this.farmSize,
    this.farmLocation,
    required this.cropType,
    this.latitude,
    this.longitude,
    this.passportPath,
    this.kycType,
    this.kycNumber,
    this.signaturePath,
    this.proofOfPaymentPath,
    this.createdAt,
    this.updatedAt,
  });

  factory SubmittedApplicationEntity.fromApplicationEntity(
      ApplicationEntity entity) {
    return SubmittedApplicationEntity(
      id: entity.id.isEmpty ? null : entity.id,
      userId: entity.userId,
      status: entity.status,
      firstName: entity.firstName,
      lastName: entity.lastName,
      otherNames: entity.otherNames,
      dateOfBirth: entity.dateOfBirth,
      gender: entity.gender,
      state: entity.state,
      lga: entity.lga,
      town: entity.town,
      bankName: entity.bankName,
      accountNumber: entity.accountNumber,
      accountName: entity.accountName,
      phoneNumber: entity.phoneNumber,
      nextOfKinName: entity.nextOfKinName,
      nextOfKinPhone: entity.nextOfKinPhone,
      nextOfKinRelationship: entity.nextOfKinRelationship,
      farmSize: entity.farmSize,
      farmLocation: entity.farmLocation,
      cropType: entity.cropType,
      latitude: entity.latitude,
      longitude: entity.longitude,
      passportPath: entity.passportPath,
      kycType: entity.kycType,
      kycNumber: entity.kycNumber,
      signaturePath: entity.signaturePath,
      proofOfPaymentPath: entity.proofOfPaymentPath,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  ApplicationEntity toApplicationEntity({
    String? passportUrl,
    String? signatureUrl,
    String? proofOfPaymentUrl,
  }) {
    return ApplicationEntity(
      id: id ?? '',
      userId: userId,
      status: status,
      firstName: firstName,
      lastName: lastName,
      otherNames: otherNames,
      dateOfBirth: dateOfBirth,
      gender: gender,
      state: state,
      lga: lga,
      town: town,
      bankName: bankName,
      accountNumber: accountNumber,
      accountName: accountName,
      phoneNumber: phoneNumber,
      nextOfKinName: nextOfKinName,
      nextOfKinPhone: nextOfKinPhone,
      nextOfKinRelationship: nextOfKinRelationship,
      farmSize: farmSize,
      farmLocation: farmLocation,
      cropType: cropType,
      latitude: latitude,
      longitude: longitude,
      passportPath: passportPath,
      kycType: kycType,
      kycNumber: kycNumber,
      signaturePath: signaturePath,
      proofOfPaymentPath: proofOfPaymentPath,
      passportUrl: passportUrl,
      signatureUrl: signatureUrl,
      proofOfPaymentUrl: proofOfPaymentUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory SubmittedApplicationEntity.fromJson(Map<String, dynamic> json) =>
      _$SubmittedApplicationEntityFromJson(json);

  Map<String, dynamic> toJson() => _$SubmittedApplicationEntityToJson(this);

  @override
  List<Object?> get props => [
        id,
        userId,
        status,
        firstName,
        lastName,
        otherNames,
        dateOfBirth,
        gender,
        state,
        lga,
        town,
        bankName,
        accountNumber,
        accountName,
        phoneNumber,
        nextOfKinName,
        nextOfKinPhone,
        nextOfKinRelationship,
        farmSize,
        farmLocation,
        cropType,
        latitude,
        longitude,
        passportPath,
        kycType,
        kycNumber,
        signaturePath,
        proofOfPaymentPath,
        createdAt,
        updatedAt,
      ];
}
