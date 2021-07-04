import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/src/ws/ws_options.dart';

import '../mock_adapter.dart';

extension WSMockAdaptater on MockAdapter {
  MockAdapter addEmptyResponseRoute(String path, ShadertoyWSOptions options,
      [Map<String, List<String>>? queryParameters]) {
    return emptyRoute(path, queryParameters: {
      'key': [options.apiKey],
      ...?queryParameters
    });
  }

  MockAdapter addTextResponseRoute(
      String path, String object, ShadertoyWSOptions options,
      [Map<String, List<String>>? queryParameters]) {
    return textRoute(path, object, queryParameters: {
      'key': [options.apiKey],
      ...?queryParameters
    });
  }

  MockAdapter addFindShaderRoute(
      FindShaderResponse fs, ShadertoyWSOptions options) {
    final id = fs.shader?.info.id;
    return jsonRoute('shaders/$id', fs, queryParameters: {
      'key': [options.apiKey]
    });
  }

  MockAdapter addFindShaderSocketErrorRoute(
      FindShaderResponse fs, ShadertoyWSOptions options, String message) {
    final id = fs.shader?.info.id;
    return errorRoute('shaders/$id',
        queryParameters: {
          'key': [options.apiKey]
        },
        type: DioErrorType.other,
        error: SocketException(message));
  }

  MockAdapter addFindShadersRoute(
      List<FindShaderResponse> fsl, ShadertoyWSOptions options) {
    for (var fixture in fsl) {
      addFindShaderRoute(fixture, options);
    }

    return this;
  }

  MockAdapter addFindShadersSocketErrorRoute(List<FindShaderResponse> fsl,
      ShadertoyWSOptions options, String message) {
    for (var fixture in fsl) {
      addFindShaderSocketErrorRoute(fixture, options, message);
    }

    return this;
  }

  String _getShaderQueryPath({String? term}) {
    var sb = StringBuffer('shaders/query');

    if (term != null && term.isNotEmpty) {
      sb.write('/$term');
    }

    return sb.toString();
  }

  Map<String, List<String>> _getShaderQueryParameters(
      ShadertoyWSOptions options,
      {Set<String>? filters,
      Sort? sort,
      int? from,
      int? num}) {
    var queryParameters = {
      'key': [options.apiKey]
    };

    if (filters != null) {
      queryParameters['filter'] = filters.toList();
    }

    if (sort != null) {
      queryParameters['sort'] = [EnumToString.convertToString(sort)];
    }

    if (from != null) {
      queryParameters['from'] = [from.toString()];
    }

    if (num != null) {
      queryParameters['num'] = [num.toString()];
    }

    return queryParameters;
  }

  MockAdapter addFindAllShaderIdsRoute(
      FindShaderIdsResponse fsi, ShadertoyWSOptions options) {
    return jsonRoute('shaders', fsi,
        queryParameters: _getShaderQueryParameters(options));
  }

  MockAdapter addFindShaderIdsRoute(
      FindShaderIdsResponse fsi, ShadertoyWSOptions options,
      {String? term, Set<String>? filters, Sort? sort, int? from, int? num}) {
    return jsonRoute(_getShaderQueryPath(term: term), fsi,
        queryParameters: _getShaderQueryParameters(options,
            filters: filters,
            sort: sort,
            from: from,
            num: num ?? options.shaderCount));
  }

  MockAdapter addFindShaderIdsSocketErrorRoute(
      ShadertoyWSOptions options, String message,
      {String? term, Set<String>? filters, Sort? sort, int? from, int? num}) {
    return errorRoute(_getShaderQueryPath(term: term),
        queryParameters: _getShaderQueryParameters(options,
            filters: filters,
            sort: sort,
            from: from,
            num: num ?? options.shaderCount),
        type: DioErrorType.other,
        error: SocketException(message));
  }
}
