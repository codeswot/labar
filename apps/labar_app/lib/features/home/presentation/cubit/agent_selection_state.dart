import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:labar_app/features/home/domain/entities/agent_entity.dart';

part 'agent_selection_state.freezed.dart';

@freezed
class AgentSelectionState with _$AgentSelectionState {
  const factory AgentSelectionState({
    @Default([]) List<AgentEntity> agents,
    @Default([]) List<AgentEntity> filteredAgents,
    @Default(false) bool isLoading,
    String? error,
    @Default('') String searchQuery,
  }) = _AgentSelectionState;
}
