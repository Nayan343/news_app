import 'package:dio/dio.dart';

enum AppExceptionType {
  requestCancelled,
  badCertificate,
  unauthorisedRequest,
  connectionError,
  badRequest,
  notFound,
  requestTimeout,
  sendTimeout,
  receiveTimeout,
  internalServerError,
  notImplemented,
  serviceUnavailable,
  socketException,
  formatException,
  unexpectedError,
}

class AppException implements Exception {
  final String name, message;
  final int? statusCode;
  final AppExceptionType exceptionType;

  AppException._({
    required this.message,
    this.exceptionType = AppExceptionType.unexpectedError,
    int? statusCode,
    String? name,
  })  : statusCode = statusCode ?? 500,
        name = exceptionType.name;

  factory AppException(dynamic error) {
    late AppException serverException;
    try {
      if (error is DioException) {
        switch (error.type) {
          case DioExceptionType.cancel:
            serverException = AppException._(
                exceptionType: AppExceptionType.requestCancelled,
                statusCode: error.response?.statusCode,
                name: error.response?.statusMessage,
                message: error.response?.data is Map
                    ? error.response?.data["message"] ??
                        error.response?.data.toString()
                    : "${error.error ?? error.response?.data ?? "Request Cancelled"}");
            break;

          case DioExceptionType.connectionTimeout:
            serverException = AppException._(
                exceptionType: AppExceptionType.requestTimeout,
                statusCode: error.response?.statusCode,
                name: error.response?.statusMessage,
                message: error.response?.data is Map
                    ? error.response?.data["message"] ??
                        error.response?.data.toString()
                    : "${error.error ?? error.response?.data ?? "Request Timeout"}");
            break;

          case DioExceptionType.receiveTimeout:
            serverException = AppException._(
                exceptionType: AppExceptionType.receiveTimeout,
                statusCode: error.response?.statusCode,
                name: error.response?.statusMessage,
                message: error.response?.data is Map
                    ? error.response?.data["message"] ??
                        error.response?.data.toString()
                    : "${error.error ?? error.response?.data ?? "Receive Timeout"}");
            break;

          case DioExceptionType.sendTimeout:
            serverException = AppException._(
                exceptionType: AppExceptionType.sendTimeout,
                statusCode: error.response?.statusCode,
                name: error.response?.statusMessage,
                message: error.response?.data is Map
                    ? error.response?.data["message"] ??
                        error.response?.data.toString()
                    : "${error.error ?? error.response?.data ?? "Send Timeout"}");
            break;

          case DioExceptionType.connectionError:
            serverException = AppException._(
                exceptionType: AppExceptionType.connectionError,
                name: error.response?.statusMessage,
                message: 'Verify your internet connection');
            break;
          case DioExceptionType.badCertificate:
            serverException = AppException._(
                exceptionType: AppExceptionType.badCertificate,
                name: error.response?.statusMessage,
                message: error.response?.data is Map
                    ? error.response?.data["message"] ??
                        error.response?.data.toString()
                    : "${error.error ?? error.response?.data ?? "Bad Certificate"}");
            break;
          case DioExceptionType.unknown:
            if (error.error
                .toString()
                .contains(AppExceptionType.socketException.name)) {
              serverException = AppException._(
                  statusCode: error.response?.statusCode,
                  name: error.response?.statusMessage,
                  message: 'Verify your internet connection');
            } else {
              serverException = AppException._(
                  exceptionType: AppExceptionType.unexpectedError,
                  statusCode: error.response?.statusCode,
                  name: error.response?.statusMessage,
                  message: error.response?.data is Map
                      ? error.response?.data["message"] ??
                          error.response?.data.toString()
                      : "${error.error ?? error.response?.data ?? "Unexpected Error"}");
            }
            break;

          case DioExceptionType.badResponse:
            switch (error.response?.statusCode) {
              case 400:
                serverException = AppException._(
                    exceptionType: AppExceptionType.badRequest,
                    name: error.response?.statusMessage,
                    message: error.response?.data is Map
                        ? error.response?.data["message"] ??
                            error.response?.data.toString()
                        : "${error.error ?? error.response?.data ?? "Bad Request"}");
                break;
              case 401:
                serverException = AppException._(
                    exceptionType: AppExceptionType.unauthorisedRequest,
                    name: error.response?.statusMessage,
                    message: error.response?.data is Map
                        ? error.response?.data["message"] ??
                            error.response?.data.toString()
                        : "${error.error ?? error.response?.data ?? "Unauthorised Request"}");
                break;
              case 404:
                serverException = AppException._(
                    exceptionType: AppExceptionType.notFound,
                    name: error.response?.statusMessage,
                    message: error.response?.data is Map
                        ? error.response?.data["message"] ??
                            error.response?.data.toString()
                        : "${error.error ?? error.response?.data ?? "Not Found"}");
                break;
              case 500:
                serverException = AppException._(
                    exceptionType: AppExceptionType.internalServerError,
                    name: error.response?.statusMessage,
                    message: 'Internal server error');
                break;
              case 503:
                serverException = AppException._(
                    exceptionType: AppExceptionType.serviceUnavailable,
                    name: error.response?.statusMessage,
                    message: 'Service unavailable');
                break;
              default:
                serverException = AppException._(
                    exceptionType: AppExceptionType.unexpectedError,
                    name: error.response?.statusMessage,
                    message: error.response?.data is Map
                        ? error.response?.data["message"] ??
                            error.response?.data.toString()
                        : "${error.error ?? error.response?.data ?? "Unexpected Error"}");
            }
            break;
        }
      } else if (error is FormatException) {
        serverException = AppException._(
            exceptionType: AppExceptionType.formatException,
            message: error.message);
      } else {
        serverException = AppException._(
            exceptionType: AppExceptionType.unexpectedError,
            message: "$error");
      }
    } on FormatException catch (e) {
      serverException = AppException._(
          exceptionType: AppExceptionType.formatException, message: e.message);
    } on Exception catch (e) {
      serverException = AppException._(
          exceptionType: AppExceptionType.unexpectedError,
          message: "$e");
    }
    return serverException;
  }
}
