import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:labar_app/features/home/domain/entities/enums.dart';

part 'application_entity.g.dart';

@JsonSerializable()
class ApplicationEntity extends Equatable {
  final String id;
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
  @JsonKey(name: 'farm_polygon')
  final List<Map<String, dynamic>>? farmPolygon;

  // KYC
  final String? passportPath;
  final KycType? kycType;
  final String? kycNumber;
  final String? signaturePath;
  @JsonKey(name: 'proof_of_payment_path')
  final String? proofOfPaymentPath;

  // Display URLs (not persisted)
  @JsonKey(includeToJson: false, includeFromJson: false)
  final String? passportUrl;
  @JsonKey(includeToJson: false, includeFromJson: false)
  final String? signatureUrl;
  @JsonKey(includeToJson: false, includeFromJson: false)
  final String? proofOfPaymentUrl;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ApplicationEntity({
    required this.id,
    required this.userId,
    this.status = ApplicationStatus.initial,
    this.firstName = '',
    this.lastName = '',
    this.otherNames,
    this.dateOfBirth,
    this.gender = '',
    this.state = '',
    this.lga = '',
    this.bankName,
    this.accountNumber,
    this.accountName,
    this.phoneNumber = '',
    this.nextOfKinName = '',
    this.nextOfKinPhone = '',
    this.nextOfKinRelationship = '',
    this.farmSize,
    this.farmLocation,
    this.cropType = '',
    this.latitude,
    this.longitude,
    this.farmPolygon,
    this.passportPath,
    this.kycType,
    this.kycNumber,
    this.signaturePath,
    this.proofOfPaymentPath,
    this.passportUrl,
    this.signatureUrl,
    this.proofOfPaymentUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory ApplicationEntity.initial({required String userId}) {
    final now = DateTime.now();
    return ApplicationEntity(
      id: '',
      userId: userId,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory ApplicationEntity.fromJson(Map<String, dynamic> json) =>
      _$ApplicationEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationEntityToJson(this);

  ApplicationEntity copyWith({
    String? id,
    String? userId,
    ApplicationStatus? status,
    String? firstName,
    String? lastName,
    String? otherNames,
    DateTime? dateOfBirth,
    String? gender,
    String? state,
    String? lga,
    String? bankName,
    String? accountNumber,
    String? accountName,
    String? phoneNumber,
    String? nextOfKinName,
    String? nextOfKinPhone,
    String? nextOfKinRelationship,
    String? farmSize,
    String? farmLocation,
    String? cropType,
    double? latitude,
    double? longitude,
    List<Map<String, dynamic>>? farmPolygon,
    String? passportPath,
    KycType? kycType,
    String? kycNumber,
    String? signaturePath,
    String? proofOfPaymentPath,
    String? passportUrl,
    String? signatureUrl,
    String? proofOfPaymentUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ApplicationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      otherNames: otherNames ?? this.otherNames,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      state: state ?? this.state,
      lga: lga ?? this.lga,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nextOfKinName: nextOfKinName ?? this.nextOfKinName,
      nextOfKinPhone: nextOfKinPhone ?? this.nextOfKinPhone,
      nextOfKinRelationship:
          nextOfKinRelationship ?? this.nextOfKinRelationship,
      farmSize: farmSize ?? this.farmSize,
      farmLocation: farmLocation ?? this.farmLocation,
      cropType: cropType ?? this.cropType,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      farmPolygon: farmPolygon ?? this.farmPolygon,
      passportPath: passportPath ?? this.passportPath,
      kycType: kycType ?? this.kycType,
      kycNumber: kycNumber ?? this.kycNumber,
      signaturePath: signaturePath ?? this.signaturePath,
      proofOfPaymentPath: proofOfPaymentPath ?? this.proofOfPaymentPath,
      passportUrl: passportUrl ?? this.passportUrl,
      signatureUrl: signatureUrl ?? this.signatureUrl,
      proofOfPaymentUrl: proofOfPaymentUrl ?? this.proofOfPaymentUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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
        farmPolygon,
        passportPath,
        kycType,
        kycNumber,
        signaturePath,
        proofOfPaymentPath,
        passportUrl,
        signatureUrl,
        proofOfPaymentUrl,
        createdAt,
        updatedAt,
      ];
}
