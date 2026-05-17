import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/constants/app_endpoints.dart';
import '../../../../core/errors/app_failure.dart';
import '../../domain/entities/location_entity.dart';

abstract class LocationDataSource {
  Future<LocationEntity> getCurrentLocation();
}

class LocationDataSourceImpl implements LocationDataSource {
  final Dio _dio;

  LocationDataSourceImpl(this._dio);

  @override
  Future<LocationEntity> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const AppFailure(message: 'Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const AppFailure(message: 'Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const AppFailure(message: 'Location permission permanently denied.');
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );

    return _reverseGeocode(position.latitude, position.longitude);
  }

  Future<LocationEntity> _reverseGeocode(double lat, double lon) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        AppEndpoints.reverseGeocode,
        queryParameters: {'lat': lat, 'lon': lon, 'format': 'json'},
      );

      final address = response.data?['address'] as Map<String, dynamic>?;
      final city = (address?['city'] ??
              address?['town'] ??
              address?['village'] ??
              address?['county'] ??
              'India')
          as String;
      final state = (address?['state'] ?? '') as String;

      return LocationEntity(
        latitude: lat,
        longitude: lon,
        city: city,
        state: state,
      );
    } on DioException catch (e) {
      throw AppFailure.fromDioException(e);
    } catch (_) {
      return LocationEntity(
        latitude: lat,
        longitude: lon,
        city: 'India',
        state: '',
      );
    }
  }
}
