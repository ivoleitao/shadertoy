import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:pool/pool.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/src/http_client.dart';
import 'package:shadertoy_client/src/site/site_options.dart';
import 'package:shadertoy_client/src/site/site_parser.dart';

/// The base Shadertoy Client API for WS and site access to Shadertoy
abstract class ShadertoySite extends ShadertoyExtendedClient {
  /// Performs a login in shadertoy website
  ///
  /// Upon success error is null
  ///
  /// In case of error the error field has the corresponding
  /// [ResponseError] structure
  Future<LoginResponse> login();

  /// Performs a logout in shadertoy website
  ///
  /// Upon success error is null
  ///
  /// In case of error the error field has the corresponding
  /// [ResponseError] structure
  Future<LogoutResponse> logout();

  /// Returns true when logged in, false otherwise
  Future<bool> get loggedIn;

  /// Returns a [DownloadFileResponse] for a shader with id [shaderId]
  ///
  /// On success [DownloadFileResponse.bytes] has the corresponding
  /// byte list and a null error
  ///
  /// In case of error the error field has the corresponding
  /// [ResponseError] structure and a null [DownloadFileResponse.bytes]
  Future<DownloadFileResponse> downloadShaderPicture(String shaderId);

  /// Returns a [DownloadFileResponse] for a path [inputPath]
  ///
  /// On success [DownloadFileResponse.bytes] has the corresponding
  /// byte list and a null error
  ///
  /// In case of error the error field has the corresponding
  /// [ResponseError] structure and a null [DownloadFileResponse.bytes]
  Future<DownloadFileResponse> downloadMedia(String inputPath);
}

/// A Shadertoy site API client
///
/// Provides an implementation of the [ShadertoySite] thus allowing the creation
/// of a client to access all the methods provided by the shadertoy site API
/// Please note that most of the implementations provided rely on some stability on
/// the website design since data extraction is in some cases performed with web scrapping
class ShadertoySiteClient extends ShadertoyHttpClient<ShadertoySiteOptions>
    implements ShadertoySite {
  /// Creates a [ShadertoySiteClient]
  ///
  /// * [options]: The [ShadertoySiteOptions] used to configure this client
  /// * [client]: A pre-initialized [Dio] client
  ShadertoySiteClient(ShadertoySiteOptions options, {Dio? client})
      : super(options, client: client);

  @override
  Future<bool> get loggedIn => cookies.then(
      (c) => c.where((cookie) => options.cookieName == cookie.name).isNotEmpty);

  @override
  Future<LoginResponse> login() {
    var data =
        FormData.fromMap({'user': options.user, 'password': options.password});
    var clientOptions = Options(
        contentType:
            ContentType.parse('application/x-www-form-urlencoded').toString(),
        headers: {HttpHeaders.refererHeader: context.signInUrl},
        followRedirects: false,
        validateStatus: (int? status) => status == 302);

    if (options.supportsCookies) {
      clearCookies();
    }

    return catchDioError<LoginResponse>(
        client
            .post('/${ShadertoyContext.signInPath}',
                data: data, options: clientOptions)
            .then((Response<dynamic> response) {
          final headers = response.headers;
          final locationHeaders = headers.map[HttpHeaders.locationHeader];
          if (locationHeaders?.length == 1) {
            final location = locationHeaders?.single;
            if (location == '/') {
              return LoginResponse();
            } else if (location == '/${ShadertoyContext.signInPath}?error=1') {
              return LoginResponse(
                  error: ResponseError.authentication(
                      message: 'Login error',
                      context: contextUser,
                      target: options.user));
            }
          }

          return LoginResponse(
              error: ResponseError.unknown(
                  message: 'Invalid location header',
                  context: contextUser,
                  target: options.user));
        }), (de) {
      return LoginResponse(
          error: toResponseError(de)
              .copyWith(context: contextUser, target: options.user));
    });
  }

  @override
  Future<LogoutResponse> logout() {
    if (options.supportsCookies) {
      return loggedIn.then((isLoggedIn) {
        if (isLoggedIn) {
          var clientOptions = Options(
              headers: {HttpHeaders.refererHeader: context.baseUrl},
              followRedirects: false,
              validateStatus: (int? status) => status == 302);
          return catchDioError<LogoutResponse>(
              client
                  .get('/${ShadertoyContext.signOutPath}',
                      options: clientOptions)
                  .then((Response<dynamic> response) {
                clearCookies();
                return LogoutResponse();
              }),
              (de) => LogoutResponse(
                  error: toResponseError(de)
                      .copyWith(context: contextUser, target: options.user)));
        }

        return Future.value(LogoutResponse());
      });
    } else {
      return Future.value(LogoutResponse());
    }
  }

  /// Finds shaders by ids
  ///
  /// * [ids]: The list of shaders
  ///
  /// Returns a [FindShadersResponse] with the list of [Shader] obtained or a [ResponseError]
  /// This call posts a list of of shader ids to the shadertoy [path](https://www.shadertoy.com/shadertoy)
  /// obtaining a list of [Shader] objects as the response
  Future<FindShadersResponse> _getShadersByIdSet(Set<String> ids) {
    if (ids.isEmpty) {
      return Future.value(FindShadersResponse(shaders: []));
    }

    var data = FormData.fromMap(
        {'s': jsonEncode(FindShadersRequest(ids)), 'nt': 1, 'nl': 1});
    var options = Options(
        contentType:
            ContentType.parse('application/x-www-form-urlencoded').toString(),
        headers: {HttpHeaders.refererHeader: context.shaderBrowseUrl});

    return client.post('/shadertoy', data: data, options: options).then(
        (Response<dynamic> response) => jsonResponse<FindShadersResponse>(
            response,
            (data) => FindShadersResponse(
                shaders: List<dynamic>.from(data)
                    .map((shader) =>
                        FindShaderResponse(shader: Shader.fromJson(shader)))
                    .toList())));
  }

  /// Finds a [Shader] by Id
  ///
  /// [shaderId]: The id of the shader
  ///
  /// Returns a [FindShaderResponse] with the [Shader] or a [ResponseError]
  Future<FindShaderResponse> _getShaderById(String shaderId) {
    return _getShadersByIdSet({shaderId}).then((response) {
      final shaders = response.shaders;
      if (shaders == null || shaders.isEmpty) {
        return FindShaderResponse(
            error: ResponseError.notFound(
                message: 'Shader not found',
                context: contextShader,
                target: shaderId));
      }

      return shaders[0];
    });
  }

  @override
  Future<FindShaderResponse> findShaderById(String shaderId) {
    return catchDioError<FindShaderResponse>(
        _getShaderById(shaderId),
        (de) => FindShaderResponse(
            error:
                toResponseError(de, context: contextShader, target: shaderId)));
  }

  @override
  Future<FindShadersResponse> findShadersByIdSet(Set<String> ids) {
    return catchDioError<FindShadersResponse>(
        _getShadersByIdSet(ids),
        (de) => FindShadersResponse(
            error: toResponseError(de, context: contextShader)));
  }

  /// Gets the results query
  ///
  /// * [num]: The number of results
  /// * [term]: Shaders that have [term] in the name or in description
  /// * [filters]: A set of tag filters
  /// * [sort]: The sort order of the shaders
  /// * [from]: A 0 based index for results returned
  ///
  /// Returns the results query
  String _getResultsQuery(int num,
      {String? term, Set<String>? filters, Sort? sort, int? from}) {
    final queryParameters = [];
    if (term != null && term.isNotEmpty) {
      queryParameters.add('query=$term');
    }

    if (filters != null) {
      for (var filter in filters) {
        queryParameters.add('filter=$filter');
      }
    }

    if (sort != null) {
      queryParameters.add('sort=${sort.name}');
    }

    if (from != null) {
      queryParameters.add('from=$from');
    }

    queryParameters.add('num=$num');

    var sb = StringBuffer('/results');
    for (var i = 0; i < queryParameters.length; i++) {
      sb.write(i == 0 ? '?' : '&');
      sb.write(queryParameters[i]);
    }

    return sb.toString();
  }

  /// Obtains the shaders
  ///
  /// * [term]: Shaders that have [term] in the name or in description
  /// * [filters]: A set of tag filters
  /// * [sort]: The sort order of the shaders
  /// * [from]: A 0 based index for results returned
  ///
  /// Returns a [FindShadersResponse] with a list of shaders or a [ResponseError]
  Future<FindShadersResponse> _getShadersPage(
      {String? term, Set<String>? filters, Sort? sort, int? from}) {
    final num = options.pageResultsShaderCount;

    return client
        .get(_getResultsQuery(num,
            term: term, filters: filters, sort: sort, from: from))
        .then((Response<dynamic> response) =>
            parseShaders(parseDocument(response.data), num));
  }

  /// Finds shaders
  ///
  /// * [term]: Shaders that have [term] in the name or in description
  /// * [filters]: A set of tag filters
  /// * [sort]: The sort order of the shaders
  /// * [from]: A 0 based index for results returned
  /// * [num]: The total number of results
  ///
  /// Returns a [FindShadersResponse] with a list of ids or a [ResponseError]
  /// According with [from] and [num] parameters the number of calls to the Shadertoy
  /// site API s calculated. Note that the site returns a fixed number of shaders
  /// (configured in [ShadertoySiteOptions.pageResultsShaderCount])
  Future<FindShadersResponse> _getShaders(
      {String? term, Set<String>? filters, Sort? sort, int? from, int? num}) {
    final startFrom = from ?? 0;
    return _getShadersPage(
            term: term, filters: filters, sort: sort, from: startFrom)
        .then((FindShadersResponse shaderPage) {
      if (shaderPage.error != null) {
        return shaderPage;
      }

      var pages = (min(num ?? shaderPage.total, shaderPage.total) /
              options.pageResultsShaderCount)
          .ceil();
      if (pages > 1) {
        var shaderTaskPool = Pool(options.poolMaxAllocatedResources,
            timeout: Duration(seconds: options.poolTimeout));

        var tasks = [Future.value(shaderPage)];
        for (var page = 1; page < pages; page++) {
          tasks.add(pooledRetry(
              shaderTaskPool,
              () => _getShadersPage(
                  term: term,
                  filters: filters,
                  sort: sort,
                  from: startFrom + page * options.pageResultsShaderCount)));
        }

        return Future.wait(tasks).then((List<FindShadersResponse> responses) {
          final results = <FindShaderResponse>[];

          for (var i = 0; i < responses.length; i++) {
            final response = responses[i];

            if (response.error != null) {
              return FindShadersResponse(
                  error: ResponseError.backendResponse(
                      message:
                          'Page ${i + 1} of $pages page(s) was not successfully fetched: ${response.error?.message}'));
            }

            final shaders = response.shaders;
            if (shaders != null) {
              results.addAll(shaders);
            }
          }

          return FindShadersResponse(total: shaderPage.total, shaders: results);
        });
      }

      return shaderPage;
    });
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
  /// According with [from] and [num] parameters the number of calls to the Shadertoy
  /// site API s calculated. Note that the site returns a fixed number of shaders
  /// (configured in [ShadertoySiteOptions.pageResultsShaderCount])
  Future<FindShaderIdsResponse> _getShaderIds(
      {String? term, Set<String>? filters, Sort? sort, int? from, int? num}) {
    return _getShaders(
            term: term, filters: filters, sort: sort, from: from, num: num)
        .then((fsr) => FindShaderIdsResponse(
            count: fsr.total,
            error: fsr.error,
            ids: fsr.shaders
                ?.map((item) => item.shader?.info.id)
                .whereType<String>()
                .toList()));
  }

  @override
  Future<FindShadersResponse> findShaders(
      {String? term, Set<String>? filters, Sort? sort, int? from, int? num}) {
    return catchDioError<FindShadersResponse>(
        _getShaders(
            term: term,
            filters: filters,
            sort: sort,
            from: from,
            num: num ?? options.shaderCount),
        (de) => FindShadersResponse(
            error: toResponseError(de, context: contextShader)));
  }

  @override
  Future<FindShaderIdsResponse> findAllShaderIds() {
    return catchDioError<FindShaderIdsResponse>(
        _getShaderIds(),
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
            num: options.shaderCount),
        (de) => FindShaderIdsResponse(
            error: toResponseError(de, context: contextShader)));
  }

  /// Builds the user url used in the call to Shadertoy user page in order to obtain user data.
  ///
  /// * [userId]: The user Id
  ///
  /// The call is performed to a user page identified by it's id, for example user
  /// iq [page](https://www.shadertoy.com/user/iq)
  String _getUserUrl(String userId) => '/user/$userId';

  /// Builds the user query url used in the call to Shadertoy user page in order to obtain both the user and the his shaders data.
  ///
  /// * [userId]: The user Id
  /// * [filters]: A set of tag filters
  /// * [sort]: The sort order of the shaders
  /// * [from]: A 0 based index for results returned
  ///
  /// The call is performed to a user page identified by it's id, for example user
  /// iq [page](https://www.shadertoy.com/user/iq)
  String _getUserQueryUrl(String userId,
      {Set<String>? filters, Sort? sort, int? from}) {
    var num = options.pageUserShaderCount;

    var queryParameters = [];

    if (filters != null) {
      for (var filter in filters) {
        queryParameters.add('filter=$filter');
      }
    }

    if (sort != null) {
      queryParameters.add('sort=${sort.name}');
    }

    if (from != null) {
      queryParameters.add('from=$from');
    }

    queryParameters.add('num=$num');

    var sb = StringBuffer(_getUserUrl(userId));
    for (var i = 0; i < queryParameters.length; i++) {
      // Strangely the only way to filter the calls is by ommiting ? in the
      // query string. This is probably a bug on the shadertoy website
      // If fixed line bellow should be used to distinguish between index 0
      // thus '?' and the remaining indexes (which should use '&')
      sb.write('&');
      sb.write(queryParameters[i]);
    }

    return sb.toString();
  }

  /// Get the shaders of a user
  ///
  /// * [userId]: The user Id
  /// * [filters]: A set of tag filters
  /// * [sort]: The sort order of the shaders
  /// * [from]: A 0 based index for results returned
  ///
  /// Returns a [FindShaderIdsResponse] with a list of ids or a [ResponseError]
  Future<FindShadersResponse> _getShadersPageByUserId(String userId,
      {Set<String>? filters, Sort? sort, int? from}) {
    return client
        .get(_getUserQueryUrl(userId, filters: filters, sort: sort, from: from))
        .then((Response<dynamic> response) => parseShaders(
            parseDocument(response.data), options.pageUserShaderCount,
            context: contextUser, target: userId));
  }

  /// Gets the shaders of a user
  ///
  /// * [userId]: The user Id
  /// * [filters]: A set of tag filters
  /// * [sort]: The sort order of the shaders
  /// * [from]: A 0 based index for results returned
  /// * [num]: The total number of results
  ///
  /// Returns a [FindShadersResponse] with a list of ids or a [ResponseError]
  /// According with [from] and [num] parameters the number of calls to the Shadertoy
  /// site API s calculated. Note that the site returns a fixed number of shaders
  /// (configured in [ShadertoySiteOptions.pageUserShaderCount])
  Future<FindShadersResponse> _getShadersByUserId(String userId,
      {Set<String>? filters, Sort? sort, int? from, int? num}) {
    final startFrom = from ?? 0;
    return _getShadersPageByUserId(userId,
            filters: filters, sort: sort, from: startFrom)
        .then((FindShadersResponse userShaderPage) {
      final error = userShaderPage.error;
      if (error != null) {
        error.target = userId;
        return userShaderPage;
      }

      var firstPageShaders = userShaderPage.shaders;
      var firstPageResponse = FindShadersResponse(
          total: firstPageShaders?.length, shaders: firstPageShaders);

      var pages = (min(num ?? userShaderPage.total, userShaderPage.total) /
              options.pageUserShaderCount)
          .ceil();
      if (pages > 1) {
        var shaderTaskPool = Pool(options.poolMaxAllocatedResources,
            timeout: Duration(seconds: options.poolTimeout));

        var tasks = [Future.value(firstPageResponse)];
        for (var page = 1; page < pages; page++) {
          tasks.add(pooledRetry(
              shaderTaskPool,
              () => _getShadersPageByUserId(userId,
                  filters: filters,
                  sort: sort,
                  from: startFrom + page * options.pageUserShaderCount)));
        }

        return Future.wait(tasks)
            .then((List<FindShadersResponse> findShadersResponse) {
          final result = <FindShaderResponse>[];

          for (var i = 0; i < findShadersResponse.length; i++) {
            final findShaderResponse = findShadersResponse[i];

            if (findShaderResponse.error != null) {
              return FindShadersResponse(
                  error: ResponseError.backendResponse(
                      message:
                          'Page ${i + 1} of $pages page(s) was not successfully fetched: ${findShaderResponse.error?.message}',
                      context: contextUser,
                      target: userId));
            }

            final shaders = findShaderResponse.shaders;
            if (shaders != null) {
              result.addAll(shaders);
            }
          }

          return FindShadersResponse(
              total: userShaderPage.total, shaders: result);
        });
      }

      return userShaderPage;
    });
  }

  /// Gets the shaders ids of a user
  ///
  /// * [userId]: The user Id
  /// * [filters]: A set of tag filters
  /// * [sort]: The sort order of the shaders
  /// * [from]: A 0 based index for results returned
  /// * [num]: The total number of results
  ///
  /// Returns a [FindShaderIdsResponse] with a list of ids or a [ResponseError]
  /// According with [from] and [num] parameters the number of calls to the Shadertoy
  /// site API s calculated. Note that the site returns a fixed number of shaders
  /// (configured in [ShadertoySiteOptions.pageUserShaderCount])
  Future<FindShaderIdsResponse> _getShaderIdsByUserId(String userId,
      {Set<String>? filters, Sort? sort, int? from, int? num}) {
    return _getShadersByUserId(userId,
            filters: filters, sort: sort, from: from, num: num)
        .then((fsr) => FindShaderIdsResponse(
            count: fsr.total,
            error: fsr.error,
            ids: fsr.shaders
                ?.map((item) => item.shader?.info.id)
                .whereType<String>()
                .toList()));
  }

  @override
  Future<FindUserResponse> findUserById(String userId) {
    return catchDioError<FindUserResponse>(
        client.get(_getUserUrl(userId)).then((Response<dynamic> response) =>
            parseUser(userId, parseDocument(response.data))),
        (de) => FindUserResponse(
            error: toResponseError(de, context: contextUser, target: userId)));
  }

  @override
  Future<FindShadersResponse> findShadersByUserId(String userId,
      {Set<String>? filters, Sort? sort, int? from, int? num}) {
    return catchDioError<FindShadersResponse>(
        _getShadersByUserId(userId,
            filters: filters,
            sort: sort,
            from: from,
            num: num ?? options.userShaderCount),
        (de) => FindShadersResponse(
            error: toResponseError(de, context: contextUser, target: userId)));
  }

  @override
  Future<FindShaderIdsResponse> findShaderIdsByUserId(String userId,
      {Set<String>? filters, Sort? sort, int? from, int? num}) {
    return catchDioError<FindShaderIdsResponse>(
        _getShaderIdsByUserId(userId,
            filters: filters,
            sort: sort,
            from: from,
            num: num ?? options.userShaderCount),
        (de) => FindShaderIdsResponse(
            error: toResponseError(de, context: contextUser, target: userId)));
  }

  @override
  Future<FindShaderIdsResponse> findAllShaderIdsByUserId(String userId) {
    return catchDioError<FindShaderIdsResponse>(
        _getShaderIdsByUserId(userId).then((userResponse) =>
            FindShaderIdsResponse(
                count: userResponse.ids?.length, ids: userResponse.ids)),
        (de) => FindShaderIdsResponse(
            error: toResponseError(de, context: contextUser, target: userId)));
  }

  @override
  Future<FindCommentsResponse> findCommentsByShaderId(String shaderId) {
    var data = FormData.fromMap({'s': shaderId});
    var options = Options(
        contentType: 'application/x-www-form-urlencoded',
        headers: {
          HttpHeaders.refererHeader: context.getShaderViewUrl(shaderId)
        });

    return catchDioError<FindCommentsResponse>(
        client
            .post('/comment', data: data, options: options)
            .then((Response<dynamic> response) =>
                jsonResponse<CommentsResponse>(
                    response, (data) => CommentsResponse.from(data),
                    context: contextShader, target: shaderId))
            .then((c) {
          var userIdList = c.userIds;
          var userPictureList = c.userPictures;
          var dateList = c.dates;
          var textList = c.texts;
          var idList = c.ids;
          var hiddenList = c.hidden;

          var commentsLength = [
            userIdList?.length ?? 0,
            userPictureList?.length ?? 0,
            dateList?.length ?? 0,
            textList?.length ?? 0,
            idList?.length ?? 0,
            hiddenList?.length ?? 0
          ].reduce(min);
          final comments = List<Comment?>.filled(commentsLength, null);

          for (var i = 0; i < comments.length; i++) {
            String? userId;
            String? userPicture;
            DateTime? date;
            String? text;
            String? id;
            bool? hidden;

            if (userIdList != null && userIdList.length > i) {
              userId = userIdList[i];
            }

            if (userPictureList != null && userPictureList.length > i) {
              userPicture =
                  userPictureList[i].replaceAll(userPictureRegExp, '');
            }

            if (dateList != null && dateList.length > i) {
              date = DateTime.fromMillisecondsSinceEpoch(
                  int.parse(dateList[i]) * 1000);
            }

            if (textList != null && textList.length > i) {
              text = textList[i];
            }

            if (idList != null && idList.length > i) {
              id = idList[i];
            }

            if (hiddenList != null && hiddenList.length > i) {
              hidden = !(hiddenList[i] == 0);
            }

            if (id != null && userId != null && date != null && text != null) {
              comments[i] = Comment(
                  id: id,
                  shaderId: shaderId,
                  userId: userId,
                  picture: userPicture,
                  date: date,
                  text: text,
                  hidden: hidden ?? false);
            }
          }

          return FindCommentsResponse(
              total: comments.length,
              comments: comments.whereType<Comment>().toList());
        }),
        (de) => FindCommentsResponse(
            error:
                toResponseError(de, context: contextShader, target: shaderId)));
  }

  /// Builds the playlist url used in the call to Shadertoy playlist page in
  /// order to obtain playlist data.
  ///
  /// * [playlistId]: The playlist id
  ///
  /// The call is performed to a playlist page identified by it's id, for example
  /// playlist week [page](https://www.shadertoy.com/playlist/week)
  String _getPlaylistUrl(String playlistId) => '/playlist/$playlistId';

  /// Builds the playlist url used in the call to Shadertoy playlist page.
  ///
  /// * [playlistId]: The playlist id
  /// * [from]: A 0 based index for results returned
  ///
  /// The call is performed to a playlist page identified by it's id, for example week
  /// [playlist](https://www.shadertoy.com/playlist/week)
  String _getPlaylistQueryUrl(String playlistId, {int? from}) {
    var num = options.pagePlaylistShaderCount;

    var queryParameters = [];
    if (from != null) {
      queryParameters.add('from=$from');
    }

    queryParameters.add('num=$num');

    var sb = StringBuffer(_getPlaylistUrl(playlistId));
    for (var i = 0; i < queryParameters.length; i++) {
      sb.write(i == 0 ? '?' : '&');
      sb.write(queryParameters[i]);
    }

    return sb.toString();
  }

  /// Get's a playlist with it's associated shaders
  ///
  /// * [playlistId]: The playlist Id
  ///
  /// Returns a [FindPlaylistResponse] with a list of shader id's or a [ResponseError]
  Future<FindPlaylistResponse> _getPlaylistById(String playlistId) {
    return client.get(_getPlaylistUrl(playlistId)).then(
        (Response<dynamic> response) =>
            parsePlaylist(playlistId, parseDocument(response.data)));
  }

  /// Get's the shader id's of a playlist
  ///
  /// * [playlistId]: The playlist Id
  /// * [from]: A 0 based index for results returned
  ///
  /// Returns a [FindShaderIdsResponse] with a list of shader id's or a [ResponseError]
  Future<FindShaderIdsResponse> _getShaderIdsPageByPlayListId(String playlistId,
      {int? from}) {
    return client.get(_getPlaylistQueryUrl(playlistId, from: from)).then(
        (Response<dynamic> response) => parseShaderIds(
            parseDocument(response.data), options.pagePlaylistShaderCount,
            context: contextPlaylist, target: playlistId));
  }

  /// Gets the shader ids of a playlist
  ///
  /// * [playlistId]: The playlist Id
  /// * [from]: A 0 based index for results returned
  /// * [num]: The total number of results
  ///
  /// Returns a [FindShaderIdsResponse] with a list of shader id's or a [ResponseError]
  /// According with [from] and [num] parameters the number of calls to the Shadertoy
  /// site API s calculated. Note that the site returns a fixed number of shaders
  /// (configured in [ShadertoySiteOptions.pagePlaylistShaderCount])
  Future<FindShaderIdsResponse> _getShaderIdsByPlaylistId(String playlistId,
      {int? from, int? num}) {
    final startFrom = from ?? 0;
    return _getShaderIdsPageByPlayListId(playlistId, from: startFrom)
        .then((FindShaderIdsResponse playlistShaderPage) {
      final error = playlistShaderPage.error;
      if (error != null) {
        error.target = playlistId;
        return playlistShaderPage;
      }

      var firstPageIds = playlistShaderPage.ids;
      var firstPageResponse =
          FindShaderIdsResponse(count: firstPageIds?.length, ids: firstPageIds);

      var pages =
          (min(num ?? playlistShaderPage.total, playlistShaderPage.total) /
                  options.pagePlaylistShaderCount)
              .ceil();
      if (pages > 1) {
        var shaderTaskPool = Pool(options.poolMaxAllocatedResources,
            timeout: Duration(seconds: options.poolTimeout));

        var tasks = [Future.value(firstPageResponse)];
        for (var page = 1; page < pages; page++) {
          tasks.add(pooledRetry(
              shaderTaskPool,
              () => _getShaderIdsPageByPlayListId(playlistId,
                  from: startFrom + page * options.pagePlaylistShaderCount)));
        }

        return Future.wait(tasks)
            .then((List<FindShaderIdsResponse> findShaderIdsResponses) {
          var shaders = <String>[];

          for (var i = 0; i < findShaderIdsResponses.length; i++) {
            var findShaderIdsResponse = findShaderIdsResponses[i];

            if (findShaderIdsResponse.error != null) {
              return FindShaderIdsResponse(
                  error: ResponseError.backendResponse(
                      message:
                          'Page ${i + 1} of $pages page(s) was not successfully fetched: ${findShaderIdsResponse.error?.message}',
                      context: contextPlaylist,
                      target: playlistId));
            }

            shaders.addAll(findShaderIdsResponse.ids ?? []);
          }

          return FindShaderIdsResponse(
              count: playlistShaderPage.total, ids: shaders);
        });
      }

      return playlistShaderPage;
    });
  }

  @override
  Future<FindPlaylistResponse> findPlaylistById(String playlistId) {
    return catchDioError<FindPlaylistResponse>(
        _getPlaylistById(playlistId),
        (de) => FindPlaylistResponse(
            error: toResponseError(de,
                context: contextPlaylist, target: playlistId)));
  }

  @override
  Future<FindShadersResponse> findShadersByPlaylistId(String playlistId,
      {int? from, int? num = 0}) {
    return catchDioError<FindShadersResponse>(
        _getShaderIdsByPlaylistId(playlistId,
                from: from, num: num ?? options.playlistShaderCount)
            .then((FindShaderIdsResponse response) {
          if (response.error != null) {
            return FindShadersResponse(
                error: response.error
                    ?.copyWith(context: contextPlaylist, target: playlistId));
          }

          final ids = response.ids ?? [];
          return _getShadersByIdSet(ids.toSet());
        }),
        (de) => FindShadersResponse(
            error: toResponseError(de,
                context: contextPlaylist, target: playlistId)));
  }

  @override
  Future<FindShaderIdsResponse> findShaderIdsByPlaylistId(String playlistId,
      {int? from, int? num}) {
    return catchDioError<FindShaderIdsResponse>(
        _getShaderIdsByPlaylistId(playlistId,
                from: from, num: num ?? options.playlistShaderCount)
            .then((playlistResponse) => FindShaderIdsResponse(
                count: playlistResponse.ids?.length,
                ids: playlistResponse.ids)),
        (de) => FindShaderIdsResponse(
            error: toResponseError(de,
                context: contextPlaylist, target: playlistId)));
  }

  @override
  Future<FindShaderIdsResponse> findAllShaderIdsByPlaylistId(
      String playlistId) {
    return catchDioError<FindShaderIdsResponse>(
        _getShaderIdsByPlaylistId(playlistId).then((playlistResponse) =>
            FindShaderIdsResponse(
                count: playlistResponse.ids?.length,
                ids: playlistResponse.ids)),
        (de) => FindShaderIdsResponse(
            error: toResponseError(de,
                context: contextPlaylist, target: playlistId)));
  }

  @override
  Future<DownloadFileResponse> downloadShaderPicture(String shaderId) {
    return catchDioError<DownloadFileResponse>(
        client
            .get<List<int>>('/${context.getShaderPicturePath(shaderId)}',
                options: Options(responseType: ResponseType.bytes))
            .then((response) => DownloadFileResponse(bytes: response.data)),
        (de) => DownloadFileResponse(
            error:
                toResponseError(de, context: contextShader, target: shaderId)));
  }

  @override
  Future<DownloadFileResponse> downloadMedia(String inputPath) {
    return catchDioError<DownloadFileResponse>(
        client
            .get<List<int>>(inputPath,
                options: Options(responseType: ResponseType.bytes))
            .then((response) => DownloadFileResponse(bytes: response.data)),
        (de) => DownloadFileResponse(
            error: toResponseError(de, target: inputPath)));
  }
}
