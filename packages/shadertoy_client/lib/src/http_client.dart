import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:pool/pool.dart';
import 'package:retry/retry.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/src/http_options.dart';

/// The base Shadertoy http client class
///
/// To be used as the base class for all the Http client variations implemented in this
/// library. It provides a number of base methods with common functionality across implementations
/// and enforces a number of configuration options
abstract class ShadertoyHttpClient<T extends ShadertoyHttpOptions>
    extends ShadertoyBaseClient {
  /// Maps the error codes returned by the Shadertoy API to [ErrorCode] values.
  static const Map<String, ErrorCode> messageToErrorCode = {
    'Invalid key': ErrorCode.authorization,
    'Shader not found': ErrorCode.notFound
  };

  /// Internal [Dio] http client instance
  late final Dio _client;

  /// A object inheriting from [ShadertoyHttpOptions]
  final T options;

  /// Object implementing a cookie storage strategy
  late final DefaultCookieJar _cookieJar;

  /// Builds a [ShadertoyHttpClient]
  ///
  /// * [options]: The client options
  /// * [client]: An optional [Dio] instance
  ShadertoyHttpClient(this.options, {Dio? client}) : super(options.baseUrl) {
    _client = client ?? Dio(BaseOptions(baseUrl: options.baseUrl));
    if (options.supportsCookies) {
      _cookieJar = DefaultCookieJar();
      _client.interceptors.add(CookieManager(_cookieJar));
    }
  }

  /// Provides the [Dio] client instance build as part of this Shadertoy client instance
  Dio get client => _client;

  /// Provides the list of [Cookie] received
  Future<List<Cookie>> get cookies =>
      _cookieJar.loadForRequest(Uri.parse(context.baseUrl));

  /// Clears the cookies
  void clearCookies() {
    _cookieJar.deleteAll();
  }

  /// Reads the response and returns the appropiate object.
  ///
  /// * [response]: The [Dio] response
  /// * [handler]: Delegate reponsivel for the transformation on the reponse on the appropriate object
  /// * [context]: Optional response context allowing the construction of a richer [ResponseError] with the context of the call
  /// * [target]: Optional response target allowing the construction of a richer [ResponseError] with the target of the call
  ///
  /// [context] and [target] is mostly for debugging and contextual error tracking
  R jsonResponse<R extends APIResponse>(
      Response<dynamic> response, R Function(dynamic data) handler,
      {String? context, String? target}) {
    dynamic responseData = response.data;

    if (responseData is String) {
      try {
        responseData = jsonDecode(responseData);
      } on FormatException {
        throw DioError(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Unexpected response: ${response.data}');
      }
    }

    if (responseData is List) {
      var data = handler(responseData);

      return data;
    } else if (responseData is Map) {
      var data = handler(responseData);

      final error = data.error;
      if (error != null) {
        error.code =
            messageToErrorCode[data.error?.message] ?? ErrorCode.unknown;
        error.context = context;
        error.target = target;
      }

      return data;
    }

    throw DioError(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Unexpected response: ${response.data}');
  }

  /// Helper function to test if an object is a [DioError]
  bool isDioError(Object error) => error is DioError;

  /// Converts a [DioError] to a [ResponseError]
  ///
  /// * [de]: The [DioError]
  /// * [context]: The optional context of the error
  /// * [target]: The optional target of the error
  ///
  /// Used to create a consistent response when there is a internal error in the [Dio] client
  ResponseError toResponseError(DioError de,
      {String? context, String? target}) {
    if (de.type == DioErrorType.connectTimeout ||
        de.type == DioErrorType.sendTimeout ||
        de.type == DioErrorType.receiveTimeout) {
      return ResponseError.backendTimeout(
          message: de.message, context: context, target: target);
    } else if (de.type == DioErrorType.response) {
      var statusCode = de.response?.statusCode;

      if (statusCode == 404 || de.error == 'Http status error [404]') {
        return ResponseError.notFound(
            message: de.message, context: context, target: target);
      } else {
        return ResponseError.backendStatus(
            message: de.message, context: context, target: target);
      }
    } else if (de.type == DioErrorType.cancel) {
      return ResponseError.aborted(
          message: de.message, context: context, target: target);
    }

    return ResponseError.unknown(
        message: de.message, context: context, target: target);
  }

  /// Makes a call using a [Pool]
  ///
  /// * [pool]: The [Pool]
  /// * [fn]: The delegate to run in the [Pool]
  ///
  /// Returns a [Future] for the completion of the delegate
  Future<R> pooled<R>(Pool pool, FutureOr<R> Function() fn) {
    return pool.withResource(fn);
  }

  /// Makes a call using a [Pool] whith retry semantics in case of error
  ///
  /// * [pool]: The [Pool]
  /// * [fn]: The delegate to run in the [Pool]
  /// * [retryOptions]: The [RetryOptions] for this call
  ///
  /// Returns a [Future] for the completion of the delegate
  Future<R> pooledRetry<R>(Pool pool, FutureOr<R> Function() fn,
      {RetryOptions? retryOptions}) {
    return pooled(
        pool,
        () => (retryOptions ??
                RetryOptions(maxAttempts: options.retryMaxAttempts))
            .retry(fn, retryIf: (e) => isDioError(e)));
  }

  /// Catches and handles a [DioError] error in a future
  ///
  /// * [future]: The future
  /// * [handle]: The error handling function
  Future<R> catchDioError<R extends APIResponse>(
      Future<R> future, R Function(DioError) handle) {
    return catchError<R, DioError>(future, handle, options.errorHandling);
  }
}
