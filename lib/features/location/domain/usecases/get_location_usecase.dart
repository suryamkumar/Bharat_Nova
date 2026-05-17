import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class GetLocationUsecase {
  final LocationRepository _repository;

  GetLocationUsecase(this._repository);

  Future<LocationEntity> call() => _repository.getCurrentLocation();
}
