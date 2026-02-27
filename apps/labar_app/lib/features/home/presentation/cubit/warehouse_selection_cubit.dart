import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_app/features/home/domain/repositories/warehouse_repository.dart';
import 'package:labar_app/features/home/presentation/cubit/warehouse_selection_state.dart';

@injectable
class WarehouseSelectionCubit extends Cubit<WarehouseSelectionState> {
  final WarehouseRepository _warehouseRepository;

  WarehouseSelectionCubit(this._warehouseRepository)
      : super(const WarehouseSelectionState());

  Future<void> loadWarehouses() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final warehouses = await _warehouseRepository.getWarehouses();
      emit(state.copyWith(
        warehouses: warehouses,
        filteredWarehouses: warehouses,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void searchWarehouses(String query) {
    final filtered = state.warehouses.where((w) {
      final name = w.name.toLowerCase();
      final location = (w.location ?? '').toLowerCase();
      final q = query.toLowerCase();
      return name.contains(q) || location.contains(q);
    }).toList();

    emit(state.copyWith(
      searchQuery: query,
      filteredWarehouses: filtered,
    ));
  }
}
