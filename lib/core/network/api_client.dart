import 'package:dio/dio.dart';
import '../errors/app_failure.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw AppFailure.fromDioException(e);
    } catch (e) {
      throw AppFailure.unknown(e.toString());
    }
  }
}
