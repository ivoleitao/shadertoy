import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:file/file.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/shadertoy_client.dart';
import 'package:shadertoy_client/src/hybrid/playlist_sync.dart';
import 'package:shadertoy_client/src/hybrid/shader_sync.dart';
import 'package:shadertoy_client/src/hybrid/user_sync.dart';
import 'package:shadertoy_client/src/site/site_client.dart';
import 'package:shadertoy_client/src/site/site_options.dart';
import 'package:shadertoy_client/src/ws/ws_client.dart';
import 'package:shadertoy_client/src/ws/ws_options.dart';

/// The sync mode of the hybrid client
enum HybridSyncMode {
  /// Retrieves all the shaders / users from the shadertoy website adding / removing
  /// from the storage
  full,

  /// Retrieves only the new shaders / users from the shadertoy webisite adding them to
  /// the storage
  latest
}

/// The definition of a generic interface whose implementation is able to
/// process synchronization tasks
abstract class SyncTaskRunner {
  /// Logs a message
  ///
  /// * [message]: The message to log
  void log(String message);

  /// Processes synchronization tasks
  ///
  /// * [tasks]: The tasks to process
  /// * [message]: An optional message to display
  Future<List<T>> process<T extends IterableMixin<APIResponse>>(
      List<Future<T>> tasks,
      {String? message});
}

/// An hybrid interface implementing both [ShadertoySite] and [ShadertoyWS]
abstract class ShadertoyHybrid implements ShadertoySite, ShadertoyWS {
  /// Returns a new [FindShaderIdsResponse] with a list of the new shader ids.
  ///
  /// * [storeShaderIds]: The list of stored shader ids
  ///
  /// Upon success a list of new shader ids is provided
  ///
  /// In case of error a [ResponseError] is set and no shader id list is
  /// provided
  Future<FindShaderIdsResponse> findNewShaderIds(Set<String> storeShaderIds);

  /// Synchronizes the [store] with the remote shadertoy data. It can optionally
  /// download shader and user assets if [fs] is specified
  ///
  /// * [store]: A [ShadertoyStore] implementation
  /// * [mode]: Specifies the mode used on the synchronization, either full or newest
  /// * [fs]: A [FileSystem] implementation to store shader and user assets
  /// * [dir]: A path on the [FileSystem]
  /// * [concurrency]: Maximum number of simultaneous requests
  /// * [timeout]: Request timeout in seconds
  /// * [playlistIds]: The playlists to synchronize
  void rsync(ShadertoyStore store, HybridSyncMode mode,
      {FileSystem? fs,
      Directory? dir,
      SyncTaskRunner? runner,
      int? concurrency,
      int? timeout,
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
  /// The hybrid options (either an instance of [ShadertoySiteOptions] or [ShadertoyWSOptions] if provided)
  late final ShadertoyHttpOptions _options;

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
      _options = wsOptions;
      _hybridClient = ShadertoyWSClient(wsOptions, client: client);
    } else {
      _options = siteOptions;
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
  Future<FindShaderIdsResponse> findNewShaderIds(
      Set<String> storeShaderIds) async {
    final newShaderIds = <String>[];
    var addShaderIds = <String>{};
    var from = 0;
    final num = _options.shaderCount;
    do {
      final clientResponse = await _hybridClient.findShaderIds(
          sort: Sort.newest, from: from, num: num);
      if (!clientResponse.ok) {
        return clientResponse;
      }
      final shaderIds = clientResponse.ids ?? [];
      final clientShaderIds = shaderIds.toSet();
      addShaderIds = clientShaderIds.difference(storeShaderIds);
      shaderIds.retainWhere((shaderId) => addShaderIds.contains(shaderId));
      newShaderIds.addAll(shaderIds);
      from += num;
    } while (addShaderIds.isNotEmpty && addShaderIds.length == num);

    return FindShaderIdsResponse(ids: newShaderIds);
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
  void rsync(ShadertoyStore store, HybridSyncMode mode,
      {FileSystem? fs,
      Directory? dir,
      SyncTaskRunner? runner,
      int? concurrency,
      int? timeout,
      List<String> playlistIds = const <String>[]}) async {
    final shaderProcessor = ShaderSyncProcessor(this, store,
        runner: runner, concurrency: concurrency, timeout: timeout);
    final shaderSyncResult =
        await shaderProcessor.syncShaders(mode, fs: fs, dir: dir);

    final userProcessor = UserSyncProcessor(this, store,
        runner: runner, concurrency: concurrency, timeout: timeout);
    final userSyncResult =
        await userProcessor.syncUsers(shaderSyncResult, mode, fs: fs, dir: dir);

    final playlistProcessor = PlaylistSyncProcessor(this, store,
        runner: runner, concurrency: concurrency, timeout: timeout);
    await playlistProcessor.syncPlaylists(
        shaderSyncResult, userSyncResult, playlistIds);
  }
}
