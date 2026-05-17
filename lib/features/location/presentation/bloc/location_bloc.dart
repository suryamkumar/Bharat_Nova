import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/app_failure.dart';
import '../../domain/usecases/get_location_usecase.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetLocationUsecase _getLocationUsecase;

  LocationBloc(this._getLocationUsecase) : super(const LocationInitial()) {
    on<LocationFetchRequested>(_onFetch);
  }

  Future<void> _onFetch(
    LocationFetchRequested event,
    Emitter<LocationState> emit,
  ) async {
    emit(const LocationLoading());
    try {
      final location = await _getLocationUsecase();
      emit(LocationLoaded(location));
    } on AppFailure {
      emit(const LocationError());
    } catch (_) {
      emit(const LocationError());
    }
  }
}
