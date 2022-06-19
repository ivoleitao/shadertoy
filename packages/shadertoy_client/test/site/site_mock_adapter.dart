import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/src/site/site_options.dart';

import '../mock_adapter.dart';

extension SiteMockAdaptater on MockAdapter {
  MockAdapter addLoginRoute(ShadertoySiteOptions options, int statusCode,
      Map<String, List<String>> responseHeaders) {
    var formData =
        FormData.fromMap({'user': options.user, 'password': options.password});
    return textRoute('/signin', '',
        requestHeaders: {
          HttpHeaders.refererHeader: '${options.baseUrl}/signin'
        },
        formData: formData,
        statusCode: statusCode,
        responseHeaders: responseHeaders);
  }

  MockAdapter addLoginSocketErrorRoute(
      ShadertoySiteOptions options, String message) {
    var formData =
        FormData.fromMap({'user': options.user, 'password': options.password});

    return errorRoute('/signin',
        headers: {HttpHeaders.refererHeader: '${options.baseUrl}/signin'},
        formData: formData,
        type: DioErrorType.other,
        error: SocketException(message));
  }

  MockAdapter addLogoutRoute(ShadertoySiteOptions options, int statusCode,
      Map<String, List<String>> responseHeaders) {
    return textRoute('/signout', '',
        requestHeaders: {HttpHeaders.refererHeader: options.baseUrl},
        statusCode: statusCode,
        responseHeaders: responseHeaders);
  }

  MockAdapter addLogoutSocketErrorRoute(
      ShadertoySiteOptions options, String message) {
    return errorRoute('/signout',
        headers: {HttpHeaders.refererHeader: options.baseUrl},
        type: DioErrorType.other,
        error: SocketException(message));
  }

  MockAdapter addShaderRoute(Shader shader, ShadertoySiteOptions options) {
    final data = FindShadersRequest({shader.info.id});

    final formData =
        FormData.fromMap({'s': jsonEncode(data), 'nt': 1, 'nl': 1});
    return jsonRoute('/shadertoy', [shader],
        requestHeaders: {
          HttpHeaders.refererHeader: '${options.baseUrl}/browse'
        },
        formData: formData);
  }

  MockAdapter addShaderRouteList(
      List<Shader> shaders, ShadertoySiteOptions options) {
    for (var shader in shaders) {
      addShaderRoute(shader, options);
    }

    return this;
  }

  MockAdapter addShadersRoute(
      List<Shader> requestShaders, ShadertoySiteOptions options,
      {List<Shader>? responseShaders}) {
    final data =
        FindShadersRequest(requestShaders.map((s) => s.info.id).toSet());

    final formData =
        FormData.fromMap({'s': jsonEncode(data), 'nt': 1, 'nl': 1});
    final response = responseShaders ?? requestShaders;
    return jsonRoute('/shadertoy', response,
        requestHeaders: {
          HttpHeaders.refererHeader: '${options.baseUrl}/browse'
        },
        formData: formData);
  }

  MockAdapter addShadersSocketErrorRoute(
      FindShadersRequest fs, ShadertoySiteOptions options, String message) {
    final requestBody =
        FormData.fromMap({'s': jsonEncode(fs), 'nt': 1, 'nl': 1});
    return errorRoute('/shadertoy',
        headers: {HttpHeaders.refererHeader: '${options.baseUrl}/browse'},
        formData: requestBody,
        type: DioErrorType.other,
        error: SocketException(message));
  }

  MockAdapter addResponseErrorRoute(
      String requestPath, String error, ShadertoySiteOptions options) {
    return errorRoute('/$requestPath',
        type: DioErrorType.response, error: error);
  }

  Map<String, List<String>> _getResultsQueryParameters(
      ShadertoySiteOptions options,
      {String? query,
      Set<String>? filters,
      Sort? sort,
      int? from,
      int? num}) {
    var queryParameters = <String, List<String>>{};

    if (query != null) {
      queryParameters['query'] = [query];
    }

    if (filters != null) {
      queryParameters['filter'] = filters.toList();
    }

    if (sort != null) {
      queryParameters['sort'] = [sort.name];
    }

    if (from != null) {
      queryParameters['from'] = [from.toString()];
    }

    if (num != null) {
      queryParameters['num'] = [num.toString()];
    }

    return queryParameters;
  }

  MockAdapter addResultsRoute(String response, ShadertoySiteOptions options,
      {String? query, Set<String>? filters, Sort? sort, int? from, int? num}) {
    return htmlRoute('/results', response,
        queryParameters: _getResultsQueryParameters(options,
            query: query,
            filters: filters,
            sort: sort,
            from: from ?? 0,
            num: num ?? options.shaderCount));
  }

  MockAdapter addResultsSocketErrorRoute(
      ShadertoySiteOptions options, String message,
      {String? query, Set<String>? filters, Sort? sort, int? from, int? num}) {
    return errorRoute('/results',
        queryParameters: _getResultsQueryParameters(options,
            query: query,
            filters: filters,
            sort: sort,
            from: from ?? 0,
            num: num ?? options.shaderCount),
        type: DioErrorType.other,
        error: SocketException(message));
  }

  MockAdapter addUserRoute(
      String response, String userId, ShadertoySiteOptions options) {
    return htmlRoute('/user/$userId', response);
  }

  MockAdapter addUserRouteMap(
      Map<String, String> userResponseMap, ShadertoySiteOptions options) {
    for (var entry in userResponseMap.entries) {
      addUserRoute(entry.value, entry.key, options);
    }

    return this;
  }

  MockAdapter addUserSocketErrorRoute(
      String userId, ShadertoySiteOptions options, String message) {
    return errorRoute('/user/$userId',
        type: DioErrorType.other, error: SocketException(message));
  }

  Map<String, List<String>> _getUserQueryParameters(
      ShadertoySiteOptions options,
      {Set<String>? filters,
      Sort? sort,
      int? from,
      int? num}) {
    var queryParameters = <String, List<String>>{};

    if (filters != null) {
      queryParameters['filter'] = filters.toList();
    }

    if (sort != null) {
      queryParameters['sort'] = [sort.name];
    }

    if (from != null) {
      queryParameters['from'] = [from.toString()];
    }

    if (num != null) {
      queryParameters['num'] = [num.toString()];
    }

    return queryParameters;
  }

  String _getUserShadersUrl(
      String userId, Map<String, List<String>> queryParameters) {
    // This strange behaviour is needed because the filtering on the shadertoy
    // website works wrongly i.e. https://www.shadertoy.com/user/iq&sort=popular&filter=multipass&filter=musicstream
    // and not https://www.shadertoy.com/user/iq?sort=popular&filter=multipass&filter=musicstream as expected
    // (note the & in the former instead of ? in the latter)
    var url = StringBuffer('/user/$userId');
    for (final queryParameter in queryParameters.entries) {
      for (final queryParameterValue in queryParameter.value) {
        url.write('&${queryParameter.key}=$queryParameterValue');
      }
    }

    return url.toString();
  }

  MockAdapter addUserShadersSocketErrorRoute(
      String userId, ShadertoySiteOptions options, String message,
      {Set<String>? filters, Sort? sort, int? from, int? num}) {
    final queryParameters = _getUserQueryParameters(options,
        filters: filters,
        sort: sort,
        from: from ?? 0,
        num: num ?? options.pageUserShaderCount);

    return errorRoute(_getUserShadersUrl(userId, queryParameters),
        type: DioErrorType.other, error: SocketException(message));
  }

  MockAdapter addUserShadersRoute(
      String response, String userId, ShadertoySiteOptions options,
      {Set<String>? filters, Sort? sort, int? from, int? num}) {
    final queryParameters = _getUserQueryParameters(options,
        filters: filters,
        sort: sort,
        from: from ?? 0,
        num: num ?? options.pageUserShaderCount);

    return htmlRoute(_getUserShadersUrl(userId, queryParameters), response);
  }

  MockAdapter addPlaylistRoute(
      String response, String playlistId, ShadertoySiteOptions options) {
    return htmlRoute('/playlist/$playlistId', response);
  }

  MockAdapter addPlaylistSocketErrorRoute(
      String playlistId, ShadertoySiteOptions options, String message) {
    return errorRoute('/playlist/$playlistId',
        type: DioErrorType.other, error: SocketException(message));
  }

  Map<String, List<String>> _getPlaylistQueryParameters(
      ShadertoySiteOptions options,
      {int? from,
      int? num}) {
    var queryParameters = <String, List<String>>{};

    if (from != null) {
      queryParameters['from'] = [from.toString()];
    }

    if (num != null) {
      queryParameters['num'] = [num.toString()];
    }

    return queryParameters;
  }

  MockAdapter addPlaylistShadersSocketErrorRoute(
      String playlistId, ShadertoySiteOptions options, String message,
      {int? from, int? num}) {
    final queryParameters = _getPlaylistQueryParameters(options,
        from: from ?? 0, num: num ?? options.pagePlaylistShaderCount);

    return errorRoute('/playlist/$playlistId',
        queryParameters: queryParameters,
        type: DioErrorType.other,
        error: SocketException(message));
  }

  MockAdapter addPlaylistShadersRoute(
      String response, String playlistId, ShadertoySiteOptions options,
      {int? from, int? num}) {
    return htmlRoute('/playlist/$playlistId', response,
        queryParameters: _getPlaylistQueryParameters(options,
            from: from ?? 0, num: num ?? options.pagePlaylistShaderCount));
  }

  MockAdapter addCommentRoute(CommentsResponse response, String shaderId,
      ShadertoySiteOptions options) {
    var formData = FormData.fromMap({'s': shaderId});
    return jsonRoute('/comment', response,
        requestHeaders: {
          HttpHeaders.refererHeader: '${options.baseUrl}/view/$shaderId'
        },
        formData: formData);
  }

  MockAdapter addCommentsRouteMap(
      Map<String, CommentsResponse> commentResponseMap,
      ShadertoySiteOptions options) {
    for (var entry in commentResponseMap.entries) {
      addCommentRoute(entry.value, entry.key, options);
    }
    return this;
  }

  MockAdapter addCommentSocketErrorRoute(
      String shaderId, ShadertoySiteOptions options, String message) {
    var formData = FormData.fromMap({'s': shaderId});
    return errorRoute('/comment',
        headers: {
          HttpHeaders.refererHeader: '${options.baseUrl}/view/$shaderId'
        },
        formData: formData,
        type: DioErrorType.other,
        error: SocketException(message));
  }

  MockAdapter addDownloadFile(
      String path, Uint8List bytes, ShadertoySiteOptions options) {
    return binaryRoute('/$path', bytes);
  }

  MockAdapter addDownloadMedia(
      String path, Uint8List bytes, ShadertoySiteOptions options) {
    return addDownloadFile(path, bytes, options);
  }

  MockAdapter addDownloadShaderPicture(
      String shaderId, Uint8List bytes, ShadertoySiteOptions options) {
    return addDownloadFile(
        ShadertoyContext.shaderPicturePath(shaderId), bytes, options);
  }

  MockAdapter addDownloadMediaMap(
      Map<String, Uint8List> mediaMap, ShadertoySiteOptions options) {
    for (var entry in mediaMap.entries) {
      addDownloadMedia(entry.key, entry.value, options);
    }

    return this;
  }
}
