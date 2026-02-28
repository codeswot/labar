import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_admin/core/utils/app_logger.dart';
import 'package:labar_admin/features/dashboard/data/repositories/admin_repository_impl.dart';

part 'item_management_cubit.freezed.dart';

@freezed
class ItemManagementState with _$ItemManagementState {
  const factory ItemManagementState({
    @Default(false) bool isLoading,
    @Default([]) List<Map<String, dynamic>> items,
    String? error,
  }) = _ItemManagementState;
}

@injectable
class ItemManagementCubit extends Cubit<ItemManagementState> {
  final AdminRepository _repository;
  StreamSubscription? _itemsSubscription;

  ItemManagementCubit(this._repository) : super(const ItemManagementState());

  Future<void> init() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final items = await _repository.getItems();
      emit(state.copyWith(isLoading: false, items: items));

      _itemsSubscription?.cancel();
      _itemsSubscription = _repository.itemsStream.listen((items) {
        emit(state.copyWith(items: items));
      });
    } catch (e, stack) {
      AppLogger.error('Failed to init items', e, stack);
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _itemsSubscription?.cancel();
    return super.close();
  }

  Future<void> addItem({
    required String name,
    required String unit,
    required num price,
    required String location,
    String? description,
  }) async {
    try {
      await _repository.addItem(
        name: name,
        unit: unit,
        price: price,
        location: location,
        description: description,
      );
    } catch (e, stack) {
      AppLogger.error('Failed to add item', e, stack);
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> updateItem({
    required String id,
    required String name,
    required String unit,
    required num price,
    required String location,
    String? description,
  }) async {
    try {
      await _repository.updateItem(
        id: id,
        name: name,
        unit: unit,
        price: price,
        location: location,
        description: description,
      );
    } catch (e, stack) {
      AppLogger.error('Failed to update item', e, stack);
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await _repository.deleteItem(id);
    } catch (e, stack) {
      AppLogger.error('Failed to delete item', e, stack);
      emit(state.copyWith(error: e.toString()));
    }
  }
}
