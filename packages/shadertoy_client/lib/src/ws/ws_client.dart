import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pool/pool.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/src/http_client.dart';
import 'package:shadertoy_client/src/ws/ws_options.dart';

/// The base Shadertoy Client API for WS access
abstract class ShadertoyWS extends ShadertoyClient {}

/// A Shadertoy REST API client
///
/// Provides an implementation of the [ShadertoyWS] thus allowing the creation
/// of a client to access all the methods provided by the shadertoy REST API
/// as described in the Shadertoy [howto](https://www.shadertoy.com/howto)
class ShadertoyWSClient extends ShadertoyHttpClient<ShadertoyWSOptions>
    implements ShadertoyWS {
  /// Creates a [ShadertoyWSClient]
  ///
  /// * [options]: The [ShadertoyWSOptions] used to configure this client
  /// * [client]: A pre-initialized [Dio] client
  ShadertoyWSClient(ShadertoyWSOptions options, {Dio? client})
      : super(options, client: client);

  /// Finds a [Shader] by Id
  ///
  /// [shaderId]: The id of the shader
  ///
  /// Returns a [FindShaderResponse] with the [Shader] or a [ResponseError]
  Future<FindShaderResponse> _getShaderById(String shaderId) {
    return client.get('${options.apiPath}/shaders/$shaderId', queryParameters: {
      'key': options.apiKey
    }).then((Response<dynamic> response) => jsonResponse<FindShaderResponse>(
        response, (data) => FindShaderResponse.fromJson(data),
        context: contextShader, target: shaderId));
  }

  @override
  Future<FindShaderResponse> findShaderById(String shaderId) {
    return catchDioError<FindShaderResponse>(
        _getShaderById(shaderId),
        (de) => FindShaderResponse(
            error:
                toResponseError(de, context: contextShader, target: shaderId)));
  }

  /// Finds shaders by ids
  ///
  /// * [shaderIds]: The list of shaders
  ///
  /// Returns a [FindShadersResponse] with the list of [Shader] obtained or a [ResponseError]
  Future<FindShadersResponse> _getShadersByIdSet(Set<String> shaderIds) {
    var shaderTaskPool = Pool(options.poolMaxAllocatedResources,
        timeout: Duration(seconds: options.poolTimeout));

    return Future.wait(shaderIds
            .map((id) => pooledRetry(shaderTaskPool, () => findShaderById(id))))
        .then((l) => FindShadersResponse(shaders: l));
  }

  @override
  Future<FindShadersResponse> findShadersByIdSet(Set<String> shaderIds) {
    return _getShadersByIdSet(shaderIds);
  }

  /// Finds shader ids
  ///
  /// * [term]: Shaders that have [term] in the name or in description
  /// * [filters]: A set of tag filters
  /// * [sort]: The sort order of the shaders
  /// * [from]: A 0 based index for results returned
  /// * [num]: The total number of results
  ///
  /// Returns a [FindShaderIdsResponse] with a list of ids or a [ResponseError]
  Future<FindShaderIdsResponse> _getShaderIds(
      {String? term, Set<String>? filters, Sort? sort, int? from, int? num}) {
    var sb = StringBuffer('${options.apiPath}/shaders/query');

    if (term != null && term.isNotEmpty) {
      sb.write('/$term');
    }

    sb.write('?key=${options.apiKey}');

    if (filters != null) {
      for (var filter in filters) {
        sb.write('&filter=$filter');
      }
    }

    if (sort != null) {
      sb.write('&sort=${sort.name}');
    }

    if (from != null) {
      sb.write('&from=$from');
    }

    if (num != null) {
      sb.write('&num=$num');
    }

    return client.get(sb.toString()).then((Response<dynamic> response) =>
        jsonResponse<FindShaderIdsResponse>(
            response, (data) => FindShaderIdsResponse.fromJson(data)));
  }

  @override
  Future<FindShadersResponse> findShaders(
      {String? term, Set<String>? filters, Sort? sort, int? from, int? num}) {
    return catchDioError<FindShadersResponse>(
        _getShaderIds(
                term: term,
                filters: filters,
                sort: sort,
                from: from,
                num: num ?? options.shaderCount)
            .then((r) => _getShadersByIdSet((r.ids ?? []).toSet())),
        (de) => FindShadersResponse(
            error: toResponseError(de, context: contextShader)));
  }

  @override
  Future<FindShaderIdsResponse> findAllShaderIds() {
    return catchDioError<FindShaderIdsResponse>(
        client.get('${options.apiPath}/shaders', queryParameters: {
          'key': options.apiKey
        }).then((Response<dynamic> response) =>
            jsonResponse<FindShaderIdsResponse>(
                response, (data) => FindShaderIdsResponse.fromJson(data))),
        (de) => FindShaderIdsResponse(
            error: toResponseError(de, context: contextShader)));
  }

  @override
  Future<FindShaderIdsResponse> findShaderIds(
      {String? term, Set<String>? filters, Sort? sort, int? from, int? num}) {
    return catchDioError<FindShaderIdsResponse>(
        _getShaderIds(
            term: term,
            filters: filters,
            sort: sort,
            from: from,
            num: num ?? options.shaderCount),
        (de) => FindShaderIdsResponse(
            error: toResponseError(de, context: contextShader)));
  }
}
