import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_app/features/home/domain/repositories/warehouse_repository.dart';
import 'package:labar_app/features/home/presentation/cubit/assigned_warehouse_state.dart';

@injectable
class AssignedWarehouseCubit extends Cubit<AssignedWarehouseState> {
  final WarehouseRepository _repository;
  StreamSubscription? _subscription;

  AssignedWarehouseCubit(this._repository)
      : super(const AssignedWarehouseState.initial());

  void watchDesignation(String applicationId) {
    emit(const AssignedWarehouseState.loading());
    _subscription?.cancel();
    _subscription = _repository.watchWarehouseDesignation(applicationId).listen(
      (designation) {
        emit(AssignedWarehouseState.loaded(designation));
      },
      onError: (error) {
        emit(AssignedWarehouseState.error(error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
