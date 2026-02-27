import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_app/features/home/domain/repositories/application_repository.dart';
import 'package:labar_app/features/home/presentation/cubit/agent_selection_state.dart';

@injectable
class AgentSelectionCubit extends Cubit<AgentSelectionState> {
  final ApplicationRepository _applicationRepository;

  AgentSelectionCubit(this._applicationRepository)
      : super(const AgentSelectionState());

  Future<void> loadAgents() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final agents = await _applicationRepository.getAgents();
      emit(state.copyWith(
        agents: agents,
        filteredAgents: agents,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void searchAgents(String query) {
    final filtered = state.agents.where((a) {
      final name = a.fullName.toLowerCase();
      final email = (a.email ?? '').toLowerCase();
      final q = query.toLowerCase();
      return name.contains(q) || email.contains(q);
    }).toList();

    emit(state.copyWith(
      searchQuery: query,
      filteredAgents: filtered,
    ));
  }
}
