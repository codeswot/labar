import 'package:injectable/injectable.dart';
import 'package:labar_app/features/home/data/datasources/location_local_datasource.dart';
import 'package:labar_app/features/home/domain/repositories/location_repository.dart';

@LazySingleton(as: LocationRepository)
class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDataSource _dataSource;

  LocationRepositoryImpl(this._dataSource);

  @override
  Future<List<String>> getStates() {
    return _dataSource.getStates();
  }

  @override
  Future<List<String>> getLgas(String state) {
    return _dataSource.getLgas(state);
  }
}
