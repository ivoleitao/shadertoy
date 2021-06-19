import 'package:dio/dio.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/src/site/site_client.dart';
import 'package:shadertoy_client/src/site/site_options.dart';
import 'package:shadertoy_client/src/ws/ws_client.dart';
import 'package:shadertoy_client/src/ws/ws_options.dart';

/// A marker interface implementing both [ShadertoySite] and [ShadertoyWS]
abstract class ShadertoyHybrid implements ShadertoySite, ShadertoyWS {}

/// A Shadertoy hybrid client
///
/// An implementation of the [ShadertoyWS] and [ShadertoySite] APIs
/// providing the full set of methods either through the [ShadertoySite] implementation
/// or through the [ShadertoyWS] implementation first then falling back to the [ShadertoySite]
/// implementation. This provides an implementation that provides the same set of shaders available
/// through the REST API (public+api privacy settings) complementing those with additional methods
/// available through the site implementation
class ShadertoyHybridClient extends ShadertoyBaseClient
    implements ShadertoyHybrid {
  /// The site client
  late final ShadertoySiteClient _siteClient;

  /// The hybrid client (either an instance of [ShadertoySite] or [ShadertoyWS] if provided)
  late final ShadertoyClient _hybridClient;

  /// Builds a [ShadertoyHybridClient]
  ///
  /// * [siteOptions]: Options for the site client
  /// * [wsOptions]: Options for the REST client
  /// * [client]: A dio client instance
  ShadertoyHybridClient(ShadertoySiteOptions siteOptions,
      {ShadertoyWSOptions? wsOptions, Dio? client})
      : super(siteOptions.baseUrl) {
    client ??= Dio(BaseOptions(baseUrl: siteOptions.baseUrl));
    if (wsOptions != null) {
      _hybridClient = ShadertoyWSClient(wsOptions, client: client);
    } else {
      _hybridClient =
          _siteClient = ShadertoySiteClient(siteOptions, client: client);
    }
  }

  @override
  Future<bool> get loggedIn => _siteClient.loggedIn;

  @override
  Future<LoginResponse> login() {
    return _siteClient.login();
  }

  @override
  Future<LogoutResponse> logout() {
    return _siteClient.logout();
  }

  @override
  Future<FindShaderResponse> findShaderById(String shaderId) {
    return _hybridClient.findShaderById(shaderId);
  }

  @override
  Future<FindShadersResponse> findShadersByIdSet(Set<String> shaderIds) {
    return _hybridClient.findShadersByIdSet(shaderIds);
  }

  @override
  Future<FindShadersResponse> findShaders(
      {String? term, Set<String>? filters, Sort? sort, int? from, int? num}) {
    return _hybridClient.findShaders(
        term: term, filters: filters, sort: sort, from: from, num: num);
  }

  @override
  Future<FindShaderIdsResponse> findAllShaderIds() {
    return _hybridClient.findAllShaderIds();
  }

  @override
  Future<FindShaderIdsResponse> findShaderIds(
      {String? term, Set<String>? filters, Sort? sort, int? from, int? num}) {
    return _hybridClient.findShaderIds(
        term: term, filters: filters, sort: sort, from: from, num: num);
  }

  @override
  Future<FindUserResponse> findUserById(String userId) {
    return _siteClient.findUserById(userId);
  }

  @override
  Future<FindShadersResponse> findShadersByUserId(String userId,
      {Set<String>? filters, Sort? sort, int? from, int? num}) {
    return _siteClient.findShadersByUserId(userId,
        filters: filters, sort: sort, from: from, num: num);
  }

  @override
  Future<FindShaderIdsResponse> findShaderIdsByUserId(String userId,
      {Set<String>? filters, Sort? sort, int? from, int? num}) {
    return _siteClient.findShaderIdsByUserId(userId,
        filters: filters, sort: sort, from: from, num: num);
  }

  @override
  Future<FindShaderIdsResponse> findAllShaderIdsByUserId(String userId) {
    return _siteClient.findShaderIdsByUserId(userId);
  }

  @override
  Future<FindCommentsResponse> findCommentsByShaderId(String shaderId) {
    return _siteClient.findCommentsByShaderId(shaderId);
  }

  @override
  Future<FindPlaylistResponse> findPlaylistById(String playlistId) {
    return _siteClient.findPlaylistById(playlistId);
  }

  @override
  Future<FindShadersResponse> findShadersByPlaylistId(String playlistId,
      {int? from, int? num}) {
    return _siteClient.findShadersByPlaylistId(playlistId,
        from: from, num: num);
  }

  @override
  Future<FindShaderIdsResponse> findShaderIdsByPlaylistId(String playlistId,
      {int? from, int? num}) {
    return _siteClient.findShaderIdsByPlaylistId(playlistId,
        from: from, num: num);
  }

  @override
  Future<FindShaderIdsResponse> findAllShaderIdsByPlaylistId(
      String playlistId) {
    return _siteClient.findShaderIdsByPlaylistId(playlistId);
  }

  @override
  Future<DownloadFileResponse> downloadShaderPicture(String shaderId) {
    return _siteClient.downloadShaderPicture(shaderId);
  }

  @override
  Future<DownloadFileResponse> downloadMedia(String inputPath) {
    return _siteClient.downloadMedia(inputPath);
  }
}

/// Creates [ShadertoyHybrid] backed by a [ShadertoyHybridClient]
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
/// * [shaderCount]: The number of shaders fetched in a paged call
/// * [errorHandling]: The error handling mode
/// * [client]: A pre-initialized [Dio] client
ShadertoyHybrid newShadertoyHybridClient(
    {String? user,
    String? password,
    String? cookieName,
    int? userShaderCount,
    int? playlistShaderCount,
    int? pageResultsShaderCount,
    int? pageUserShaderCount,
    int? pagePlaylistShaderCount,
    String? apiKey,
    String? apiPath,
    String? baseUrl,
    int? poolMaxAllocatedResources,
    int? poolTimeout,
    int? retryMaxAttempts,
    int? shaderCount,
    ErrorMode? errorHandling,
    Dio? client}) {
  return ShadertoyHybridClient(
      ShadertoySiteOptions(
          user: user,
          password: password,
          cookieName: cookieName,
          userShaderCount: userShaderCount,
          playlistShaderCount: playlistShaderCount,
          pageResultsShaderCount: pageResultsShaderCount,
          pageUserShaderCount: pageUserShaderCount,
          pagePlaylistShaderCount: pagePlaylistShaderCount,
          baseUrl: baseUrl,
          poolMaxAlocatedResources: poolMaxAllocatedResources,
          poolTimeout: poolTimeout,
          retryMaxAttempts: retryMaxAttempts,
          errorHandling: errorHandling),
      wsOptions: apiKey != null
          ? ShadertoyWSOptions(
              apiKey: apiKey,
              apiPath: apiPath,
              baseUrl: baseUrl,
              poolMaxAllocatedResources: poolMaxAllocatedResources,
              poolTimeout: poolTimeout,
              retryMaxAttempts: retryMaxAttempts,
              shaderCount: shaderCount,
              errorHandling: errorHandling)
          : null,
      client: client);
}
