import 'package:dio/dio.dart';
import '../constants/app_endpoints.dart';
import '../network/api_client.dart';
import 'injection.dart';

Future<void> initNetworkDependencies() async {
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      Dio(
        BaseOptions(
          baseUrl: AppEndpoints.feedBaseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      ),
    ),
  );

  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: AppEndpoints.nominatimBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'User-Agent': 'BharatNova/1.0.0'},
      ),
    ),
    instanceName: 'location',
  );
}
