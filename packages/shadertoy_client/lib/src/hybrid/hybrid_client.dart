import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:file/file.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/src/hybrid/shader_sync.dart';
import 'package:shadertoy_client/src/hybrid/user_sync.dart';
import 'package:shadertoy_client/src/site/site_client.dart';
import 'package:shadertoy_client/src/site/site_options.dart';
import 'package:shadertoy_client/src/ws/ws_client.dart';
import 'package:shadertoy_client/src/ws/ws_options.dart';

import 'playlist_sync.dart';

abstract class SyncTaskRunner {
  void log(String message);

  Future<List<T>> process<T extends IterableMixin<APIResponse>>(
      List<Future<T>> tasks,
      {String? message});
}

/// An hybrid interface implementing both [ShadertoySite] and [ShadertoyWS]
abstract class ShadertoyHybrid implements ShadertoySite, ShadertoyWS {
  /// Synchronizes the [store] with the remote shadertoy data. It can optionally
  /// download shader and user assets if [fs] is specified
  ///
  /// * [store]: A [ShadertoyStore] implementation
  /// * [fs]: A [FileSystem] implementation to store shader and user assets
  /// * [dir]: A path on the [FileSystem]
  /// * [concurrency]: Maximum number of simultaneous requests
  /// * [timeout]: Request timeout in seconds
  /// * [shaderIds]: If specified only the this shader id's will be sync
  /// * [playlistIds]: The playlists to synchronize
  void rsync(ShadertoyStore store,
      {FileSystem? fs,
      Directory? dir,
      SyncTaskRunner? runner,
      int? concurrency,
      int? timeout,
      List<String>? shaderIds,
      List<String> playlistIds});
}

/// A Shadertoy hybrid client
///
/// An implementation of the [ShadertoyWS] and [ShadertoySite] APIs
/// providing the full set of methods either through the [ShadertoySite] implementation
/// or through the [ShadertoyWS] implementation then falling back to the [ShadertoySite]
/// implementation. This could be used to provide the same set of shaders available
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
    _siteClient = ShadertoySiteClient(siteOptions, client: client);
    if (wsOptions != null) {
      _hybridClient = ShadertoyWSClient(wsOptions, client: client);
    } else {
      _hybridClient = _siteClient;
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

  @override
  void rsync(ShadertoyStore store,
      {FileSystem? fs,
      Directory? dir,
      SyncTaskRunner? runner,
      int? concurrency,
      int? timeout,
      List<String>? shaderIds,
      List<String> playlistIds = const <String>[]}) async {
    final shaderProcessor = ShaderSyncProcessor(this, store,
        runner: runner, concurrency: concurrency, timeout: timeout);
    final shaderSyncResult = await shaderProcessor.syncShaders(
        fs: fs, dir: dir, shaderIds: shaderIds);

    final userProcessor = UserSyncProcessor(this, store,
        runner: runner, concurrency: concurrency, timeout: timeout);
    await userProcessor.syncUsers(shaderSyncResult, fs: fs, dir: dir);

    if (shaderIds == null) {
      final playlistProcessor = PlaylistSyncProcessor(this, store,
          runner: runner, concurrency: concurrency, timeout: timeout);
      await playlistProcessor.syncPlaylists(playlistIds);
    }
  }
}
