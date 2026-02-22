import 'package:json_annotation/json_annotation.dart';

enum ApplicationStatus {
  @JsonValue('initial')
  initial,
  @JsonValue('in_review')
  inReview,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
}

enum KycType {
  @JsonValue('nin')
  nin,
  @JsonValue('bvn')
  bvn,
  @JsonValue('international_passport')
  internationalPassport,
  @JsonValue('voters_card')
  votersCard,
}
