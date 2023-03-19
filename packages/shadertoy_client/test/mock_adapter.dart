import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:equatable/equatable.dart';

class _FormField extends Equatable {
  final String key;
  final String value;

  const _FormField(this.key, this.value);

  @override
  List<Object> get props => [key, value];
}

class _Route extends Equatable {
  final String path;
  final Map<String, List<String>> queryParameters;
  final Map<String, dynamic> headers;
  final List<_FormField> formFields;

  _Route(this.path,
      {Map<String, List<String>>? queryParameters =
          const <String, List<String>>{},
      Map<String, dynamic>? headers = const <String, dynamic>{},
      List<_FormField>? formFields})
      : queryParameters = queryParameters ?? const <String, List<String>>{},
        headers = headers ?? const <String, dynamic>{},
        formFields = formFields ?? const <_FormField>[];

  @override
  List<Object> get props => [path, queryParameters, headers, formFields];
}

class MockAdapter implements HttpClientAdapter {
  static const String mockHost = 'mockserver';
  static const String mockBase = 'http://$mockHost';
  static const List<String> _checkedHeaders = [HttpHeaders.refererHeader];

  final String? basePath;
  final Map<_Route, Function> _routes = {};

  MockAdapter({this.basePath});

  final _adapter = IOHttpClientAdapter();

  _Route _newRoute(String path,
      {String? basePath,
      Map<String, List<String>>? queryParameters,
      Map<String, dynamic>? headers,
      List<MapEntry<String, String>>? formFields}) {
    final filteredHeaders = <String, dynamic>{};
    if (headers != null) {
      for (final header in headers.keys) {
        if (_checkedHeaders.contains(header)) {
          filteredHeaders[header] = headers[header];
        }
      }
    }

    return _Route(basePath != null ? '$basePath/$path' : path,
        queryParameters: queryParameters,
        headers: filteredHeaders,
        formFields: formFields
            ?.map((field) => _FormField(field.key, field.value))
            .toList());
  }

  _Route _newRequestRoute(RequestOptions options) {
    final uri = options.uri;
    final path = uri.path;
    final queryParameters = uri.queryParametersAll;
    final headers = options.headers;
    final data = options.data;

    return _newRoute(path,
        queryParameters: queryParameters,
        headers: headers,
        formFields: data is FormData ? data.fields : null);
  }

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future? cancelFuture) async {
    var uri = options.uri;
    var route = _newRequestRoute(options);
    if (uri.host == mockHost && _routes.containsKey(route)) {
      final routeCall = _routes[route];
      if (routeCall != null) {
        return routeCall();
      }
    }
    return _adapter.fetch(options, requestStream, cancelFuture);
  }

  Function _errorResponse(
      {required RequestOptions requestOptions,
      Response<dynamic>? response,
      DioErrorType? type,
      dynamic error}) {
    return () {
      throw DioError(
          requestOptions: requestOptions,
          response: response,
          type: type ?? DioErrorType.unknown,
          error: error);
    };
  }

  Function _emptyResponse(int statusCode, Map<String, List<String>>? headers) {
    return () => ResponseBody(Stream<Uint8List>.empty(), statusCode,
        headers: headers ?? const {});
  }

  Function _binaryResponse(
      Uint8List bytes, int statusCode, Map<String, List<String>>? headers) {
    return () => ResponseBody.fromBytes(
          bytes,
          statusCode,
          headers: headers ?? const {},
        );
  }

  Function _textResponse(
      String text, int statusCode, Map<String, List<String>>? headers) {
    return () => ResponseBody.fromString(
          text,
          statusCode,
          headers: headers ?? const {},
        );
  }

  Function _jsonResponse(
      Object object, int statusCode, Map<String, List<String>>? headers) {
    return () => ResponseBody.fromString(
          jsonEncode(object),
          statusCode,
          headers: {
            HttpHeaders.contentTypeHeader: [ContentType.json.toString()],
            ...?headers
          },
        );
  }

  Function _htmlResponse(
      String html, int statusCode, Map<String, List<String>>? headers) {
    return () => ResponseBody.fromString(
          html,
          statusCode,
          headers: {
            HttpHeaders.contentTypeHeader: [ContentType.html.toString()],
            ...?headers
          },
        );
  }

  MockAdapter responseRoute(String path, Function response,
      {Map<String, List<String>>? queryParameters,
      Map<String, dynamic>? headers,
      FormData? formData}) {
    final route = _newRoute(path,
        basePath: basePath,
        queryParameters: queryParameters,
        headers: headers,
        formFields: formData?.fields);
    _routes[route] = response;

    return this;
  }

  MockAdapter errorRoute(String path,
      {Map<String, List<String>>? queryParameters,
      Map<String, dynamic>? headers,
      FormData? formData,
      Response<dynamic>? response,
      DioErrorType? type,
      dynamic error}) {
    return responseRoute(
        path,
        _errorResponse(
            requestOptions: RequestOptions(path: path),
            response: response,
            type: type,
            error: error),
        queryParameters: queryParameters,
        headers: headers,
        formData: formData);
  }

  MockAdapter emptyRoute(String path,
      {Map<String, List<String>>? queryParameters,
      Map<String, dynamic>? headers,
      FormData? formData,
      int statusCode = HttpStatus.ok,
      Map<String, List<String>>? responseHeaders}) {
    return responseRoute(path, _emptyResponse(statusCode, responseHeaders),
        queryParameters: queryParameters, headers: headers, formData: formData);
  }

  MockAdapter binaryRoute(String path, Uint8List bytes,
      {Map<String, List<String>>? queryParameters,
      Map<String, dynamic>? headers,
      FormData? formData,
      int statusCode = HttpStatus.ok,
      Map<String, List<String>>? responseHeaders}) {
    return responseRoute(
        path, _binaryResponse(bytes, statusCode, responseHeaders),
        queryParameters: queryParameters, headers: headers, formData: formData);
  }

  MockAdapter textRoute(String path, String text,
      {Map<String, List<String>>? queryParameters,
      Map<String, dynamic>? requestHeaders,
      FormData? formData,
      int statusCode = HttpStatus.ok,
      Map<String, List<String>>? responseHeaders}) {
    return responseRoute(path, _textResponse(text, statusCode, responseHeaders),
        queryParameters: queryParameters,
        headers: requestHeaders,
        formData: formData);
  }

  MockAdapter htmlRoute(String path, String response,
      {Map<String, List<String>>? queryParameters,
      Map<String, dynamic>? requestHeaders,
      FormData? formData,
      int statusCode = HttpStatus.ok,
      Map<String, List<String>>? responseHeaders}) {
    return responseRoute(
        path, _htmlResponse(response, statusCode, responseHeaders),
        queryParameters: queryParameters,
        headers: requestHeaders,
        formData: formData);
  }

  MockAdapter jsonRoute(String path, Object response,
      {Map<String, List<String>>? queryParameters,
      Map<String, dynamic>? requestHeaders,
      FormData? formData,
      int statusCode = HttpStatus.ok,
      Map<String, List<String>>? responseHeaders}) {
    return responseRoute(
        path, _jsonResponse(response, statusCode, responseHeaders),
        queryParameters: queryParameters,
        headers: requestHeaders,
        formData: formData);
  }

  @override
  void close({bool force = false}) {
    _adapter.close(force: force);
  }
}
