import 'package:injectable/injectable.dart';
import 'package:labar_app/features/home/domain/repositories/location_repository.dart';

@lazySingleton
class GetStatesUseCase {
  final LocationRepository _repository;

  GetStatesUseCase(this._repository);

  Future<List<String>> call() {
    return _repository.getStates();
  }
}
