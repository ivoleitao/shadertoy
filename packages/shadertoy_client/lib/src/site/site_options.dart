import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/src/http_options.dart';

/// Options for the Shadertoy Site API client
///
/// Stores the options used to build a [ShadertoySiteClient]
class ShadertoySiteOptions extends ShadertoyHttpOptions {
  /// The default Shadertoy cookie name
  static const String defaultCookieName = 'sdtd';

  /// The default number of shaders presented in the Shadertoy
  /// results [page](https://www.shadertoy.com/results)
  static const int defaultPageResultsShaderCount = 12;

  /// The default number of shaders presented in the Shadertoy
  /// user, for example iq user page as seen in
  /// [here](https://www.shadertoy.com/user/iq)
  static const int defaultPageUserShaderCount = 8;

  /// The default number of shaders presented in a Shadertoy
  /// playlist page, for example the playlist of the week as seen in
  /// [here](https://www.shadertoy.com/playlist/week)
  static const int defaultPagePlaylistShaderCount = 12;

  /// The Shadertoy user login
  final String? user;

  /// The Shadertoy user password
  final String? password;

  /// The Shadertoy cookie name
  final String cookieName;

  /// The number of shaders requested for a user paged call
  final int userShaderCount;

  /// The number of shaders requested for a playlist paged call
  final int playlistShaderCount;

  /// The number of shaders presented in the Shadertoy
  /// results [page](https://www.shadertoy.com/browse)
  final int pageResultsShaderCount;

  /// The number of shaders presented in the Shadertoy
  /// user, for example iq user page as seen in
  /// [here](https://www.shadertoy.com/user/iq)
  final int pageUserShaderCount;

  /// The number of shaders presented in a Shadertoy playlist
  /// page, for example the playlist of the week as seen in
  /// [here](https://www.shadertoy.com/playlist/week)
  final int pagePlaylistShaderCount;

  /// Builds a [ShadertoySiteOptions]
  ///
  /// * [user]: The Shadertoy user
  /// * [password]: The Shadertoy password
  /// * [cookieName]: The Shadertoy cookie name, defaults to [ShadertoySiteOptions.defaultCookieName]
  /// * [userShaderCount]: The number of shaders requested for a user paged call, defaults to [ShadertoySiteOptions.defaultPageUserShaderCount]
  /// * [playlistShaderCount]: The number of shaders requested for a playlist paged call, defaults to [ShadertoySiteOptions.defaultPagePlaylistShaderCount]
  /// * [pageResultsShaderCount]: The number of shaders presented in the Shadertoy results page, defaults to [ShadertoySiteOptions.defaultPageResultsShaderCount]
  /// * [pageUserShaderCount]: The number of shaders presented in the Shadertoy user page, defaults to [ShadertoySiteOptions.defaultPageUserShaderCount]
  /// * [pagePlaylistShaderCount]: The number of shaders presented in the Shadertoy playlist page, defaults to [ShadertoySiteOptions.defaultPagePlaylistShaderCount]
  /// * [baseUrl]: The Shadertoy base url
  /// * [poolMaxAllocatedResources]: The maximum number of resources allocated for parallel calls
  /// * [poolTimeout]: The timeout before giving up on a call
  /// * [retryMaxAttempts]: The maximum number of attempts at a failed request
  /// * [shaderCount]: The number of shaders fetched in a paged call
  /// * [errorHandling]: The error handling mode
  ShadertoySiteOptions(
      {this.user,
      this.password,
      String? cookieName,
      int? userShaderCount,
      int? playlistShaderCount,
      int? pageResultsShaderCount,
      int? pageUserShaderCount,
      int? pagePlaylistShaderCount,
      String? baseUrl,
      int? poolMaxAlocatedResources,
      int? poolTimeout,
      int? retryMaxAttempts,
      int? shaderCount,
      ErrorMode? errorHandling})
      : assert(user == null || user.isNotEmpty, 'user is null or not empty'),
        assert(password == null || password.isNotEmpty,
            'password is null or not empty'),
        cookieName = cookieName ?? defaultCookieName,
        userShaderCount = userShaderCount ?? defaultPageUserShaderCount,
        playlistShaderCount =
            playlistShaderCount ?? defaultPagePlaylistShaderCount,
        pageResultsShaderCount =
            pageResultsShaderCount ?? defaultPageResultsShaderCount,
        pageUserShaderCount = pageUserShaderCount ?? defaultPageUserShaderCount,
        pagePlaylistShaderCount =
            pagePlaylistShaderCount ?? defaultPagePlaylistShaderCount,
        super(
            baseUrl: baseUrl,
            supportsCookies: true,
            poolMaxAllocatedResources: poolMaxAlocatedResources,
            poolTimeout: poolTimeout,
            retryMaxAttempts: retryMaxAttempts,
            shaderCount: shaderCount,
            errorHandling: errorHandling) {
    assert(this.cookieName.isNotEmpty, 'cookieName is not empty');
    assert(this.userShaderCount >= 1,
        'userShaderCount is greater or equal to one');
    assert(this.playlistShaderCount >= 1);
    assert(this.pageResultsShaderCount >= 1,
        'pageResultsShaderCount is greater or equal to one');
    assert(this.pageUserShaderCount >= 1,
        'pageUserShaderCount is greater or equal to one');
    assert(this.pagePlaylistShaderCount >= 1,
        'pagePlaylistShaderCount is greater or equal to one');
  }

  /// Builds a copy of a [ShadertoySiteOptions]
  ///
  /// * [user]: The Shadertoy user
  /// * [password]: The Shadertoy password
  /// * [cookieName]: The Shadertoy cookie name
  /// * [userShaderCount]: The number of shaders requested for a user paged call
  /// * [playlistShaderCount]: The number of shaders requested for a playlist paged call
  /// * [pageResultsShaderCount]: The number of shaders presented in the Shadertoy results page
  /// * [pageUserShaderCount]: The number of shaders presented in the Shadertoy user page
  /// * [pagePlaylistShaderCount]: The number of shaders presented in the Shadertoy playlist page
  /// * [baseUrl]: The Shadertoy base url
  /// * [poolMaxAllocatedResources]: The maximum number of resources allocated for parallel calls
  /// * [poolTimeout]: The timeout before giving up on a call
  /// * [retryMaxAttempts]: The maximum number of attempts at a failed request
  /// * [errorHandling]: The error handling mode
  ShadertoySiteOptions copyWith(
      {String? user,
      String? password,
      String? cookieName,
      int? userShaderCount,
      int? playlistShaderCount,
      int? pageResultsShaderCount,
      int? pageUserShaderCount,
      int? pagePlaylistShaderCount,
      String? baseUrl,
      int? poolMaxAllocatedResources,
      int? poolTimeout,
      int? retryMaxAttempts,
      ErrorMode? errorHandling}) {
    return ShadertoySiteOptions(
        user: user ?? this.user,
        password: password ?? this.password,
        cookieName: cookieName ?? this.cookieName,
        userShaderCount: userShaderCount ?? this.userShaderCount,
        playlistShaderCount: playlistShaderCount ?? this.playlistShaderCount,
        pageResultsShaderCount:
            pageResultsShaderCount ?? this.pageResultsShaderCount,
        pageUserShaderCount: pageUserShaderCount ?? this.pageUserShaderCount,
        pagePlaylistShaderCount:
            pagePlaylistShaderCount ?? this.pagePlaylistShaderCount,
        baseUrl: baseUrl ?? this.baseUrl,
        poolMaxAlocatedResources:
            poolMaxAllocatedResources ?? this.poolMaxAllocatedResources,
        poolTimeout: poolTimeout ?? this.poolTimeout,
        retryMaxAttempts: retryMaxAttempts ?? this.retryMaxAttempts,
        errorHandling: errorHandling ?? this.errorHandling);
  }
}
