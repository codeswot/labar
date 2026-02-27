// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_form_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApplicationFormStateImpl _$$ApplicationFormStateImplFromJson(
        Map<String, dynamic> json) =>
    _$ApplicationFormStateImpl(
      currentStep: (json['current_step'] as num?)?.toInt() ?? 0,
      status:
          $enumDecodeNullable(_$ApplicationFormStatusEnumMap, json['status']) ??
              ApplicationFormStatus.initial,
      errorMessage: json['error_message'] as String?,
      loadingMessage: json['loading_message'] as String?,
      userId: json['user_id'] as String? ?? '',
      initialApplication: json['initial_application'] == null
          ? null
          : ApplicationEntity.fromJson(
              json['initial_application'] as Map<String, dynamic>),
      selectedWarehouse: json['selected_warehouse'] == null
          ? null
          : WarehouseEntity.fromJson(
              json['selected_warehouse'] as Map<String, dynamic>),
      selectedAgent: json['selected_agent'] == null
          ? null
          : AgentEntity.fromJson(
              json['selected_agent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ApplicationFormStateImplToJson(
        _$ApplicationFormStateImpl instance) =>
    <String, dynamic>{
      'current_step': instance.currentStep,
      'status': _$ApplicationFormStatusEnumMap[instance.status]!,
      'error_message': instance.errorMessage,
      'loading_message': instance.loadingMessage,
      'user_id': instance.userId,
      'initial_application': instance.initialApplication,
      'selected_warehouse': instance.selectedWarehouse,
      'selected_agent': instance.selectedAgent,
    };

const _$ApplicationFormStatusEnumMap = {
  ApplicationFormStatus.initial: 'initial',
  ApplicationFormStatus.draft: 'draft',
  ApplicationFormStatus.submitting: 'submitting',
  ApplicationFormStatus.success: 'success',
  ApplicationFormStatus.failure: 'failure',
};
