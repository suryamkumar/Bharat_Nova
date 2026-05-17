import '../../domain/entities/location_entity.dart';

sealed class LocationState {
  const LocationState();
}

final class LocationInitial extends LocationState {
  const LocationInitial();
}

final class LocationLoading extends LocationState {
  const LocationLoading();
}

final class LocationLoaded extends LocationState {
  final LocationEntity location;

  const LocationLoaded(this.location);
}

final class LocationError extends LocationState {
  const LocationError();
}
