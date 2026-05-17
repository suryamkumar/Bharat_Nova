import '../../core/di/injection.dart';
import 'data/datasources/location_datasource.dart';
import 'data/repositories/location_repository_impl.dart';
import 'domain/repositories/location_repository.dart';
import 'domain/usecases/get_location_usecase.dart';
import 'presentation/bloc/location_bloc.dart';

Future<void> initLocationDependency() async {
  sl.registerLazySingleton<LocationDataSource>(() => LocationDataSourceImpl(sl(instanceName: 'location')));

  sl.registerLazySingleton<LocationRepository>(() => LocationRepositoryImpl(sl()));

  sl.registerLazySingleton<GetLocationUsecase>(() => GetLocationUsecase(sl()));

  sl.registerFactory<LocationBloc>(() => LocationBloc(sl()));
}
