import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:html/dom.dart' show Document, Element, Node;
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
import 'package:pool/pool.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/src/http_client.dart';
import 'package:shadertoy_client/src/site/site_options.dart';

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
  /// Parses the number of results out of the Shadertoy browse
  /// [page](https://www.shadertoy.com/browse)
  static final RegExp numResultsRegExp = RegExp(r'\s*Results\s\((-?\d*)\):\s*');

  /// Parses the number of shaders out of the Shadertoy playlist page,
  /// for example this week playlist [page](https://www.shadertoy.com/playlist/week)
  static final RegExp numShadersRegExp = RegExp(r'(-?\d*)\s(Shaders:)');

  /// Parses the id's from the Shadertoy results, for example on
  /// a search for "elevated" this regular expression parses the
  /// id's from this [page](https://www.shadertoy.com/results?query=elevated)
  static final RegExp idArrayRegExp = RegExp(r'\[(\s*\"(\w{6})\"\s*,?)+\]');

  /// Parses a Shadertoy id after sucessfully aplying the regex [idArrayRegExp]
  static final RegExp shaderIdRegExp = RegExp(r'\"(\w{6})\"');

  /// Used to remove the '\' on the userpicture field of the comment
  /// Ex: '\/img\/profile.jpg' becomes '/img/profile.jpg'
  static final RegExp userPictureRegExp = RegExp(r'\\');

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

  /// Validates [doc] and returns a [ResponseError] when invalid
  ///
  /// * [doc]: The document
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ///
  /// Returns [ResponseError] for a invalid document or null otherwise.
  ResponseError? _validate(Document doc, {String? context, String? target}) {
    var body = doc.querySelector('body');
    if (body == null || body.children.isEmpty) {
      return ResponseError.backendResponse(
          message: 'Unexpected HTML response body: ${body?.text}',
          context: context,
          target: target);
    }

    return null;
  }

  /// Parses the number of returned shader's from the html
  /// returned in the Shadertoy browse [page](https://www.shadertoy.com/browse)
  /// the results [page](https://www.shadertoy.com/results) or the playlist page
  /// [week](https://www.shadertoy.com/playlist/week) for example
  ///
  /// [doc]: The [Document] with the page DOM
  ///
  /// Returns null in case of a unsucessful match
  int? _parseResultsPager(Document doc) {
    var elements = doc.querySelectorAll(
        '#content>#controls>div>span,#content>#controls>div>div');
    if (elements.isNotEmpty) {
      for (var element in elements) {
        final numResultsMatch = numResultsRegExp.firstMatch(element.text);
        if (numResultsMatch != null) {
          final group = numResultsMatch.group(1);

          if (group != null) {
            return int.tryParse(group);
          }
        }
      }
    }

    return null;
  }

  /// Parses the number of returned shader's from the html
  /// returned in the Shadertoy playlist [week](https://www.shadertoy.com/playlist/week)
  /// playlist for example
  ///
  /// [doc]: The [Document] with the page DOM
  ///
  /// Returns null in case of a unsucessful match
  int? _parseShadersPager(Document doc) {
    var elements = doc.querySelectorAll('#content>#controls>*>div');
    if (elements.isNotEmpty) {
      for (var element in elements) {
        final numShadersMatch = numShadersRegExp.firstMatch(element.text);
        if (numShadersMatch != null) {
          final group = numShadersMatch.group(1);

          if (group != null) {
            return int.tryParse(group);
          }
        }
      }
    }

    return null;
  }

  /// Parses the list of shader id's returned
  ///
  /// * [doc]: The [Document] with the page DOM
  /// * [maxShaders]: The maximum number of shaders
  ///
  /// It should be used to parse the html of
  /// browse, results, user and playlist pages
  FindShaderIdsResponse _parseShaderIds(Document doc, int maxShaders) {
    final error = _validate(doc);
    if (error != null) {
      return FindShaderIdsResponse(error: error);
    }

    final count = _parseShadersPager(doc) ?? _parseResultsPager(doc);
    final results = <String>[];

    if (count == null) {
      return FindShaderIdsResponse(
          error: ResponseError.backendResponse(
              message: 'Unable to parse the number of results'));
    } else if (count < 0) {
      return FindShaderIdsResponse(
          error: ResponseError.backendResponse(
              message: 'Obtained an invalid number of results: $count'));
    } else if (count == 0) {
      return FindShaderIdsResponse(count: 0, ids: const []);
    }

    var elements = doc.querySelectorAll('script');
    if (elements.isNotEmpty) {
      for (var element in elements) {
        final elementMatch = idArrayRegExp.firstMatch(element.text);

        if (elementMatch != null) {
          var shaderListText = elementMatch.group(0);
          if (shaderListText != null) {
            Iterable<Match> shaderIdMatches =
                shaderIdRegExp.allMatches(shaderListText);

            for (var i = 0; i < min(shaderIdMatches.length, maxShaders); i++) {
              final shaderIdMatch = shaderIdMatches.elementAt(i);
              final shaderIdMatchGroup = shaderIdMatch.group(1);
              if (shaderIdMatchGroup != null) {
                results.add(shaderIdMatchGroup);
              }
            }
          }
        }
      }

      if (results.isEmpty) {
        return FindShaderIdsResponse(
            error: ResponseError.backendResponse(
                message:
                    'No script block matches with "${idArrayRegExp.pattern}" pattern'));
      }
    } else {
      return FindShaderIdsResponse(
          error: ResponseError.backendResponse(
              message: 'Unable to get the script blocks from the document'));
    }

    return FindShaderIdsResponse(count: count, ids: results);
  }

  /// Finds shader ids
  ///
  /// * [term]: Shaders that have [term] in the name or in description
  /// * [filters]: A set of tag filters
  /// * [sort]: The sort order of the shaders
  /// * [from]: A 0 based index for results returned
  ///
  /// Returns a [FindShaderIdsResponse] with a list of ids or a [ResponseError]
  Future<FindShaderIdsResponse> _getShaderIdsPage(
      {String? term, Set<String>? filters, Sort? sort, int? from}) {
    var num = options.pageResultsShaderCount;

    var queryParameters = [];
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

    return client.get(sb.toString()).then((Response<dynamic> response) =>
        _parseShaderIds(parse(response.data), num));
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
    final startFrom = from ?? 0;
    return _getShaderIdsPage(
            term: term, filters: filters, sort: sort, from: startFrom)
        .then((FindShaderIdsResponse shaderPage) {
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
              () => _getShaderIdsPage(
                  term: term,
                  filters: filters,
                  sort: sort,
                  from: startFrom + page * options.pageResultsShaderCount)));
        }

        return Future.wait(tasks).then((List<FindShaderIdsResponse> responses) {
          final results = <String>[];

          for (var i = 0; i < responses.length; i++) {
            final response = responses[i];

            if (response.error != null) {
              return FindShaderIdsResponse(
                  error: ResponseError.backendResponse(
                      message:
                          'Page ${i + 1} of $pages page(s) was not successfully fetched: ${response.error?.message}'));
            }

            final ids = response.ids;
            if (ids != null) {
              results.addAll(ids);
            }
          }

          return FindShaderIdsResponse(count: results.length, ids: results);
        });
      }

      return shaderPage;
    });
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
            .then((FindShaderIdsResponse response) {
          if (response.error != null) {
            return FindShadersResponse(error: response.error);
          }

          final ids = response.ids ?? [];

          return _getShadersByIdSet(ids.toSet());
        }),
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

  /// Get the shader id's of a user
  ///
  /// * [userId]: The user Id
  /// * [filters]: A set of tag filters
  /// * [sort]: The sort order of the shaders
  /// * [from]: A 0 based index for results returned
  ///
  /// Returns a [FindShaderIdsResponse] with a list of ids or a [ResponseError]
  Future<FindShaderIdsResponse> _getShaderIdsPageByUserId(String userId,
      {Set<String>? filters, Sort? sort, int? from}) {
    return client
        .get(_getUserQueryUrl(userId, filters: filters, sort: sort, from: from))
        .then((Response<dynamic> response) =>
            _parseShaderIds(parse(response.data), options.pageUserShaderCount));
  }

  /// Gets the shader ids of a user
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
    final startFrom = from ?? 0;
    return _getShaderIdsPageByUserId(userId,
            filters: filters, sort: sort, from: startFrom)
        .then((FindShaderIdsResponse userShaderPage) {
      final error = userShaderPage.error;
      if (error != null) {
        error.target = userId;
        return userShaderPage;
      }

      var firstPageIds = userShaderPage.ids;
      var firstPageResponse =
          FindShaderIdsResponse(count: firstPageIds?.length, ids: firstPageIds);

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
              () => _getShaderIdsPageByUserId(userId,
                  filters: filters,
                  sort: sort,
                  from: startFrom + page * options.pageUserShaderCount)));
        }

        return Future.wait(tasks)
            .then((List<FindShaderIdsResponse> findShaderIdsResponses) {
          final shaders = <String>[];

          for (var i = 0; i < findShaderIdsResponses.length; i++) {
            final findShaderIdsResponse = findShaderIdsResponses[i];

            if (findShaderIdsResponse.error != null) {
              return FindShaderIdsResponse(
                  error: ResponseError.backendResponse(
                      message:
                          'Page ${i + 1} of $pages page(s) was not successfully fetched: ${findShaderIdsResponse.error?.message}',
                      target: userId));
            }

            final ids = findShaderIdsResponse.ids;
            if (ids != null) {
              shaders.addAll(ids);
            }
          }

          return FindShaderIdsResponse(
              count: userShaderPage.total, ids: shaders);
        });
      }

      return userShaderPage;
    });
  }

  /// Helper methods which parses a [String] out of a [Node]
  String? _userString(Node node) {
    return node.text?.substring(1).trim();
  }

  /// Helper methods which parses a [int] out of a [Node]
  int? _userInt(Node node) {
    final userString = _userString(node);
    return userString != null ? int.tryParse(userString) : null;
  }

  /// Helper methods which parses a [DateTime] out of a [Node]
  DateTime? _userDate(Node node) {
    final userString = _userString(node);
    return userString != null
        ? DateFormat('MMMM d, y').parse(userString)
        : null;
  }

  /// Parses a user out of the DOM representation
  ///
  /// * [userId]: The user id
  /// * [doc]: The [Document] with the page DOM
  ///
  /// Return a [FindUserResponse] with a [User] or a [ResponseError]
  FindUserResponse _parseUser(String userId, Document doc) {
    var error = _validate(doc, context: contextUser, target: userId);
    if (error != null) {
      return FindUserResponse(error: error);
    }

    String? picture;
    var memberSince = DateTime(2013, 1, 11);
    var following = 0;
    var followers = 0;
    final aboutBuffer = StringBuffer();

    var elements = doc.querySelectorAll('#content>#divUser>table>tbody>tr>td');
    if (elements.length < 3) {
      return FindUserResponse(
          error: ResponseError.backendResponse(
              message:
                  'Obtained an invalid number of user sections: ${elements.length}',
              context: contextUser,
              target: userId));
    }

    final pictureSection = elements[0];
    picture = pictureSection.querySelector('#userPicture')?.attributes['src'];
    final fieldsSection = elements[1];
    List<Node> nodes = fieldsSection.nodes;
    for (var i = 0; i < nodes.length; i++) {
      final text = nodes[i].text;

      if (text != null) {
        if ('Joined'.compareTo(text) == 0 && i < nodes.length - 1) {
          final userMemberSince = _userDate(nodes[i + 1]);
          if (userMemberSince != null) {
            memberSince = userMemberSince;
          }
        }

        if ('Following'.compareTo(text) == 0 && i < nodes.length - 1) {
          final userFollowing = _userInt(nodes[i + 1]);
          if (userFollowing != null) {
            following = userFollowing;
          }
        }

        if ('Followers'.compareTo(text) == 0 && i < nodes.length - 1) {
          final userFollowers = _userInt(nodes[i + 1]);
          if (userFollowers != null) {
            followers = userFollowers;
          }
        }
      }
    }

    final aboutSection = elements[2];
    nodes = aboutSection.nodes;
    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final text = node.text?.trim();

      if (node.nodeType == Node.ELEMENT_NODE) {
        var element = node as Element;
        var tag = element.localName;

        if (tag == 'br') {
          aboutBuffer.write('\n');
        } else if (tag == 'strong') {
          aboutBuffer.write('[b]$text[/b]');
        } else if (tag == 'em') {
          aboutBuffer.write('[i]$text[/i]');
        } else if (tag == 'a') {
          var href = element.attributes['href'];
          if (href != null) {
            if (href == text) {
              aboutBuffer.write('[url]$href[/url]');
            } else {
              aboutBuffer.write('[url=$href]$text[/url]');
            }
          }
        } else if (tag == 'pre') {
          aboutBuffer.write('[code]$text[/code]');
        } else if (tag == 'img') {
          final src = element.attributes['src'];
          if (src != null) {
            if (src.endsWith('emoticonHappy.png')) {
              aboutBuffer.write(':)');
            } else if (src.endsWith('emoticonSad.png')) {
              aboutBuffer.write(':(');
            } else if (src.endsWith('emoticonLaugh.png')) {
              aboutBuffer.write(':D');
            } else if (src.endsWith('emoticonLove.png')) {
              aboutBuffer.write(':love:');
            } else if (src.endsWith('emoticonOctopus.png')) {
              aboutBuffer.write(':octopus:');
            } else if (src.endsWith('emoticonOctopusBalloon.png')) {
              aboutBuffer.write(':octopusballoon:');
            }
          }
        }
      } else if (node.nodeType == Node.TEXT_NODE) {
        if (text == 'α') {
          aboutBuffer.write(':alpha:');
        } else if (text == 'β') {
          aboutBuffer.write(':beta:');
        } else if (text == '⏑') {
          aboutBuffer.write(':delta');
        } else if (text == 'ε') {
          aboutBuffer.write(':epsilon:');
        } else if (text == '∇') {
          aboutBuffer.write(':nabla:');
        } else if (text == '²') {
          aboutBuffer.write(':square:');
        } else if (text == '≐') {
          aboutBuffer.write(':limit:');
        } else {
          aboutBuffer.write(text);
        }
      }
    }

    return FindUserResponse(
        user: User(
            id: userId,
            picture: picture,
            memberSince: memberSince,
            following: following,
            followers: followers,
            about: aboutBuffer.toString()));
  }

  @override
  Future<FindUserResponse> findUserById(String userId) {
    return catchDioError<FindUserResponse>(
        client.get(_getUserUrl(userId)).then((Response<dynamic> response) =>
            _parseUser(userId, parse(response.data))),
        (de) => FindUserResponse(
            error: toResponseError(de, context: contextUser, target: userId)));
  }

  @override
  Future<FindShadersResponse> findShadersByUserId(String userId,
      {Set<String>? filters, Sort? sort, int? from, int? num}) {
    return catchDioError<FindShadersResponse>(
        _getShaderIdsByUserId(userId,
                filters: filters,
                sort: sort,
                from: from,
                num: num ?? options.userShaderCount)
            .then((FindShaderIdsResponse response) {
          if (response.error != null) {
            return FindShadersResponse(
                error: response.error
                    ?.copyWith(context: contextUser, target: userId));
          }

          final ids = response.ids ?? [];
          return _getShadersByIdSet(ids.toSet());
        }),
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
                num: num ?? options.userShaderCount)
            .then((userResponse) => FindShaderIdsResponse(
                count: userResponse.ids?.length, ids: userResponse.ids)),
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

  /// Parses the list of shader id's returned
  ///
  /// * [playlistId]: The id of the playlist
  /// * [doc]: The [Document] with the page DOM
  ///
  /// It should be used to parse the html of
  /// the playlist pages
  FindPlaylistResponse _parsePlaylist(String playlistId, Document doc) {
    var error = _validate(doc, context: contextPlaylist, target: playlistId);
    if (error != null) {
      return FindPlaylistResponse(error: error);
    }

    String? name;
    String? userId;
    String? description;

    description =
        doc.querySelector('#content>div>span')?.nodes.last.text?.trim();
    if (description == null) {
      return FindPlaylistResponse(
          error: ResponseError.backendResponse(
              message:
                  'Unable to get the playlist description from the document',
              context: contextPlaylist,
              target: playlistId));
    }

    name = doc.querySelector('#content>div>span>span')?.text;
    if (name == null) {
      return FindPlaylistResponse(
          error: ResponseError.backendResponse(
              message: 'Unable to get the playlist name from the document',
              context: contextPlaylist,
              target: playlistId));
    }

    userId = doc.querySelector('#content>div>span>a')?.text.trim();
    if (userId == null) {
      return FindPlaylistResponse(
          error: ResponseError.backendResponse(
              message: 'Unable to get the playlist user id from the document',
              context: contextPlaylist,
              target: playlistId));
    }

    return FindPlaylistResponse(
        playlist: Playlist(
            id: playlistId,
            userId: userId,
            name: name,
            description: description));
  }

  /// Get's a playlist with it's associated shaders
  ///
  /// * [playlistId]: The playlist Id
  ///
  /// Returns a [FindPlaylistResponse] with a list of shader id's or a [ResponseError]
  Future<FindPlaylistResponse> _getPlaylistById(String playlistId) {
    return client.get(_getPlaylistUrl(playlistId)).then(
        (Response<dynamic> response) =>
            _parsePlaylist(playlistId, parse(response.data)));
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
        (Response<dynamic> response) => _parseShaderIds(
            parse(response.data), options.pagePlaylistShaderCount));
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
