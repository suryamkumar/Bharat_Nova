import 'package:dio/dio.dart';

class AppFailure implements Exception {
  final String message;
  final int? statusCode;

  const AppFailure({required this.message, this.statusCode});

  factory AppFailure.fromDioException(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        const AppFailure(message: 'Connection timed out. Please try again.'),
      DioExceptionType.badResponse => AppFailure(
          message: _messageForStatus(e.response?.statusCode),
          statusCode: e.response?.statusCode,
        ),
      DioExceptionType.connectionError =>
        const AppFailure(message: 'No internet connection.'),
      DioExceptionType.cancel =>
        const AppFailure(message: 'Request was cancelled.'),
      _ => const AppFailure(message: 'Something went wrong. Please try again.'),
    };
  }

  factory AppFailure.unknown([String? message]) =>
      AppFailure(message: message ?? 'Something went wrong.');

  static String _messageForStatus(int? code) => switch (code) {
        400 => 'Bad request.',
        401 => 'Unauthorised.',
        403 => 'Forbidden.',
        404 => 'Resource not found.',
        500 => 'Internal server error.',
        503 => 'Service unavailable.',
        _ => 'Server error (${code ?? 'unknown'}).',
      };

  @override
  String toString() => 'AppFailure(message: $message, statusCode: $statusCode)';
}
