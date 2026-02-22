import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_app/features/home/domain/entities/allocated_resource_entity.dart';
import 'package:labar_app/features/home/domain/repositories/allocated_resource_repository.dart';

part 'allocated_resources_state.dart';
part 'allocated_resources_cubit.freezed.dart';

@injectable
class AllocatedResourcesCubit extends Cubit<AllocatedResourcesState> {
  final AllocatedResourceRepository _repository;
  StreamSubscription? _subscription;

  AllocatedResourcesCubit(this._repository)
      : super(const AllocatedResourcesState.initial());

  void watchResources(String applicationId) {
    emit(const AllocatedResourcesState.loading());
    _subscription?.cancel();
    _subscription = _repository.watchAllocatedResources(applicationId).listen(
      (resources) {
        emit(AllocatedResourcesState.loaded(resources));
      },
      onError: (error) {
        emit(AllocatedResourcesState.error(error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
