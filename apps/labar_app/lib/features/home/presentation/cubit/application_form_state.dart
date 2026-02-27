import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:labar_app/features/home/domain/entities/agent_entity.dart';
import 'package:labar_app/features/home/domain/entities/application_entity.dart';
import 'package:labar_app/features/home/domain/entities/warehouse_entity.dart';

part 'application_form_state.freezed.dart';
part 'application_form_state.g.dart';

enum ApplicationFormStatus { initial, draft, submitting, success, failure }

@freezed
class ApplicationFormState with _$ApplicationFormState {
  const ApplicationFormState._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ApplicationFormState({
    @Default(0) int currentStep,
    @Default(ApplicationFormStatus.initial) ApplicationFormStatus status,
    String? errorMessage,
    String? loadingMessage,
    @Default('') String userId,
    ApplicationEntity? initialApplication,
    WarehouseEntity? selectedWarehouse,
    AgentEntity? selectedAgent,
  }) = _ApplicationFormState;

  factory ApplicationFormState.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFormStateFromJson(json);
}
