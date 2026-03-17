import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../error/exception_handler.dart';
import '../error/exceptions.dart';
import 'pretty_dio_logger.dart';

class NetworkClient {
  Dio _dio = Dio();
  late CookieJar _cookieJar;
  bool _isInitialized = false;

  NetworkClient(String baseUrl) {
    BaseOptions baseOptions = BaseOptions(
      receiveTimeout: const Duration(seconds: 100),
      connectTimeout: const Duration(seconds: 100),
      baseUrl: baseUrl,
      maxRedirects: 2,
      //maxRedirects: 0,
      // followRedirects: false,
    );
    _dio = Dio(baseOptions);

    // Initialize cookie jar asynchronously with persistent storage
    _initializeCookieJar();
  }

  Future<void> _initializeCookieJar() async {
    if (_isInitialized) return;

    try {
      // Use PersistCookieJar for persistent cookie storage across app restarts
      final appDocDir = await getApplicationDocumentsDirectory();
      final cookiePath = '${appDocDir.path}/.cookies/';
      _cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));
    } catch (e) {
      // Fallback to in-memory cookie jar if persistent storage fails
      _cookieJar = CookieJar();
    }

    // Add cookie manager interceptor
    _dio.interceptors.add(CookieManager(_cookieJar));

    // Add error handling interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          final appException = ExceptionHandler.handleDioException(error);

          if (appException is AuthenticationException &&
              appException.statusCode == 401) {
            await _handleUnauthorizedError();
          }

          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: appException,
              message: appException.message,
            ),
          );
        },
      ),
    );

    // Adding logging interceptor (should be last for better logging)
    _dio.interceptors.add(
      PrettyDioLogger(request: true, requestBody: true, responseBody: true),
    );
    // _dio.interceptors.add(LogInterceptor(
    //   requestBody: true,
    //   error: true,
    //   request: true,
    //   requestHeader: true,
    //   responseBody: true,
    //   responseHeader: true,
    //   logPrint: (object) => log('Log: $object'),
    // ));

    _isInitialized = true;
  }

  Future<void> _handleUnauthorizedError() async {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    context.read<AuthBloc>().add(const Logout());
  }

  // Ensure cookie jar is initialized before making requests
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _initializeCookieJar();
    }
  }

  // Cookie management methods
  Future<void> setCookie(
    String name,
    String value, {
    String? domain,
    String? path,
  }) async {
    await _ensureInitialized();
    final cookie = Cookie(name, value);
    if (domain != null) cookie.domain = domain;
    if (path != null) cookie.path = path;

    await _cookieJar.saveFromResponse(Uri.parse(_dio.options.baseUrl), [
      cookie,
    ]);
  }

  Future<void> clearCookies() async {
    await _ensureInitialized();
    await _cookieJar.deleteAll();
  }

  Future<List<Cookie>> getCookies() async {
    await _ensureInitialized();
    return await _cookieJar.loadForRequest(Uri.parse(_dio.options.baseUrl));
  }

  // for HTTP.GET Request.
  Future<Response> get(
    String url,
    Map<String, dynamic> params, {
    Map<String, dynamic>? headers,
  }) async {
    await _ensureInitialized();
    Response response;
    try {
      response = await _dio.get(
        url,
        queryParameters: params,
        options: Options(
          responseType: ResponseType.json,
          headers: headers,
        ),
      );
    } on DioException catch (exception) {
      // Check if error was already converted by interceptor
      if (exception.error is AppException) {
        throw exception.error as AppException;
      }
      // Fallback: convert here if interceptor didn't catch it
      throw ExceptionHandler.handleDioException(exception);
    }
    return response;
  }

  // for HTTP.POST Request.
  Future<Response> post(
    String url,
    dynamic params, {
    Map<String, dynamic>? headers,
  }) async {
    await _ensureInitialized();
    Response response;
    try {
      response = await _dio.post(
        url,
        data: params,
        options: Options(
          responseType: ResponseType.json,
          contentType: Headers.jsonContentType,
          headers: headers,
        ),
      );
    } on DioException catch (exception) {
      // Check if error was already converted by interceptor
      if (exception.error is AppException) {
        throw exception.error as AppException;
      }
      // Fallback: convert here if interceptor didn't catch it
      throw ExceptionHandler.handleDioException(exception);
    }
    return response;
  }

  // for HTTP.PUT Request.
  Future<Response> put(
    String url,
    Map<String, dynamic> params, {
    Map<String, dynamic>? headers,
  }) async {
    await _ensureInitialized();
    Response response;
    try {
      response = await _dio.put(
        url,
        data: params,
        options: Options(
          responseType: ResponseType.json,
          headers: headers,
        ),
      );
    } on DioException catch (exception) {
      // Check if error was already converted by interceptor
      if (exception.error is AppException) {
        throw exception.error as AppException;
      }
      // Fallback: convert here if interceptor didn't catch it
      throw ExceptionHandler.handleDioException(exception);
    }
    return response;
  }

  Future<Response> patch(
    String url,
    Map<String, dynamic> params, {
    Map<String, dynamic>? headers,
  }) async {
    await _ensureInitialized();
    Response response;
    try {
      response = await _dio.patch(
        url,
        data: params,
        options: Options(
          responseType: ResponseType.json,
          headers: headers,
        ),
      );
    } on DioException catch (exception) {
      // Check if error was already converted by interceptor
      if (exception.error is AppException) {
        throw exception.error as AppException;
      }
      // Fallback: convert here if interceptor didn't catch it
      throw ExceptionHandler.handleDioException(exception);
    }
    return response;
  }

  // for HTTP.DELETE Request.
  Future<Response> delete(
    String url,
    dynamic params, {
    Map<String, dynamic>? headers,
  }) async {
    await _ensureInitialized();
    Response response;
    try {
      response = await _dio.delete(
        url,
        data: params,
        options: Options(
          responseType: ResponseType.json,
          headers: headers,
        ),
      );
    } on DioException catch (exception) {
      // Check if error was already converted by interceptor
      if (exception.error is AppException) {
        throw exception.error as AppException;
      }
      // Fallback: convert here if interceptor didn't catch it
      throw ExceptionHandler.handleDioException(exception);
    }
    return response;
  }

  // for dwonload Request.
  Future<Response> download(
    String url,
    String pathName,
    void Function(int, int)? onReceiveProgress,
  ) async {
    await _ensureInitialized();
    Response response;
    try {
      response = await _dio.download(
        url,
        pathName,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (exception) {
      // Check if error was already converted by interceptor
      if (exception.error is AppException) {
        throw exception.error as AppException;
      }
      // Fallback: convert here if interceptor didn't catch it
      throw ExceptionHandler.handleDioException(exception);
    }
    return response;
  }
}
