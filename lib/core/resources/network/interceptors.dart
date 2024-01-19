import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'network_imports.dart';

/// This interceptor is used to show request and response logs
class LoggerInterceptor extends Interceptor {

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    debugPrint('${options.method} request ==> ${options.uri}'); //Error log
    debugPrint('Error type: ${err.error} \n '
        'Error message: ${err.message}'); //Debug log
    handler.next(err); //Continue with the Error
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('${options.method} request ==> ${options.uri}'); //Info log
    handler.next(options); // continue with the Request
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('STATUS_CODE: ${response.statusCode} \n '
        'STATUS_MESSAGE: ${response.statusMessage} \n'
        'HEADERS: ${response.headers} \n'
        'Data: ${response.data}'); // Debug log
    handler.next(response); // continue with the Response
  }
}

/// This interceptor intercepts GET request and add "Authorization" header
/// and then, send it to the [API]
class AuthorizationInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_needAuthorizationHeader(options)) {
      // adds the access-token with the header
      options.headers['Authorization'] = Endpoints.apiToken;
    }
    handler.next(options); // continue with the request
  }

  bool _needAuthorizationHeader(RequestOptions options) {
    if (options.method == 'GET') {
      return true;
    }
    return false;
  }
}
