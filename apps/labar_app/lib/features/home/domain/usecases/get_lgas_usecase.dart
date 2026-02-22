import 'package:injectable/injectable.dart';
import 'package:labar_app/features/home/domain/repositories/location_repository.dart';

@lazySingleton
class GetLgasUseCase {
  final LocationRepository _repository;

  GetLgasUseCase(this._repository);

  Future<List<String>> call(String state) {
    return _repository.getLgas(state);
  }
}
